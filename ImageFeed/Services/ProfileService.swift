//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 13.02.2023.
//

import UIKit

final class ProfileService {
    static let shared = ProfileService()
    
    private(set) var profile: Profile?
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private var currentUrlSessionTask: URLSessionTask?
    private var lastToken: String?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastToken != oAuth2TokenStorage.token,
              let request = profileRequest(token: token) else { return }
        
        currentUrlSessionTask?.cancel()
        lastToken = oAuth2TokenStorage.token
        let task = urlSession.makeUrlSessionTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profileResult):
                let profile = profileResult.convertToProfile()
                self.profile = profile
                completion(Result.success(profile))
            case .failure(let error):
                self.profile = nil
                completion(Result.failure(error))
            }
        }
        currentUrlSessionTask = task
        task.resume()
    }
    
    private func profileRequest(token: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "me",
            httpMethod: "GET"
        )
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
