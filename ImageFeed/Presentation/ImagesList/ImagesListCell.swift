//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 28.12.2022.
//

import Kingfisher
import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    static let reuseIdentifier = "ImagesListCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil
        dateLabel.text = nil
        //TODO: - сброс лайков
    }
}
