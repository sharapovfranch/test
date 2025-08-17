import Foundation

extension Date {
	func startOfWeek(using calendar: Calendar = .current) -> Date {
		let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
		return calendar.date(from: components) ?? self
	}

	func endOfWeek(using calendar: Calendar = .current) -> Date {
		let start = startOfWeek(using: calendar)
		return calendar.date(byAdding: .day, value: 6, to: start) ?? self
	}

	func isWithin(_ start: Date, and end: Date, using calendar: Calendar = .current) -> Bool {
		let dayStart = calendar.startOfDay(for: self)
		return (dayStart >= calendar.startOfDay(for: start)) && (dayStart <= calendar.startOfDay(for: end))
	}
}

extension DateFormatter {
	static let mealTime: DateFormatter = {
		let df = DateFormatter()
		df.locale = Locale(identifier: "en_GB")
		df.dateFormat = "HH:mm"
		return df
	}()

	static let dayHeader: DateFormatter = {
		let df = DateFormatter()
		df.locale = Locale(identifier: "en_GB")
		df.dateFormat = "EEEE, d MMMM"
		return df
	}()

	static func weekRangeString(start: Date, end: Date) -> String {
		let df = DateFormatter()
		df.locale = Locale(identifier: "en_GB")
		df.dateFormat = "d MMM"
		let s = df.string(from: start)
		let e = df.string(from: end)
		return "\(s) – \(e)"
	}
}