import Mustache
import HTTPServer
import String
import URLEncodedForm


//Make String be ResponseRepresentable so we can return plain strings
//as responses for request
extension String: ResponseRepresentable {
    public var response: Response {
        return Response(body: self)
    }
}

//Make a Response be ResponseRepresentable (because it isn't by default) so
//we can return a non-string response and string based response in the same method
//(that's needed to redirect to "/" in 'add' and 'remove' operations)
extension Response: ResponseRepresentable {
    public var response: Response {
        return self
    }
}

//This is the type that holds all the logic: list, add and remove Todo objects
struct TodoServer {

    //PostgreSQL running on linked docker
    private let store = Database(host: "PSQL")

    //Parse a Request and return a dictionary with the parameters (URLEncodedForm is [String:String]).
    //All the requests are form-encoded (Content-Type: application/x-www-form-urlencoded) so the values
    //sent from the page arrive in the body of the request.
    private func getParamsFor(_ request: Request) throws -> URLEncodedForm? {

        guard case .buffer(let dataBuffer) = request.body else {
            //should throw something...
            return nil
        }

        return try? URLEncodedFormParser().parse(data: dataBuffer)
    }

    //Return the result of rendering the mustach template at 'path'.
    //This function pass to the template an Array<Todo> with the key 'todos' and
    //return the render result as string or an error message.
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
}

//This extension has all the public method that handle one of the supported actins:
//list, add and remove
extension TodoServer {

    //Return the render index.mustach template for both request methods: POST and GET
    func listView(request: Request) -> ResponseRepresentable {
        return renderTodosWithTemplateAt(path: "./Templates/index.mustache")
    }

    //Add a new Todo to the database and return to the "/"
    func addView(request: Request) -> ResponseRepresentable {

        switch request.method {

            //The POST create a new record in the database
            case .post:
                do {
                    if let parameters = try getParamsFor(request),
                        //The text of the Todo is the parameter read from the page
                        let value = parameters["text"] {
                        try store.add(withText: value)
                    } else {
                        return "Missing parameters in request body"
                    }
                } catch {
                    return "Database error"
                }

                //if everything go well, redirect to the main list of Todos. For This
                //to work we need a Response to be ResponseRepresentable and suport POST to the "/" url
                return Response(status: .permanentRedirect, headers: ["Location": "/"])


            //GET return the page that ask for the title of the new Todo and confirms the action
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

    //Remove a Todo from the database and return to "/"
    func removeView(request: Request) -> ResponseRepresentable {

        switch request.method {

            //The POST remove a record from the database
            case .post:

                do {
                    if let parameters = try getParamsFor(request),
                        //The id of the Todo to remove is in the parameter read form the page
                        let stringValue = parameters["removeId"],
                        let value = Int(stringValue) {
                        try store.remove(withId: value)
                    } else {
                        return "Missing parameters in request body"
                    }
                } catch {
                    return "Database error"
                }

                //if everything go well, redirect to the main list of Todos.
                return Response(status: .permanentRedirect, headers: ["Location": "/"])

            //GET return the page that ask for the Todo to delete
            case .get:
                //This function is the same one used in the 'listView' function to return the complete
                //list of Todos. Here we are using a diferent template but the input to the render
                //is the same
                return renderTodosWithTemplateAt(path: "./Templates/remove.mustache")

            default:
                return "Unsuported method: \(request.method)"
        }

    }
}
