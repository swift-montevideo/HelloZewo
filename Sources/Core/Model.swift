import Mustache

/// Todo data model
struct Todo {
    let id: Int
    let text: String

    init(id _id: Int, text _text: String) {
        id = _id
        text = _text
    }
}

extension Todo: MustacheBoxable {

    var mustacheBox: MustacheBox {
        return [
            "id": id.mustacheBox,
            "text": text.mustacheBox
        ].mustacheBox
    }

}
