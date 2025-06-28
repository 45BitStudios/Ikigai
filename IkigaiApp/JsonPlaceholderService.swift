import Foundation
import IkigaiCore

// MARK: - Models

/// A struct representing a post in the JSONPlaceholder API.
public struct Post: Codable {
    /// The unique identifier of the post.
    public let id: Int?
    
    /// The user ID who created the post.
    public let userId: Int
    
    /// The title of the post.
    public let title: String
    
    /// The body content of the post.
    public let body: String
    
    public init(id: Int? = nil, userId: Int, title: String, body: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
}

// MARK: - Endpoints

/// An enumeration of JSONPlaceholder API endpoints.
public enum JSONPlaceholderEndpoint: Endpoint {
    case getAllPosts
    case getPost(id: Int)
    case createPost(userId: Int, title: String, body: String)
    case updatePost(id: Int, userId: Int, title: String, body: String)
    case deletePost(id: Int)
    
    public var baseURL: String {
        "https://jsonplaceholder.typicode.com"
    }
    
    public var path: String {
        switch self {
        case .getAllPosts:
            return "/posts"
        case .getPost(let id):
            return "/posts/\(id)"
        case .createPost:
            return "/posts"
        case .updatePost(let id, _, _, _):
            return "/posts/\(id)"
        case .deletePost(let id):
            return "/posts/\(id)"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getAllPosts, .getPost:
            return .get
        case .createPost:
            return .post
        case .updatePost:
            return .put
        case .deletePost:
            return .delete
        }
    }
    
    public var headers: [String: String]? {
        nil // JSONPlaceholder doesn't require headers
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .createPost(let userId, let title, let body):
            return [
                "userId": userId,
                "title": title,
                "body": body
            ]
        case .updatePost(_, let userId, let title, let body):
            return [
                "userId": userId,
                "title": title,
                "body": body
            ]
        case .getAllPosts, .getPost, .deletePost:
            return nil
        }
    }
}

// MARK: - Service

/// A service class for interacting with the JSONPlaceholder API.
public class JSONPlaceholderService {
    private let networkManager: NetworkService
    
    /// Initializes a new JSONPlaceholder service.
    /// - Parameter networkManager: The network service to use for requests. Defaults to a new `NetworkManager`.
    public init(networkManager: NetworkService = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    /// Retrieves all posts from the API.
    /// - Returns: An array of Post objects.
    /// - Throws: An error if the request fails.
    public func fetchAllPosts() async throws -> [Post] {
        return try await networkManager.request(JSONPlaceholderEndpoint.getAllPosts, debug: true)
    }
    
    /// Retrieves a specific post by ID.
    /// - Parameter id: The ID of the post to retrieve.
    /// - Returns: A Post object.
    /// - Throws: An error if the request fails.
    public func fetchPost(id: Int) async throws -> Post {
        return try await networkManager.request(JSONPlaceholderEndpoint.getPost(id: id), debug: true)
    }
    
    /// Creates a new post.
    /// - Parameters:
    ///   - userId: The ID of the user creating the post.
    ///   - title: The title of the post.
    ///   - body: The body content of the post.
    /// - Returns: The created Post object.
    /// - Throws: An error if the request fails.
    public func createPost(userId: Int, title: String, body: String) async throws -> Post {
        return try await networkManager.request(
            JSONPlaceholderEndpoint.createPost(userId: userId, title: title, body: body), debug: true)
    }
    
    /// Updates an existing post.
    /// - Parameters:
    ///   - id: The ID of the post to update.
    ///   - userId: The ID of the user updating the post.
    ///   - title: The new title of the post.
    ///   - body: The new body content of the post.
    /// - Returns: The updated Post object.
    /// - Throws: An error if the request fails.
    public func updatePost(id: Int, userId: Int, title: String, body: String) async throws -> Post {
        return try await networkManager.request(
            JSONPlaceholderEndpoint.updatePost(id: id, userId: userId, title: title, body: body), debug: true
        )
    }
    
    /// Deletes a post by ID.
    /// - Parameter id: The ID of the post to delete.
    /// - Throws: An error if the request fails.
    public func deletePost(id: Int) async throws {
        let _: EmptyResponse = try await networkManager.request(
            JSONPlaceholderEndpoint.deletePost(id: id), debug: true)
    }
}

/// An empty response struct for operations that return no data.
public struct EmptyResponse: Codable {}

/*
// MARK: - Test Example
import XCTest
@testable import Networking

class JSONPlaceholderServiceTests: XCTestCase {
    var mockNetwork: MockNetworkService!
    var service: JSONPlaceholderService!
    
    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkService()
        service = JSONPlaceholderService(networkManager: mockNetwork)
    }
    
    func testFetchAllPosts() async throws {
        // Arrange
        let mockPosts = [Post(id: 1, userId: 1, title: "Test Post", body: "Test Body")]
        mockNetwork.mockData["/posts"] = try JSONEncoder().encode(mockPosts)
        
        // Act
        let posts = try await service.fetchAllPosts()
        
        // Assert
        XCTAssertEqual(posts.count, 1)
        XCTAssertEqual(posts.first?.title, "Test Post")
    }
}

class MockNetworkService: NetworkService {
    var mockData: [String: Data] = [:]
    var shouldThrowError: Error?
    
    func request<T: Decodable>(_ endpoint: any Endpoint) async throws -> T {
        let key = endpoint.path
        
        if let error = shouldThrowError {
            throw error
        }
        
        guard let data = mockData[key] else {
            throw NetworkError.invalidResponse
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
*/
