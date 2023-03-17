//
//  ProfilePresenterProtocol.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 16.03.2023.
//

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    
    func updateProfileDetails()
    func updateAvatar()
    func onLogout()
}
