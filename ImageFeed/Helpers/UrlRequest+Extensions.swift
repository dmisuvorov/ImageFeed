//
//  UrlRequest.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 03.02.2023.
//

import Foundation

extension URLRequest {
    
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        queryItems: [URLQueryItem]? = nil,
        baseURL: URL = Constants.defaultBaseURL
    ) -> URLRequest? {
        guard var url = URL(string: path, relativeTo: baseURL) else {
            assertionFailure("URL \(baseURL)\\\(path) is not correct")
            return nil
        }
        url.appendQueryItems(queryItems: queryItems)
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}

extension URL {
    mutating func appendQueryItems(queryItems: [URLQueryItem]?) {
        guard let queryItems = queryItems,
              var urlComponents = URLComponents(string: absoluteString) else { return }
        
        var currentQueryItems = urlComponents.queryItems ?? []
        currentQueryItems.append(contentsOf: queryItems)
        urlComponents.queryItems = currentQueryItems
        
        if let newUrl = urlComponents.url {
            self = newUrl
        }
    }
}
