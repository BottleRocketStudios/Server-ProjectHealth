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
        let offset = (try? request.query.get(Int.self, at: "offset")) ?? 0
        let maxResults = (try? request.query.get(Int.self, at: "count")) ?? .max
        return try request.parameters.next(Project.self).flatMap(to: [CoverageReport].self) { project in
            return try CoverageReport.query(on: request).filter(\.projectID == project.id).sort(\.createdAt, .ascending).range(offset..<maxResults).all()
        }
    }
    
    func getTargetReportsHandler(_ request: Request) throws -> Future<[TargetReport]> {
        let offset = (try? request.query.get(Int.self, at: "offset")) ?? 0
        let maxResults = (try? request.query.get(Int.self, at: "count")) ?? .max
        
        return try request.parameters.next(CoverageReport.self).flatMap(to: [TargetReport].self) { report in
            return try TargetReport.query(on: request).filter(\.reportID == report.id).range(offset..<maxResults).all()
        }
    }
    
    func getFileReportsHandler(_ request: Request) throws -> Future<[FileReport]> {
        let offset = (try? request.query.get(Int.self, at: "offset")) ?? 0
        let maxResults = (try? request.query.get(Int.self, at: "count")) ?? .max
        
        return try request.parameters.next(TargetReport.self).flatMap(to: [FileReport].self) { report in
            return try FileReport.query(on: request).filter(\.targetID == report.id).range(offset..<maxResults).all()
        }
    }
    
    func getFunctionReportsHandler(_ request: Request) throws -> Future<[FunctionReport]> {
        let offset = (try? request.query.get(Int.self, at: "offset")) ?? 0
        let maxResults = (try? request.query.get(Int.self, at: "count")) ?? .max
        
        return try request.parameters.next(FileReport.self).flatMap(to: [FunctionReport].self) { report in
            return try FunctionReport.query(on: request).filter(\.fileID == report.id).range(offset..<maxResults).all()
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
