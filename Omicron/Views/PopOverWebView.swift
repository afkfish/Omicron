//
//  PopOverWebView.swift
//  Omicron
//
//  Created by Beni Kis on 04/03/2024.
//

import SwiftUI
import SwiftData
import SwiftSoup

struct PopOverWebView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var shows: [Show]
    
    @Binding var showSafari: Bool
    @Binding var scrapeError: Bool
    
    @State private var lastURL = ""
    @State private var page: Any?
    
    private var webView: WebView {
        WebView(url: ListsView.baseURL, isPresented: $showSafari, lastURL: $lastURL, page: $page)
    }
    
    private var validURL: Bool {
        if (!lastURL.matches(of: /https:\/\/www\.imdb\.com\/title\/tt[0-9]*[\/]\?.*/).isEmpty) {
            return true
        }
        return false
    }
    
    var body: some View {
        HStack {
            Button {
                showSafari = false
            } label: {
                Text("Cancel")
            }
            Spacer()
            Button {
                submitShowURL()
            } label: {
                Text("Add show")
            }
            .disabled(!validURL)
        }
        .padding(.top)
        .padding(.horizontal)
        webView
    }
    
    func submitShowURL() {
        getData(url: lastURL)
        lastURL = ""
    }
    
    func getData(url: String) {
        let id = String(lastURL.dropFirst("https://www.imdb.com/title/".count).split(separator: "/")[0])
        
        if (shows.allSatisfy {$0.id != id }) {
            do {
                let newShow = try scrape(id)
                addShow(newShow: newShow)
            } catch {
                scrapeError = true
            }
        }
        showSafari = false
    }
    
    func scrape(_ id: String) throws -> Show {
        let doc = try SwiftSoup.parse(page as! String)
        let title: String? = try doc.select("span.hero__primary-text").first()?.text()
        let airDate: String? = try doc.select(".sc-d8941411-2 li:nth-of-type(2) a").first()?.text()
        let rating: String? = try doc.select(".sc-d8941411-2 li:nth-of-type(3) a").first()?.text()
        let score: String? = try doc.select(".sc-69e49b85-1 span.sc-bde20123-1").first()?.text()
        let description: String? = try doc.select("span.sc-466bb6c-2").first()?.text()
        let image: String? = try doc.select(".ipc-media--poster-l img").first()?.attr("src")
        let length: String? = try doc.select(".sc-d8941411-2 li:nth-of-type(4)").first()?.text()
        let episodes: String? = try doc.select("[data-testid='episodes-header'] span.ipc-title__subtext").first()?.text()
        
        var scor = 0.0
        if (score != nil) {
            scor = (score! as NSString).doubleValue
        }
        var ep = 0
        if (episodes != nil) {
            ep = Int((episodes! as NSString).intValue)
        }
        
        return Show(id: id, name: title ?? "", airDate: airDate ?? "", rating: rating ?? "", score:  scor, episodes: ep, episodeLength: length ?? "", desc: description ?? "", image: image ?? "", link: lastURL)
    }
    
    func addShow(newShow :Show) {
        withAnimation {
            if (!shows.contains(where: { $0.id == newShow.id })) {
                modelContext.insert(newShow)
            }
        }
    }
}

//#Preview {
//    PopOverWebView(showSafari: Binding.constant(true), scrapeError: Binding.constant(false))
//}
