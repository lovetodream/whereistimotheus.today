import Fluent

struct CreateAQEntry: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("aq_entry")
            .id()
            .field("timestamp", .date, .required)
            .field("seconds_since_last_reset", .int, .required)
            .field("firmware", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("aq_entry").delete()
    }
}
