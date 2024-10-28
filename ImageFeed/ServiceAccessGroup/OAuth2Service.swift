//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 04.10.2024.
//

import Foundation

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

    // Кастомное декодирование для поля scope
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        
        // Обрабатываем scope как массив или строку
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
    // MARK: - Public Properties
    
    var authToken: String? {
        get {
            OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    static let shared = OAuth2Service()
    
    // MARK: - Private Properties
    private let decoder = JSONDecoder()
    private let urlSession = URLSession.shared
    private enum NetworkError: Error {
        case codeError
    }
    
    private enum OAuth2ServiceConstants {
        static let unsplashGetTokenURLString = "https://unsplash.com/oauth/token"
    }
    
    // MARK: - Initializers
    private init() {}

    // MARK: - Public Methods
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, any Error>) -> Void) {
        
        let request = makeOAuthTokenRequest(code: code)
        
        let task = urlSession.data(for: request) { [weak self] result in
            
            guard let self else { preconditionFailure("self is unavalible") }
            
            switch result {
            case .success(let data):
                
                do {
                    let OAuthTokenResponseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    print(OAuthTokenResponseBody)
                    print(OAuthTokenResponseBody.accessToken)
                    self.authToken = OAuthTokenResponseBody.accessToken
                    completion(.success(OAuthTokenResponseBody.accessToken))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
        task.resume()
    }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest {
        guard var urlComponents = URLComponents(string: OAuth2ServiceConstants.unsplashGetTokenURLString) else {
            preconditionFailure("invalide sheme or host name")
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            preconditionFailure("Cannot make url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        print(request)
        return request
    }
    // MARK: - Private Methods
    
}

