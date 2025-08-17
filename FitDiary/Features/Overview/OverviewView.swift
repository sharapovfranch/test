import SwiftUI

struct OverviewView: View {
	@EnvironmentObject var store: Store

	@State private var dailyCalories: Int = Goals.default.dailyCalories
	@State private var dailyProtein: Int = Goals.default.dailyProtein
	@State private var weeklyWorkoutTarget: Int = Goals.default.weeklyWorkoutTarget
	@State private var selectedDay: Date = Date()

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {
				Card {
					VStack(alignment: .leading, spacing: 12) {
						Text("Daily goals").font(.headline)
						HStack(spacing: 12) {
							VStack(alignment: .leading) {
								Text("Daily calories").font(.caption).foregroundStyle(.secondary)
								NumberField(title: "kcal", value: $dailyCalories)
							}
							VStack(alignment: .leading) {
								Text("Daily protein").font(.caption).foregroundStyle(.secondary)
								NumberField(title: "g", value: $dailyProtein)
							}
						}
						Button("Save goals") {
							store.goals.dailyCalories = dailyCalories
							store.goals.dailyProtein = dailyProtein
							store.save()
						}
						.buttonStyle(.borderedProminent)
					}
				}

				VStack(alignment: .leading, spacing: 8) {
					Text("This month").font(.headline).padding(.horizontal, 16)
					DayRibbon(anchor: $selectedDay) { date in
						VStack(spacing: 8) {
							DonutProgress(pct: store.dailyNutritionProgress(for: date))
								.frame(width: 44, height: 44)
							Text("\(Calendar.current.component(.day, from: date))")
								.font(.subheadline)
						}
					}
				}

				Card {
					VStack(alignment: .leading, spacing: 12) {
						HStack {
							Text("Weekly workouts goal").font(.headline)
							Spacer()
							Stepper(value: $weeklyWorkoutTarget, in: 0...14) {
								Text("\(weeklyWorkoutTarget)")
							}
						}
						Button("Save goal") {
							store.goals.weeklyWorkoutTarget = weeklyWorkoutTarget
							store.save()
						}
						.buttonStyle(.bordered)
					}
				}

				VStack(alignment: .leading, spacing: 8) {
					Text("12 weeks").font(.headline).padding(.horizontal, 16)
					WeeksRibbon { start, end in
						let count = store.workouts(inWeekOf: start).count
						let ok = count >= store.goals.weeklyWorkoutTarget
						HStack(spacing: 8) {
							Text("\(DateFormatter.weekRangeString(start: start, end: end)): \(count)")
								.font(.subheadline)
							Image(systemName: ok ? "checkmark.circle.fill" : "xmark.circle")
								.foregroundStyle(ok ? Color.green : Color.red)
						}
						.padding(8)
						.background(.thinMaterial)
						.clipShape(RoundedRectangle(cornerRadius: 12))
					}
				}
			}
			.padding(.vertical, 16)
		}
		.navigationTitle("Overview")
		.onAppear {
			dailyCalories = store.goals.dailyCalories
			dailyProtein = store.goals.dailyProtein
			weeklyWorkoutTarget = store.goals.weeklyWorkoutTarget
		}
	}
}