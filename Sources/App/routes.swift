import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    try app.register(collection: TodoController())
}

// MARK: - The following needs refactoring

struct Data: Content {
    var location: Location
    var mood: Mood
}

struct Location: Content {
    var name: String
    var latitude: Double
    var longitude: Double
    var isExact: Bool = true
}

struct Mood: Content {
    var name: String
    var emoji: String
    var updatedAt: Date = .now
}
