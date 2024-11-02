//
//  APIController.swift
//  Omicron
//
//  Created by Beni Kis on 15/04/2024.
//

import Foundation
import SwiftUI

/// `@Environment` value for the APIController
private struct APIControllerKey: EnvironmentKey {
    static let defaultValue: APIController = TVDbAPIController()
}

extension EnvironmentValues {
    var defaultAPIController: APIController {
        get { self[APIControllerKey.self] }
        set { self[APIControllerKey.self] = newValue }
    }
}
