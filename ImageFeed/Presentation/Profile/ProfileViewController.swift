//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 22.01.2023.
//

import UIKit
import Kingfisher

class ProfileViewController : UIViewController {
    private let profileService = ProfileService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let avatarPlaceholder = UIImage(named: "avatar_place_holder")
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private var window: UIWindow? {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return nil
        }
        return window
    }
    
    private lazy var alertPresenter = AlertPresenter(viewController: self)
    
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
        logoutButton.addTarget(self, action: #selector(onLogoutButtonClick), for: .touchUpInside)
        return logoutButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfileDetails(profile: profileService.profile)
        configureUI()
        configureObserver()
    }
    
    private func configureObserver() {
        profileImageServiceObserver = NotificationCenter
            .default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: OperationQueue.main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
    
    @objc private func onLogoutButtonClick() {
        alertPresenter.presentAlert(
            title: "Пока, пока!",
            message: "Уверены сто хотите выйти?",
            firstButtonTitle: "Да",
            firstButtonAction: { self.logout() },
            secondButtonTitle: "Нет",
            secondButtonAction: { }
        )
    }
    
    private func logout() {
        oAuth2TokenStorage.token = ""
        WebViewViewController.clearData()
        window?.rootViewController = SplashViewController()
        window?.makeKeyAndVisible()
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
    
    private func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { preconditionFailure("Unable to get user profile") }
        nameLabel.text = profile.name
        nicknameLabel.text = profile.loginName
        statusLabel.text = profile.bio
        
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        avatarImageView.kf.indicatorType = IndicatorType.activity
        avatarImageView.kf.setImage(with: url, placeholder: avatarPlaceholder) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let imageResult):
                self.avatarImageView.image = imageResult.image
            case .failure:
                self.avatarImageView.image = self.avatarPlaceholder
            }
        }
    }
}
