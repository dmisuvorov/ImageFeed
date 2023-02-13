//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 02.02.2023.
//
import Foundation

final class OAuth2Service {
    private let tokenStorage: OAuth2TokenStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private var currentUrlSessionTask: URLSessionTask?
    private var lastCode: String?
    
    func fetchAuthToken(
        code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        currentUrlSessionTask?.cancel()
        lastCode = code
        let request = authTokenRequest(code: code)
        let task = createAuthTokenUrlSessionTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
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
    
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: UnsplashTokenURL
        )
    }
    
    private func createAuthTokenUrlSessionTask(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
        return urlSession.makeUrlSessionTask(for: request) { result in
            let response = result.flatMap { data in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
    
    
}
