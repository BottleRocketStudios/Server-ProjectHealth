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
        basicAuthGroup.post(Group.self, use: addGroupHandler)
        basicAuthGroup.patch(GroupPatch.self, at: Group.parameter, use: updateGroupHandler)
        basicAuthGroup.delete(Group.parameter, use: deleteGroupHandler)
        basicAuthGroup.post(Project.self, at: Group.parameter, use: addProjectToGroupHandler)
    }
}

//MARK: Helper
private extension GroupRouteController {
    
    func retrieveAllGroupsHandler(_ request: Request) throws -> Future<[Group]> {
        return Group.query(on: request).all()
    }
    
    func retrieveGroupHandler(_ request: Request) throws -> Future<[Project]> {
        return try request.parameters.next(Group.self).flatMap {
            return try $0.projects.query(on: request).all()
        }
    }
    
    func addGroupHandler(_ request: Request, group: Group) throws -> Future<HTTPResponseStatus> {
        return group.save(on: request).transform(to: .created)
    }
    
    func updateGroupHandler(_ request: Request, update: GroupPatch) throws -> Future<HTTPResponseStatus> {
        return try request.parameters.next(Group.self).flatMap { current in
            return current.patched(with: update).update(on: request).transform(to: .ok)
        }
    }

    func deleteGroupHandler(_ request: Request) throws -> Future<HTTPResponseStatus> {
        return try request.parameters.next(Group.self).delete(on: request).transform(to: .noContent)
    }
    
    func addProjectToGroupHandler(_ request: Request, project: Project) throws -> Future<HTTPResponseStatus> {
        return try request.parameters.next(Group.self).flatMap { matchingGroup in
            let modified = project.inGroup(with: matchingGroup.id)
            return modified.save(on: request).transform(to: .created)
        }
    }
}
