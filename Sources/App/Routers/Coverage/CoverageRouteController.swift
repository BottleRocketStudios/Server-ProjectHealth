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

class CoverageRouteController: RouteCollection {
    
    func boot(router: Router) throws {
        let group = router.grouped("api", "coverage")
        
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCrypt)
        let basicAuthGroup = group.grouped(basicAuthMiddleware)
        basicAuthGroup.post(CompleteReport.self, at: Project.parameter, use: addCoverageReportHandler)
    }
}

//MARK: Helper
private extension CoverageRouteController {
    
    func addCoverageReportHandler(_ request: Request, completeReport: CompleteReport) throws -> Future<HTTPResponseStatus> {
        return try request.parameters.next(Project.self).flatMap(to: HTTPResponseStatus.self) { project in
            return completeReport.report.associating(with: project).save(on: request).then { coverageReport -> Future<[[[FunctionReport]]]> in
                let targetsFuture: Future<[TargetReport]> = completeReport.targets.map { $0.report.associating(with: coverageReport).save(on: request) }.flatten(on: request)
                return CoverageRecordController.createFunctionRecords(for: targetsFuture, with: completeReport, on: request)
            }.transform(to: HTTPResponseStatus.created)
        }
    }
}
