//  Created by Vince Davis on 2/25/25.
//

import Foundation

// MARK: - Protocols

/// A protocol defining the requirements for a network service that performs asynchronous requests.
public protocol NetworkService {
    /// Performs an asynchronous network request for the given endpoint.
    /// - Parameter endpoint: The endpoint to request data from.
    /// - Returns: A decoded object of type `T`.
    /// - Throws: An error if the request or decoding fails.
    func request<T: Decodable>(_ endpoint: any Endpoint, debug: Bool) async throws -> T
}

/// A protocol defining the structure of an API endpoint.
public protocol Endpoint {
    /// The base URL for the endpoint.
    var baseURL: String { get }
    
    /// The path component of the endpoint URL.
    var path: String { get }
    
    /// The HTTP method to use for the request.
    var method: HTTPMethod { get }
    
    /// Optional headers to include in the request.
    var headers: [String: String]? { get }
    
    /// Optional parameters to include in the request.
    var parameters: [String: Any]? { get }
}

/// A protocol for building URL requests from endpoints.
public protocol URLRequestBuilder {
    /// Builds a URLRequest from the given endpoint.
    /// - Parameter endpoint: The endpoint to create a request for.
    /// - Returns: A configured URLRequest.
    /// - Throws: An error if the request cannot be built.
    func buildRequest(from endpoint: any Endpoint) throws -> URLRequest
}

// MARK: - Enums

/// An enumeration representing HTTP methods.
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// An enumeration of possible network-related errors.
public enum NetworkError: Error {
    /// The URL is invalid.
    case invalidURL
    
    /// The response from the server is invalid.
    case invalidResponse
    
    /// A server error occurred with the given status code.
    case serverError(statusCode: Int)
    
    /// An error occurred while decoding the response.
    case decodingError
    
    /// A general network error occurred.
    case networkError(Error)
}

// MARK: - URL Request Builder

/// A struct that builds URL requests for API endpoints.
public struct DefaultURLRequestBuilder: URLRequestBuilder {
    /// Initializes a new DefaultURLRequestBuilder.
    public init() {}
    
    public func buildRequest(from endpoint: any Endpoint) throws -> URLRequest {
        var components = URLComponents(string: endpoint.baseURL + endpoint.path)
        
        if endpoint.method == .get, let parameters = endpoint.parameters {
            components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if let headers = endpoint.headers {
            headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        }
        
        if let parameters = endpoint.parameters,
           [.post, .put].contains(endpoint.method) {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
}

// MARK: - Network Manager

/// A class that manages network requests using a configurable session and request builder.
public class NetworkManager: NetworkService {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let requestBuilder: URLRequestBuilder
    
    /// Initializes a new network manager.
    /// - Parameters:
    ///   - session: The URLSession to use for requests. Defaults to `.shared`.
    ///   - decoder: The JSONDecoder to use for decoding responses. Defaults to a new instance.
    ///   - requestBuilder: The builder to create URL requests. Defaults to `DefaultURLRequestBuilder`.
    public init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        requestBuilder: URLRequestBuilder = DefaultURLRequestBuilder()
    ) {
        self.session = session
        self.decoder = decoder
        self.requestBuilder = requestBuilder
    }
    
    public func request<T: Decodable>(_ endpoint: any Endpoint, debug: Bool = false) async throws -> T {
        let urlRequest = try requestBuilder.buildRequest(from: endpoint)
        if debug {
            print("URL: \(urlRequest.url?.absoluteString ?? "Unknown")")
        }
        // Capture the data and response from the network request.
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            if debug {
                print("URL: \(urlRequest.url?.absoluteString ?? "Unknown")")
            }
            throw NetworkError.networkError(error)
        }
        
        // Validate the HTTP response.
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if debug {
                print("URL: \(urlRequest.url?.absoluteString ?? "Unknown")")
            }
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        // Attempt to decode the response.
        do {
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            if debug {
                print("URL: \(urlRequest.url?.absoluteString ?? "Unknown")")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Decoding error: \(error)\nResponse Data: \(jsonString)")
                } else {
                    print("Decoding error: \(error)\nCould not convert data to string.")
                }
            }
            throw NetworkError.decodingError
        }
    }
}
