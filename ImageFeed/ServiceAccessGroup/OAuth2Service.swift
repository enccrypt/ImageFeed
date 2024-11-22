//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 04.10.2024.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
    case invalidResponse
}

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: [String]
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        tokenType = try container.decode(String.self, forKey: .tokenType)

        if let scopeArray = try? container.decode([String].self, forKey: .scope) {
            scope = scopeArray
        } else {
            let scopeString = try container.decode(String.self, forKey: .scope)
            scope = scopeString.components(separatedBy: " ")
        }

        createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let decoder = JSONDecoder()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private var storage = OAuth2TokenStorage()
    
    private enum OAuth2ServiceConstants {
        static let unsplashGetTokenURLString = "https://unsplash.com/oauth/token"
    }
    
    private init() {}

    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastCode == code && task != nil {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }

        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("[fetchOAuthToken]: NetworkError - \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    print("[fetchOAuthToken]: InvalidResponse - No data received.")
                    completion(.failure(AuthServiceError.invalidResponse))
                    return
                }
                
                do {
                    let tokenResponse = try self.decoder.decode(OAuthTokenResponseBody.self, from: data)
                    self.storage.token = tokenResponse.accessToken
                    print("Received access token: \(tokenResponse.accessToken)")
                    completion(.success(tokenResponse.accessToken))
                } catch {
                    print("[fetchOAuthToken]: DecodingError - \(error.localizedDescription), Data: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.failure(error))
                }
                
                self.task = nil
                self.lastCode = nil
            }
        }
        
        task?.resume()
    }

    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let url = URL(string: OAuth2ServiceConstants.unsplashGetTokenURLString) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let bodyParameters = [
            "client_id": Constants.accessKey,
            "client_secret": Constants.secretKey,
            "redirect_uri": Constants.redirectURI,
            "code": code,
            "grant_type": "authorization_code"
        ]
        
        request.httpBody = bodyParameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}

