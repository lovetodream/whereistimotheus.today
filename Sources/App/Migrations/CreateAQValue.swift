import Fluent

struct CreateAQValue: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("aq_value")
            .id()
            .field("name", .string, .required)
            .field("homematic_name", .string, .required)
            .field("description", .string, .required)
            .field("type", .string, .required)
            .field("unit", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("aq_value").delete()
    }
}
