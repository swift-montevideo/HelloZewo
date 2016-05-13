import HTTPServer
import Router
import LogMiddleware
import StandardOutputAppender

// Log middleware to monitor the requests
let log = Logger(name: "TodoServerLogger", appender: StandardOutputAppender(), levels: .info)
let logMidd = LogMiddleware(logger: log)

// The todo core app
let app = TodoServer()

//Build the routes that point to the core
let router = Router { routeBuilder in

    //This calls to 'routeBuilder' map an HTTP method, POST and GET, to a
    //function that receive a Request type and return a Response.

    routeBuilder.get("/", respond: app.listView)
    routeBuilder.post("/", respond: app.listView)

    routeBuilder.get("/AddNew", respond: app.addView)
    routeBuilder.post("/AddNew", respond: app.addView)

    routeBuilder.get("/Remove", respond: app.removeView)
    routeBuilder.post("/Remove", respond: app.removeView)
}

// Start the server loop
try Server(port: 80, middleware: logMidd, responder: router).start()
