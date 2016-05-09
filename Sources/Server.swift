import Mustache
import HTTPServer
import String


extension String: ResponseRepresentable {
    public var response: Response {
        return Response(body: self)
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

        switch request.method {

            case .post:
                do {
                    var body = request.body
                    let dataBuffer = try body.becomeBuffer()
                    let text = try String(data: dataBuffer)
                    let value = text.split(byString: "=")[1]
                    try store.addNew(withText: value)
                } catch {
                    return "Database error"
                }

                return listView(request: request)

            case .get:
                do {
                    let responsePage = try Template(path: "./Templates/addNew.mustache")
                    return try responsePage.render()
                } catch {
                    return "Strange error"
                }

            default:
                return "Unsuported method: \(request.method)"
        }
    }

}
