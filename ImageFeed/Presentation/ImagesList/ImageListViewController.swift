//
//  ImageListViewController.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 16.12.2022.
//

import UIKit
import Kingfisher

final class ImageListViewController: UIViewController {
    private lazy var photos: [Photo] = []
    private lazy var alertPresenter = AlertPresenter(viewController: self)
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        configureObserver()
        imagesListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as? SingleImageViewController
            guard let indexPath = sender as? IndexPath,
                  let imageName = photos[safe: indexPath.row]?.largeImageURL,
                  let largeImageURL = URL(string: imageName) else { return }
            
            viewController?.imageURL = largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configureObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    self?.updateTableViewAnimated()
                }
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.automatic)
            } completion: { _ in }
        }
    }
}

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImageListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard
            let image = photos[safe: indexPath.row],
            let thumbUrl = URL(string: image.thumbImageURL) else { return }
        
        cell.dateLabel.text = image.createdAt
        cell.setIsLiked(image.isLiked)
        // TODO: - перенести всю логику по kingfisher в ImagesListCell
        cell.cellImage.kf.indicatorType = IndicatorType.activity
        cell.cellImage.kf.setImage(
            with: thumbUrl,
            placeholder: UIImage(named: "photo_place_holder")
        ) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}

extension ImageListViewController: ImageListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
            
                self.alertPresenter.presentAlert(
                    title: "Что-то пошло не так(",
                    message: "Попробовать ещё раз?",
                    firstButtonTitle: "Да",
                    firstButtonAction: { self.imageListCellDidTapLike(cell) },
                    secondButtonTitle: "Нет",
                    secondButtonAction: { }
                )
            }
        }
    }
}
