//
//  ThemeProtocol.swift
//  Omicron
//
//  Created by Beni Kis on 11/09/2024.
//

import Foundation
import SwiftUI

protocol Theme {
    var name: String { get }
    var primary: Color { get }
    var secondary: Color { get }
    var text: Color { get }
}

struct Default: Theme {
    var name: String = "Elephant"
    var primary: Color = Color("ElephantLightShade")
    var secondary: Color = Color("Elephant")
    var text: Color = Color("ElephantText")
}

struct Trout: Theme {
    var name: String = "Trout"
    var primary: Color = Color("TroutLightShade")
    var secondary: Color = Color("Trout")
    var text: Color = Color("TroutText")
}

enum ThemeType: String, CaseIterable {
    case elephant
    case trout
    
    var theme: Theme {
        switch self {
        case .elephant: return Default()
        case .trout: return Trout()
        }
    }
}

class ThemeManager: ObservableObject {
    @AppStorage("theme") private var theme: ThemeType = .elephant
    @Published var selected: Theme = Default()
    
    init() {
        self.selected = self.theme.theme
    }
        
    func setTheme(_ themeType: ThemeType) {
        self.selected = themeType.theme
        self.theme = themeType
    }
    
    func getType() -> ThemeType {
        return self.theme
    }
}



