//
//  TestFailureReport.swift
//  App
//
//  Created by William McGinty on 5/18/18.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct TestFailureReport: Content, PostgreSQLUUIDModel, Migration {
    
    //MARK: Properties
    var id: UUID?
    let message: String
    let location: String
    var testID: UUID?
    
    //MARK: Interface
    func associating(with file: UnitTestReport) -> TestFailureReport {
        var copy = self
        copy.testID = file.id
        return copy
    }
}

//MARK: Parameter
extension TestFailureReport: Parameter { }

//MARK: ParentRetrievable
extension TestFailureReport: ParentRetrievable {
    static var parentIDKey: KeyPath<TestFailureReport, UUID?> = \.testID
}

