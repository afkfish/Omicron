//
//  ListViewModel.swift
//  Omicron
//
//  Created by Beni Kis on 2024. 10. 23..
//

import Foundation
import SwiftUI

/// ViewModel for the `ListView`, this can delete shows from a user's library by the given offsets.
class ListViewModel: ObservableObject {
    @Published var searchPhrase: String = ""
    @Published var userLibrary: [ShowModel] = []
    
    private var accountManager: AccountManager?
    
    func setUp(accountManager: AccountManager) {
        self.accountManager = accountManager
    }
    
    func deleteItems(offsets: IndexSet, searchResults: [ShowModel]) {
        let entries = searchResults.sorted(by: <).enumerated().filter{ offsets.contains($0.offset) }.map(\.element.id)
        accountManager?.currentAccount?.library.removeAll(where: { entries.contains($0.id) })
    }
}
