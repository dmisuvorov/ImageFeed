//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 14.02.2023.
//

import UIKit

final class ProfileImageService {
    static let shared = ProfileImageService()
    
    private (set) var avatarURL: String?
    
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private var currentUrlSessionTask: URLSessionTask?
    private var lastUsername: String?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastUsername == username { return }
        currentUrlSessionTask?.cancel()
        lastUsername = username
        let request = profileImageRequest(token: oAuth2TokenStorage.token, username: username)
        let task = createProfileImageUrlSessionTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let userResult):
                let profileSmallImageURL = userResult.profileImage.small
                self.avatarURL = profileSmallImageURL
                completion(Result.success(profileSmallImageURL))
            case .failure(let error):
                self.avatarURL = nil
                completion(Result.failure(error))
            }
        }
        currentUrlSessionTask = task
        task.resume()
    }
    
    private func profileImageRequest(token: String, username: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "users/\(username)",
            httpMethod: "GET"
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func createProfileImageUrlSessionTask(
        for request: URLRequest,
        completion: @escaping (Result<UserResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
        return urlSession.makeUrlSessionTask(for: request) { result in
            let response = result.flatMap { data in
                Result { try decoder.decode(UserResult.self, from: data) }
            }
            completion(response)
        }
    }
}
