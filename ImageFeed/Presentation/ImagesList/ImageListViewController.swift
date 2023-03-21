//
//  ImageListViewController.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 16.12.2022.
//

import UIKit

final class ImageListViewController: UIViewController, ImageListViewControllerProtocol {
    var presenter: ImageListPresenterProtocol?
    private lazy var alertPresenter = AlertPresenter(viewController: self)
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imagesListServiceObserver: NSObjectProtocol?
    
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        configureObserver()
        presenter?.onViewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as? SingleImageViewController
            guard let indexPath = sender as? IndexPath,
                  let imageName = presenter?.getPhotoOrNilByIndex(row: indexPath.row)?.largeImageURL,
                  let largeImageURL = URL(string: imageName) else { return }
            
            viewController?.imageURL = largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    //MARK: - ImageListViewControllerProtocol
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.automatic)
        } completion: { _ in }
    }
    
    func showProgress() {
        UIBlockingProgressHUD.show()
    }
    
    func dismissProgress() {
        UIBlockingProgressHUD.dismiss()
    }
    
    //MARK: - private func
    private func configureObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    self?.presenter?.onDataUpdated()
                }
    }
}

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.onCellWillDisplay(row: indexPath.row)
    }
}

extension ImageListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let photosCount = presenter?.photosCount else { return 0 }
        return photosCount
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
            let image = presenter?.getPhotoOrNilByIndex(row: indexPath.row),
            let thumbUrl = URL(string: image.thumbImageURL) else { return }
        
        cell.setDate(image.createdAt)
        cell.setIsLiked(image.isLiked)
        cell.setImage(url: thumbUrl) { [weak self] in
            guard let self = self else { return }
            
            self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}

extension ImageListViewController: ImageListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        presenter?.imageListCellDidTapLike(row: indexPath.row) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photo):
                cell.setIsLiked(photo.isLiked)
            case .failure:
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
