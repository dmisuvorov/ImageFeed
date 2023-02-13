//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 13.02.2023.
//

import UIKit

final class ProfileService {
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private var currentUrlSessionTask: URLSessionTask?
    private var lastToken: String?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == oAuth2TokenStorage.token { return }
        currentUrlSessionTask?.cancel()
        lastToken = oAuth2TokenStorage.token
        let request = profileRequest(token: token)
        let task = createProfileUrlSessionTask(for: request) { (result: Result<ProfileResult, Error>) in
            
            switch result {
            case .success(let profileResult):
                let profile = profileResult.convertToProfile()
                completion(Result.success(profile))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
        currentUrlSessionTask = task
        task.resume()
    }
    
    private func profileRequest(token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "me",
            httpMethod: "GET"
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func createProfileUrlSessionTask(
        for request: URLRequest,
        completion: @escaping (Result<ProfileResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
        return urlSession.makeUrlSessionTask(for: request) { result in
            let response = result.flatMap { data in
                Result { try decoder.decode(ProfileResult.self, from: data) }
            }
            completion(response)
        }
    }
}
