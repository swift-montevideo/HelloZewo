import Router


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
