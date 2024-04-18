//
//  TVDbA.swift
//  Omicron
//
//  Created by Beni Kis on 28/03/2024.
//

import Foundation
import Combine

class TVDbAPIController: APIController {
    private let baseURL = "https://api4.thetvdb.com/v4"
    private let key = "4007f509-091c-4c14-8856-4e6d6ccd34bd"
    @Published private var token: String?
    
    private var authenticatedHeader: [String: String] {
        ["Authorization": "Bearer \(self.token ?? "")"]
    }
    
    private var storage = Set<AnyCancellable>()
    
    init() {
        login(with: self.key) {
            self.token = $0 ?? nil
        }
    }
    
    func login(with key: String, set: @escaping (String?) -> Void) {
        let loginURL = URL(string: "https://api4.thetvdb.com/v4/login")!
        let body = try? JSONSerialization.data(withJSONObject: ["apikey": "4007f509-091c-4c14-8856-4e6d6ccd34bd"], options: [])
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        request.httpBody = body!
  
        doRequest(request: request, LoginResponse(), debugMessage: "Logged in succesfully") {
            set($0.data!.token)
        }
    }
    
    func search(for q: String, result: @escaping (SearchDTO) -> Void) {
        let query = URLQueryItem(name: "q", value: q)
        let type = URLQueryItem(name: "type", value: "series")
        let limit = URLQueryItem(name: "limit", value: "10")
        let url = URL(string: baseURL + "/search")!.appending(queryItems: [query, type, limit])
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = authenticatedHeader
        
        if token == nil {
            login(with: key) {
                self.token = $0 ?? nil
            }
            Thread.detachNewThread {
                Thread.sleep(forTimeInterval: 1)
                
                request.allHTTPHeaderFields = self.authenticatedHeader
                self.doRequest(request: request, SearchDTO(), debugMessage: "Search succesful") {
                    result($0)
                }
            }
        } else {
            doRequest(request: request, SearchDTO(), debugMessage: "Search succesful") {
                result($0)
            }
        }
    }
    
    func getSeries(id: Int, page: Int = 0, result: @escaping (ShowDTO, Int) -> Void) {
        let pageQuery = URLQueryItem(name: "page", value: String(page))
        let url = URL(string: baseURL + "/series/\(id)/episodes/default")!.appending(queryItems: [pageQuery])
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = authenticatedHeader
        
        if token == nil {
            login(with: key) {
                self.token = $0 ?? nil
            }
            Thread.detachNewThread {
                Thread.sleep(forTimeInterval: 1)
                
                request.allHTTPHeaderFields = self.authenticatedHeader
                self.doRequest(request: request, ShowDTO(), debugMessage: "Get series succesful") {
                    result($0, $0.links!.totalItems! - $0.links!.pageSize!)
                }
            }
        } else {
            doRequest(request: request, ShowDTO(), debugMessage: "Get series succesful") {
                result($0, $0.links!.totalItems! - ($0.links!.pageSize! * (page+1)))
            }
        }
    }
    
    func doRequest<T: Codable>(request: URLRequest, _: T, debugMessage: String?, callback: @escaping (T) -> Void) {
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {completion in
                switch completion {
                case .finished:
                    print(debugMessage ?? "")
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: {
                callback($0)
            })
            .store(in: &storage)
    }
    
    struct LoginResponse: Codable {
        var data: DataClass?
        
        struct DataClass: Codable {
            let token: String
        }
    }
}
