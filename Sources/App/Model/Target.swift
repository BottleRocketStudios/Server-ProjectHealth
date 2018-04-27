//
//  Target.swift
//  App
//
//  Created by William McGinty on 4/26/18.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite

struct Target: Content, SQLiteUUIDModel, Migration {
    
    //MARK: Properties
    var id: UUID?
    let name: String
    let buildProductPath: String
    
    let coveredLines: Int
    let executableLines: Int
    let lineCoverage: Double
    
    var reportID: UUID?
    
    var files: Children<Target, File> {
        return children(\.targetID)
    }
}

//MARK: Convenience Initializer
extension Target {
    init(target: CoverageReport.Target, report: Report) {
        self.init(id: nil, name: target.name, buildProductPath: target.buildProductPath,
                  coveredLines: target.coveredLines, executableLines: target.executableLines, lineCoverage: target.lineCoverage, reportID: report.id)
    }
}
