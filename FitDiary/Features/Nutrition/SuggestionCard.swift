import SwiftUI

struct SuggestionCard: View {
	var meal: Meal
	var onAdd: () -> Void

	var body: some View {
		Card {
			VStack(alignment: .leading, spacing: 8) {
				Text(meal.title).font(.headline)
				Text("P \(meal.protein) · F \(meal.fat) · C \(meal.carbs) · \(meal.calories) kcal")
					.font(.subheadline)
					.foregroundStyle(.secondary)
				HStack {
					Spacer()
					Button("Add to history", action: onAdd)
						.buttonStyle(.borderedProminent)
				}
			}
		}
	}
}