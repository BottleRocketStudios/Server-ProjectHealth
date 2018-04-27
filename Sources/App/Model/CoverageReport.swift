//
//  CoverageReport.swift
//  App
//
//  Created by William McGinty on 4/26/18.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite

struct CoverageReport: Content {
    
    //MARK: Properties
    let coveredLines: Int
    let executableLines: Int
    let lineCoverage: Double
    
    let targets: [Target]
    
    func target(matching target: App.Target) -> CoverageReport.Target? {
        return targets.first { $0.name == target.name }
    }
    
    func file(matching file: App.File) -> CoverageReport.Target.File? {
        for target in targets {
            if let f = target.files.first(where: { file.name == $0.name }) {
                return f
            }
        }
        
        return nil
    }
    
    //MARK: Target Subtype
    struct Target: Content {
        
        //MARK: Properties
        let name: String
        let buildProductPath: String
        
        let coveredLines: Int
        let executableLines: Int
        let lineCoverage: Double
        
        let files: [File]
        
        //MARK: File Subtype
        struct File: Content {
            
            //MARK: Properties
            let name: String
            let path: String
            
            let coveredLines: Int
            let executableLines: Int
            let lineCoverage: Double
            
            let functions: [Function]
            
            //MARK: Function Subtype
            struct Function: Content {
                let name: String
                let coveredLines: Int
                let executableLines: Int
                let lineCoverage: Double
                let lineNumber: Int
                let executionCount: Int
            }
        }
    }
}
