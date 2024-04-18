//
//  PopOverWebView.swift
//  Omicron
//
//  Created by Beni Kis on 04/03/2024.
//

import SwiftUI
import SwiftData
import SwiftSoup

//struct PopOverWebView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var shows: [Show]
//    
//    @Binding var showSafari: Bool
//    @Binding var scrapeError: Bool
//    
//    @State private var lastURL = ""
//    @State private var page: Any?
//    
//    private let baseURL = "https://www.imdb.com/search/title/?title_type=tv_series"
//    
//    private var webView: WebView {
//        WebView(url: baseURL, isPresented: $showSafari, lastURL: $lastURL, page: $page)
//    }
//    
//    private var validURL: Bool {
//        if (!lastURL.matches(of: /https:\/\/www\.imdb\.com\/title\/tt[0-9]*[\/]\?.*/).isEmpty) {
//            return true
//        }
//        return false
//    }
//    
//    var body: some View {
//        HStack {
//            Button {
//                showSafari = false
//            } label: {
//                Text("Cancel")
//            }
//            Spacer()
//            Button {
//                submitShowURL()
//            } label: {
//                Text("Add show")
//            }
//            .disabled(!validURL)
//        }
//        .padding(.top)
//        .padding(.horizontal)
//        webView
//    }
//    
//    func submitShowURL() {
//        do {
//            try getData(lastURL: lastURL, page: page, shows: shows) {
//                addShow(newShow: $0)
//            }
//        } catch {
//            print("error")
//            scrapeError = true
//        }
//        showSafari = false
//        lastURL = ""
//    }
//    
//    func addShow(newShow: Show) {
//        withAnimation {
//            if (!shows.contains(where: { $0.id == newShow.id })) {
//                modelContext.insert(newShow)
//            }
//        }
//    }
//}

//#Preview {
//    PopOverWebView(showSafari: Binding.constant(true), scrapeError: Binding.constant(false))
//}
