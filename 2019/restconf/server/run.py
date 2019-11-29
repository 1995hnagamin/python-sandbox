from flask import Flask
import textwrap

app = Flask(__name__)

@app.route('/.well-known/host-meta', methods=['GET'])
def serve_root_discoverty():
    msg = """\
            <XRD xmlns='http://docs.oasis-open.org/ns/xri/xrd-1.0'>
                <Link rel='restconf' href='/restconf'/>
            </XRD>
            """
    return textwrap.dedent(msg)

if __name__ == "__main__":
    app.debug = True
    portnum = 8080
    app.run(host='0.0.0.0', port=portnum)
