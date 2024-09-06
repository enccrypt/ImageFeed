//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 05.09.2024.
//

import Foundation

extension Date {
    var dateTimeString: String { DateFormatter.defaultDateTime.string(from: self) }
}

private extension DateFormatter {
    static let defaultDateTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm"
        return dateFormatter
    }()
}
