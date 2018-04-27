import Vapor
import Fluent
import FluentSQLite
import Authentication

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    //Configure the directory config - so we can use the present working directory
    let directoryConfig = DirectoryConfig.detect()
    services.register(directoryConfig)
    
    //Configure fluent - creating a database so we can persist data
    try services.register(FluentSQLiteProvider())
    
    var databaseConfig = DatabasesConfig()
    let db = try SQLiteDatabase(storage: .file(path: "\(directoryConfig.workDir)projects.db"))
    databaseConfig.add(database: db, as: .sqlite)
    services.register(databaseConfig)
    
    //Configure the database migration table
    var migrationConfig = MigrationConfig()
    migrationConfig.add(model: Project.self, database: .sqlite)
    migrationConfig.add(model: Group.self, database: .sqlite)
    migrationConfig.add(model: User.self, database: .sqlite)
    migrationConfig.add(model: Report.self, database: .sqlite)
    migrationConfig.add(model: Target.self, database: .sqlite)
    migrationConfig.add(model: File.self, database: .sqlite)
    migrationConfig.add(model: Function.self, database: .sqlite)
    services.register(migrationConfig)
    
    //Configure authentication provisions
    try services.register(AuthenticationProvider())
    
    //Configure middlewares
    var middlewareConfig = MiddlewareConfig()
    middlewareConfig.use(ErrorMiddleware.self)
    services.register(middlewareConfig)
}
