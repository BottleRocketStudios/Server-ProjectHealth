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
        basicAuthGroup.post(CoverageReport.self, at: Project.parameter, use: addCoverageReportHandler)
    }
}

//MARK: Helper
private extension CoverageRouteController {
    
    func addCoverageReportHandler(_ request: Request, report: CoverageReport) throws -> HTTPResponseStatus {
        print(report)
        return .ok
    }
}
