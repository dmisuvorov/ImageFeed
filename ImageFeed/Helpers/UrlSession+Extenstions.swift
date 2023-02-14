//
//  UrlSession+Extenstions.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 03.02.2023.
//

import UIKit

extension URLSession {
    
    func makeUrlSessionTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
        return makeUrlSessionTask(for: request) { result in
            let response = result.flatMap { data in
                Result { try decoder.decode(T.self, from: data) }
            }
            completion(response)
        }
    }
    
    func makeUrlSessionTask(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if (200..<300).contains(statusCode) {
                    fulfillCompletion(Result.success(data))
                    return
                }
                fulfillCompletion(Result.failure(NetworkError.httpStatusCode(statusCode)))
            } else if let error = error {
                fulfillCompletion(Result.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(Result.failure(NetworkError.urlSessionError))
            }
        }
        task.resume()
        return task
    }
}
