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
        basicAuthGroup.post(Project.parameter, use: addTestResultsHandler)
    }
}

private extension TestResultsRouteController {
    
    func addTestResultsHandler(_ request: Request) throws -> HTTPResponseStatus {
        guard let xmlData = request.http.body.data else { throw Abort(.badRequest) }
        let xml = SWXMLHash.parse(xmlData)
        let a = xml["testsuites"]["testsuite"].all
        
        print("XML")
        print(a[0].element?.attribute(by: "name")?.text)
//        for b in a {
//            print(b)
//            print(b["name"].element?.text)
//            print(b["tests"].element?.text)
//            print(b["failures"].element?.text)
//        }

        return .ok
    }
}
