//
//  Group.swift
//  App
//
//  Created by Will McGinty on 4/6/18.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite

struct Group: Content, SQLiteUUIDModel, Migration  {
    
    //MARK: Properties
    var id: UUID?
    var name: String
    
    var projects: Children<Group, Project> {
        return children(\.groupID)
    }
}

//MARK: Parameter
extension Group: Parameter { }
