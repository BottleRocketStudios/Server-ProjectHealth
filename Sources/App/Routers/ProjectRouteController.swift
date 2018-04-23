//
//  ProjectRouteController.swift
//  App
//
//  Created by Will McGinty on 4/6/18.
//

import Foundation
import Vapor
import Authentication
import Crypto

class ProjectRouteController: RouteCollection {
    
    func boot(router: Router) throws {
        let group = router.grouped("api", "projects")
        group.get(use: retrieveAllProjectsHandler)
    
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCrypt)
        let basicAuthGroup = group.grouped(basicAuthMiddleware)
        basicAuthGroup.post(use: addNewProjectHandler)
    }
}

//MARK: Helper
private extension ProjectRouteController {
    
    func retrieveAllProjectsHandler(_ request: Request) throws -> Future<[Project]> {
        return Project.query(on: request).all()
    }
    
    func addNewProjectHandler(_ request: Request) throws -> Future<HTTPResponseStatus> {
        return try request.content.decode(Project.self).save(on: request).transform(to: .created)
    }
}
