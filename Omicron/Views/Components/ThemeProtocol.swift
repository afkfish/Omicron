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
    var contrast: Color { get }
}

struct Trout: Theme {
    var name: String = "Trout"
    var primary: Color = Color("TroutLightShade")
    var secondary: Color = Color("Trout")
    var contrast: Color = Color("LightText")
}

struct ChichagoDark: Theme {
    var name: String = "ChichagoDark"
    var primary: Color = Color("ChichagoDarkPrimary")
    var secondary: Color = Color("ChichagoDarkSecondary")
    var contrast: Color = Color("LightText")
}

struct Fern: Theme {
    var name: String = "Fern"
    var primary: Color = Color("FernPrimary")
    var secondary: Color = Color("FernSecondary")
    var contrast: Color = Color("DarkText")
}

struct Gallery: Theme {
    var name: String = "Gallery"
    var primary: Color = Color("GalleryPrimary")
    var secondary: Color = Color("GallerySecondary")
    var contrast: Color = Color("GalleryText")
}

enum ThemeType: String, CaseIterable {
    case trout
    case chichagoDark
    case fern
    case gallery
    
    var theme: Theme {
        switch self {
        case .trout: return Trout()
        case .chichagoDark: return ChichagoDark()
        case .fern: return Fern()
        case .gallery: return Gallery()
        }
    }
}

class ThemeManager: ObservableObject {
    @AppStorage("theme") private var theme: ThemeType = .gallery
    @Published var selected: Theme = Gallery()
    
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



