//
//  UserResult+ProfileImage.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 14.02.2023.
//

import UIKit

struct UserResult: Decodable {
    let profileImage: ProfileImage
}

struct ProfileImage: Decodable {
    let small: String
    let medium: String
    let large: String
}
