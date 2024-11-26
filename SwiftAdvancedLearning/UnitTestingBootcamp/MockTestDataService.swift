//
//  MockTestDataService.swift
//  SwiftAdvancedLearning
//
//  Created by Santhoshi Guduru on 11/12/24.
//

import Foundation
import Combine

protocol MockTestDataServiceProtocol{
    func downloadItemsWithEscaping(completion: @escaping(_ items: [String]) -> ())
    func downloadItemsWithCombine() -> AnyPublisher<[String],Error>
}

class MockTestDataService: MockTestDataServiceProtocol{
    let items : [String]
    
    init(items: [String]?){
        self.items = items ?? ["ONE", "TWO","THREE"]
        print("Item count: \(self.items.count)")
    }
    func downloadItemsWithEscaping(completion: @escaping(_ items: [String]) -> ()){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            completion(self.items)
        }
    }
    func downloadItemsWithCombine() -> AnyPublisher<[String],Error> {
        Just(items)
            .tryMap({ publishedItems in
                guard !publishedItems.isEmpty else {
                    throw URLError(.badServerResponse)
                }
                return publishedItems
            })
            .eraseToAnyPublisher()
    }
}
