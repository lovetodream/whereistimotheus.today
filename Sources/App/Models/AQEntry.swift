import Fluent
import Vapor

final class AQEntry: Model, Content {
    static let schema = "aq_entry"

    @ID(custom: "id", generatedBy: .database)
    var id: Int?

    @Field(key: "timestamp")
    var timestamp: Date

    @Field(key: "seconds_since_last_reset")
    var secondsSinceLastReset: Int

    @Field(key: "firmware")
    var firmware: String

    init() {}
}
