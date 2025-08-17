import SwiftUI

struct DayRibbon<Content: View>: View {
	@Binding var anchor: Date
	var content: (Date) -> Content

	private var days: [Date] {
		let cal = Calendar.current
		let now = Date()
		let range = cal.range(of: .day, in: .month, for: now) ?? 1...30
		let components = cal.dateComponents([.year, .month], from: now)
		let firstOfMonth = cal.date(from: components) ?? now
		return range.compactMap { day -> Date? in
			cal.date(byAdding: .day, value: day - 1, to: firstOfMonth)
		}
	}

	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 12) {
				ForEach(days, id: \.self) { day in
					Button(action: { anchor = day }) {
						content(day)
							.padding(8)
							.background(
								RoundedRectangle(cornerRadius: 12)
									.fill(Calendar.current.isDate(day, inSameDayAs: anchor) ? Color.green.opacity(0.15) : Color.clear)
							)
					}
					.buttonStyle(.plain)
				}
			}
			.padding(.horizontal, 16)
		}
	}
}