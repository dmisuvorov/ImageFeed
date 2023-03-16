//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 16.03.2023.
//
import UIKit

protocol ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol? { get set }
    func setProfileDetails(name: String, nickname: String, bio: String?)
    func setAvatar(url: URL)
    func navigateToSplashController()
}
