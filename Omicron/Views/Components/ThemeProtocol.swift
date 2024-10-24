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
    var accent: Color { get }
}

struct Gallery: Theme {
    var name: String = "Gallery"
    var primary: Color = Color("GalleryPrimary")
    var secondary: Color = Color("GallerySecondary")
    var accent: Color = Color("GalleryAccent")
}

struct Fern: Theme {
    var name: String = "Fern"
    var primary: Color = Color("FernPrimary")
    var secondary: Color = Color("FernSecondary")
    var accent: Color = Color("FernAccent")
}

struct Pewter: Theme {
    var name: String = "Pewter"
    var primary: Color = Color("PewterPrimary")
    var secondary: Color = Color("PewterSecondary")
    var accent: Color = Color("PewterAccent")
}

enum ThemeType: String, CaseIterable {
    case gallery
    case fern
    case pewter
    
    var theme: Theme {
        switch self {
        case .gallery: return Gallery()
        case .fern: return Fern()
        case .pewter: return Pewter()
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



