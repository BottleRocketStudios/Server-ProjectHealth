//
//  ParentRetrievable.swift
//  App
//
//  Created by William McGinty on 4/27/18.
//

import Foundation

protocol ParentRetrievable {
    static var parentIDKey: KeyPath<Self, UUID?> { get }
}
