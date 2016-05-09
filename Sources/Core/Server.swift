import Mustache
import HTTPServer


extension String: ResponseRepresentable {
    var response: Response {
        Response(body: self)
    }
}


struct TodoServer {

    //PostgreSQL running on local docker
    private let store = Database(host: "192.168.99.100")

    func listView(request: Request) -> ResponseRepresentable {

        let todos: [Todo]

        do {
            todos = try store.getAll()
        } catch {
            return "Database Error"
        }

        do {
            let responsePage = try Template(path: "./Templates/index.mustache")

            let data = [
                "todos": todos.mustacheBox
            ]

            return try responsePage.render(box: data.mustacheBox)

        } catch {
            return "Mustache error"
        }
    }

    func addView(request: Request) -> ResponseRepresentable {

        do {
            let responsePage = try Template(path: "./Templates/addNew.mustache")
            return try responsePage.render()
        } catch {
            return "Strange error"
        }

    }

    func add(request: Request) -> ResponseRepresentable {
        do {
            var body = request.body
            let dataBuffer = try body.becomeBuffer()
            let text = try String(data: dataBuffer)
            let value = text.byString("=")[1]
            try store.addNew(withText: text)
        } catch {
            return "Database error"
        }

        return list()
    }

}
