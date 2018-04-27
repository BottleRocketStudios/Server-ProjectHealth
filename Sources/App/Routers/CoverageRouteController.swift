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
        return try request.parameters.next(Project.self).map(to: HTTPResponseStatus.self) { _ in
            return HTTPResponseStatus.internalServerError
        }

        
        
//        return Report(coverageReport: coverageReport).save(on: request).then { report -> Future<[[[Function]]]> in
//            let futureTargets: Future<[Target]> = coverageReport.targets.map { Target(target: $0, report: report).save(on: request) }.flatten(on: request)
        
//            //TODO: Not 100% sure I understand how this is working yet. But it is. It needs more work though.
//            return futureTargets.then { targets -> Future<[[[Function]]]> in
//                let y: [Future<[[Function]]>] = targets.compactMap { target in
//                    guard let match = coverageReport.target(matching: target) else { return nil }
//                    let futureFiles: Future<[FileReport]> = match.files.map { FileReport(file: $0, target: target).save(on: request) }.flatten(on: request)
//                    let futureFunctions = futureFiles.then { files -> Future<[[Function]]> in
//                        let futureFuncs: [Future<[Function]>] = files.compactMap { file in
//                            guard let match = coverageReport.file(matching: file) else { return nil }
//                            return match.functions.map { $0.associating(with: file).save(on: request) }.flatten(on: request)
//                        }
//                        return futureFuncs.flatten(on: request)
//                    }
//
//                    return futureFunctions
//                }
//                return y.flatten(on: request)
//            }
//        }.transform(to: HTTPResponseStatus.created)
    }
}
