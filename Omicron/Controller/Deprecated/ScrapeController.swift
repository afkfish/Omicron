//
//  ScrapeLogic.swift
//  Omicron
//
//  Created by Beni Kis on 07/03/2024.
//

import Foundation
import SwiftSoup


//func getData(lastURL: String, page: Any?, shows: [Show], addShow: (_: Show) -> Void) throws {
//    let id = String(lastURL.dropFirst("https://www.imdb.com/title/".count).split(separator: "/")[0])
//    
//    if (shows.allSatisfy {$0.id != id }) {
//        do {
//            let newShow = try scrape(id, lastURL: lastURL, page: page)
//            addShow(newShow)
//        } catch {
//            throw DataError.scrapeError
//        }
//    }
//}
//
//func scrape(_ id: String, lastURL: String, page: Any?) throws -> Show {
//    let doc = try SwiftSoup.parse(page as! String)
//    let title: String? = try doc.select("span.hero__primary-text").first()?.text()
//    let airDate: String? = try doc.select(".sc-d8941411-2 li:nth-of-type(2) a").first()?.text()
//    let rating: String? = try doc.select(".sc-d8941411-2 li:nth-of-type(3) a").first()?.text()
//    let score: String? = try doc.select(".sc-69e49b85-1 span.sc-bde20123-1").first()?.text()
//    let description: String? = try doc.select("span.sc-466bb6c-2").first()?.text()
//    let image: String? = try doc.select(".ipc-media--poster-l img").first()?.attr("src")
//    let length: String? = try doc.select(".sc-d8941411-2 li:nth-of-type(4)").first()?.text()
//    let episodes: String? = try doc.select("[data-testid='episodes-header'] span.ipc-title__subtext").first()?.text()
//    
//    var scor = 0.0
//    if (score != nil) {
//        scor = (score! as NSString).doubleValue
//    }
//    var ep = 0
//    if (episodes != nil) {
//        ep = Int((episodes! as NSString).intValue)
//    }
//    var len = 0
//    if (length != nil) {
//        len = Int((length! as NSString).intValue)
//    }
//    
//    return Show(id: id, name: title ?? "", airDate: airDate ?? "", rating: rating ?? "", score:  scor, episodes: ep, episodeLength: len, desc: description ?? "", image: image ?? "", link: lastURL)
//}
