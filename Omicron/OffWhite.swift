//
//  OffWhite.swift
//  Omicron
//
//  Created by Beni Kis on 16/04/2024.
//

import Foundation
import SwiftUI

extension Color {
    static let offWhite = Color(red: 225/255, green: 225/255, blue: 235/255)
    static let darkStart = Color(red: 50 / 255, green: 60 / 255, blue: 65 / 255)
    static let darkEnd = Color(red: 25 / 255, green: 25 / 255, blue: 30 / 255)
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct NeumorphicButton<S: Shape>: ButtonStyle {
    var shape: S
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(15)
            .background(Background(isPressed: configuration.isPressed, shape: shape))
    }
}

struct Background<S: Shape>: View {
    var isPressed: Bool
    var shape: S
    
    var body: some View {
        ZStack {
            if isPressed {
                withAnimation {
                    shape
                        .fill(Color.offWhite)
                        .overlay(
                            shape
                                .stroke(Color.gray, lineWidth: 3)
                                .blur(radius: 4)
                                .offset(x: 2, y: 2)
                                .mask(shape.fill(LinearGradient(Color.black, Color.clear)))
                        )
                        .overlay(
                            shape
                                .stroke(Color.white, lineWidth: 3)
                                .blur(radius: 4)
                                .offset(x: -2, y: -2)
                                .mask(shape.fill(LinearGradient(Color.clear, Color.black)))
                        )
                }
            } else {
                shape
                    .fill(Color.offWhite)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
            }
        }
    }
}
