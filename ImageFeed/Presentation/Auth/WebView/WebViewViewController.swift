//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 30.01.2023.
//

import UIKit
import WebKit

final class WebViewViewController : UIViewController & WebViewViewControllerProtocol {
    weak var delegate: WebViewViewControllerDelegate?
    
    var presenter: WebViewPresenterProtocol?
    
    @IBOutlet private var webView: WKWebView!
    
    @IBOutlet private var progressView: UIProgressView!
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: .new
        ) { [weak self] _, _ in
            guard let self = self else { return }
            self.presenter?.didUpdateProgressValue(self.webView.estimatedProgress)
        }
    }
    
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    //MARK: - WebViewControllerPRotocol
    internal func load(request: URLRequest) {
        webView.load(request)
    }
    
    internal func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }

    internal func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
}

extension WebViewViewController : WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}

extension WebViewViewController {
    static func clearData() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
