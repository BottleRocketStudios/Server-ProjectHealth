//
//  Bool+SQLiteDataConvertible.swift
//  App
//
//  Created by William McGinty on 4/29/18.
//

import Foundation
import FluentSQLite

enum SQLiteError: Error {
    case inconvertibleBool
}

extension Bool: SQLiteDataConvertible {
    
    /// See `SQLiteDataConvertible.convertFromSQLiteData(_:)`
    public static func convertFromSQLiteData(_ data: SQLiteData) throws -> Bool {
        switch data {
        case .integer(let integer):
            let state = integer != 0 ? true : false
            return state
        default:
            throw SQLiteError.inconvertibleBool
        }
    }
    
    /// See `convertToSQLiteData()`
    public func convertToSQLiteData() throws -> SQLiteData {
        let state = self == false ? 0 : 1
        return SQLiteData.integer(state)
    }
}
