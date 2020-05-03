//
//  MasterViewModelTests.swift
//  TestProjectTests
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Lost Toys. All rights reserved.
//

import XCTest
@testable import DevigetTest

class MasterViewModelTests: XCTestCase {
    
    // System Under Test
    var sut: MasterViewModel!
    let mockArticlesClient = MockArticlesClient()
    let mockArticlesPersistence = MockArticlesPersistence()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = MasterViewModel(articles: [], networkClient: mockArticlesClient, persistence: mockArticlesPersistence, coordinator: MockMasterViewNavigation())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func test_initial_state() throws {
        XCTAssertEqual(sut.datasource.value.count, 0)
    }
    
    func test_start_call() throws {
        sut.start()
        XCTAssertEqual(mockArticlesClient.responseCount, sut.datasource.value.count)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
