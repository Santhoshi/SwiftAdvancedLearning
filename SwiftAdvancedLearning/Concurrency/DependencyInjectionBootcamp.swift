//
//  DependencyInjectionBootcamp.swift
//  SwiftAdvancedLearning
//
//  Created by Santhoshi Guduru on 11/11/24.
//

import SwiftUI
import Combine

struct PostsModel:Identifiable,Codable{
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
// DataService Protocol
protocol DataServiceProtocol{
    func getData() -> AnyPublisher<[PostsModel],Error>
}
// Production DataService
class ProductionDataService: DataServiceProtocol{
    let url: URL
    init(url: URL){
        self.url = url
    }
    func getData() -> AnyPublisher<[PostsModel],Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: [PostsModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
//Mock DataService
class MockDataService: DataServiceProtocol{
    let testData : [PostsModel]
    init(data: [PostsModel]?) {
        self.testData = data ?? [
            PostsModel(userId: 11, id: 12, title: "Mandalorian", body: "The Bounty Hunter"),
            PostsModel(userId: 21, id: 22, title: "Friends", body: "Comical")
        ]
    }
    func getData() -> AnyPublisher<[PostsModel], any Error> {
        Just(testData)
            .tryMap({$0})
            .eraseToAnyPublisher()
    }
    
}
class DependencyInjectionViewModel: ObservableObject{
    @Published var dataArray: [PostsModel] = []
    var cancellables = Set<AnyCancellable>()
    let dataService: DataServiceProtocol
    
    
    init(dataService: DataServiceProtocol){
        self.dataService = dataService
        loadPosts()
    }
    private func loadPosts(){
        dataService.getData()
            .sink { _ in
                
            } receiveValue: { [weak self] returnedPosts in
                self?.dataArray = returnedPosts
            }
            .store(in: &cancellables)
    }
}

struct DependencyInjectionBootcamp: View {
    @StateObject private var vm: DependencyInjectionViewModel
    
    
    init(dataService: DataServiceProtocol){
        _vm = StateObject(wrappedValue: DependencyInjectionViewModel(dataService: dataService))
    }
    
    var body: some View {
        List{
            ForEach(vm.dataArray){post in
                VStack(alignment: .leading){
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
//let dataService = ProductionDataService(url:URL(string: "https://jsonplaceholder.typicode.com/posts")!)
let dataService = MockDataService(data: [
    PostsModel(userId: 1234, id: 1234, title: "Mandalorian", body: "The Bounty Hunter"),
    PostsModel(userId: 21, id: 22, title: "Friends", body: "Comical")
])
#Preview {
    DependencyInjectionBootcamp(dataService: dataService)
}
