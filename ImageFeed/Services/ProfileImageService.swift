//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 14.02.2023.
//

import UIKit

protocol ProfileImageServiceProtocol {
    var avatarURL: String? { get }
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void)
}

final class ProfileImageService : ProfileImageServiceProtocol {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private (set) var avatarURL: String?
    
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private var currentUrlSessionTask: URLSessionTask?
    private var lastUsername: String?
    
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastUsername != username,
              let token = oAuth2TokenStorage.token,
              let request = profileImageRequest(token: token, username: username) else { return }
        
        currentUrlSessionTask?.cancel()
        lastUsername = username
        let task = urlSession.makeUrlSessionTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
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
    
    private func profileImageRequest(token: String, username: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "users/\(username)",
            httpMethod: "GET"
        )
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
