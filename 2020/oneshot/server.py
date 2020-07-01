import http.server
import socketserver
import threading

def kill(server):
    server.shutdown()

class OneshotHandler(http.server.BaseHTTPRequestHandler):
    path = ""

    def do_GET(self):
        OneshotHandler.path = self.path
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        threading.Timer(1, kill, args=(self.server,)).start()

def get_path():
    port = 8080
    handler = OneshotHandler
    with socketserver.TCPServer(("", port), handler) as httpd:
        httpd.serve_forever()
    return handler.path

print(get_path())
