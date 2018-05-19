//
//  CoverageReport.swift
//  App
//
//  Created by William McGinty on 4/26/18.
//

import Foundation
import Vapor

struct CompleteCoverageReport: Content {
    
    //MARK: Properties
    let report: CoverageReport
    let targets: [Target]
    
    //MARK: Target Subtype
    struct Target: Content {
        
        //MARK: Properties
        let report: TargetReport        
        let files: [File]
        
        //MARK: File Subtype
        struct File: Content {
            
            //MARK: Properties
            let report: FileReport
            let functions: [FunctionReport]
        }
    }
    
    //MARK: Interface
    func target(matching targetReport: TargetReport) -> CompleteCoverageReport.Target? {
        return targets.first { $0.report == targetReport }
    }

    func file(matching fileReport: FileReport) -> CompleteCoverageReport.Target.File? {
        for target in targets {
            if let match = target.files.first(where: { fileReport == $0.report }) {
                return match
            }
        }
        
        return nil
    }
}

//MARK: Codable
extension CompleteCoverageReport.Target.File {
    
    private enum CodingKeys: String, CodingKey {
        case functions
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(report: try FileReport(from: decoder), functions: try container.decode([FunctionReport].self, forKey: .functions))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(functions, forKey: .functions)
        try report.encode(to: encoder)
    }
}

//MARK: Codable
extension CompleteCoverageReport.Target {
    
    private enum CodingKeys: String, CodingKey {
        case files
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(report: try TargetReport(from: decoder), files: try container.decode([File].self, forKey: .files))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(files, forKey: .files)
        try report.encode(to: encoder)
    }
}

//MARK: Codable
extension CompleteCoverageReport {
    
    private enum CodingKeys: String, CodingKey {
        case targets
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(report: try CoverageReport(from: decoder), targets: try container.decode([Target].self, forKey: .targets))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(targets, forKey: .targets)
        try report.encode(to: encoder)
    }
}
