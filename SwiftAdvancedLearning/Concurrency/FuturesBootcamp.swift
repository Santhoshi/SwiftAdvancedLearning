//
//  FuturesBootcamp.swift
//  SwiftAdvancedLearning
//
//  Created by Santhoshi Guduru
//

import SwiftUI
import Combine

// Download with combine

//Download with @escaping Closures





class FuturesBootcampViewModel: ObservableObject{
    @Published var title: String = "Starting title"
    let url  = URL(string: "https://www.google.com")!
    var cancellables = Set<AnyCancellable>()
    
    init() {
        downloadData()
    }
    func downloadData(){
       // getCombinePublisher()
       // getFuturePublisher()
        doSomethingInFuture()
            .sink { _ in
                
            } receiveValue: { [weak self] returnedValue in
                self?.title = returnedValue
            }
            .store(in: &cancellables)
        
 //       getEscapingClosures { [weak self] value, error in
//            self?.title = value
//        }

    }
    func getCombinePublisher() -> AnyPublisher<String, URLError>{
        URLSession.shared.dataTaskPublisher(for: url)
            .timeout(1, scheduler: DispatchQueue.main)
            .map({_ in
                return "New Value"
            })
            .eraseToAnyPublisher()
    }
    func getEscapingClosures(completionHandler: @escaping (_ value: String, _ error: Error?) -> Void){
        URLSession.shared.dataTask(with: url) { data, response, error in
            completionHandler("New escaping value", nil)
        }
        .resume()
    }
    func getFuturePublisher() -> Future<String, Error>{
        //Converting @escaping closures into publisher that we can subscribe to with "Future". It publishes once and then stops
         Future { promise in
             self.getEscapingClosures {value, error in
                if let error = error{
                    promise(.failure(error))
                } else{
                    promise(.success(value))
                }
            }
        }
    }
    
    func doSomething(completion: @escaping(_ value: String)-> ()){
        DispatchQueue.main.asyncAfter(deadline: .now() + 4){
            completion("Do something")
        }
    }
    func doSomethingInFuture() -> Future<String, Never>{
        Future { promise in
            self.doSomething { value in
                promise(.success(value))
            }
        }
    }
}

struct FuturesBootcamp: View {
    @StateObject private var vm = FuturesBootcampViewModel()
    var body: some View {
        Text(vm.title)
    }
}

#Preview {
    FuturesBootcamp()
}
