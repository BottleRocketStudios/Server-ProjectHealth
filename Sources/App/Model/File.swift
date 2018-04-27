//
//  File.swift
//  App
//
//  Created by William McGinty on 4/26/18.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite

struct File: Content, SQLiteUUIDModel, Migration {
    
    //MARK: Properties
    var id: UUID?
    let name: String
    let path: String
    
    let coveredLines: Int
    let executableLines: Int
    let lineCoverage: Double
    
    var targetID: UUID?
    
    var functions: Children<File, Function> {
        return children(\.fileID)
    }
}

//MARK: Convenience Initializer
extension File {
    init(file: CoverageReport.Target.File, target: Target) {
        self.init(id: nil, name: file.name, path: file.path, coveredLines: file.coveredLines, executableLines: file.executableLines, lineCoverage: file.lineCoverage, targetID: target.id)
    }
}
