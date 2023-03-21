//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 10.03.2023.
//
import UIKit

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    
    func viewDidLoad()
    
    func didUpdateProgressValue(_ newValue: Double)
    
    func code(from url: URL) -> String?
}
