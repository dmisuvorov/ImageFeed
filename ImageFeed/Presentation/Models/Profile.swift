//
//  Profile.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 13.02.2023.
//

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}

extension ProfileResult {
    func convertToProfile() -> Profile {
        Profile(username: self.username,
                name: "\(self.firstName) \(self.lastName)",
                loginName: "@\(self.username)",
                bio: self.bio)
    }
}
