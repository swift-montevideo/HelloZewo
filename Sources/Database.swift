import PostgreSQL


struct Database {

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

    func addNew(withText text: String) throws {
        let connection = Connection(host: host, databaseName: "postgres", username: "postgres")
        
        defer {
            connection.close()
        }

        try connection.open()
        try connection.execute("INSERT INTO TODOS(text) VALUES(%@)", parameters: text)
    }
}
