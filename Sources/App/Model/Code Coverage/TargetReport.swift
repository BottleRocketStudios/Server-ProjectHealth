//
//  Target.swift
//  App
//
//  Created by William McGinty on 4/26/18.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite

struct TargetReport: Content, SQLiteUUIDModel, Migration, Equatable {
    
    //MARK: Properties
    var id: UUID?
    let name: String
    let buildProductPath: String
    
    let coveredLines: Int
    let executableLines: Int
    let lineCoverage: Double
    
    var reportID: UUID?
    
    var files: Children<TargetReport, FileReport> {
        return children(\.targetID)
    }
}
