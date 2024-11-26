//
//  UnitTestingBootcampViewModel_Tests.swift
//  SwiftAdvancedLearningTests
//
//  Created by Santhoshi Guduru on 11/11/24.
//

import XCTest
@testable import SwiftAdvancedLearning
import Combine

//Naming Convention - test_UnitOfWork_StateUnderTest_ExpectedBehavior
//Naming Structure - test_[struct or class]_[variable or function]_[expected result]
//Testing Structure - Given, When , Then

final class UnitTestingBootcampViewModel_Tests: XCTestCase {
    var viewModel: UnitTestingBootcampViewModel?
    var cancellables = Set<AnyCancellable>()
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = UnitTestingBootcampViewModel(isPremium: Bool.random())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    //This test checks isPremium being true at any given time
    func test_UnitTestingBootcampViewModel_isPremium_shouldBeTrue(){
        //Given
        let userIsPremium: Bool = true
        //When
        let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
        //Then
        XCTAssertTrue(vm.isPremium)
    }
    //This test checks isPremium being false at any given time
    func test_UnitTestingBootcampViewModel_isPremium_shouldBeFalse(){
        let userIsPremium: Bool = false
        let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
        XCTAssertFalse(vm.isPremium)
    }
    
    //This test checks isPremium being true or false at any given time
    func test_UnitTestingBootcampViewModel_isPremium_shouldBeInjectedValue(){
        let userIsPremium: Bool = Bool.random()
        let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
        XCTAssertEqual(vm.isPremium, userIsPremium)
    }
    //This test check isPremium being true or false 50 percent to cover all the edge cases.
    func test_UnitTestingBootcampViewModel_isPremium_shouldBeInjectedValue_stress(){
        
        for _ in 0..<10 {
            let userIsPremium: Bool = Bool.random()
            let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
            XCTAssertEqual(vm.isPremium, userIsPremium)
        }
    }
    //Test for testing dataArray
    func test_UnitTestingBootcampViewModel_dataArray_shouldBeEmpty(){
        //Given
        
        //When
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        //Then
        XCTAssertTrue(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingBootcampViewModel_dataArray_shouldAddItems(){
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        //When
        let loopCount: Int = Int.random(in: 1..<100)
        for _ in 0..<loopCount{
            vm.addItem(item: UUID().uuidString)
        }
        
        //Then
//        XCTAssertTrue(!vm.dataArray.isEmpty)
//        XCTAssertFalse(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, loopCount)
//        XCTAssertNotEqual(vm.dataArray.count, 0)
//        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    //Edge case scenario where the dataArray is appended with an empty string
    func test_UnitTestingBootcampViewModel_dataArray_shouldNotAddBlankString(){
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        //When
        vm.addItem(item: "")
        //Then
        XCTAssertTrue(vm.dataArray.isEmpty)
    }
    //Optional for declaring at class level
    func test_UnitTestingBootcampViewModel_dataArray_shouldNotAddBlankString2(){
        //Given
        //let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        //When
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        vm.addItem(item: "")
        //Then
        XCTAssertTrue(vm.dataArray.isEmpty)
    }
    
    func test_UnitTestingBootcampViewModel_selectedItem_shouldStartAsNil(){
        //Given
        
        //When
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        //Then
        XCTAssertTrue(vm.selectedItem == nil)
        //Does same as the above line of code
        XCTAssertNil (vm.selectedItem)
    }
    
    func test_UnitTestingBootcampViewModel_selectedItem_shouldBeNilWhenSelectingInvalidItem(){
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        //When
        //Select valid item
        let newItem = UUID().uuidString
        vm.addItem(item: newItem)
        vm.selectedItem(item: newItem)
        
        //Select Invalid item
        vm.selectedItem(item: UUID().uuidString)
        //Then
        XCTAssertNil(vm.selectedItem)
    }
    func test_UnitTestingBootcampViewModel_selectedItem_shouldBeSelected(){
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        //When
        let newItem = UUID().uuidString
        vm.addItem(item: newItem)
        vm.selectedItem(item: newItem)
        //Then
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem,newItem)
    }
    //Advanced Tests - STRESS
    func test_UnitTestingBootcampViewModel_selectedItem_shouldBeSelected_stress(){
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        //When
        let loopCount: Int = Int.random(in: 0..<100)
        var itemsArray : [String] = []
        for _ in 0..<loopCount{
            let newItem = UUID().uuidString
            vm.addItem(item: newItem)
            itemsArray.append(newItem)
        }
        let randomItem = itemsArray.randomElement() ?? ""
        vm.selectedItem(item: randomItem)
        //Then
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem,randomItem)
    }
    
    func test_UnitTestingBootcampViewModel_saveItem_shouldThrowError_itemNotFound(){
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        //When
        let loopCount: Int = Int.random(in: 0..<100)
        for _ in 0..<loopCount{
            vm.addItem(item:  UUID().uuidString)
        }
        //Then
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString))
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString), "Should throw item not found error") { error in
            let returnedError = error as? UnitTestingBootcampViewModel.DataError
            XCTAssertEqual(returnedError, UnitTestingBootcampViewModel.DataError.itemNotFound)
        }
    }
    func test_UnitTestingBootcampViewModel_saveItem_shouldThrowError_noData(){
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        //When
        let loopCount: Int = Int.random(in: 0..<100)
        for _ in 0..<loopCount{
            vm.addItem(item:  UUID().uuidString)
        }
        //Then
        
        do {
            try vm.saveItem(item: "")
        } catch let error {
            let returnedError = error as? UnitTestingBootcampViewModel.DataError
            XCTAssertEqual(returnedError, UnitTestingBootcampViewModel.DataError.noData)
        }
        
        /*
        XCTAssertThrowsError(try vm.saveItem(item: ""))
        XCTAssertThrowsError(try vm.saveItem(item: ""), "Should throw no data error") { error in
            let returnedError = error as? UnitTestingBootcampViewModel.DataError
            XCTAssertEqual(returnedError, UnitTestingBootcampViewModel.DataError.noData)
        }
         */
    }
    func test_UnitTestingBootcampViewModel_saveItem_shouldThrowError_shouldSaveItem(){
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        //When
        let loopCount: Int = Int.random(in: 0..<100)
        var itemsArray : [String] = []
        for _ in 0..<loopCount{
            let newItem = UUID().uuidString
            vm.addItem(item: newItem)
            itemsArray.append(newItem)
        }
        let randomItem = itemsArray.randomElement() ?? ""
        
        XCTAssertFalse(randomItem.isEmpty)
        
        //Then
        // XCTAssertNoThrow(try vm.saveItem(item: randomItem))
        //Another way of writing the above line of code
        do {
            try vm.saveItem(item: randomItem)
        } catch {
            XCTFail()
        }
    }
    //writing test cases for asynchronous code - Download with escaping
    func test_UnitTestingBootcampViewModel_downloadWithEscaping_shouldReturnItems(){
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        //When
        let expectation = XCTestExpectation(description: "Should return items after 3 seconds")
        vm.$dataArray
            .dropFirst() //Dropping the first published value during initialization
            .sink { _ in
                expectation.fulfill()
            }.store(in: &cancellables)
        
        vm.downloadWithEscaping()
        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
        
    }

    //Writing test cases for asynchronous code - Download with combine
    func test_UnitTestingBootcampViewModel_downloadWithCombine_shouldReturnItems(){
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        //When
        let expectation = XCTestExpectation(description: "Should return items after 3 seconds")
        vm.$dataArray
            .dropFirst()
            .sink { returnedItems in
                expectation.fulfill()
            }.store(in: &cancellables)
        vm.downloadWithCombine()
        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    //Writing test cases for asynchronous code - Download with combine by passing the data
    func test_UnitTestingBootcampViewModel_injectItems_downloadWithCombine_shouldReturnItems_(){
        //Given
        let items = [UUID().uuidString, UUID().uuidString, UUID().uuidString, UUID().uuidString, UUID().uuidString]
        let dataService: MockTestDataServiceProtocol = MockTestDataService(items:items)
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random(), dataService: dataService)
        //When
        let expectation = XCTestExpectation(description: "Should return items after 3 seconds")
        vm.$dataArray
            .dropFirst()
            .sink { returnedItems in
                expectation.fulfill()
            }.store(in: &cancellables)
        vm.downloadWithCombine()
        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
}
