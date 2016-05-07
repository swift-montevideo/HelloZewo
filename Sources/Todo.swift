import Mustache
import PostgreSQL

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


struct TodoApp {

    private func getAllTodos() throws -> [Todo] {
        let connection = Connection(host: "192.168.99.100", databaseName: "postgres", username: "postgres")
        try connection.open()

        // for row in try connection.execute("SELECT * FROM TODOS") {
        //     let id: Int = try row.value("id")
        //     print(id)
        // }

        return try connection.execute("SELECT * FROM TODOS")
            .map { row in
                let id: Int = try row.value("id")
                let text: String = try row.value("text")
                return Todo(id: id, text: text)
            }

        // return []
    }

    func todoList() -> String {
        let todos: [Todo]
        do {
            todos = try getAllTodos()
        } catch {
            return "Database Error"
        }

        do {
            // Load the `document.mustache` resource of the main bundle
            let template = try Template(path: "./Templates/index.mustache")

            // The rendered data
            let data = [
                "todos": todos.mustacheBox
            ]

            // The rendering: "Hello Arthur..."
            return try template.render(box: data.mustacheBox)
        } catch let e as MustacheError {
            return e.description
        } catch {
            return "Strange error"
        }
    }

}
