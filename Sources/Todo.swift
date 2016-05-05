import Mustache
import PostgreSQL


struct TodoApp {

    struct Todo {
        let id: Int
        let text: String

        init(id _id: Int, text _text: String) {
            id = _id
            text = _text
        }
    }

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
        do {
            let todos = try getAllTodos()
            print(todos)
        } catch {
            return "Database Error"
        }

        do {
            // Load the `document.mustache` resource of the main bundle
            let templateDef = "Hello {{name}}\n{{#late}}Well, on die{{/late}}"
            let template = try Template(string: templateDef)

            // The rendered data
            let data = [
                "name": "Arthur".mustacheBox,
                "late": false.mustacheBox
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
