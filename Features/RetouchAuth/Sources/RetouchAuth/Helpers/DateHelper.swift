import UIKit

final class DateHelper: Sendable {
    // MARK: - Properties
    // Shared
    static let shared = DateHelper()

    // Calendar
    let utcCalendar: Calendar

    // UTC TimeZone
    let utcTimeZone = TimeZone(secondsFromGMT: 0)!

    // Formatters
    private let dateFormatter = DateFormatter()

    var dateStyleFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.timeZone = utcTimeZone
        return dateFormatter
    }

    // MARK: - Init
    init() {
        var calendar = Calendar.current
        calendar.timeZone = utcTimeZone
        utcCalendar = calendar
    }
}
