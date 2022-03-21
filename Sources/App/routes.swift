import Fluent
import SwiftJWT
import Vapor

func routes(_ app: Application) throws {
    app.get { req -> View in
        let data = try await getData(req: req)
        return try await req.view.render("index", [
            "location": "\(data.location.isExact ? "in" : "near") \(data.location.name)",
            "mood_label": data.mood.name,
            "mood_emoji": data.mood.emoji,
            "mood_updated_at": data.mood.updatedAt.description,
            "air_quality": data.airQuality.label.rawValue,
            "air_quality_status_emoji": data.airQuality.status.rawValue,
            "air_quality_updated_at": data.airQuality.updatedAt.description,
            "development": "\(app.environment == .development)",
        ])
    }

    app.get("data") { req -> Data in
        try await getData(req: req)
    }

    app.get("token") { _ -> String in
        try getToken()
    }

    try app.register(collection: TodoController())
}

// MARK: - The following needs refactoring

func getData(req: Request) async throws -> Data {
    // TODO: This will dynamic/automated in the future
    let location = Location(name: "Ingolstadt", latitude: 48.76508, longitude: 11.42372, isExact: false)
    let mood = Mood(name: "happy", emoji: "😃")
    let aqValue = try await AQValue.query(on: req.db).filter(\.$id == 21).first()
    let aqEntry = try await AQEntry.query(on: req.db).sort(\.$timestamp, .descending).first()
    let aq = try await AQEntryValue.query(on: req.db).filter(\.$entry == aqEntry!.id!).filter(\.$valueType == aqValue!.id!).first()
    let airQuality = AirQuality(index: try Int(value: aq!.value), timestamp: aqEntry!.timestamp)
    return Data(location: location, mood: mood, airQuality: airQuality)
}

func getToken() throws -> String {
    let header = Header(typ: "JWT", kid: Environment.get("MAPKIT_KEYID"))
    let claims = ClaimsStandardJWT(iss: Environment.get("MAPKIT_TEAMID"), exp: Date(timeIntervalSinceNow: 86400), iat: Date())
    var jwt = JWT(header: header, claims: claims)

    let p8 = Environment.get("MAPKIT_KEY")!.data(using: .utf8)!

    let token = try jwt.sign(using: JWTSigner.es256(privateKey: p8))

    return token
}

struct Data: Content {
    var location: Location
    var mood: Mood
    var airQuality: AirQuality
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
    var updatedAt = Date()
}

struct AirQuality: Content {
    var index: Int
    var label: AirQualityLabel
    var status: AirQualityStatus
    var updatedAt: Date = Date()

    init(index: Int, timestamp: Date) {
        self.index = index
        label = AirQualityLabel(index: index)
        status = AirQualityStatus(for: label)
        updatedAt = timestamp
    }
}

enum AirQualityLabel: String, Content {
    case veryGood = "very good"
    case good
    case moderate
    case poor
    case veryPoor = "very poor"
    case terrible
    case unknown

    init(index: Int) {
        switch index {
        case 1: self = .veryGood
        case 2: self = .good
        case 3: self = .moderate
        case 4: self = .poor
        case 5: self = .veryPoor
        case 6: self = .terrible
        default: self = .unknown
        }
    }
}

enum AirQualityStatus: String, Content {
    case good = "🟢"
    case moderate = "🟡"
    case poor = "🟠"
    case terrible = "🔴"
    case unknown = "🔵"

    init(for label: AirQualityLabel) {
        switch label {
        case .veryGood, .good: self = .good
        case .moderate: self = .moderate
        case .poor, .veryPoor: self = .poor
        case .terrible: self = .terrible
        default: self = .unknown
        }
    }
}
