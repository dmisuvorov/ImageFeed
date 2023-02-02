//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 02.02.2023.
//

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
