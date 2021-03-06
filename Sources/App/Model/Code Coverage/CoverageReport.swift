//
//  Report.swift
//  App
//
//  Created by William McGinty on 4/26/18.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct CoverageReport: Content, PostgreSQLUUIDModel, Migration {
    
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

//MARK: Parameter
extension CoverageReport: Parameter { }

//MARK: Timestampable
extension CoverageReport: Timestampable {
    static var createdAtKey: WritableKeyPath<CoverageReport, Date?> = \.createdAt
    static var updatedAtKey: WritableKeyPath<CoverageReport, Date?> = \.updatedAt
}

//MARK: ParentRetrievable
extension CoverageReport: ParentRetrievable {
    static var parentIDKey: KeyPath<CoverageReport, UUID?> = \.projectID
}
