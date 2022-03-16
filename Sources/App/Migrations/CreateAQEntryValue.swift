import Fluent

struct CreateAQEntryValue: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("aq_entry_value")
            .id()
            .field("entry_id", .int, .required)
            .field("value_id", .int, .required)
            .field("value", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("aq_entry_value").delete()
    }
}
