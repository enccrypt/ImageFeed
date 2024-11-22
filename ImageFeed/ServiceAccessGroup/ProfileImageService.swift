//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 13.11.2024.
//

import Foundation

// структура для декодирования JSON-ответа
struct UserResult: Codable {
    let profileImage: ProfileImage

    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

// структура для извлечения URL маленькой версии аватарки
struct ProfileImage: Codable {
    let small: String
}

// Сервис для получения URL изображения профиля
final class ProfileImageService {
    static let shared = ProfileImageService()
    
    private(set) var avatarURL: String?
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private let storage = OAuth2TokenStorage()
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private init() {}

    private func makeProfileImageRequest(username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = storage.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        if task != nil { return }
        
        guard let request = makeProfileImageRequest(username: username) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            defer { self?.task = nil }
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let userResult):
                    let profileImageURL = userResult.profileImage.small
                    self.avatarURL = profileImageURL
                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImageURL]
                    )
                    completion(.success(profileImageURL))
                case .failure(let error):
                    print("[fetchProfileImageURL]: \(error.localizedDescription), Request: \(request.url?.absoluteString ?? "")")
                    completion(.failure(error))
                }
            }
        }
        
        task?.resume()
    }
}
