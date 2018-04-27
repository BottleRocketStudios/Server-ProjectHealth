//
//  Project.swift
//  App
//
//  Created by Will McGinty on 4/6/18.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite

struct Project: Content, SQLiteUUIDModel, Migration {
    
    //MARK: Properties
    var id: UUID?
    var name: String
    private var active: Int
    var groupID: UUID?
    
    //MARK: Interface
    var isActive: Bool { return active == 1 }
    
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
        return Project(id: patch.id ?? id, name: patch.name ?? name, active: patch.active ?? active, groupID: patch.groupID ?? groupID)
    }
}

//MARK: Parameter
extension Project: Parameter { }

//MARK: PATCH Support
struct ProjectPatch: Content {
    
    //MARK: Properties
    var id: UUID?
    var name: String?
    var active: Int?
    var groupID: UUID?
    
    //MARK: Interface
    func invalidatingGroupID() -> ProjectPatch {
        return ProjectPatch(id: id, name: name, active: active, groupID: nil)
    }
}
