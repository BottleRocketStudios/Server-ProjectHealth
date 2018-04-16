//
//  UserRouteController.swift
//  App
//
//  Created by Will McGinty on 4/16/18.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite
import Crypto

class UserRouteController: RouteCollection {
    
    func boot(router: Router) throws {
        let group = router.grouped("api", "users")
        group.post("register", use: registerUserHandler)
    }
}

//MARK: Helper
private extension UserRouteController {
    
    func registerUserHandler(_ request: Request) throws -> Future<HTTPResponseStatus> {
        return try request.content.decode(User.self).flatMap(to: HTTPResponseStatus.self) { newUser in
            return try User.query(on: request).filter(\.email == newUser.email).first().flatMap(to: HTTPResponseStatus.self) { existingUser in
                guard existingUser == nil else { throw Abort(.badRequest) }
                try newUser.validate()
                
                guard let hashed = String(data: try request.make(BCryptDigest.self).hash(newUser.password), encoding: .utf8) else { throw Abort(.internalServerError) }
                return User(email: newUser.email, password: hashed).save(on: request).transform(to: .created)
            }
        }
    }
}
