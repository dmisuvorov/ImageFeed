//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 03.02.2023.
//

enum NetworkError : Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
