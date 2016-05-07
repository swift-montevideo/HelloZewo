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
    }

    route.get("/AddNew") { _ in
        return Response(body: app.addTodo())
    }

    route.post("/AddNew") { request in
        do {
            var body = request.body
            let dataBuffer = try body.becomeBuffer()
            let text = try String(data: dataBuffer)
            return Response(body: app.addTodo(text: text))
        } catch {
            return Response(body: "Error")
        }
    }
}

try Server(middleware: logMidd, responder: router).start()
