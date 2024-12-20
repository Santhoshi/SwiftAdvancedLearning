//
//  PublisherBootcamp.swift
//  SwiftAdvancedLearning
//
//  Created by Santhoshi Guduru 
//

import SwiftUI
import Combine

class PublishedViewModel: ObservableObject{
    var characterLimit = 30
    @Published var data = ""
    @Published var characterCount = 0
    @Published var countColor = Color.gray
    
    init(){
        $data
            .map{$0.count}
            .assign(to: &$characterCount)
        
        $characterCount
            .map{[unowned self] count -> Color in
                let eightyPercent = Int(Double(characterLimit) * 0.8)
                if (eightyPercent...characterLimit).contains(count) {
                    return Color.yellow
                } else if count > characterLimit {
                    return Color.red
                }
                return Color.gray
            }
            .assign(to: &$countColor)
        
    }
}

struct PublisherBootcamp: View {
    @StateObject private  var viewModel = PublishedViewModel()
    
    var body: some View {
        VStack(spacing: 20){
            TextEditor(text: $viewModel.data)
                .border(Color.gray, width: 1)
                .frame(height: 200)
                .padding()
            Text("\(viewModel.characterCount)/\(viewModel.characterLimit)")
                .foregroundColor(viewModel.countColor)
            Spacer()
        }
    }
}

#Preview {
    PublisherBootcamp()
}
