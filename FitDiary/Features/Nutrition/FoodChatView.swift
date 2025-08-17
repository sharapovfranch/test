import SwiftUI

struct FoodChatView: View {
	@EnvironmentObject var store: Store
	@State private var input: String = ""
	@State private var suggestion: Meal? = nil

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {
				Card {
					VStack(alignment: .leading, spacing: 12) {
						Text("Describe your meal").font(.headline)
						HStack(spacing: 8) {
							TextField("e.g. Oatmeal 300g, banana", text: $input)
								.textFieldStyle(.roundedBorder)
							Button("Send") {
								suggestion = suggest(from: input)
							}
							.buttonStyle(.borderedProminent)
						}
					}
				}

				if let suggestion {
					SuggestionCard(meal: suggestion) {
						store.meals.append(suggestion)
						store.save()
						self.suggestion = nil
					}
				}

				Text("Note: simple local parser.\nTODO: replace with real LLM call.")
					.font(.caption)
					.foregroundStyle(.secondary)
			}
			.padding(.horizontal, 16)
		}
	}

	func suggest(from text: String) -> Meal? {
		// TODO: replace with real LLM call
		let lower = text.lowercased()

		// Extract grams: first number followed by g/гр
		let grams: Double = {
			let pattern = #"(\d{2,4})\s*(g|гр)"#
			if let regex = try? NSRegularExpression(pattern: pattern),
				let match = regex.firstMatch(in: lower, range: NSRange(lower.startIndex..., in: lower)),
				let range = Range(match.range(at: 1), in: lower) {
				return Double(lower[range]) ?? 100
			}
			return 100
		}()
		let scale = grams / 100.0

		struct FoodBase { let title: String; let kcal: Double; let p: Double; let f: Double; let c: Double }
		let bases: [FoodBase] = {
			// Approximate per 100g
			if lower.contains("oat") || lower.contains("овсян") {
				return [FoodBase(title: "Oatmeal", kcal: 180, p: 6, f: 4, c: 30)]
			}
			if lower.contains("banana") || lower.contains("банан") {
				return [FoodBase(title: "Banana", kcal: 89, p: 1.1, f: 0.3, c: 23)]
			}
			if lower.contains("chicken") || lower.contains("курица") {
				return [FoodBase(title: "Chicken", kcal: 165, p: 31, f: 3.6, c: 0)]
			}
			if lower.contains("rice") || lower.contains("рис") {
				return [FoodBase(title: "Rice", kcal: 130, p: 2.7, f: 0.3, c: 28)]
			}
			return []
		}()

		guard let base = bases.first else { return nil }
		let kcal = Int((base.kcal * scale).rounded())
		let p = Int((base.p * scale).rounded())
		let f = Int((base.f * scale).rounded())
		let c = Int((base.c * scale).rounded())
		return Meal(title: base.title, calories: kcal, protein: p, fat: f, carbs: c)
	}
}