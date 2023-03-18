//
//  ImageListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 18.03.2023.
//

protocol ImageListViewControllerProtocol {
    var presenter: ImageListPresenterProtocol? { get set }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    
    func showProgress()
    
    func dismissProgress()
}
