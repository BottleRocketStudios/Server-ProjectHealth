//
//  UserRouteController.swift
//  App
//
//  Created by Will McGinty on 4/16/18.
//

import Foundation
import Vapor
import Fluent
import Crypto

class UserRouteController: RouteCollection {
    
    func boot(router: Router) throws {
        let group = router.grouped("api", "users")
        group.post(User.self, at: "register", use: registerUserHandler)
    }
}

//MARK: Helper
private extension UserRouteController {
    
    func registerUserHandler(_ request: Request, newUser: User) throws -> Future<HTTPResponseStatus> {
        return try User.query(on: request).filter(\.email == newUser.email).first().flatMap { existingUser in
            
            guard existingUser == nil else { throw Abort(.badRequest, reason: "a user with this email already exists" , identifier: nil) /* User already exists */ }
            try newUser.validate()
            
            let hashed = try request.make(BCryptDigest.self).hash(newUser.password)
            return User(email: newUser.email, password: hashed).save(on: request).transform(to: .created)
        }
    }
}
