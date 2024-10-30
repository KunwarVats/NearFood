//
//  NetworkClient.swift
//  NearFood
//
//  Created by Kunwar Vats on 30/10/24.
//

import Foundation
import Combine

class NetworkClient {
    
    func fetchBusinesses(latitude: Double, longitude: Double, offset: Int) -> AnyPublisher<[Business], Error> {
        guard let url = URL(string: "\(baseURL)?latitude=\(latitude)&longitude=\(longitude)&offset=\(offset)&categories=restaurant&sort_by=best_match&limit=20") else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: YelpResults.self, decoder: JSONDecoder())
            .map { $0.businesses }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
