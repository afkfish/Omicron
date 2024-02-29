//
//  ListsView.swift
//  Omicron
//
//  Created by Beni Kis on 24/02/2024.
//

import SwiftUI
import SwiftData
import SwiftSoup

struct ListsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var shows: [Show]
    @State private var showSafari = false
    @State private var lastURL = ""
    @State private var page: Any?
    
    private var webView: WebView {
        WebView(url: ListsView.baseURL, isPresented: $showSafari, lastURL: $lastURL, page: $page)
    }
    
    private var validURL: Bool {
        if (lastURL.contains("https://www.imdb.com/title/")) {
            return true
        }
        return false
    }
    
    static let baseURL = "https://www.imdb.com/search/title/?title_type=tv_series"
    
    var body: some View {
        NavigationView {
            List(shows) {show in
                NavigationLink {
                    ShowDetailsView(show: Binding.constant(show))
                } label: {
                    Text(show.name)
                }
            }.toolbar {
                ToolbarItem {
                    Button(action: {
                        showSafari = true
                    }, label: {
                        Label("Add Item", systemImage: "plus")
                    })
                    .popover(isPresented: $showSafari) {
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
                }
            }
        }
//        .onAppear {
//            addDebug()
//        }
    }
    
    func submitShowURL() {
        scrapeData(url: lastURL)
        lastURL = ""
    }
    
    func scrapeData(url: String) {
        do {
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
            
            let id = String(lastURL.dropFirst("https://www.imdb.com/title/".count).split(separator: "/")[0])
            
            let newShow: Show = Show(id: id, name: title ?? "", airDate: airDate ?? "", score:  scor, episodes: ep, episodeLength: length ?? "", desc: description ?? "", image: image ?? "", link: lastURL)
            
            addShow(newShow: newShow)
        } catch {
            print("error in parsing")
        }
        showSafari = false
    }
    
    func addShow(newShow :Show) {
        modelContext.insert(newShow)
    }
    
    func addDebug() {
        modelContext.insert(Show.exaple)
    }
}

#Preview {
    ListsView()
        .modelContainer(for: Show.self, inMemory: true)
}
