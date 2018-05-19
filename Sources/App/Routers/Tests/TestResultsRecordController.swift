//
//  TestResultsRecordController.swift
//  App
//
//  Created by William McGinty on 5/3/18.
//

import Foundation
import Vapor

struct TestResultsRecordController {
    
    //MARK: Import
    static func createFailureRecords(for casesFuture: Future<[TestCaseReport]>, with completeReport: CompleteTestResultsReport, on worker: Worker & DatabaseConnectable) -> Future<[[[TestFailureReport]]]> {
        return casesFuture.then { caseReports in
            return caseReports.compactMap { caseReport -> Future<[[TestFailureReport]]>? in
                guard let match = completeReport.testCase(matching: caseReport) else { return nil }
                let testsFuture: Future<[UnitTestReport]> = match.tests.map { $0.report.associating(with: caseReport).save(on: worker) }.flatten(on: worker)
                return createFailureRecords(for: testsFuture, with: completeReport, on: worker)
            }.flatten(on: worker)
        }
    }
    
    private static func createFailureRecords(for testsFuture: Future<[UnitTestReport]>, with completeReport: CompleteTestResultsReport, on worker: Worker & DatabaseConnectable) -> Future<[[TestFailureReport]]> {
        return testsFuture.then { testReports -> Future<[[TestFailureReport]]> in
            let failuresFuture: [Future<[TestFailureReport]>] = testReports.compactMap{ unitTest in
                guard let match = completeReport.unitTest(matching: unitTest) else { return nil }
                return match.failures.map { $0.associating(with: unitTest).save(on: worker) }.flatten(on: worker)
            }
            return failuresFuture.flatten(on: worker)
        }
    }
    

    //MARK: Export
    static func completeReport(for report: TestSuiteReport, on worker: Worker & DatabaseConnectable) throws -> Future<CompleteTestResultsReport> {
        return try report.cases.query(on: worker).all().flatMap { caseReports in
            return try caseReports.map { try self.completeTestCase(for: $0, on: worker) }.map(to: CompleteTestResultsReport.self, on: worker) { cases in
                return CompleteTestResultsReport(report: report, cases: cases)
            }
        }
    }
    
    private static func completeTestCase(for caseReport: TestCaseReport, on worker: Worker & DatabaseConnectable) throws -> Future<CompleteTestResultsReport.Case> {
        return try caseReport.tests.query(on: worker).all().flatMap { testReports in
            return try testReports.map { try self.completeTest(for: $0, on: worker) }.map(to: CompleteTestResultsReport.Case.self, on: worker) { tests in
                return CompleteTestResultsReport.Case(report: caseReport, tests: tests)
                
            }
        }
    }
    
    private static func completeTest(for testReport: UnitTestReport, on worker: DatabaseConnectable) throws -> Future<CompleteTestResultsReport.Case.Test> {
        return try testReport.failures.query(on: worker).all().map { failures in
            return CompleteTestResultsReport.Case.Test(report: testReport, failures: failures)
        }
    }
}
