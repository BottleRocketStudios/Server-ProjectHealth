//
//  TestResultsRouteController.swift
//  App
//
//  Created by William McGinty on 5/3/18.
//

import Foundation
import Vapor
import Authentication
import Crypto
import Fluent
import SWXMLHash

class TestResultsRouteController: RouteCollection {
    
    func boot(router: Router) throws {
        let group = router.grouped("api", "tests")
        group.get(Project.parameter, use: getTestResultsReportHandler)
        group.get("complete", Project.parameter, use: getCompleteTestResultsReportHandler)
        group.get("cases", TestSuiteReport.parameter, use: getTestCaseReportsHandler)
        group.get("unittests", TestCaseReport.parameter, use: getUnitTestReportsHandler)
        group.get("failures", UnitTestReport.parameter, use: getTestFailureReportsHandler)
        
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCrypt)
        let basicAuthGroup = group.grouped(basicAuthMiddleware)
        basicAuthGroup.post(Project.parameter, use: addTestResultsReportHandler)
    }
}

private extension TestResultsRouteController {
    
    //MARK: Retrieve
    func getTestResultsReportHandler(_ request: Request) throws -> Future<[TestSuiteReport]> {
        let page = request.getPageInformation()
        let direction = request.getSortDirection()
        return try request.parameters.next(Project.self).flatMap { project in
            return try TestSuiteReport.query(on: request).whereParent(has: project.id).sortedByCreation(in: direction).paged(to: page).all()
        }
    }
    
    func getCompleteTestResultsReportHandler(_ request: Request) throws -> Future<[CompleteTestResultsReport]> {
        return try getTestResultsReportHandler(request).flatMap { testSuiteReports in
            return try testSuiteReports.map { try TestResultsRecordController.completeReport(for: $0, on: request) }.flatten(on: request)
        }
    }
    
    func getTestCaseReportsHandler(_ request: Request) throws -> Future<[TestCaseReport]> {
        let page = request.getPageInformation()
        return try request.parameters.next(TestSuiteReport.self).flatMap { report in
            return try TestCaseReport.query(on: request).whereParent(has: report.id).paged(to: page).all()
        }
    }
    
    func getUnitTestReportsHandler(_ request: Request) throws -> Future<[UnitTestReport]> {
        let page = request.getPageInformation()
        return try request.parameters.next(TestCaseReport.self).flatMap { report in
            return try UnitTestReport.query(on: request).whereParent(has: report.id).paged(to: page).all()
        }
    }
    
    func getTestFailureReportsHandler(_ request: Request) throws -> Future<[TestFailureReport]> {
        let page = request.getPageInformation()
        return try request.parameters.next(UnitTestReport.self).flatMap { report in
            return try TestFailureReport.query(on: request).whereParent(has: report.id).paged(to: page).all()
        }
    }
    
    //MARK: Add New
    func addTestResultsReportHandler(_ request: Request) throws -> Future<HTTPResponseStatus> {
        guard let xmlData = request.http.body.data else { throw Abort(.badRequest) }
        let testResults = try TestResultsParseController.parsedTestResults(from: xmlData)
        
        return try addTestResultsReportHandler(request, completeReport: testResults)
    }
    
    func addTestResultsReportHandler(_ request: Request, completeReport: CompleteTestResultsReport) throws -> Future<HTTPResponseStatus> {
        return try request.parameters.next(Project.self).flatMap { project in
            return completeReport.report.associating(with: project).save(on: request).then { suiteReport -> Future<[[[TestFailureReport]]]> in
                let casesFuture: Future<[TestCaseReport]> = completeReport.cases.map { $0.report.associating(with: suiteReport).save(on: request) }.flatten(on: request)
                return TestResultsRecordController.createFailureRecords(for: casesFuture, with: completeReport, on: request)
            }.transform(to: .created)
        }
    }
}
