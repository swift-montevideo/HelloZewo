import Mustache

/// Todo data model
struct Todo {
    let id: Int
    let text: String
}

//This extension describe how the Todo objects should be rendered in the Mustache
//templates.
extension Todo: MustacheBoxable {

    var mustacheBox: MustacheBox {
        return [
            "id": id.mustacheBox,
            "text": text.mustacheBox
        ].mustacheBox
    }

}
