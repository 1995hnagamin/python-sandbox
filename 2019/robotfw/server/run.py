import flask
import json
import os
import textwrap
import uuid

app = flask.Flask(__name__)


@app.route("/", methods=["GET"])
def index():
    msg = """\
            Hello
            """
    return textwrap.dedent(msg)


def image_info(img_id):
    return {"image_id": img_id}


@app.route("/images", methods=["GET"])
def show_image_list():
    return json.dumps(
        [image_info(os.path.splitext(p)[0]) for p in os.listdir("data/img")]
    )


@app.route("/upload", methods=["POST"])
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
