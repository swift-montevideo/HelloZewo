import HTTPServer
import Router
import LogMiddleware
import StandardOutputAppender

let log = Logger(name: "example-logger", appender: StandardOutputAppender(), levels: .info)
let logMidd = LogMiddleware(logger: log)

let app = TodoApp()

let router = Router { route in
    route.get("/") { _ in
        return Response(body: app.todoList())
        // return Response(body: "<BODY><HEAD>hello world</HEAD></BODY>")
    }
}

try Server(middleware: logMidd, responder: router).start()
