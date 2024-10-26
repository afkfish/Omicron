//
//  MD5StringExtension.swift
//  Omicron
//
//  Created by Beni Kis on 10/09/2024.
//

import Foundation
import CryptoKit

extension String {
    var md5: String {
        guard let data = self.data(using: .utf8) else { return self }
        return Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
    }
}
