//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 28.12.2022.
//

import Kingfisher
import UIKit

final class ImagesListCell: UITableViewCell {
    weak var delegate: ImageListCellDelegate?
    
    private lazy var likeButtonOn = UIImage(named: "like_button_on")
    private lazy var likeButtonOff = UIImage(named: "like_button_off")
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    static let reuseIdentifier = "ImagesListCell"
    
    @IBAction func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil
        dateLabel.text = nil
        setIsLiked(false)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        likeButton.setImage(isLiked ? likeButtonOn : likeButtonOff, for: .normal)
    }
}
