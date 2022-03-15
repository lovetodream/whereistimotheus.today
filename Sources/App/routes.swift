import Fluent
import SwiftJWT
import Vapor

func routes(_ app: Application) throws {
    app.get { req -> View in
        let data = getData()
        return try await req.view.render("index", [
            "location": "\(data.location.isExact ? "in" : "near") \(data.location.name)",
            "mood_label": data.mood.name,
            "mood_emoji": data.mood.emoji,
            "mood_updated_at": data.mood.updatedAt.description,
            "development": "\(app.environment == .development)",
        ])
    }

    app.get("data") { _ -> Data in
        getData()
    }

    app.get("token") { _ -> String in
        try getToken()
    }

    try app.register(collection: TodoController())
}

// MARK: - The following needs refactoring

func getData() -> Data {
    // TODO: This will dynamic/automated in the future
    let location = Location(name: "Ingolstadt", latitude: 48.76508, longitude: 11.42372, isExact: false)
    let mood = Mood(name: "happy", emoji: "😃")
    return Data(location: location, mood: mood)
}

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
