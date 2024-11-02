//
//  ImageCache.swift
//  Omicron
//
//  Created by Beni Kis on 10/09/2024.
//

import Foundation
import SwiftUI

/// Singleton persistent image cache for the `CachedAsyncImage`.
class ImageCache {
    static let shared = ImageCache()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cachesDirectory.appendingPathComponent("ImageCache")
        
        do {
            try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating cache directory: \(error)")
        }
    }
    
    func get(forKey key: String) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent(key.md5)
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return UIImage(data: data)
        } catch {
            print("Error reading image from cache: \(error)")
            return nil
        }
    }
    
    func set(_ image: UIImage, forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key.md5)
        
        do {
            if let data = image.heicData() {
                try data.write(to: fileURL)
            }
        } catch {
            print("Error writing image to cache: \(error)")
        }
    }
    
    /// Clears the cache directory.
    func clearCache() -> Bool {
        do {
            try fileManager.removeItem(at: cacheDirectory)
            try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            print("Error clearing cache: \(error)")
            return false
        }
    }
}
