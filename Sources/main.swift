import HTTPServer
import Router
import LogMiddleware

let log = Log()
let logger = LogMiddleware(log: log)

let router = Router { route in
    route.get("/") { _ in
        return Response(body: "<BODY><HEAD>hello world</HEAD></BODY>")
    }
}

try Server(middleware: logger, responder: router).start()
