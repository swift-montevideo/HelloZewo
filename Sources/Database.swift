import PostgreSQL


struct Database {

    //The host where the database server is running. It can be an IP address or
    //a valid DNS name
    private let host: String

    init(host: String) {
        self.host = host
    }

    func getAll() throws -> [Todo] {
        let connection = Connection(host: self.host, databaseName: "postgres", username: "postgres")

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

    func add(withText text: String) throws {
        let connection = Connection(host: host, databaseName: "postgres", username: "postgres")

        defer {
            connection.close()
        }

        try connection.open()
        try connection.execute("INSERT INTO TODOS(text) VALUES(%@)", parameters: text)
    }

    func remove(withId id: Int) throws {
        let connection = Connection(host: host, databaseName: "postgres", username: "postgres")

        defer {
            connection.close()
        }

        try connection.open()
        try connection.execute("DELETE FROM TODOS WHERE id = %@", parameters: id)
    }
}
