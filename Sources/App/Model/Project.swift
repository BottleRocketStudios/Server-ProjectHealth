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
    var group: UUID?
    
    var isActive: Bool { return active == 1 }
    
    func inGroup(with id: UUID) -> Project {
        var copy = self
        copy.group = id
        return copy
    }
}
