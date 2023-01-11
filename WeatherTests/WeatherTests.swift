//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Nidhi patel on 09/01/23.
//

import XCTest
@testable import Weather

class WeatherTests: XCTestCase {
    
    var apiRouter : APIRouter!
    
    override func setUp() {
       super.setUp()
       apiRouter = APIRouter()
    }
    
    override func tearDown() {
        apiRouter = nil
        super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
