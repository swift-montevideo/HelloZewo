import Mustache
import File

//This extension add a convenience constructor for Mustache templates that read
//the templates form a file system path.
extension Template {

    //This constructor the file at the give path as String and call the default
    //constructor with that value
    convenience init(path: String) throws {
        let file = try File(path: path)
        let data = try file.readAllBytes()
        let templateString = try String(data: data)
        try self.init(string: templateString)
    }

}
