//
//  TestSuite.swift
//  App
//
//  Created by William McGinty on 5/17/18.
//

import Foundation

struct TestSuites: Decodable {
    let name: String
    let tests: Int
    let failures: Int
    
    let testsuite: [TestSuite]
}

struct TestSuite: Decodable {
    let name: String
    let tests: Int
    let failures: Int
    
    let testcase: [TestCase]
}

struct TestCase: Decodable {
    let classname: String
    let name: String
    let time: Double?
    
    let failure: String?
}

//struct Failure: Decodable {
//    let message: String
//}

/*
 <?xml version='1.0' encoding='UTF-8'?>
 <testsuites name='Edits_Tests.xctest' tests='30' failures='1'>
 <testsuite name='Edits_Tests.ExtensionTests' tests='4' failures='0'>
 <testcase classname='Edits_Tests.ExtensionTests' name='testBifilter' time='0.001'/>
 <testcase classname='Edits_Tests.ExtensionTests' name='testCollectionElementAtOffset' time='0.006'/>
 <testcase classname='Edits_Tests.ExtensionTests' name='testCollectionElementAtOffsetNotStartingAtZero' time='0.001'/>
 <testcase classname='Edits_Tests.ExtensionTests' name='testCollectionElementAtOffsetOutOfBounds' time='0.001'/>
 </testsuite>
 <testsuite name='Edits_Tests.InterfaceTests' tests='12' failures='0'>
 <testcase classname='Edits_Tests.InterfaceTests' name='testDeleteCollectionEdits' time='0.006'/>
 <testcase classname='Edits_Tests.InterfaceTests' name='testDeleteIndexPathGeneration' time='0.001'/>
 <testcase classname='Edits_Tests.InterfaceTests' name='testDeleteTableEdits' time='0.003'/>
 <testcase classname='Edits_Tests.InterfaceTests' name='testInsertCollectionEdits' time='0.002'/>
 <testcase classname='Edits_Tests.InterfaceTests' name='testInsertIndexPathGeneration' time='0.001'/>
 <testcase classname='Edits_Tests.InterfaceTests' name='testInsertTableEdits' time='0.002'/>
 <testcase classname='Edits_Tests.InterfaceTests' name='testMoveCollectionEdits' time='0.001'/>
 <testcase classname='Edits_Tests.InterfaceTests' name='testMoveIndexPathGeneration' time='0.001'/>
 <testcase classname='Edits_Tests.InterfaceTests' name='testMoveTableEdits' time='0.001'/>
 <testcase classname='Edits_Tests.InterfaceTests' name='testSubstituteCollectionEdits' time='0.001'/>
 <testcase classname='Edits_Tests.InterfaceTests' name='testSubstituteTableEdits' time='0.001'/>
 <testcase classname='Edits_Tests.InterfaceTests' name='testSubstitutionIndexPathGeneration' time='0.001'/>
 </testsuite>
 <testsuite name='Edits_Tests.Tests' tests='14' failures='1'>
 <testcase classname='Edits_Tests.Tests' name='testAnyEditorPerform' time='0.002'/>
 <testcase classname='Edits_Tests.Tests' name='testAnyRangeAlteringEditor' time='0.001'/>
 <testcase classname='Edits_Tests.Tests' name='testBasicTransforms' time='0.003'/>
 <testcase classname='Edits_Tests.Tests' name='testDeletion' time='0.001'/>
 <testcase classname='Edits_Tests.Tests' name='testDeletionEquality' time='0.001'/>
 <testcase classname='Edits_Tests.Tests' name='testEndOfMatrix' time='0.001'/>
 <testcase classname='Edits_Tests.Tests' name='testInsertion' time='0.001'/>
 <testcase classname='Edits_Tests.Tests' name='testInsertionEquality' time='0.000'/>
 <testcase classname='Edits_Tests.Tests' name='testMatrixInitialization'>
 <failure message='XCTAssertEqual failed: (&quot;1&quot;) is not equal to (&quot;0&quot;) - '>Tests/Tests.swift:11</failure>
 </testcase>
 <testcase classname='Edits_Tests.Tests' name='testMatrixPreviousRow' time='0.001'/>
 <testcase classname='Edits_Tests.Tests' name='testMovement' time='0.001'/>
 <testcase classname='Edits_Tests.Tests' name='testMovementEquality' time='0.000'/>
 <testcase classname='Edits_Tests.Tests' name='testSubstitution' time='0.001'/>
 <testcase classname='Edits_Tests.Tests' name='testSubstitutionEquality' time='0.000'/>
 </testsuite>
 </testsuites>
 */
