//
//  PhotoRama_Ch20Tests.swift
//  PhotoRama-Ch20Tests
//
//  Created by Ben Smith on 30/05/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import XCTest
@testable import NewOMBD

class NewOMBDTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIfPgSearchTitleResturnsCustomLocalizedDescriptionError() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ViewController.notifyErrorResponse),
                                               name:  NSNotification.Name(rawValue: "omdbError" ),
                                               object: nil)
        OMDBService.searchMovieByTitle(title: "Pg")
    }
    
    func notifyErrorResponse(notification: NSNotification) {
        var searchesDict: Dictionary<String,NSError> = notification.userInfo as! Dictionary<String,NSError>
        let errorObject = searchesDict["error"]!
        
        let errorMessage = errorObject.localizedDescription
        
        // should be equal to this error message if we search for Pg
        XCTAssertEqual(errorMessage, "The JSON is faulty! Some backend developer needs to be fired")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
