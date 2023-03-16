//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 16.03.2023.
//
import UIKit

final class ProfilePresenter: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        
        view?.setProfileDetails(name: profile.name, nickname: profile.loginName, bio: profile.bio)
        updateAvatar()
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        view?.setAvatar(url: url)
    }
    
    func onLogout() {
        oAuth2TokenStorage.token = ""
        WebViewViewController.clearData()
        view?.navigateToSplashController()
    }
}
