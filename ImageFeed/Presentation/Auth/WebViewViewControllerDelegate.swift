//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 30.01.2023.
//

import UIKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
