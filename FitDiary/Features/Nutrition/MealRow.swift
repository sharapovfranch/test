import SwiftUI

struct MealRow: View {
	var meal: Meal

	var body: some View {
		HStack(alignment: .top, spacing: 12) {
			Image(systemName: meal.timeOfDaySystemIcon)
				.font(.title3)
				.frame(width: 28, height: 28)
			VStack(alignment: .leading, spacing: 4) {
				HStack {
					Text(meal.title)
						.font(.subheadline)
					Text("· \(meal.calories) kcal")
						.font(.subheadline)
						.foregroundStyle(.secondary)
				}
				Text("P \(meal.protein) / F \(meal.fat) / C \(meal.carbs) · \(DateFormatter.mealTime.string(from: meal.date))")
					.font(.caption)
					.foregroundStyle(.secondary)
			}
			Spacer(minLength: 0)
		}
		.padding(.vertical, 6)
	}
}