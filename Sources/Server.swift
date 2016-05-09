import Mustache
import HTTPServer
import String


extension String: ResponseRepresentable {
    public var response: Response {
        return Response(body: self)
    }
}

extension Response: ResponseRepresentable {
    public var response: Response {
        return self
    }
}

struct TodoServer {

    //PostgreSQL running on local docker
    private let store = Database(host: "192.168.99.100")

    private func getParamsFor(_ request: Request) throws -> [String:String]? {

        guard case .buffer(let dataBuffer) = request.body else {
            //should throw something...
            return nil
        }

        let text = try String(data: dataBuffer)

        if text.contains("=") {

            var keys: [String] = []
            var values: [String] = []

            for (idx, str) in text.split(byString: "=").enumerated() {

                var parsedStr = str
                parsedStr.replace(string: "+", with: " ")

                if idx % 2 == 0 {
                    keys.append(parsedStr)
                } else {
                    values.append(parsedStr)
                }
            }

            return zip(keys, values).reduce([String:String](), combine: { partial, kv in
                var tmp = partial
                tmp[kv.0] = kv.1
                return tmp
            })

        } else {
            return nil
        }
    }

    private func renderTodosWithTemplateAt(path: String) -> String {
        let todos: [Todo]

        do {
            todos = try store.getAll()
        } catch {
            return "Database Error"
        }

        do {
            let responsePage = try Template(path: path)

            let data = [
                "todos": todos.mustacheBox
            ]

            return try responsePage.render(box: data.mustacheBox)

        } catch {
            return "Mustache error"
        }
    }

    func listView(request: Request) -> ResponseRepresentable {
        return renderTodosWithTemplateAt(path: "./Templates/index.mustache")
    }

    func addView(request: Request) -> ResponseRepresentable {

        switch request.method {

            case .post:
                do {
                    if let parameters = try getParamsFor(request),
                        let value = parameters["text"] {
                        try store.add(withText: value)
                    } else {
                        return "Missing parameters in request body"
                    }
                } catch {
                    return "Database error"
                }

                return Response(status: .permanentRedirect, headers: ["Location": "/"])

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

    func removeView(request: Request) -> ResponseRepresentable {

        switch request.method {

            case .post:

                do {
                    if let parameters = try getParamsFor(request),
                        let stringValue = parameters["removeId"],
                        let value = Int(stringValue) {
                        try store.remove(withId: value)
                    } else {
                        return "Missing parameters in request body"
                    }
                } catch {
                    return "Database error"
                }

                return Response(status: .permanentRedirect, headers: ["Location": "/"])

            case .get:
                return renderTodosWithTemplateAt(path: "./Templates/remove.mustache")

            default:
                return "Unsuported method: \(request.method)"
        }

    }
}
