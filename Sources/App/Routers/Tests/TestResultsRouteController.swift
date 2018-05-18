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
import XMLCoding


class TestResultsRouteController: RouteCollection {
    
    func boot(router: Router) throws {
        let group = router.grouped("api", "tests")
        
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCrypt)
        let basicAuthGroup = group.grouped(basicAuthMiddleware)
        basicAuthGroup.post(Project.parameter, use: addTestResultsHandler)
    }
}

private extension TestResultsRouteController {
    
    func addTestResultsHandler(_ request: Request) throws -> HTTPResponseStatus {
        guard let xmlData = request.http.body.data else { throw Abort(.badRequest) }
        let xml = try XMLDecoder().decode(TestSuites.self, from: xmlData)
        
        print(xml)


        return .ok
    }
}
