import HTTPServer
import Router
import LogMiddleware
import StandardOutputAppender
import Mustache

let log = Logger(name: "example-logger", appender: StandardOutputAppender(), levels: .info)
let logMidd = LogMiddleware(logger: log)

let app = TodoApp()

let router = Router { route in
    route.get("/") { _ in

        do {
            let responseStr = try app.todoList()
            return Response(body: responseStr)
        } catch let e as MustacheError {
            return Response(body: e.description)
        }
        // return Response(body: "<BODY><HEAD>hello world</HEAD></BODY>")
    }
}

try Server(middleware: logMidd, responder: router).start()
