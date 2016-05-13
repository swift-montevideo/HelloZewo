import PackageDescription

let package = Package(
    name: "hello",
    dependencies: [
        .Package(url: "https://github.com/Zewo/HTTPServer.git", majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/Router.git", majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/LogMiddleware.git", majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/PostgreSQL.git", majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/StandardOutputAppender", majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/Mustache.git", majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/URLEncodedForm.git", majorVersion: 0, minor: 5),
    ]
)
