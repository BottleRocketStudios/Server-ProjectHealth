//
//  Validator+Custom.swift
//  App
//
//  Created by Will McGinty on 4/16/18.
//

import Foundation
import Validation

fileprivate struct BottleRocketEmailValidator: ValidatorType {

    //MARK: Properties
    private var emailValidator: Validator = .email
    public var validatorReadable: String { return "a valid BottleRocket email address" }
    
    //MARK: Initializers
    public init() {}
    
    public func validate(_ s: String) throws {
        try emailValidator.validate(s)
        guard let range = s.range(of: "@bottlerocketstudios.com"), range.upperBound == s.endIndex else { throw BasicValidationError("is not a valid BottleRocket email address") }
    }
}

extension Validator where T == String {
    
    public static var bottleRocketEmail: Validator<T> {
        return BottleRocketEmailValidator().validator()
    }
}
