import Mustache
import File

extension Template {

    convenience init(path: String) throws {
        let file = try File(path: path)
        let data = try file.readAllBytes()
        let templateString = try String(data: data)
        try self.init(string: templateString)
    }

}
