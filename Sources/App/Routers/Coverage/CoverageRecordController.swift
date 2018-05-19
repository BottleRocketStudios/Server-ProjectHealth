//
//  CoverageRecordController.swift
//  App
//
//  Created by Will McGinty on 4/27/18.
//

import Foundation
import Vapor

struct CoverageRecordController {
    
    //MARK: Import
    static func createFunctionRecords(for targetsFuture: Future<[TargetReport]>, with completeReport: CompleteCoverageReport, on worker: Worker & DatabaseConnectable) -> Future<[[[FunctionReport]]]> {
        return targetsFuture.then { targetReports in
            return targetReports.compactMap { targetReport -> Future<[[FunctionReport]]>? in
                guard let match = completeReport.target(matching: targetReport) else { return nil }
                let filesFuture: Future<[FileReport]> = match.files.map { $0.report.associating(with: targetReport).save(on: worker) }.flatten(on: worker)
                return createFunctionRecords(for: filesFuture, with: completeReport, on: worker)
            }.flatten(on: worker)
        }
    }
    
    private static func createFunctionRecords(for futureFiles: Future<[FileReport]>, with completeReport: CompleteCoverageReport, on worker: Worker & DatabaseConnectable) -> Future<[[FunctionReport]]> {
        return futureFiles.then { fileReports -> Future<[[FunctionReport]]> in
            let functionsFuture: [Future<[FunctionReport]>] =  fileReports.compactMap { file in
                guard let match = completeReport.file(matching: file) else { return nil }
                return match.functions.map { $0.associating(with: file).save(on: worker) }.flatten(on: worker)
            }
            return functionsFuture.flatten(on: worker)
        }
    }
    
    //MARK: Export
    static func completeReport(for report: CoverageReport, on worker: Worker & DatabaseConnectable) throws -> Future<CompleteCoverageReport> {
        return try report.targets.query(on: worker).all().flatMap { targetReports in
            return try targetReports.map { try self.completeTarget(for: $0, on: worker) }.map(to: CompleteCoverageReport.self, on: worker) { targets in
                return CompleteCoverageReport(report: report, targets: targets)
            }
        }
    }
    
    private static func completeTarget(for target: TargetReport, on worker: Worker & DatabaseConnectable) throws -> Future<CompleteCoverageReport.Target> {
        return try target.files.query(on: worker).all().flatMap { fileReports in
            return try fileReports.map { try self.completeFile(for: $0, on: worker) }.map(to: CompleteCoverageReport.Target.self, on: worker) { files in
                return CompleteCoverageReport.Target(report: target, files: files)
            }
        }
    }
    
    private static func completeFile(for file: FileReport, on worker: DatabaseConnectable) throws -> Future<CompleteCoverageReport.Target.File> {
        return try file.functions.query(on: worker).all().map { functions in
            return CompleteCoverageReport.Target.File(report: file, functions: functions)
        }
    }
}
