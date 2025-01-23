//
//  NetworkClient.swift
//  randomuser
//
//  Created by Pau on 23/1/25.
//

import Foundation

protocol NetworkClient {
    func fetchData(from url: URL) async throws -> Data
}

final class URLSessionNetworkClient: NetworkClient {
    func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}
