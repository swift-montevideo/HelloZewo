import HTTPServer
import Router
import LogMiddleware
import StandardOutputAppender
// import PostgreSQL
//
// func test(a: Int) -> String? {
//     return "1 \(a)"
// }
//
// func test(_ a: Int) -> String {
//     return (test(a: a) as String?)!
// }
//
// if let a = test(a: 6) {
//     print(a)
// }
//
// print(test(3))
// exit(0)
//
// let connection = Connection(host: "192.168.99.100", databaseName: "postgres", username: "postgres")
// try connection.open()
//
// for row in try connection.execute("SELECT * FROM TODOS") {
//     // if let id: Data = try row.data(field: "id") {
//     //     print(id)
//     // } else {
//     //     print(row)
//     // }
//
//     let id: Int = try row.value("id")
//     print(id)
//     print(row)
// }

let log = Logger(name: "example-logger", appender: StandardOutputAppender(), levels: .info)
let logMidd = LogMiddleware(logger: log)

let app = TodoApp()

let router = Router { route in
    route.get("/") { _ in
        return Response(body: app.todoList())
        // return Response(body: "<BODY><HEAD>hello world</HEAD></BODY>")
    }
}

try Server(middleware: logMidd, responder: router).start()
