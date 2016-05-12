import Mustache

/// Todo data model
struct Todo {
    let id: Int
    let text: String
}

extension Todo: MustacheBoxable {

    var mustacheBox: MustacheBox {
        return [
            "id": id.mustacheBox,
            "text": text.mustacheBox
        ].mustacheBox
    }

}
