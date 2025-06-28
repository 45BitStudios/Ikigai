import Foundation

/// iTunes Search from https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/Searching.html#//apple_ref/doc/uid/TP40017632-CH5-SW3

/// An endpoint for the iTunes Search API.
public struct ITunesSearchEndpoint: Endpoint {
    /// The search term.
    public let term: String
    /// Optional media type.
    public let media: ITunesSearchMedia?
    /// Optional entity.
    public let entity: ITunesSearchEntity?
    /// Optional language parameter.
    public let lang: String?
    /// Optional limit for the number of results.
    public let limit: Int?
    /// Optional country code.
    public let country: String?
    
    /// Creates a new ITunesSearchEndpoint.
    /// - Parameters:
    ///   - term: The search term.
    ///   - media: Optional media type.
    ///   - entity: Optional entity.
    ///   - lang: Optional language parameter (e.g., "en_us").
    ///   - limit: Optional limit for the number of results.
    ///   - country: Optional country code (e.g., "US").
    public init(term: String,
                media: ITunesSearchMedia? = nil,
                entity: ITunesSearchEntity? = nil,
                lang: String? = nil,
                limit: Int? = nil,
                country: String? = nil) {
        self.term = term
        self.media = media
        self.entity = entity
        self.lang = lang
        self.limit = limit
        self.country = country
    }
    
    public var baseURL: String {
        return "https://itunes.apple.com"
    }
    
    public var path: String {
        return "/search"
    }
    
    public var method: HTTPMethod {
        return .get
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    public var parameters: [String: Any]? {
        var params: [String: Any] = ["term": term]
        if let media = media {
            params["media"] = media.rawValue
        }
        if let entity = entity {
            params["entity"] = entity.rawValue
        }
        if let lang = lang {
            params["lang"] = lang
        }
        if let limit = limit {
            params["limit"] = limit
        }
        if let country = country {
            params["country"] = country
        }
        return params
    }
}
