//
//  Report.swift
//  App
//
//  Created by William McGinty on 4/26/18.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite

struct Report: Content, SQLiteUUIDModel, Migration {
    
    //MARK: Properties
    var id: UUID?
    let coveredLines: Int
    let executableLines: Int
    let lineCoverage: Double
    
    var projectID: UUID?
    
    var targets: Children<Report, Target> {
        return children(\.reportID)
    }
}

//MARK: Convenience Initializer
extension Report {
    init(coverageReport: CoverageReport) {
        self.init(id: nil, coveredLines: coverageReport.coveredLines, executableLines: coverageReport.executableLines, lineCoverage: coverageReport.lineCoverage)
    }
}
