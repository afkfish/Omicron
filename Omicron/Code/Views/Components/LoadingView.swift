//
//  LoadingView.swift
//  Omicron
//
//  Created by Beni Kis on 2024. 11. 04..
//

import SwiftUI

struct LoadingView: View {
    @EnvironmentObject private var theme: ThemeManager
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView() // System loading spinner
                .scaleEffect(1.5)
            
            Text("Signing in...")
                .foregroundStyle(theme.selected.accent)
        }
    }
}

#Preview {
    LoadingView()
        .environmentObject(ThemeManager())
}
