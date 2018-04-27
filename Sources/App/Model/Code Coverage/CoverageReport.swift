//
//  Report.swift
//  App
//
//  Created by William McGinty on 4/26/18.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite

struct CoverageReport: Content, SQLiteUUIDModel, Migration {
    
    //MARK: Properties
    var id: UUID?
    let coveredLines: Int
    let executableLines: Int
    let lineCoverage: Double
    
    var projectID: UUID?
    
    var targets: Children<CoverageReport, TargetReport> {
        return children(\.reportID)
    }
}
