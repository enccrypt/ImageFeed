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


final class OAuth2Service {
    private let tokenKey = "oauth_token"

    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }

    func makeOAuthTokenRequest(code: String) -> URLRequest {
        let baseURL = URL(string: "https://unsplash.com")
        let url = URL(
            string: "/oauth/token" + "?client.id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        )!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let request = makeOAuthTokenRequest(code: code)

        URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    self.token = tokenResponse.accessToken // Сохраняем токен
                    completion(.success(tokenResponse.accessToken))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(error))
                }

            case .failure(let error):
                print("Network error: \(error)")
                completion(.failure(error))
            }
        }
    }

}
