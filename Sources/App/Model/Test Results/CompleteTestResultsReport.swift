//
//  CompleteTestResults.swift
//  App
//
//  Created by William McGinty on 5/18/18.
//

import Foundation

struct CompleteTestResultsReport {
    
    //MARK: Properties
    let name: String
    let testCount: Int
    let failureCount: Int
    let cases: [Case]
    
    //MARK: Case Subtype
    struct Case {
        
        //MARK: Properties
        let name: String
        let testCount: Int
        let failureCount: Int
        let tests: [Test]
        
        //MARK: Test Subtype
        struct Test {
        
            //MARK: Properties
            let className: String
            let name: String
            let duration: TimeInterval?
            let failures: [Failure]
            
            //MARK: Failure Subtype
            struct Failure {
                
                //MARK: Properties
                let message: String
                let location: String
            }
        }
    }
}
    
