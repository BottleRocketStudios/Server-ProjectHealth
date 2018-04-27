//
//  CoverageRecordController.swift
//  App
//
//  Created by Will McGinty on 4/27/18.
//

import Foundation
import Vapor

struct CoverageRecordController {
    
    static func createFunctionRecords(for targetsFuture: Future<[TargetReport]>, with completeReport: CompleteReport, on worker: Worker & DatabaseConnectable) -> Future<[[[FunctionReport]]]> {
        return targetsFuture.then { targetReports in
            return targetReports.compactMap { targetReport -> Future<[[FunctionReport]]>? in
                guard let match = completeReport.target(matching: targetReport) else { return nil }
                let filesFuture: Future<[FileReport]> = match.files.map { $0.report.associating(with: targetReport).save(on: worker) }.flatten(on: worker)
                return createFunctionRecords(for: filesFuture, with: completeReport, on: worker)
            }.flatten(on: worker)
        }
    }
    
    private static func createFunctionRecords(for futureFiles: Future<[FileReport]>, with completeReport: CompleteReport, on worker: Worker & DatabaseConnectable) -> Future<[[FunctionReport]]> {
        return futureFiles.then { fileReports -> Future<[[FunctionReport]]> in
            let functionsFuture: [Future<[FunctionReport]>] =  fileReports.compactMap { file in
                guard let match = completeReport.file(matching: file) else { return nil }
                return match.functions.map { $0.associating(with: file).save(on: worker) }.flatten(on: worker)
            }
            return functionsFuture.flatten(on: worker)
        }
    }
}
