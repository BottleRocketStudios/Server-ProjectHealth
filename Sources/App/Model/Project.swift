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
}

//MARK: Parameter
extension Project: Parameter { }
