//
//  SearchResults.swift
//  IkigaiAPI
//
//  Created by Vince Davis on 3/24/25.
//
import Foundation

public struct ITunesSearchResponse: Codable {
    public let resultCount: Int
    public let results: [ITunesSearchResult]
}

public struct ITunesSearchResult: Codable {
    let wrapperType: String?
    let kind: String?
    let artistId: Int?
    let artistName: String?
    let artistViewUrl: String?
    let trackId: Int?
    public let trackName: String?
    let trackCensoredName: String?
    let trackViewUrl: String?
    let artworkUrl60: String?
    public let artworkUrl100: String?
    let artworkUrl512: String?
    let screenshotUrls: [String]?
    let ipadScreenshotUrls: [String]?
    let appletvScreenshotUrls: [String]?
    let supportedDevices: [String]?
    let advisories: [String]?
    let features: [String]?
    let averageUserRating: Double?
    let userRatingCount: Int?
    let contentAdvisoryRating: String?
    let averageUserRatingForCurrentVersion: Double?
    let userRatingCountForCurrentVersion: Int?
    let currentVersionReleaseDate: String?
    let releaseDate: String?
    let trackContentRating: String?
    let primaryGenreName: String?
    let genres: [String]?
    let languageCodesISO2A: [String]?
    let fileSizeBytes: String?
    public let version: String?
    let description: String?
    let releaseNotes: String?
    let sellerName: String?
    public let bundleId: String?
    let minimumOsVersion: String?
    let price: Double?
    let formattedPrice: String?
    let currency: String?
}
