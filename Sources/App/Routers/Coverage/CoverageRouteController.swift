//
//  CoverageRouteController.swift
//  App
//
//  Created by William McGinty on 4/26/18.
//

import Foundation
import Vapor
import Authentication
import Crypto
import Fluent
import FluentSQLite

class CoverageRouteController: RouteCollection {
    
    func boot(router: Router) throws {
        let group = router.grouped("api", "coverage")
        group.get(Project.parameter, use: getCoverageReportHandler)
        group.get("targets", CoverageReport.parameter, use: getTargetReportsHandler)
        group.get("files", TargetReport.parameter, use: getFileReportsHandler)
        group.get("functions", FileReport.parameter, use: getFunctionReportsHandler)

        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCrypt)
        let basicAuthGroup = group.grouped(basicAuthMiddleware)
        basicAuthGroup.post(CompleteReport.self, at: Project.parameter, use: addCoverageReportHandler)
    }
}

//MARK: Helper
private extension CoverageRouteController {
    
    func getCoverageReportHandler(_ request: Request) throws -> Future<[CoverageReport]> {
        let page = request.getPageInformation()
        return try request.parameters.next(Project.self).flatMap(to: [CoverageReport].self) { project in
            return try CoverageReport.query(on: request).whereParent(has: project.id).sortedByCreation().paged(to: page).all()
        }
    }
    
    func getTargetReportsHandler(_ request: Request) throws -> Future<[TargetReport]> {
        let page = request.getPageInformation()
        return try request.parameters.next(CoverageReport.self).flatMap(to: [TargetReport].self) { report in
            return try TargetReport.query(on: request).whereParent(has: report.id).paged(to: page).all()
        }
    }
    
    func getFileReportsHandler(_ request: Request) throws -> Future<[FileReport]> {
        let page = request.getPageInformation()
        return try request.parameters.next(TargetReport.self).flatMap(to: [FileReport].self) { report in
            return try FileReport.query(on: request).whereParent(has: report.id).paged(to: page).all()
        }
    }
    
    func getFunctionReportsHandler(_ request: Request) throws -> Future<[FunctionReport]> {
        let page = request.getPageInformation()
        return try request.parameters.next(FileReport.self).flatMap(to: [FunctionReport].self) { report in
            return try FunctionReport.query(on: request).whereParent(has: report.id).paged(to: page).all()
        }
    }
    
    func addCoverageReportHandler(_ request: Request, completeReport: CompleteReport) throws -> Future<HTTPResponseStatus> {
        return try request.parameters.next(Project.self).flatMap(to: HTTPResponseStatus.self) { project in
            return completeReport.report.associating(with: project).save(on: request).then { coverageReport -> Future<[[[FunctionReport]]]> in
                let targetsFuture: Future<[TargetReport]> = completeReport.targets.map { $0.report.associating(with: coverageReport).save(on: request) }.flatten(on: request)
                return CoverageRecordController.createFunctionRecords(for: targetsFuture, with: completeReport, on: request)
            }.transform(to: HTTPResponseStatus.created)
        }
    }
}
