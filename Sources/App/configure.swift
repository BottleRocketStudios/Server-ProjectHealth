import Vapor
import FluentPostgreSQL
import Authentication
import Logging

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
    
    //Configure our Fluent provider with our Postgres database running in Docker
    /*NOTE: If you haven't done so, you will need to create a local Postgres Docker container for your database:
        docker run --name projecthealth-postgres -e POSTGRES_DB=vapor -e POSTGRES_USER=vapor -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres */
    try services.register(FluentPostgreSQLProvider())
    
    var databaseConfig = DatabasesConfig()
    let postgreDatabase = PostgreSQLDatabase(config: PostgreSQLDatabaseConfig(hostname: "localhost", username: "vapor", database: "vapor", password: "password"))
    databaseConfig.add(database: postgreDatabase, as: .psql)
    services.register(databaseConfig)
    
    //Configure the database migration table
    var migrationConfig = MigrationConfig()
    migrationConfig.add(model: Project.self, database: .psql)
    migrationConfig.add(model: Group.self, database: .psql)
    migrationConfig.add(model: User.self, database: .psql)
    migrationConfig.add(model: CoverageReport.self, database: .psql)
    migrationConfig.add(model: TargetReport.self, database: .psql)
    migrationConfig.add(model: FileReport.self, database: .psql)
    migrationConfig.add(model: FunctionReport.self, database: .psql)
    services.register(migrationConfig)
    
    //Configure authentication provisions
    try services.register(AuthenticationProvider())
    
    //Configure global middlewares - errors, logging, cache-control
    var middlewareConfig = MiddlewareConfig()
    middlewareConfig.use(ErrorMiddleware.self)
    
    services.register { LogMiddleware(log: try $0.make(Logger.self)) }
    middlewareConfig.use(LogMiddleware.self)
    
    let cacheMiddleware = CacheControlMiddleware()
    middlewareConfig.use(cacheMiddleware)
    
    services.register(middlewareConfig)
}
