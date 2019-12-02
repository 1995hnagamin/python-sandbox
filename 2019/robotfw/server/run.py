import flask
import json
import os
import textwrap

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


if __name__ == "__main__":
    os.makedirs("data/img", exist_ok=True)
    app.debug = True
    portnum = 8080
    app.run(host="0.0.0.0", port=portnum)
