//
//  CompleteTestResults.swift
//  App
//
//  Created by William McGinty on 5/18/18.
//

import Foundation
import Vapor

struct CompleteTestResultsReport: Content {
    
    //MARK: Properties
    let report: TestSuiteReport
    let cases: [Case]
    
    //MARK: Case Subtype
    struct Case: Content {
        
        //MARK: Properties
        let report: TestCaseReport
        let tests: [Test]
        
        //MARK: Test Subtype
        struct Test: Content {
        
            //MARK: Properties
            let report: UnitTestReport
            let failures: [TestFailureReport]
        }
    }
    
    //MARK: Interface
    func testCase(matching testCaseReport: TestCaseReport) -> CompleteTestResultsReport.Case? {
        return cases.first { $0.report == testCaseReport }
    }
    
    func unitTest(matching unitTestReport: UnitTestReport) -> CompleteTestResultsReport.Case.Test? {
        for testCase in cases {
            if let match = testCase.tests.first(where: { unitTestReport == $0.report }) {
                return match
            }
        }
        
        return nil
    }
}

//MARK: Codable
extension CompleteTestResultsReport.Case.Test {
    
    private enum CodingKeys: String, CodingKey {
        case failures
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(report: try UnitTestReport(from: decoder), failures: try container.decode([TestFailureReport].self, forKey: .failures))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(failures, forKey: .failures)
        try report.encode(to: encoder)
    }
}

//MARK: Codable
extension CompleteTestResultsReport.Case {
    
    private enum CodingKeys: String, CodingKey {
        case unitTests = "unit_tests"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(report: try TestCaseReport(from: decoder), tests: try container.decode([Test].self, forKey: .unitTests))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tests, forKey: .unitTests)
        try report.encode(to: encoder)
    }
}

//MARK: Codable
extension CompleteTestResultsReport {
    
    private enum CodingKeys: String, CodingKey {
        case testCases = "test_cases"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(report: try TestSuiteReport(from: decoder), cases: try container.decode([Case].self, forKey: .testCases))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cases, forKey: .testCases)
        try report.encode(to: encoder)
    }
}
    
