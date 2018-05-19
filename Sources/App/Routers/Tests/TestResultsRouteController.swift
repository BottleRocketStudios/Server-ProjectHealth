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
        
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCrypt)
        let basicAuthGroup = group.grouped(basicAuthMiddleware)
        basicAuthGroup.post(Project.parameter, use: addTestResultsReportHandler)
    }
}

private extension TestResultsRouteController {
    
    func addTestResultsReportHandler(_ request: Request) throws -> Future<HTTPResponseStatus> {
        guard let xmlData = request.http.body.data else { throw Abort(.badRequest) }
        let testResults = try TestResultsParseController.parsedTestResults(from: xmlData)
        
        return try addTestResultsReportHandler(request, testResults: testResults)
    }
    
    func addTestResultsReportHandler(_ request: Request, testResults: CompleteTestResultsReport) throws -> Future<HTTPResponseStatus> {
        return Future.map(on: request) {
            return HTTPResponseStatus.ok
        }
        
//        return try request.parameters.next(Project.self).flatMap { project in
//
//
//            return completeReport.report.associating(with: project).save(on: request).then { coverageReport -> Future<[[[FunctionReport]]]> in
//                let targetsFuture: Future<[TargetReport]> = completeReport.targets.map { $0.report.associating(with: coverageReport).save(on: request) }.flatten(on: request)
//                return CoverageRecordController.createFunctionRecords(for: targetsFuture, with: completeReport, on: request)
//                }.transform(to: HTTPResponseStatus.created)
//        }
    }
}
