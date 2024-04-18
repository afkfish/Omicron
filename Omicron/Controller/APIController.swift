//
//  APIController.swift
//  Omicron
//
//  Created by Beni Kis on 15/04/2024.
//

import Foundation

protocol APIController {
    func login(with key: String, set: @escaping (String?) -> Void)
    func search(for q: String, result: @escaping (SearchDTO) -> Void)
    func getSeries(id: Int, page: Int, result: @escaping (ShowDTO, Int) -> Void)
    func doRequest<T: Codable>(request: URLRequest, _: T, debugMessage: String?, callback: @escaping (T) -> Void)
}
