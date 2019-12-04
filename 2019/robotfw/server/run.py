import flask
from flask_httpauth import HTTPBasicAuth
import imghdr
import json
import os
import textwrap
import uuid
from werkzeug.security import generate_password_hash, check_password_hash

app = flask.Flask(__name__)

auth = HTTPBasicAuth()
users = {"janedoe": generate_password_hash("p4ssw0rd")}


@auth.verify_password
def verify_password(username, password):
    if username in users:
        return check_password_hash(users.get(username), password)
    return False


@app.route("/", methods=["GET"])
def index():
    msg = """\
            Hello
            """
    return textwrap.dedent(msg)


def image_info(img_id):
    return {"image_id": img_id}


@app.route("/images", methods=["GET"])
@auth.login_required
def show_image_list():
    return json.dumps(
        [image_info(os.path.splitext(p)[0]) for p in os.listdir("data/img")]
    )


@app.route("/raw/<img_id>")
def deliver_image(img_id=None):
    if not img_id:
        flask.abort(421)
    path = os.path.abspath("data/img/{}".format(img_id))
    if not os.path.isfile(path):
        flask.abort(404)
    filetype = imghdr.what(path)
    return flask.send_file(path, mimetype="image/{}".format(filetype))


@app.route("/upload", methods=["POST"])
@auth.login_required
def receive_image():
    if "image" not in flask.request.files:
        return json.dumps({"status": "error", "message": "image missing."})
    data = flask.request.files["image"]
    img_id = str(uuid.uuid1())
    data.save(os.path.join("data/img", img_id))
    return json.dumps({"status": "ok", "image_id": img_id})


if __name__ == "__main__":
    os.makedirs("data/img", exist_ok=True)
    app.debug = True
    portnum = 8080
    app.run(host="0.0.0.0", port=portnum)
