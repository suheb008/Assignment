//
//  AssignmentTests.swift
//  AssignmentTests
//
//  Created by Suheb Jamadar on 29/11/17
//  Copyright © 2017 com. Assignment.com. All rights reserved.
//

import XCTest
@testable import Assignment

class AssignmentTests: XCTestCase {
   
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
  
    // TEST Cases
    
    func testValidAPI() {
        
        // For success used -->PABaseUrl
        let  baseURL  = "https://dl.dropboxuserconte ntww.com/s/2iodh4vg0eortkl/facts.json"
            // For Failed used -->baseURL
        Service.sharedInstance.FetchAllFeeds(requestFor:baseURL, completionBlockSuccess: { (result) in
            
            //Serilazation reponce into model format
            let tupleResult = Service.sharedInstance.feedResult(providedResult: result)
            
           let resultArray = tupleResult.0!
            //If result found then display on table view
             XCTAssert((resultArray.count) > 0, "Provide API hae result; Test Success")
            
        }) { (error) in
            //handle error here....
            XCTFail()
        }

    }
    func testValidAPIAsyn(){
           let readyExpectation = expectation(description: "ready")
        
        
       // let  baseURL  = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/ facts. json"
        Service.sharedInstance.FetchAllFeeds(requestFor:PABaseUrl, completionBlockSuccess: { (result) in
            //API Respond Scuess
            readyExpectation.fulfill()
                   })
        { (error) in
          XCTFail()
        }
        
        // Loop until the expectation is fulfilled //Change timeOut value like  1,2,3... give error .. 5 sec got sucess
        self.waitForExpectations(timeout: 1, handler: { errorMessage in
            XCTAssertNil(errorMessage, "Error")
        })
    }
}
