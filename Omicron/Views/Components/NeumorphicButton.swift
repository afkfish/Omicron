//
//  NeumorphicButton.swift
//  Omicron
//
//  Created by Beni Kis on 18/04/2024.
//

import Foundation
import SwiftUI

struct NeumorphicButton<S: Shape>: ButtonStyle {
    var shape: S
    var width: CGFloat = 0
    
    func makeBody(configuration: Self.Configuration) -> some View {
        if !width.isZero {
            configuration.label
                .frame(width: width)
                .padding(15)
                .background(Background(isPressed: configuration.isPressed, shape: shape))
        } else {
            configuration.label
                .padding(15)
                .background(Background(isPressed: configuration.isPressed, shape: shape))
        }
    }
}

struct Background<S: Shape>: View {
    @StateObject private var theme = ThemeManager()
    var isPressed: Bool
    var shape: S
    
    var body: some View {
        ZStack {
            if isPressed {
                withAnimation {
                    shape
                        .fill(theme.selected.primary)
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
                    .fill(theme.selected.primary)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
            }
        }
    }
}
