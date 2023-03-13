//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 10.03.2023.
//
import UIKit

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    private let authConfiguration = AuthConfiguration.standard
    
    func viewDidLoad() {
        var urlComponents = URLComponents(string: authConfiguration.unsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: authConfiguration.accessKey),
            URLQueryItem(name: "redirect_uri", value: authConfiguration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: authConfiguration.accessScope)
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        
        didUpdateProgressValue(0)
        
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        }
        return nil
    }
        
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
