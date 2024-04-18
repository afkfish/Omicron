//
//  RapidApiLogic.swift
//  Omicron
//
//  Created by Beni Kis on 14/03/2024.
//

import Foundation
import Combine

class RapidApiController {
    private let headers = [
        "X-RapidAPI-Key": "f16ef9d6c2msha9449eabe752b02p1de3f0jsnceaa0c4d9983",
        "X-RapidAPI-Host": "imdb8.p.rapidapi.com"
    ]
    private let baseURL = "https://imdb8.p.rapidapi.com/title/"
    private var storage = Set<AnyCancellable>()

    func getTitleById(id: String, err: @escaping () -> Void, result: @escaping (Show) -> Void) {
        let url = URL(string: baseURL + "get-overview-details")!.appending(queryItems: [URLQueryItem(name: "tconst", value: id)])
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { $0.data }
            .decode(type: DetailsDTO.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {completion in
                switch completion {
                case .finished:
                    print("Fetched title!")
                case .failure(let error):
                    print(error)
                    err()
                }
            }, receiveValue: {detailsDTO in
                let show = Show(from: detailsDTO, link: "https://imdb.com\(detailsDTO.id)")
                self.getTitleSeasons(id: id) {
                    show.seasons = $0
                    show.seasonCount = $0.count
                    result(show)
                }
            })
            .store(in: &storage)
    }
    
    func getTitleSeasons(id: String, result: @escaping ([Season]) -> Void) {
        let url = URL(string: baseURL + "get-seasons")!.appending(queryItems: [URLQueryItem(name: "tconst", value: id)])
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { $0.data }
            .decode(type: Array<SeasonsDTO>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {completion in
                switch completion {
                case .finished:
                    print("Fetched seasons!")
                case .failure(let error):
                    print(error)
                }
                
            }, receiveValue: {seasonsDTO in
                result(
                    seasonsDTO.map{ Season(from: $0) }
                )
            })
            .store(in: &storage)
    }
    
    func getMostPopular(result: @escaping ([String]) -> Void) {
        let url = URL(string: baseURL + "get-most-popular-tv-shows")!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { $0.data }
            .decode(type: Array<String>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {completion in
                switch completion {
                case .finished:
                    print("Fetched most popular!")
                case .failure(let error):
                    print(error)
                }
                
            }, receiveValue: { result($0) })
            .store(in: &storage)
    }
    
    func getBase(id: String, result: @escaping (BaseDetail) -> Void) {
        let url = URL(string: baseURL + "get-base")!.appending(queryItems: [URLQueryItem(name: "tconst", value: id)])
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { $0.data }
            .decode(type: BaseDTO.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {completion in
                switch completion {
                case .finished:
                    print("Fetched base!")
                case .failure(let error):
                    print(error)
                }
                
            }, receiveValue: { result(BaseDetail(from: $0)) })
            .store(in: &storage)
    }
}


