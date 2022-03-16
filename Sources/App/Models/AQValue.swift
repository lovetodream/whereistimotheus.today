import Fluent
import Vapor

final class AQValue: Model, Content {
    static let schema = "aq_value"

    @ID(custom: "id", generatedBy: .database)
    var id: Int?

    @Field(key: "name")
    var name: String

    @Field(key: "homematic_name")
    var homematicName: String

    @Field(key: "description")
    var description: String

    @Field(key: "type")
    var type: String

    @Field(key: "unit")
    var unit: String

    init() {}
}
