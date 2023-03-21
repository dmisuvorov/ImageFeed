//
//  ImageListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 18.03.2023.
//

protocol ImageListPresenterProtocol {
    var view: ImageListViewControllerProtocol? { get set }
    var photosCount: Int { get }
    
    func onViewDidLoad()
    
    func onDataUpdated()
    
    func onCellWillDisplay(row index: Int)
    
    func getPhotoOrNilByIndex(row index: Int) -> Photo?
    
    func imageListCellDidTapLike(row index: Int, _ completion: @escaping (Result<Photo, Error>) -> Void)
}
