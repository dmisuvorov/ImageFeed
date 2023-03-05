//
//  DateHelper.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 28.02.2023.
//
import UIKit

final class DateHelper {
    private let iso8601DateFormatter = ISO8601DateFormatter()
    private let mediumDateStyleFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        return dateFormatter
    }()
    
    static let shared = DateHelper()
    
    private init() { }
    
    func dateFromIso8601String(from: String) -> Date? {
        return iso8601DateFormatter.date(from: from)
    }
    
    func stringOrEmptyFromDate(from: Date?) -> String {
        guard let from = from else { return "" }
        return mediumDateStyleFormatter.string(from: from)
    }
}
