//
//  ImageUIImageExtension.swift
//  Omicron
//
//  Created by Beni Kis on 10/09/2024.
//

import Foundation
import SwiftUI

extension Image {
    /// Image converter to UIImage
    @MainActor
    func asUIImage() -> UIImage? {
        let renderer = ImageRenderer(content: self)
        return renderer.uiImage
    }
}
