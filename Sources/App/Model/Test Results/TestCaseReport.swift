//
//  TestCaseReport.swift
//  App
//
//  Created by William McGinty on 5/18/18.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct TestCaseReport: Content, PostgreSQLUUIDModel, Migration {
    
    //MARK: Properties
    var id: UUID?
    let name: String
    let testCount: Int
    let failureCount: Int
    var reportID: UUID?
    //MARK: Interface
    
    var tests: Children<TestCaseReport, UnitTestReport> {
        return children(\.caseID)
    }
    
    func associating(with report: TestSuiteReport) -> TestCaseReport {
        var copy = self
        copy.reportID = report.id
        return copy
    }
    
    //MARK: Equatuable
    static func ==(lhs: TestCaseReport, rhs: TestCaseReport) -> Bool {
        return lhs.name == rhs.name && lhs.testCount == rhs.testCount && lhs.failureCount == rhs.failureCount
    }
}

//MARK: Parameter
extension TestCaseReport: Parameter { }

//MARK: ParentRetrievable
extension TestCaseReport: ParentRetrievable {
    static var parentIDKey: KeyPath<TestCaseReport, UUID?> = \.reportID
}
