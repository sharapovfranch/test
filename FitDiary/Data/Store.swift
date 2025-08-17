import Foundation
import Combine

final class Store: ObservableObject {
	@Published var goals: Goals
	@Published var meals: [Meal]
	@Published var workouts: [WorkoutEntry]

	private let fileURL: URL

	private struct Snapshot: Codable {
		var goals: Goals
		var meals: [Meal]
		var workouts: [WorkoutEntry]
		var debugSeeded: Bool?
	}

	init() {
		let fm = FileManager.default
		let docs = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
		self.fileURL = docs.appendingPathComponent("fitdiary.json")

		if let loaded = try? Data(contentsOf: fileURL) {
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			if let snapshot = try? decoder.decode(Snapshot.self, from: loaded) {
				self.goals = snapshot.goals
				self.meals = snapshot.meals
				self.workouts = snapshot.workouts
				return
			}
		}

		self.goals = .default
		self.meals = []
		self.workouts = []

		#if DEBUG
		seedIfNeeded()
		#else
		save()
		#endif
	}

	func save() {
		let encoder = JSONEncoder()
		encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
		encoder.dateEncodingStrategy = .iso8601
		let snapshot = Snapshot(goals: goals, meals: meals, workouts: workouts, debugSeeded: nil)
		if let data = try? encoder.encode(snapshot) {
			try? data.write(to: fileURL, options: [.atomic])
		}
	}

	func meals(on day: Date) -> [Meal] {
		let cal = Calendar.current
		return meals
			.filter { cal.isDate($0.date, inSameDayAs: day) }
			.sorted { $0.date < $1.date }
	}

	func workouts(inWeekOf date: Date) -> [WorkoutEntry] {
		let cal = Calendar.current
		let start = date.startOfWeek(using: cal)
		let end = date.endOfWeek(using: cal)
		return workouts.filter { $0.date.isWithin(start, and: end, using: cal) }
	}

	func dailyNutritionProgress(for day: Date) -> Double {
		let dayMeals = meals(on: day)
		guard !dayMeals.isEmpty else { return 0 }
		let totalCalories = dayMeals.reduce(0) { $0 + $1.calories }
		let totalProtein = dayMeals.reduce(0) { $0 + $1.protein }

		let cGoal = max(goals.dailyCalories, 1)
		let pGoal = max(goals.dailyProtein, 1)

		let cPct = min(Double(totalCalories) / Double(cGoal), 1.0)
		let pPct = min(Double(totalProtein) / Double(pGoal), 1.0)
		return (cPct + pPct) / 2.0
	}

	#if DEBUG
	private func seedIfNeeded() {
		if FileManager.default.fileExists(atPath: fileURL.path) {
			return
		}

		let now = Date()
		let cal = Calendar.current
		// Meals: today and yesterday
		let today = now
		let yesterday = cal.date(byAdding: .day, value: -1, to: now) ?? now
		meals = [
			Meal(title: "Oatmeal", calories: 360, protein: 12, fat: 8, carbs: 60, date: cal.date(bySettingHour: 8, minute: 15, second: 0, of: today) ?? today),
			Meal(title: "Chicken & Rice", calories: 550, protein: 45, fat: 12, carbs: 65, date: cal.date(bySettingHour: 13, minute: 5, second: 0, of: today) ?? today),
			Meal(title: "Banana", calories: 100, protein: 1, fat: 0, carbs: 25, date: cal.date(bySettingHour: 16, minute: 40, second: 0, of: yesterday) ?? yesterday)
		]

		// Workouts: current and previous week
		let lastWeek = cal.date(byAdding: .day, value: -7, to: now) ?? now
		workouts = [
			WorkoutEntry(title: "Bench Press", date: cal.date(bySettingHour: 18, minute: 30, second: 0, of: now) ?? now, sets: [
				WorkoutSet(weight: 60, reps: 8),
				WorkoutSet(weight: 65, reps: 6),
				WorkoutSet(weight: 70, reps: 5)
			], effort: .normal),
			WorkoutEntry(title: "Squat", date: cal.date(bySettingHour: 19, minute: 00, second: 0, of: lastWeek) ?? lastWeek, sets: [
				WorkoutSet(weight: 80, reps: 5),
				WorkoutSet(weight: 85, reps: 5),
				WorkoutSet(weight: 90, reps: 3)
			], effort: .hard)
		]

		save()
	}
	#endif
}