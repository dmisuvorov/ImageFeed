//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 13.02.2023.
//

struct ProfileResult: Codable {
    let id: String
    let updatedAt: String
    let username: String
    let firstName: String
    let lastName: String
    let twitterUsername: String
    let portfolioUrl: String?
    let bio: String
    let location: String
    let totalLikes: Int
    let totalPhotos: Int
    let totalCollections: Int
    let followedByUser: Bool
    let downloads: Int
    let uploadsRemaining: Int
    let instagramUsername: String
    let email: String?
    let links: Links
}

struct Links: Codable {
    let `self`: String
    let html: String
    let photos: String
    let likes: String
    let portfolio: String
}
