import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    
    let routers: [RouteCollection] = [ProjectRouteController(),
                                      GroupRouteController(),
                                      UserRouteController()]
    
    try routers.forEach { try router.register(collection: $0) }    
}
 
