import Mustache


struct TodoApp {

    func todoList() throws -> String {
        // Load the `document.mustache` resource of the main bundle
        let templateDef = "Hello {{name}}\n{{#late}}Well, on die{{/late}}"
        let template = try Template(string: templateDef)

        // The rendered data
        let data = [
            "name": "Arthur".mustacheBox,
            "late": false.mustacheBox
        ]

        // The rendering: "Hello Arthur..."
        return try template.render(box: data.mustacheBox)
    }

}
