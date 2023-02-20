//
//  Array+Extensions.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 20.02.2023.
//

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
