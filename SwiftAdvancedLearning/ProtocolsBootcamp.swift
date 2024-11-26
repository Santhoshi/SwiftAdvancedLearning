//
//  ProtocolsBootcamp.swift
//  SwiftAdvancedLearning
//
//  Created by Santhoshi Guduru on 11/11/24.
//

import SwiftUI

struct DefaultColorTheme: ColorThemeProtocol{
    let primary: Color = .blue
    let secondary: Color = .white
    let tertiary: Color = .gray
}
struct AmazingColorTheme: ColorThemeProtocol{
    var primary: Color = .red
    var secondary: Color = .white
    var tertiary: Color = .green
}

protocol ColorThemeProtocol{
    var primary: Color { get }
    var secondary: Color { get }
    var tertiary: Color { get }
}

protocol ButtonTextProtocol{
    var buttonText: String { get }
}
protocol ButtonPressedProtocol{
    func buttonPressed()
}
protocol ButtonDataSourceProtocol: ButtonTextProtocol,ButtonPressedProtocol{
    
    
}
class DefaultDataSource: ButtonDataSourceProtocol{
    var buttonText : String = "Amazing Protocols"
    
    func buttonPressed() {
        print("Button Pressed!!")
    }
    
}


struct ProtocolsBootcamp: View {
    let colorTheme: ColorThemeProtocol
    let dataSource: ButtonDataSourceProtocol
    
    var body: some View {
        ZStack{
            colorTheme.tertiary
                .ignoresSafeArea()
            Text(dataSource.buttonText)
                .font(.headline)
                .foregroundColor(colorTheme.secondary)
                .padding()
                .background(colorTheme.primary)
                .cornerRadius(10)
                .onTapGesture {
                    dataSource.buttonPressed()
                }
        }
    }
}

#Preview {
    ProtocolsBootcamp(colorTheme: DefaultColorTheme(),dataSource: DefaultDataSource())
}
