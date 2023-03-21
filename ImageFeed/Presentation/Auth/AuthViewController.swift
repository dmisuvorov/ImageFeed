//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 30.01.2023.
//

import UIKit

final class AuthViewController : UIViewController {
    var delegate: AuthViewControllerDelegate?
    
    private let showWebViewSegueId = "ShowWebView"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueId {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(showWebViewSegueId)")
                return
            }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewPresenter.view = webViewViewController
            webViewViewController.presenter = webViewPresenter
            webViewViewController.delegate = self
            return
        }
        super.prepare(for: segue, sender: sender)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
