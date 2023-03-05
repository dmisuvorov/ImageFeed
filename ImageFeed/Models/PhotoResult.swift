//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 20.02.2023.
//

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let updatedAt: String
    let width: Int
    let height: Int
    let color: String
    let blurHash: String
    let likes: Int
    let likedByUser: Bool
    let description: String?
    let urls: Urls
}

struct Urls: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
