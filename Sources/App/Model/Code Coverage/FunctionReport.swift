//
//  Function.swift
//  App
//
//  Created by William McGinty on 4/26/18.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite

struct FunctionReport: Content, SQLiteUUIDModel, Migration, Equatable {
    
    //MARK: Properties
    var id: UUID?
    let name: String
    let coveredLines: Int
    let executableLines: Int
    let lineCoverage: Double
    let lineNumber: Int
    let executionCount: Int
    
    var fileID: UUID?
    
    //MARK: Interface
    func associating(with file: FileReport) -> FunctionReport {
        var copy = self
        copy.fileID = file.id
        return copy
    }
}

//MARK: Parameter
extension FunctionReport: Parameter { }

//MARK: ParentRetrievable
extension FunctionReport: ParentRetrievable {
    static var parentIDKey: KeyPath<FunctionReport, UUID?> = \.fileID
}
