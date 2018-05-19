//
//  TestResultsParseController.swift
//  App
//
//  Created by William McGinty on 5/18/18.
//

import Foundation
import SWXMLHash

class TestResultsParseController {
    
    static func parsedTestResults(from data: Data) throws -> CompleteTestResultsReport {
        let xml = SWXMLHash.parse(data)
        
        let reportName: String = try xml["testsuites"].value(ofAttribute: "name")
        let testCount: Int = try xml["testsuites"].value(ofAttribute: "tests")
        let failureCount: Int = try xml["testsuites"].value(ofAttribute: "failures")
        
        let cases = try xml["testsuites"]["testsuite"].all.map { indexer -> CompleteTestResultsReport.Case in
            let suiteName: String = try indexer.value(ofAttribute: "name")
            let testCount: Int = try xml["testsuites"].value(ofAttribute: "tests")
            let failureCount: Int = try xml["testsuites"].value(ofAttribute: "failures")
            
            let tests = try indexer["testcase"].all.map { indexer -> CompleteTestResultsReport.Case.Test in
                let className: String = try indexer.value(ofAttribute: "classname")
                let testName: String = try indexer.value(ofAttribute: "name")
                let duration: TimeInterval? = xml["testsuites"].value(ofAttribute: "time")
                
                let failures = try indexer["failure"].all.map { indexer -> CompleteTestResultsReport.Case.Test.Failure in
                    let failureMessage: String = try indexer.value(ofAttribute: "message")
                    let location: String = indexer.element?.text ?? ""
                    return CompleteTestResultsReport.Case.Test.Failure(message: failureMessage, location: location)
                }
                
                return CompleteTestResultsReport.Case.Test(className: className, name: testName, duration: duration, failures: failures)
            }
            return CompleteTestResultsReport.Case(name: suiteName, testCount: testCount, failureCount: failureCount, tests: tests)
        }
        return CompleteTestResultsReport(name: reportName, testCount: testCount, failureCount: failureCount, cases: cases)
    }
}

