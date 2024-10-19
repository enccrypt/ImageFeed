//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 04.10.2024.
//

import Foundation

// для декодирования ответа от Unsplash.
struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int?
    let scope: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case scope
    }
}
//
//
//final class OAuth2Service {
//    private let tokenKey = "oauth_token"
//
//    var token: String? {
//        get {
//            return UserDefaults.standard.string(forKey: tokenKey)
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: tokenKey)
//        }
//    }
//
//    func makeOAuthTokenRequest(code: String) -> URLRequest {
//        let baseURL = URL(string: "https://unsplash.com")
//        let url = URL(
//            string: "/oauth/token" + "?client.id=\(Constants.accessKey)"
//            + "&&client_secret=\(Constants.secretKey)"
//            + "&&redirect_uri=\(Constants.redirectURI)"
//            + "&&code=\(code)"
//            + "&&grant_type=authorization_code",
//            relativeTo: baseURL
//        )!
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        return request
//    }
//    
//    func fetchOAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
//        let request = makeOAuthTokenRequest(code: code)
//
//        URLSession.shared.data(for: request) { result in
//            switch result {
//            case .success(let data):
//                do {
//                    let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
//                    self.token = tokenResponse.accessToken // Сохраняем токен
//                    completion(.success(tokenResponse.accessToken))
//                } catch {
//                    print("Decoding error: \(error)")
//                    completion(.failure(error))
//                }
//
//            case .failure(let error):
//                print("Network error: \(error)")
//                completion(.failure(error))
//            }
//        }
//    }
//
//}


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
    init() {}
    
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

