import HTTPServer
import Router
import LogMiddleware
import StandardOutputAppender


extension RouterBuilder {

    typealias RespondRepresentable = (Request) -> ResponseRepresentable

    func get(_ path: String, respond: RespondRepresentable) {
        let responder = BasicResponder { respond($0).response }
        get(path, responder: responder)
    }


    func post(_ path: String, respond: RespondRepresentable) {
        let responder = BasicResponder { respond($0).response }
        post(path, responder: responder)
    }

}



let log = Logger(name: "TodoServerLogger", appender: StandardOutputAppender(), levels: .info)
let logMidd = LogMiddleware(logger: log)

let app = TodoServer()

let router = Router { routeBuilder in

    routeBuilder.get("/", respond: app.listView)

    routeBuilder.get("/AddNew", respond: app.addView)

    routeBuilder.post("/AddNew", respond: app.addView)
}

try Server(middleware: logMidd, responder: router).start()
