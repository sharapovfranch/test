import Foundation

struct Meal: Identifiable, Codable, Hashable {
	let id: UUID
	var title: String
	var calories: Int
	var protein: Int
	var fat: Int
	var carbs: Int
	var date: Date

	init(id: UUID = UUID(), title: String, calories: Int, protein: Int, fat: Int, carbs: Int, date: Date = Date()) {
		self.id = id
		self.title = title
		self.calories = calories
		self.protein = protein
		self.fat = fat
		self.carbs = carbs
		self.date = date
	}

	var timeOfDaySystemIcon: String {
		let hour = Calendar.current.component(.hour, from: date)
		switch hour {
		case 5...10:
			return "sunrise.fill"
		case 11...15:
			return "sun.max.fill"
		case 16...20:
			return "sunset.fill"
		default:
			return "moon.fill"
		}
	}
}