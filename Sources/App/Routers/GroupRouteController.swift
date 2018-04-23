//
//  GroupRouteController.swift
//  App
//
//  Created by Will McGinty on 4/6/18.
//

import Foundation
import Vapor
import Authentication
import Crypto

class GroupRouteController: RouteCollection {
    
    func boot(router: Router) throws {
        let group = router.grouped("api", "groups")
        group.get(use: retrieveAllGroupsHandler)
        group.get(Group.parameter, use: retrieveGroupHandler)
        
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCrypt)
        let basicAuthGroup = group.grouped(basicAuthMiddleware)
        basicAuthGroup.post(use: addNewGroupHandler)
        basicAuthGroup.post(Group.parameter, use: addProjectToGroupHandler)
    }
}

//MARK: Helper
private extension GroupRouteController {
    
    func retrieveAllGroupsHandler(_ request: Request) throws -> Future<[Group]> {
        return Group.query(on: request).all()
    }
    
    func retrieveGroupHandler(_ request: Request) throws -> Future<[Project]> {
        return try request.parameters.next(Group.self).flatMap(to: [Project].self) {
            return try $0.projects.query(on: request).all()
        }
    }
    
    func addNewGroupHandler(_ request: Request) throws -> Future<HTTPResponseStatus> {
        return try request.content.decode(Group.self).save(on: request).transform(to: .created)
    }
    
    func addProjectToGroupHandler(_ request: Request) throws -> Future<HTTPResponseStatus> {
        return try flatMap(to: HTTPResponseStatus.self, request.parameters.next(Group.self), try request.content.decode(Project.self)) { matchingGroup, project in
            let modified = project.inGroup(with: matchingGroup.id)
            return modified.save(on: request).transform(to: .created)
        }
    }
}
