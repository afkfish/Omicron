//
//  APIController.swift
//  Omicron
//
//  Created by Beni Kis on 15/04/2024.
//

import Foundation
import Combine


protocol APIController {
    func login(with key: String) async -> AnyPublisher<LoginResponse, Never>
    func search(for q: String) async -> AnyPublisher<SearchDTO, Never>
    func getSeries(id: Int, page: Int) async -> AnyPublisher<ShowDTO, Never>
    func doRequest<T: Codable>(request: URLRequest, _: T.Type) -> AnyPublisher<T, Never>
}
