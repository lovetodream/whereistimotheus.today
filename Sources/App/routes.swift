import Fluent
import SwiftJWT
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("token") { _ -> String in
        try getToken()
    }

    try app.register(collection: TodoController())
}

// MARK: - The following needs refactoring

func getToken() throws -> String {
    let header = Header(typ: "JWT", kid: Environment.get("MAPKIT_KEYID"))
    let claims = ClaimsStandardJWT(iss: Environment.get("MAPKIT_TEAMID"), exp: Date(timeIntervalSinceNow: 86400), iat: .now)
    var jwt = JWT(header: header, claims: claims)

    let p8 = Environment.get("MAPKIT_KEY")!.data(using: .utf8)!

    let token = try jwt.sign(using: .es256(privateKey: p8))

    return token
}

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
