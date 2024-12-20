//
//  HeaderView.swift
//  SwiftAdvancedLearning
//
//  Created by Santhoshi Guduru on 12/20/24.
//


import SwiftUI

struct HeaderView: View {
    var title = "Title"
    var subtitle = "Subtitle"
    var desc = "Use this to..."
    init(_ title: String, subtitle: String, desc: String) {
        self.title = title
        self.subtitle = subtitle
        self.desc = desc
    }
    var body: some View {
        VStack(spacing: 15) {
            if title != "" {
                Text(title)
                    .font(.largeTitle)
            }
            Text(subtitle)
                .foregroundStyle(.gray)
            DescView(desc)
        }
    }
}
struct DescView: View {
    var desc = "Use this to..."
   
    init(_ desc: String) {
            self.desc = desc
        }
    var body: some View {
        Text(desc)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.cyan)
            .foregroundStyle(.white)
    }
}

#Preview {
        HeaderView("Mock Data", subtitle: "Showing mock data", desc: "This is the description of the mock data")
    }
    
    
