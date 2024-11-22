//
//  ImagesListServices.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 22.11.2024.
//

import Foundation

final class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    static let shared = ImagesListService()
    
    private var isFetching = false
    private var currentPage = 0
    private let photosPerPage = 10
    private let urlSession = URLSession.shared
    private(set) var photos: [Photo] = []
    
    func fetchPhotosNextPage() {
        guard !isFetching else { return }
        isFetching = true
        
        let nextPage = currentPage + 1
        
        
        guard let baseURL = Constants.defaultBaseURL else {
            print("Base URL is nil")
            return
        }
        
        guard var urlComponents = URLComponents(url: baseURL.appendingPathComponent("/photos"), resolvingAgainstBaseURL: false) else {
            print("Failed to create URL components")
            return
        }
                
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(nextPage)"),
            URLQueryItem(name: "per_page", value: "\(photosPerPage)")
        ]
                
        guard let url = urlComponents.url else {
            print("Failed to build the URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Client-ID \(Constants.accessKey)", forHTTPHeaderField: "Authorization")

        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            self.isFetching = false
            
            if let error = error {
                print("Failed to fetch photos: \(error)")
                return
            }
            
            guard
                let data = data,
                let photoResults = try? JSONDecoder().decode([PhotoResult].self, from: data)
            else {
                print("Failed to decode photos")
                return
            }
            
            let newPhotos = photoResults.map { Photo.from(photoResult: $0) }
            
            DispatchQueue.main.async {
                self.photos.append(contentsOf: newPhotos)
                self.currentPage = nextPage
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
            }
        }
        task.resume()
    }
}


