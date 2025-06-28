//
//  MessageStoragePolicy.swift
//  IkigaiAPI
//
//  Created by Vince Davis on 3/24/25.
//
import Foundation
import CryptoKit

/// Info is from https://developer.apple.com/documentation/usernotifications/sending-channel-management-requests-to-apns

public enum MessageStoragePolicy: Int {
    case noStorage = 0
    case mostRecentMessage = 1
}

public enum APNSEnvironment {
    case development
    case production
}

public enum APNSChannelError: Error {
    case invalidToken
    case missingTopic
    case invalidPayload
    case missingExpiration
    case invalidPriority
    case invalidTopicLength
    case invalidCollapseIdLength
    case invalidPushType
    case invalidPushCredentials
}

public enum APNSChannelRequestType {
    case create
    case read
    case delete
    case getAll
    
    var method: String {
        switch self {
        case .create:
            return "POST"
        case .read:
            return "GET"
        case .delete:
            return "DELETE"
        case .getAll:
            return "GET"
        }
    }
    
    var path: String {
        switch self {
        case .create:
            return "channels"
        case .read:
            return "channels"
        case .delete:
            return "channels"
        case .getAll:
            return "all-channels"
        }
    }
}

public struct APNSChannelResponse: Codable {
    public let requestId: String
    public let channelId: String
}

public struct APNSHelper {
    /// Creates a new channel via APNs channel management API.
    /// - Parameters:
    ///   - providerToken: Your APNs provider token.
    ///   - bundleID: Your app's bundle ID (without the push-type.liveactivity suffix).
    ///   - storagePolicy: The message storage policy.
    ///   - environment: The APNs environment to target (.development or .production).
    /// - Returns: A dictionary representing the JSON response from APNs.
    /// - Throws: An error if the request fails or the response is invalid.
    public static func createChannel(providerToken: String,
                                     bundleID: String,
                                     storagePolicy: MessageStoragePolicy = .noStorage,
                                     environment: APNSEnvironment = .development) async throws -> APNSChannelResponse {
        
        let request = try createRequest(type: .create,
                                        providerToken: providerToken,
                                        bundleID: bundleID,
                                        environment: environment,
                                        storagePolicy: storagePolicy)

        let (_, response) = try await URLSession.shared.data(for: request)
        
        return try await validate(response: response)
    }
    
    /// Deletes a  channel via APNs channel management API.
    /// - Parameters:
    ///   - providerToken: Your APNs provider token.
    ///   - channelId: Channel ID to be deleted
    ///   - bundleID: Your app's bundle ID (without the push-type.liveactivity suffix).
    ///   - storagePolicy: The message storage policy.
    ///   - environment: The APNs environment to target (.development or .production).
    /// - Returns: A dictionary representing the JSON response from APNs.
    /// - Throws: An error if the request fails or the response is invalid.
    public static func deleteChannel(providerToken: String,
                                     channelId: String,
                                     bundleID: String,
                                     storagePolicy: MessageStoragePolicy = .noStorage,
                                     environment: APNSEnvironment = .development) async throws -> APNSChannelResponse {
        
        let request = try await createRequest(type: .delete,
                                              channelId: channelId,
                                              providerToken: providerToken,
                                              bundleID: bundleID,
                                              environment: environment,
                                              storagePolicy: storagePolicy)

        let (_, response) = try await URLSession.shared.data(for: request)
        
        return try await validate(response: response)
    }
    
