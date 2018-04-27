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

struct Function: Content, SQLiteUUIDModel, Migration {
    
    //MARK: Properties
    var id: UUID?
    let name: String
    let coveredLines: Int
    let executableLines: Int
    let lineCoverage: Double
    let lineNumber: Int
    let executionCount: Int
    
    var fileID: UUID?
}

//MARK: Convenience Initializer
extension Function {
    
    init(function: Function, file: File) {
        self.init(id: nil, name: function.name, coveredLines: function.coveredLines, executableLines: function.executableLines, lineCoverage: function.lineCoverage, lineNumber: function.lineNumber, executionCount: function.executionCount, fileID: file.id)
    }
    
}
