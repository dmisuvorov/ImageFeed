//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 03.02.2023.
//

import UIKit

class SplashViewController : UIViewController, AuthViewControllerDelegate {
    private let oAuth2Service = OAuth2Service()
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let MainStoryboardName = "Main"
    private let TabBarViewControllerId = "TabBarViewController"
    private let ShowAuthenticationScreenSegueId = "ShowAuthenticationScreen"
    
    //MARK: - LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if oAuth2TokenStorage.token != Empty {
            switchToTabBarController()
            return
        }
        switchToAuthViewController()
    }
    
    //MARK: - AuthViewControllerDelegate
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        vc.dismiss(animated: true)
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    //MARK: - private func
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: MainStoryboardName, bundle: Bundle.main)
            .instantiateViewController(withIdentifier: TabBarViewControllerId)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service?.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                //TODO: [Sprint 11]
            }
        }
    }
}

//MARK: - Switch to Auth flow
extension SplashViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueId {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let authViewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueId)") }
            authViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func switchToAuthViewController() {
        performSegue(withIdentifier: ShowAuthenticationScreenSegueId, sender: nil)
    }
}
