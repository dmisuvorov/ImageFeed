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
    let isLiked: Bool
}

extension Photo {
    func copy(build: (inout Builder) -> Void) -> Photo {
        var builder = Builder(original: self)
        build(&builder)
        return builder.toPhoto()
    }
    
    
    struct Builder {
        var id: String
        var size: CGSize
        var createdAt: String
        var welcomeDescription: String?
        var thumbImageURL: String
        var largeImageURL: String
        var isLiked: Bool
        
        fileprivate init(original: Photo) {
            self.id = original.id
            self.size = original.size
            self.createdAt = original.createdAt
            self.welcomeDescription = original.welcomeDescription
            self.thumbImageURL = original.thumbImageURL
            self.largeImageURL = original.largeImageURL
            self.isLiked = original.isLiked
        }
        
        fileprivate func toPhoto() -> Photo {
            return Photo(
                id: id,
                size: size,
                createdAt: createdAt,
                welcomeDescription: welcomeDescription,
                thumbImageURL: thumbImageURL,
                largeImageURL: largeImageURL,
                isLiked: isLiked
            )
        }
    }
}

extension PhotoResult {
    func convertToPhoto() -> Photo {
        let date = DateHelper.shared.dateFromIso8601String(from: self.createdAt)
        return Photo(
            id: self.id,
            size: CGSize(width: Double(self.width), height: Double(self.height)),
            createdAt: DateHelper.shared.stringOrEmptyFromDate(from: date),
            welcomeDescription: self.description,
            thumbImageURL: self.urls.thumb,
            largeImageURL: self.urls.full,
            isLiked: self.likedByUser
        )
    }
}
