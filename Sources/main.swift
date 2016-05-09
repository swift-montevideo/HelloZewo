import HTTPServer
import Router
import LogMiddleware
import StandardOutputAppender


extension RouterBuilder {

    public func get(_ path: String, middleware: Middleware..., responseTransformable: ResponseRepresentable) {
        let responder = BasicResponder(responseTransformable.response)
        get(path, middleware: middleware, responder: responder)
    }


    public func post(_ path: String, middleware: Middleware..., responseTransformable: ResponseRepresentable) {
        let responder = BasicResponder(responseTransformable.response)
        post(path, middleware: middleware, responder: responder)
    }

}



let log = Logger(name: "TodoServerLogger", appender: StandardOutputAppender(), levels: .info)
let logMidd = LogMiddleware(logger: log)

let app = TodoServer()

let router = Router { routeBuilder in

    routeBuilder.get("/", app.listView)

    routeBuilder.get("/AddNew", app.addView)

    routeBuilder.post("/AddNew", app.add)
}

try Server(middleware: logMidd, responder: router).start()
