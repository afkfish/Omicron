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
        Task {
            await login(with: self.key)
                .map { $0.data?.token }
                .assign(to: &$token)
        }
    }
    
    func login(with key: String) async -> AnyPublisher<LoginResponse, Never> {
        let loginURL = URL(string: "https://api4.thetvdb.com/v4/login")!
        let body = try? JSONSerialization.data(withJSONObject: ["apikey": key], options: [])
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        request.httpBody = body!
  
        return doRequest(request: request, LoginResponse.self)
    }
    
    func search(for q: String) async -> AnyPublisher<SearchDTO, Never> {
        let query = URLQueryItem(name: "q", value: q)
        let type = URLQueryItem(name: "type", value: "series")
        let limit = URLQueryItem(name: "limit", value: "10")
        let url = URL(string: baseURL + "/search")!.appending(queryItems: [query, type, limit])
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = authenticatedHeader
        
        
        return doRequest(request: request, SearchDTO.self)
    }
    
    func getSeries(id: Int, page: Int = 0) async -> AnyPublisher<ShowDTO, Never> {
        let pageQuery = URLQueryItem(name: "page", value: String(page))
        let url = URL(string: baseURL + "/series/\(id)/episodes/default")!.appending(queryItems: [pageQuery])
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = authenticatedHeader
        
        return doRequest(request: request, ShowDTO.self)
    }
    
    func doRequest<T: Codable>(request: URLRequest, _: T.Type) -> AnyPublisher<T, Never> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .retry(1)
            .catch { error in
                print(error)
                return Empty<T, Never>().eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
