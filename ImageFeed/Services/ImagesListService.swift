//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 20.02.2023.
//
import UIKit

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int = 0
    private var currentUrlSessionState: FetchPhotosState?
    
    private let urlSession = URLSession.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    private init() {}
    
    func fetchPhotosNextPage() {
        guard currentUrlSessionState == nil,
              currentUrlSessionState != FetchPhotosState.inProgress,
              let token = oAuth2TokenStorage.token,
              let request = photosRequest(token: token, page: lastLoadedPage + 1) else { return }
        
        let task = urlSession.makeUrlSessionTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let photoResult):
                    let newPhotos = photoResult.map { $0.convertToPhoto() }
                    self.photos.append(contentsOf: newPhotos)
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                    self.currentUrlSessionState = FetchPhotosState.success
                    self.lastLoadedPage += 1
                case .failure:
                    self.currentUrlSessionState = FetchPhotosState.failure
                    self.fetchPhotosNextPage()
                }
            }
        }
        currentUrlSessionState = FetchPhotosState.inProgress
        task.resume()
    }
    
    private func photosRequest(token: String, page: Int) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "photos",
            httpMethod: "GET",
            queryItems: [URLQueryItem(name: "page", value: String(page))]
        )
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

private enum FetchPhotosState {
    case success
    case failure
    case inProgress
}
