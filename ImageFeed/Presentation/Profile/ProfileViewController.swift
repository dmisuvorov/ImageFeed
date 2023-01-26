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
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.ypBold23
        nameLabel.textColor = UIColor.ypWhite
        nameLabel.numberOfLines = 1
        nameLabel.adjustsFontSizeToFitWidth = true
        return nameLabel
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let nicknameLabel = UILabel()
        nicknameLabel.text = "@ekaterina_nov"
        nicknameLabel.font = UIFont.ypRegular13
        nicknameLabel.textColor = UIColor.ypGray
        return nicknameLabel
    }()
    
    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.text = "Hello, world!"
        statusLabel.font = UIFont.ypRegular13
        statusLabel.textColor = UIColor.ypWhite
        return statusLabel
    }()
    
    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton()
        logoutButton.setImage(UIImage(named: "logout_button"), for: UIControl.State.normal)
        logoutButton.tintColor = UIColor.ypRed
        return logoutButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        self.view.backgroundColor = UIColor.ypBlack
        self.view.addSubview(self.avatarImageView, constraints: [
            equal(\.heightAnchor, to: 70),
            equal(\.widthAnchor, to: 70),
            equal(\.topAnchor, \.safeAreaLayoutGuide.topAnchor, to: 32),
            equal(\.leadingAnchor, to: 16)
        ])
        self.view.addSubview(self.nameLabel, constraints: [
            equal(\.topAnchor, avatarImageView.bottomAnchor, to: 8),
            equal(\.leadingAnchor, to: 16)
        ])
        self.view.addSubview(self.nicknameLabel, constraints: [
            equal(\.topAnchor, nameLabel.bottomAnchor, to: 8),
            equal(\.leadingAnchor, to: 16)
        ])
        self.view.addSubview(self.statusLabel, constraints: [
            equal(\.topAnchor, nicknameLabel.bottomAnchor, to: 8),
            equal(\.leadingAnchor, to: 16)
        ])
        self.view.addSubview(self.logoutButton, constraints: [
            equal(\.heightAnchor, to: 24),
            equal(\.widthAnchor, to: 24),
            equal(\.topAnchor, \.safeAreaLayoutGuide.topAnchor, to: 56),
            equal(\.trailingAnchor, to: -16)
        ])
    }
}
