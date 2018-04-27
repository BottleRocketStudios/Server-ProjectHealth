//
//  User.swift
//  App
//
//  Created by Will McGinty on 4/16/18.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite
import Authentication
import Validation

struct User: Content, SQLiteUUIDModel, Migration {
    
    //MARK: Properties
    var id: UUID?
    var email: String
    var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

//MARK: BasicAuthenticatable
extension User: BasicAuthenticatable {
    
    static let usernameKey: WritableKeyPath<User, String> = \User.email
    static let passwordKey: WritableKeyPath<User, String> = \User.password
}

//MARK: Validatable
extension User: Validatable {
    
    static func validations() throws -> Validations<User> {
        var validations = Validations(User.self)
        try validations.add(\.email, .count(1...) && .bottleRocketEmail)
        
        return validations
    }
}