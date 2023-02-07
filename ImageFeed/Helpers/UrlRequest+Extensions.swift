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
        baseURL: URL = DefaultBaseURL
    ) -> URLRequest {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            fatalError("URL \(baseURL)\\\(path) is not correct")
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
