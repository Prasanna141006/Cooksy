//
//  NetwrokManager.swift
//  Cooksyy
//
//  Created by Nxtwave on 18/09/25.
//

import Foundation


final class NetworkManager {

    let baseURL = "https://dummyjson.com/recipes"
    static let shared = NetworkManager()


    func fetchrecipes() async throws -> [Recipe] {

        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }

        let(data, _) = try await URLSession.shared.data(from: url)

        do {
                let decoder = JSONDecoder()
                return try decoder.decode(Welcome.self, from: data).recipes
            } catch {
                throw URLError(.badServerResponse)

            }

    }

}
