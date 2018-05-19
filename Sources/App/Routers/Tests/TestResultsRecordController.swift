//
//  TestResultsRecordController.swift
//  App
//
//  Created by William McGinty on 5/3/18.
//

import Foundation
import SWXMLHash

class TestResultsRecordController {
    
    struct TestResultsReport {
        let name: String
        let testCount: Int
        let failureCount: Int
        
        let suites: [TestCase]
    }
    
    struct TestCase {
        let name: String
        let testCount: Int
        let failureCount: Int
        
        let cases: [Test]
    }
    
    struct Test {
        let className: String
        let name: String
        let duration: TimeInterval?
        
        let failures: [TestFailure]
    }
    
    struct TestFailure {
        let message: String
        let location: String
    }
    
    static func parsedTestResults(from data: Data) throws -> TestResultsReport {
        let xml = SWXMLHash.parse(data)
        
        let reportName: String = try xml["testsuites"].value(ofAttribute: "name")
        let testCount: Int = try xml["testsuites"].value(ofAttribute: "tests")
        let failureCount: Int = try xml["testsuites"].value(ofAttribute: "failures")
        
        let suites = try xml["testsuites"]["testsuite"].all.map { indexer -> TestCase in
            let suiteName: String = try indexer.value(ofAttribute: "name")
            let testCount: Int = try xml["testsuites"].value(ofAttribute: "tests")
            let failureCount: Int = try xml["testsuites"].value(ofAttribute: "failures")
            
            let cases = try indexer["testcase"].all.map { indexer -> Test in
                let className: String = try indexer.value(ofAttribute: "classname")
                let testName: String = try indexer.value(ofAttribute: "name")
                let duration: TimeInterval? = xml["testsuites"].value(ofAttribute: "time")
                
                let failures = try indexer["failure"].all.map { indexer -> TestFailure in
                    let failureMessage: String = try indexer.value(ofAttribute: "message")
                    let location: String = indexer.element?.text ?? ""
                    return TestFailure(message: failureMessage, location: location)
                }
                
                return Test(className: className, name: testName, duration: duration, failures: failures)
            }
            return TestCase(name: suiteName, testCount: testCount, failureCount: failureCount, cases: cases)
        }
        
        return TestResultsReport(name: reportName, testCount: testCount, failureCount: failureCount, suites: suites)
    }
}
