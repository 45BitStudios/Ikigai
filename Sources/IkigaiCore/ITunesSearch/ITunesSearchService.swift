//
//  ITunesSearchService.swift
//  IkigaiAPI
//
//  Created by Vince Davis on 3/24/25.
//

import Foundation
// MARK: - Public iTunesSearchService

/// A public service for interacting with iTunesSearchService's REST API.
public class ITunesSearchService {
    private let networkService: NetworkService
    
    public init(networkService: NetworkService = NetworkManager()) {
        self.networkService = networkService
    }
    
    // MARK: - iTunes Search Info
    
    /**
     Fetches App Infor based on search terms
     
     - Parameters:
     - term: The search term you want to search for
     - country: The country you want to search
     - lang: The language you want the results returned in.
     - debug: A flag to enable debug logging.
     
     - Returns: A `ITunesSearchResponse` containing App data.
     
     - Throws: An error if the network request or decoding fails.
     */
    public func searchApps(term: String, country: String = "US", lang: String = "en_us", debug: Bool = false) async throws -> ITunesSearchResponse {
        let endpoint = ITunesSearchEndpoint(term: term, media: .software, entity: .software, lang: lang, limit: 10, country: country)
        let response: ITunesSearchResponse = try await networkService.request(endpoint, debug: debug)
        return response
    }
}
