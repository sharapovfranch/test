import SwiftUI

struct FoodHistoryView: View {
	@EnvironmentObject var store: Store
	@State private var selectedDay: Date = Date()

	private var mealsByDayInCurrentMonth: [(day: Date, meals: [Meal])] {
		let cal = Calendar.current
		let now = Date()
		let range = cal.range(of: .day, in: .month, for: now) ?? 1...30
		let comps = cal.dateComponents([.year, .month], from: now)
		let firstOfMonth = cal.date(from: comps) ?? now
		let days: [Date] = range.compactMap { d in cal.date(byAdding: .day, value: d - 1, to: firstOfMonth) }
		return days.map { day in (day, store.meals(on: day)) }.filter { !$0.meals.isEmpty }
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			DayRibbon(anchor: $selectedDay) { date in
				VStack(spacing: 8) {
					DonutProgress(pct: store.dailyNutritionProgress(for: date))
						.frame(width: 44, height: 44)
					Text("\(Calendar.current.component(.day, from: date))")
						.font(.subheadline)
				}
			}

			List {
				ForEach(mealsByDayInCurrentMonth, id: \.day) { day, meals in
					Section(header: Text(DateFormatter.dayHeader.string(from: day))) {
						ForEach(meals, id: \.id) { meal in
							MealRow(meal: meal)
						}
					}
				}
			}
			.listStyle(.insetGrouped)
		}
	}
}