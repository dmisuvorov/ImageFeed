//
//  Photo.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 20.02.2023.
//
import UIKit

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
}

extension PhotoResult {
    func convertToPhoto() -> Photo {
        Photo(
            id: self.id,
            size: CGSize(width: Double(self.width), height: Double(self.height)),
            createdAt: self.createdAt,
            welcomeDescription: self.description,
            thumbImageURL: self.urls.thumb,
            largeImageURL: self.urls.full,
            isLiked: self.likedByUser
        )
    }
}
