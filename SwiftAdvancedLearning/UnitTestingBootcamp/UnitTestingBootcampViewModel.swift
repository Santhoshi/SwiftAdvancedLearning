//
//  UnitTestingBootcampViewModel.swift
//  SwiftAdvancedLearning
//
//  Created by Santhoshi Guduru on 11/11/24.
//

import Foundation
import Combine

class UnitTestingBootcampViewModel: ObservableObject {
    
    @Published var isPremium: Bool
    @Published var dataArray: [String] = []
    @Published var selectedItem: String? = nil
    let dataService: MockTestDataServiceProtocol
    var cancellables = Set<AnyCancellable>()
    
    init(isPremium: Bool, dataService: MockTestDataServiceProtocol = MockTestDataService(items: nil)) {
        self.isPremium = isPremium
        self.dataService = dataService
    }
    
    func addItem(item: String){
        guard !item.isEmpty else { return }
        self.dataArray.append(item)
    }
    
    func selectedItem(item: String){
        if let x = dataArray.first(where: { $0 == item }){
            selectedItem = x
        } else {
            selectedItem = nil
        }
    }
    
    func saveItem(item: String) throws {
        //If an empty string is passed it throws a no data error
        guard !item.isEmpty else {
            throw DataError.noData
        }
        if let x = dataArray.first(where: { $0 == item }){
            print("Save data  logic goes here \(x)")
        } else {
            throw DataError.itemNotFound
        }
    }
    
    enum DataError: LocalizedError{
        case noData
        case itemNotFound
    }
    
    func downloadWithEscaping(){
        dataService.downloadItemsWithEscaping { [weak self] returnedItems in
            self?.dataArray = returnedItems
        }
    }
    func downloadWithCombine(){
        dataService.downloadItemsWithCombine()
            .sink { _ in
                
            } receiveValue: {[weak self] returnedItems in
                self?.dataArray = returnedItems
            }.store(in: &cancellables)

    }
    
}
