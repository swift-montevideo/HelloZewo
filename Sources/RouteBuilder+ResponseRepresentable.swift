import Router

//The default implementation of RouterBuilder allow us to use
//functions with type: (Request) -> Response to attend the HTTP requests

//This extension add two methods that allow to register functions
//with type: (Request) -> ResponseRepresentable as handlers.

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
