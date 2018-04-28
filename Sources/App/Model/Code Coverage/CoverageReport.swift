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
    
    var createdAt: Date?
    var updatedAt: Date?
    
    //MARK: Interface
    var targets: Children<CoverageReport, TargetReport> {
        return children(\.reportID)
    }
    
    func associating(with project: Project) -> CoverageReport {
        var copy = self
        copy.projectID = project.id
        return copy
    }
}

extension CoverageReport: Timestampable {
    static var createdAtKey: WritableKeyPath<CoverageReport, Date?> = \.createdAt
    static var updatedAtKey: WritableKeyPath<CoverageReport, Date?> = \.updatedAt
}
