//
//  UnitTestReport.swift
//  App
//
//  Created by William McGinty on 5/18/18.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct UnitTestReport: Content, PostgreSQLUUIDModel, Migration {
    
    //MARK: Properties
    var id: UUID?
    let className: String
    let name: String
    let duration: TimeInterval?
    var caseID: UUID?
    
    //MARK: Interface
    var failures: Children<UnitTestReport, TestFailureReport> {
        return children(\.testID)
    }
    
    func associating(with target: TestCaseReport) -> UnitTestReport {
        var copy = self
        copy.caseID = target.id
        return copy
    }
    
    //MARK: Equatuable
    static func ==(lhs: UnitTestReport, rhs: UnitTestReport) -> Bool {
        return lhs.className == rhs.className && lhs.name == rhs.name && lhs.duration == rhs.duration
    }
}

//MARK: Parameter
extension UnitTestReport: Parameter { }

//MARK: ParentRetrievable
extension UnitTestReport: ParentRetrievable {
    static var parentIDKey: KeyPath<UnitTestReport, UUID?> = \.caseID
}

