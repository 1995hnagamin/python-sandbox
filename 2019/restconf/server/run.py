import flask
import textwrap

app = flask.Flask(__name__)


@app.route("/.well-known/host-meta", methods=["GET"])
def serve_root_discoverty():
    msg = """\
            <XRD xmlns='http://docs.oasis-open.org/ns/xri/xrd-1.0'>
                <Link rel='restconf' href='/restconf'/>
            </XRD>
            """
    return textwrap.dedent(msg)


@app.route("/restconf/operations", methods=["GET"])
def show_operations():
    msg = """\
            { "operations" : { "example-jukebox:play" : [null] } }
            """
    return flask.Response(textwrap.dedent(msg), mimetype="application/yang-data+json")


@app.route("/restconf/yang-library-version", methods=["GET"])
def show_yang_lib_version():
    msg = """\
            <yang-library-version
              xmlns="urn:ietf:params:xml:ns:yang:ietf-restconf">
              2016-06-21
            </yang-library-version>"""
    return textwrap.dedent(msg)


if __name__ == "__main__":
    app.debug = True
    portnum = 8080
    app.run(host="0.0.0.0", port=portnum)
