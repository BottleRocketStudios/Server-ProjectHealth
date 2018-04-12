//
//  ProjectRouteController.swift
//  App
//
//  Created by Will McGinty on 4/6/18.
//

import Foundation
import Vapor

class ProjectRouteController: RouteCollection {
    
    func boot(router: Router) throws {
        let group = router.grouped("api", "projects")
        
        group.get(use: retrieveAllProjectsHandler)
        group.post(use: addNewProjectHandler)
    }
}

//MARK: Helper
private extension ProjectRouteController {
    
    func retrieveAllProjectsHandler(_ request: Request) throws -> Future<[Project]> {
        return Project.query(on: request).all()
    }
    
    func addNewProjectHandler(_ request: Request) throws -> Future<Project> {
        return try request.content.decode(Project.self).save(on: request)
    }
}
