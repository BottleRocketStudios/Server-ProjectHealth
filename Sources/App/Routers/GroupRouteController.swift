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
        group.get(UUID.parameter, use: retrieveGroupHandler)
        
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCrypt)
        let basicAuthGroup = group.grouped(basicAuthMiddleware)
        basicAuthGroup.post(use: addNewGroupHandler)
        basicAuthGroup.post(UUID.parameter, use: addProjectToGroupHandler)
    }
}

//MARK: Helper
private extension GroupRouteController {
    
    func retrieveAllGroupsHandler(_ request: Request) throws -> Future<[Group]> {
        //TODO: Should the list of groups also return the list of projects inside that group? Or should a call to /groups/<id> be required for that?
        return Group.query(on: request).all()
    }
    
    func retrieveGroupHandler(_ request: Request) throws -> Future<[Project]> {
        let groupID = try request.parameter(UUID.self)
        return try Group.find(groupID, on: request).flatMap(to: [Project].self) {
            guard let group = $0 else { throw Abort(.notFound) }
            return try group.projects.query(on: request).all()
        }
    }
    
    func addNewGroupHandler(_ request: Request) throws -> Future<Group> {
        return try request.content.decode(Group.self).save(on: request)
    }
    
    func addProjectToGroupHandler(_ request: Request) throws -> Future<Project> {
        let groupID = try request.parameter(UUID.self)
        return try flatMap(to: Project.self, Group.find(groupID, on: request), try request.content.decode(Project.self)) { matchingGroup, project in
            guard let group = matchingGroup else { throw Abort(.notFound) }
            
            var modifiedProject = project
            modifiedProject.group = group.id
            
            return modifiedProject.save(on: request)
        }
    }
}
