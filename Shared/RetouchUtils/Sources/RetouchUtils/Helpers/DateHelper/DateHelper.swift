//
//  DateFormatterHelper.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 27.01.2021.
//

import UIKit

public final class DateHelper: @unchecked Sendable {
    // MARK: - Properties
    // Shared
    public static let shared = DateHelper()

    // Calendar
    public var utcCalendar = Calendar.current

    // UTC TimeZone
    public var utcTimeZone = TimeZone(secondsFromGMT: 0)!

    // Formatters
    private var dateFormatter = DateFormatter()

    public var timerStyleFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        dateFormatter.timeZone = utcTimeZone
        return dateFormatter
    }
    
    public var timeStyleFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter
    }
    
    public var dateAndTimeStyleFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd hh:mm"
        dateFormatter.timeZone = utcTimeZone
        return dateFormatter
    }

    public var dateStyleFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.timeZone = utcTimeZone
        return dateFormatter
    }
    
    public var fullDateStyleFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = utcTimeZone
        return dateFormatter
    }

    // MARK: - Init
    init() {
        utcCalendar.timeZone = utcTimeZone
    }
}
