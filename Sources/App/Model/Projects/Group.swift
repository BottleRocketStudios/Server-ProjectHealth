//
//  Group.swift
//  App
//
//  Created by Will McGinty on 4/6/18.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct Group: Content, PostgreSQLUUIDModel, Migration  {
    
    //MARK: Properties
    var id: UUID?
    var name: String
    
    var projects: Children<Group, Project> {
        return children(\.groupID)
    }
    
    //MARK: Interface
    func modifying(id: UUID?) -> Group {
        var copy = self
        copy.id = id
        return copy
    }
    
    func patched(with patch: GroupPatch) -> Group {
        return Group(id: patch.id ?? id, name: patch.name ?? name)
    }
}

//MARK: Parameter
extension Group: Parameter { }

//MARK: PATCH Support
struct GroupPatch: Content {
    
    //MARK: Properties
    var id: UUID?
    var name: String?
}
