//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 28.12.2022.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    static let reuseIdentifier = "ImagesListCell"
}
