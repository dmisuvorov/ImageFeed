//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 02.02.2023.
//
import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let tokenStorage: OAuth2TokenStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private let authConfiguration = AuthConfiguration.standard
    private var currentUrlSessionTask: URLSessionTask?
    private var lastCode: String?
    
    private init() {}
    
    func fetchAuthToken(
        code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        guard lastCode != code,
              let request = authTokenRequest(code: code) else { return }
        
        currentUrlSessionTask?.cancel()
        lastCode = code
        let task = urlSession.makeUrlSessionTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.tokenStorage.token = authToken
                completion(Result.success(authToken))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
        currentUrlSessionTask = task
        task.resume()
    }
    
    private func authTokenRequest(code: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(authConfiguration.accessKey)"
            + "&&client_secret=\(authConfiguration.secretKey)"
            + "&&redirect_uri=\(authConfiguration.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: authConfiguration.unsplashTokenURL
        )
    }
    
}
