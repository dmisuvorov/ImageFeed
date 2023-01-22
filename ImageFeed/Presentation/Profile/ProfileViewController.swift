//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 22.01.2023.
//

import UIKit

class ProfileViewController : UIViewController {
    
    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.image = UIImage(named: "avatar")
        avatarImageView.backgroundColor = UIColor.ypBlack
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.layer.masksToBounds = true
        return avatarImageView
    }()
}
