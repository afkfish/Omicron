//
//  NeumorphicButton.swift
//  Omicron
//
//  Created by Beni Kis on 18/04/2024.
//

import Foundation
import SwiftUI

struct NeumorphicButton<S: Shape>: ButtonStyle {
    @EnvironmentObject private var theme: ThemeManager
    var shape: S
    var width: CGFloat = 0
    var color: Color = .clear
    
    var computedColor: Color {
        color == .clear ? theme.selected.accent : color
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        let bg = Background(isPressed: configuration.isPressed, shape: shape, color: computedColor)
        if !width.isZero {
            configuration.label
                .frame(width: width)
                .padding(15)
                .background(bg)
        } else {
            configuration.label
                .padding(15)
                .background(bg)
        }
    }
}

struct Background<S: Shape>: View {
    @EnvironmentObject private var theme: ThemeManager
    var isPressed: Bool
    var shape: S
    var color: Color = .clear
    
    var computedColor: Color {
        color == .clear ? theme.selected.secondary : color
    }
    
    var body: some View {
        ZStack {
            if isPressed {
                withAnimation {
                    shape
                        .fill(computedColor)
                        .overlay(
                            shape
                                .stroke(Color.gray, lineWidth: 3)
                                .blur(radius: 4)
                                .offset(x: 2, y: 2)
                                .mask(shape.fill(LinearGradient(theme.selected.accent, Color.clear)))
                        )
                        .overlay(
                            shape
                                .stroke(Color.white, lineWidth: 3)
                                .blur(radius: 4)
                                .offset(x: -2, y: -2)
                                .mask(shape.fill(LinearGradient(Color.clear, theme.selected.accent)))
                        )
                }
            } else {
                shape
                    .fill(computedColor)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 7.5, y: 7.5)
                    .shadow(color: Color.white.opacity(0.2), radius: 10, x: -2.5, y: -2.5)
            }
        }
    }
}
