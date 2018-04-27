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

struct FileReport: Content, SQLiteUUIDModel, Migration, Equatable {
    
    //MARK: Properties
    var id: UUID?
    let name: String
    let path: String
    let coveredLines: Int
    let executableLines: Int
    let lineCoverage: Double
    var targetID: UUID?
    
    //MARK: Interface
    var functions: Children<FileReport, FunctionReport> {
        return children(\.fileID)
    }
    
    func associating(with target: TargetReport) -> FileReport {
        var copy = self
        copy.targetID = target.id
        return copy
    }
    
    //MARK: Equatuable
    static func ==(lhs: FileReport, rhs: FileReport) -> Bool {
        return lhs.name == rhs.name && lhs.path == rhs.path
    }
}

