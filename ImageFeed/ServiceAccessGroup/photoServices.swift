//
//  photoServices.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 22.11.2024.
//

import Foundation
import CoreGraphics

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?  // Параметр "created_at" может быть nil
    let width: Int
    let height: Int
    let urls: UrlsResult
    let likedByUser: Bool
    let description: String? // Описание
    // Другие поля по мере необходимости

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case urls
        case likedByUser = "liked_by_user"
        case description
    }
}


struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

// преобразование json в массив [Photo]
extension Photo {
    static func from(photoResult: PhotoResult) -> Photo {
        let dateFormatter = ISO8601DateFormatter()
        
        // Преобразуем строку в дату, если она существует
        let date = photoResult.createdAt.flatMap { dateFormatter.date(from: $0) }
        
        // Создаем объект Photo с использованием полученной даты
        return Photo(
            id: photoResult.id,
            size: CGSize(width: photoResult.width, height: photoResult.height),
            createdAt: date,
            welcomeDescription: photoResult.description ?? "No description available", // Если описание пустое
            thumbImageURL: photoResult.urls.thumb,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.likedByUser
        )
    }
}

