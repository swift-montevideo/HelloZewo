import PostgreSQL


struct Database {

    let host: String

    init(host: host) {
        self.host = host
    }

    private var connection: Connection {
        return Connection(host: host, databaseName: "postgres", username: "postgres")
    }

    func getAll() throws -> [Todo] {
        defer {
            connection.close()
        }

        try connection.open()

        return try connection.execute("SELECT * FROM TODOS")
            .map { row in
                let id: Int = try row.value("id")
                let text: String = try row.value("text")
                return Todo(id: id, text: text)
            }
    }

    func addNew(withText text: String) throws {
        defer {
            connection.close()
        }

        try connection.open()
        try connection.execute("INSERT INTO TODOS(text) VALUES(%@)", parameters: text)
    }
}
