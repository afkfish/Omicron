//
//  Item.swift
//  Omicron
//
//  Created by Beni Kis on 22/02/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