    /// Generates an APNs provider token (JWT) using your credentials.
    /// - Parameters:
    ///   - teamID: Your Apple Developer Team ID.
    ///   - keyID: Your APNs Key ID.
    ///   - privateKeyPEM: Your APNs Auth Key (.p8 file) contents in PEM format.
    /// - Returns: A JWT string used as a provider token.
    /// - Throws: An error if token generation fails.
    public static func generateProviderToken(teamID: String,
                                            keyID: String,
                                            privateKeyPEM: String) throws -> String {
       // Load the P256 private key using the PKCS#8 PEM data.
       let privateKey = try loadPrivateKey(from: privateKeyPEM)
       
       // JWT Header: specify ES256 algorithm and include the Key ID.
       let header: [String: Any] = [
           "alg": "ES256",
           "kid": keyID
       ]
       
       // JWT Payload: include your Team ID as issuer and current time as issued-at.
       let iat = Int(Date().timeIntervalSince1970)
       let payload: [String: Any] = [
           "iss": teamID,
           "iat": iat
       ]
       
       // Serialize header and payload to JSON.
       let headerData = try JSONSerialization.data(withJSONObject: header, options: [])
       let payloadData = try JSONSerialization.data(withJSONObject: payload, options: [])
       
       // Base64URL-encode header and payload.
       let headerBase64 = base64urlEncode(data: headerData)
       let payloadBase64 = base64urlEncode(data: payloadData)
       
       // Create the unsigned token (header.payload).
       let unsignedToken = "\(headerBase64).\(payloadBase64)"
       
       // Sign the unsigned token using ES256.
       let signatureData = try sign(message: unsignedToken, using: privateKey)
       let signatureBase64 = base64urlEncode(data: signatureData)
       
       // Return the complete JWT.
       return "\(unsignedToken).\(signatureBase64)"
   }
       
    // MARK: - Private Helpers
    private static func createRequest(type: APNSChannelRequestType,
                                     requestId: String? = nil,
                                     channelId: String? = nil,
                                     providerToken: String,
                                     bundleID: String,
                                     environment: APNSEnvironment,
                                     storagePolicy: MessageStoragePolicy = .noStorage) throws -> URLRequest {
        var envString: String = environment == .development ? ".sandbox" : ""
        var port: String = environment == .development ? "2195" : "2196"
    
        guard let url = URL(string: "https://api-manage-broadcast\(envString).push.apple.com:\(port)/1/apps/\(bundleID)/\(type.path)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = type.method
        
        // Set headers
        request.setValue("bearer \(providerToken)", forHTTPHeaderField: "authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let requestId = requestId {
            request.setValue(requestId, forHTTPHeaderField: "apns-request-id")
        }
        if let channelId = channelId {
            request.setValue(channelId, forHTTPHeaderField: "apns-channel-id")
        }
        
        if type == .create {
            // Construct JSON payload
            let jsonBody: [String: Any] = [
                "push-type": "LiveActivity",
                "message-storage-policy": storagePolicy.rawValue // Use enum's raw value
            ]
            
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
        }
        
        return request
    }
    
    private static func validate(response: URLResponse) async throws -> APNSChannelResponse {
        // Validate the response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        var requestId: String = ""
        var channelId: String = ""
        
        let headers = httpResponse.allHeaderFields
        if let id = headers["apns-request-id"] as? String {
            requestId = id
        }
        
        if let id = headers["apns-channel-id"] as? String {
            channelId = id
        }
        
        return APNSChannelResponse(requestId: requestId, channelId: channelId)
    }
       
    /// Base64URL-encodes data by replacing URL-unsafe characters and removing padding.
    private static func base64urlEncode(data: Data) -> String {
        var base64 = data.base64EncodedString()
        base64 = base64
           .replacingOccurrences(of: "+", with: "-")
           .replacingOccurrences(of: "/", with: "_")
           .replacingOccurrences(of: "=", with: "")
        return base64
    }
       
    /// Loads a P256 private key from a PEM-formatted string by extracting the raw key from the PKCS#8 container.
    private static func loadPrivateKey(from pem: String) throws -> P256.Signing.PrivateKey {
        return try .init(pemRepresentation: pem)
    }
       
    /// Signs a message string using the provided private key.
    private static func sign(message: String, using privateKey: P256.Signing.PrivateKey) throws -> Data {
        guard let messageData = message.data(using: .utf8) else {
            throw NSError(domain: "APNSTokenGenerator",
                          code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Message conversion to Data failed"])
        }
        let signature = try privateKey.signature(for: messageData)
        return signature.derRepresentation
    }
}
