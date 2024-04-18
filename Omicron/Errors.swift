//
//  Errors.swift
//  Omicron
//
//  Created by Beni Kis on 15/03/2024.
//

import Foundation

enum DataError: Error {
    case scrapeError
    case apiError
    case fetchError(URLResponse)
}
