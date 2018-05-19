//
//  TestSuiteReport.swift
//  App
//
//  Created by William McGinty on 5/18/18.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct TestSuiteReport: Content, PostgreSQLUUIDModel, Migration {
    //MARK: Properties
    var id: UUID?
    let name: String
    let testCount: Int
    let failureCount: Int
    var projectID: UUID?
    
    var createdAt: Date?
    var updatedAt: Date?
    
    //MARK: Interface
    var cases: Children<TestSuiteReport, TestCaseReport> {
        return children(\.reportID)
    }
    
    func associating(with project: Project) -> TestSuiteReport {
        var copy = self
        copy.projectID = project.id
        return copy
    }
}

//MARK: Parameter
extension TestSuiteReport: Parameter { }

//MARK: Timestampable
extension TestSuiteReport: Timestampable {    
    static var createdAtKey: WritableKeyPath<TestSuiteReport, Date?> = \.createdAt
    static var updatedAtKey: WritableKeyPath<TestSuiteReport, Date?> = \.updatedAt
}

//MARK: ParentRetrievable
extension TestSuiteReport: ParentRetrievable {
    static var parentIDKey: KeyPath<TestSuiteReport, UUID?> = \.projectID
}
