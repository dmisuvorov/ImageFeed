//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 18.03.2023.
//

final class ImageListPresenter : ImageListPresenterProtocol {
    var view: ImageListViewControllerProtocol?
    var photosCount: Int {
        photos.count
    }
    
    private var photos: [Photo] = []
    private let imagesListService: ImagesListServiceProtocol
    
    init(imagesListService: ImagesListServiceProtocol = ImagesListService.shared) {
        self.imagesListService = imagesListService
    }
    
    func onViewDidLoad() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func onDataUpdated() {
        updateTableViewIfNeeded()
    }
    
    
    func getPhotoOrNilByIndex(row index: Int) -> Photo? {
        return photos[safe: index]
    }
    
    func onCellWillDisplay(row index: Int) {
        if index + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func imageListCellDidTapLike(row index: Int, _ completion: @escaping (Result<Photo, Error>) -> Void) {
        guard let photo = getPhotoOrNilByIndex(row: index) else { return }
        
        view?.showProgress()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            
            self.view?.dismissProgress()
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                completion(Result.success((self.photos[index])))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
    private func updateTableViewIfNeeded() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
}
