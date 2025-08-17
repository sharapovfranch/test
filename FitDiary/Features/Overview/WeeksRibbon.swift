import SwiftUI

struct WeeksRibbon<Content: View>: View {
	var content: (Date, Date) -> Content

	private var weeks: [(Date, Date)] {
		let cal = Calendar.current
		let now = Date()
		return (0..<12).compactMap { offset in
			let ref = cal.date(byAdding: .weekOfYear, value: -offset, to: now) ?? now
			let start = ref.startOfWeek(using: cal)
			let end = ref.endOfWeek(using: cal)
			return (start, end)
		}.reversed()
	}

	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 12) {
				ForEach(weeks, id: \.0) { start, end in
					content(start, end)
				}
			}
			.padding(.horizontal, 16)
		}
	}
}