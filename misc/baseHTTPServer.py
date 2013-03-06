#!/usr/bin/env python
import BaseHTTPServer
import SocketServer
import argparse

SERVER_HOST = ''
SERVER_PORT = 80

class ThreadedHTTPServer(SocketServer.ThreadingMixIn, BaseHTTPServer.HTTPServer):
    pass

class MyHandler(BaseHTTPServer.BaseHTTPRequestHandler):
    def do_HEAD(s):
        s.send_response(200)
        s.send_header("Content-type", "text/html")
        s.end_headers()
    def do_GET(s):
        """Respond to a GET request."""
        s.send_response(200)
        s.send_header("Content-type", "text/html")
        s.end_headers()
        s.wfile.write("<html><head><title>Title goes here.</title></head>")
        s.wfile.write("<body><p>This is a test.</p>")
        # If someone went to "http://something.somewhere.net/foo/bar/",
        # then s.path equals "/foo/bar/".
        s.wfile.write("<p>You accessed path: %s</p>" % s.path)
        s.wfile.write("</body></html>")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Tiny HTTP server.')
    parser.add_argument('-a', action='store', dest='address', default=SERVER_HOST, help='Address to bind to.')
    parser.add_argument('-p', action='store', dest='port', type=int, default=SERVER_PORT, help='Port to listen on.')
    args = parser.parse_args()
    
    if args.address == '':
        print_addr = 'any'
    else:
        print_addr = args.address
    
    print('Starting HTTP server on: %s:%s' % (print_addr, args.port))
    
    httpd = ThreadedHTTPServer((args.address, args.port), MyHandler)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()