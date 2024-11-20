//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 05.10.2024.
//

import Foundation

// Определяем возможные сетевые ошибки
// Ошибки сети
enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()

        // Создаем задачу для запроса
        let task = self.dataTask(with: request) { data, response, error in
            if let error = error {
                // Логируем ошибку запроса
                print("[objectTask]: NetworkError - \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                // Логируем ошибку, если данные не получены
                print("[objectTask]: NetworkError - No data received.")
                completion(.failure(NetworkError.urlSessionError))
                return
            }

            do {
                // Пытаемся декодировать данные в объект типа T
                let decodedObject = try decoder.decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                // Логируем ошибку декодирования
                let dataString = String(data: data, encoding: .utf8) ?? "Не удалось преобразовать данные в строку."
                print("[objectTask]: DecodingError - \(error.localizedDescription), Данные: \(dataString)")
                completion(.failure(error))
            }
        }

        task.resume()  // Запускаем задачу
        return task
    }
}
