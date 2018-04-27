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
        basicAuthGroup.post(use: addProjectHandler)
        basicAuthGroup.patch(Project.parameter, use: updateProjectHandler)
        basicAuthGroup.delete(Project.parameter, use: deleteProjectHandler)
    }
}

//MARK: Helper
private extension ProjectRouteController {
    
    func retrieveAllProjectsHandler(_ request: Request) throws -> Future<[Project]> {
        return Project.query(on: request).all()
    }
    
    func addProjectHandler(_ request: Request) throws -> Future<HTTPResponseStatus> {
        return try request.content.decode(Project.self).save(on: request).transform(to: .created)
    }
    
    func updateProjectHandler(_ request: Request) throws -> Future<HTTPResponseStatus> {
        return try flatMap(to: HTTPResponseStatus.self, request.parameters.next(Project.self), request.content.decode(ProjectPatch.self)) { current, update in
            guard let groupID = update.groupID else {
                //If the groupID is not being updated, we don't need to validate that new UUID
                return current.patched(with: update).update(on: request).transform(to: .ok)
            }
            
            //If the groupID is being changed, we want to validate it before assigning
            return try Group.find(groupID, on: request).flatMap(to: HTTPResponseStatus.self) { match in
                let patch: ProjectPatch = match == nil ? update.invalidatingGroupID() : update
                return current.patched(with: patch).update(on: request).transform(to: .ok)
            }
        }
    }
    
    func deleteProjectHandler(_ request: Request) throws -> Future<HTTPResponseStatus> {
        return try request.parameters.next(Project.self).delete(on: request).transform(to: .noContent)
    }
}
