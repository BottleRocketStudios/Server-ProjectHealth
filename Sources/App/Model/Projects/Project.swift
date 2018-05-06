//
//  Project.swift
//  App
//
//  Created by Will McGinty on 4/6/18.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct Project: Content, PostgreSQLUUIDModel, Migration {
    
    //MARK: Properties
    var id: UUID?
    var name: String
    var isActive: Bool
    var groupID: UUID?

    //MARK: Interface
    var coverageReports: Children<Project, CoverageReport> {
        return children(\.projectID)
    }
    
    func inGroup(with id: UUID?) -> Project {
        var copy = self
        copy.groupID = id
        return copy
    }
    
    func modifying(id: UUID?) -> Project {
        var copy = self
        copy.id = id
        return copy
    }
    
    func patched(with patch: ProjectPatch) -> Project {
        return Project(id: patch.id ?? id, name: patch.name ?? name, isActive: patch.isActive ?? isActive, groupID: patch.groupID ?? groupID)
    }
    
    //MARK: Codable
    private enum CodingKeys: String, CodingKey {
        case id, name, groupID
        case isActive = "is_active"
    }
}

//MARK: Parameter
extension Project: Parameter { }

//MARK: PATCH Support
struct ProjectPatch: Content {
    
    //MARK: Properties
    var id: UUID?
    var name: String?
    var isActive: Bool?
    var groupID: UUID?
    
    //MARK: Interface
    func invalidatingGroupID() -> ProjectPatch {
        return ProjectPatch(id: id, name: name, isActive: isActive, groupID: nil)
    }
    
    //MARK: Codable
    private enum CodingKeys: String, CodingKey {
        case id, name, groupID
        case isActive = "is_active"
    }
}
