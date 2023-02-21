//
//  ImageListCellDelegate.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 21.02.2023.
//

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
