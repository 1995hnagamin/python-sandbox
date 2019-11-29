import flask
import textwrap

app = flask.Flask(__name__)


@app.route("/", methods=["GET"])
def index():
    msg = """\
            Hello
            """
    return textwrap.dedent(msg)


if __name__ == "__main__":
    app.debug = True
    portnum = 8080
    app.run(host="0.0.0.0", port=portnum)
