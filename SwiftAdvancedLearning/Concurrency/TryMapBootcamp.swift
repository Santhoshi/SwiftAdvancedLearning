//
//  TryMapBootcamp.swift
//  SwiftAdvancedLearning
//
//  Created by Santhoshi Guduru
//

import SwiftUI

struct TryMapBootcamp: View {
    @StateObject private var vm = TryMapViewModel()
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("TryMap",
                       subtitle: "Introduction",
                       desc: "The tryMap operator will allow you to throw an error inside its closure.")
            List(vm.dataToView, id: \.self) { item in
                Text(item)
            }
        }
        .font(.title)
        .alert(item: $vm.error) { error in
            Alert(title: Text("Error"), message: Text(error.description))
        }
        .onAppear {
            vm.fetch()
        }
    }
}
struct ServerError: Error, Identifiable, CustomStringConvertible {
    let id = UUID()
    let description = "There was a server error while retrieving values."
}
class TryMapViewModel: ObservableObject {
    @Published var dataToView: [String] = []
    @Published var error: ServerError?
    func fetch() {
        let dataIn = ["Value 1", "Value 2", "Server Error 500", "Value 3","Server Error 400"]
        _ = dataIn.publisher
            .tryMap { item -> String in
                if item.lowercased().contains("error") {
                    throw ServerError()
                }
                return item
            }
            .sink { [unowned self] completion in
                if case .failure(let error) = completion {
                    self.error = error as? ServerError
                }
            } receiveValue: { [unowned self] item in
                dataToView.append(item)
            }
    }
}
#Preview {
    TryMapBootcamp()
}
