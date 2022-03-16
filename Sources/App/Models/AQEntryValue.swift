import Fluent
import Vapor

final class AQEntryValue: Model, Content {
    static let schema = "aq_entry_value"

    @ID(custom: "id", generatedBy: .database)
    var id: Int?

    @Field(key: "entry_id")
    var entry: Int

    @Field(key: "value_id")
    var valueType: Int

    @Field(key: "value")
    var value: String

    init() {}
}
