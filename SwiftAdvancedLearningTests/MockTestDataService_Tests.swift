//
//  MockTestDataService_Tests.swift
//  SwiftAdvancedLearningTests
//
//  Created by Santhoshi Guduru on 11/13/24.
//

import XCTest
@testable import SwiftAdvancedLearning
import Combine

final class MockTestDataService_Tests: XCTestCase {

    var cancellables = Set<AnyCancellable>()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        cancellables.removeAll()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_MockTestDataService_init_doesSetValuesCorrectly(){
        //Given
        let itemsNil: [String]? = nil
        let itemsEmpty: [String]? = []
        let itemsWithData: [String]? = [UUID().uuidString, UUID().uuidString]
        //When
        let dataServiceNil = MockTestDataService(items: itemsNil)
        let dataServiceEmpty = MockTestDataService(items: itemsEmpty)
        let dataServiceWithData = MockTestDataService(items: itemsWithData)
        //Then
        XCTAssertFalse(dataServiceNil.items.isEmpty)
        XCTAssertTrue(dataServiceEmpty.items.isEmpty)
        XCTAssertEqual(dataServiceWithData.items.count, itemsWithData?.count)
        
    }
    func test_MockTestDataService_downloadItemsWithEscaping_doesReturnValues(){
        //Given
        let dataService = MockTestDataService(items: nil)
        //When
        var items: [String] = []
        let expection = XCTestExpectation()
        dataService.downloadItemsWithEscaping { returnedItems in
            expection.fulfill()
            items = returnedItems
        }
        
        //Then
        wait(for: [expection], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }
    
    func test_MockTestDataService_downloadItemsWithCombine_doesReturnValues(){
        //Given
        let dataService = MockTestDataService(items: nil)
        //When
        var items: [String] = []
        let expection = XCTestExpectation()
        dataService.downloadItemsWithCombine()
            .sink { completion in
                switch completion{
                case .finished:
                    expection.fulfill()
                case .failure:
                    XCTFail()
                }
            } receiveValue: { returnedItems in
                items = returnedItems
                
            }.store(in: &cancellables)

        
        //Then
        wait(for: [expection], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
        
    }
    func test_MockTestDataService_downloadItemsWithCombine_doesFail(){
        //Given
        let dataService = MockTestDataService(items: [])
        //When
        var items: [String] = []
        let expectionError = XCTestExpectation(description: "Does throw an error")
        let expectationServerResponse = XCTestExpectation(description: "Does throw URLError.badServerResponse")
        dataService.downloadItemsWithCombine()
            .sink { completion in
                switch completion{
                case .finished:
                    XCTFail()
                case .failure(let error):
                    expectionError.fulfill()
                    
                    if error as? URLError == URLError(.badServerResponse){
                        expectationServerResponse.fulfill()
                    }
                }
            } receiveValue: { returnedItems in
                items = returnedItems
                
            }.store(in: &cancellables)

        
        //Then
        wait(for: [expectionError,expectationServerResponse], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
        
    }
    
}
