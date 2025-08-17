import Foundation

struct Goals: Codable, Equatable {
	var dailyCalories: Int
	var dailyProtein: Int
	var weeklyWorkoutTarget: Int

	static let `default` = Goals(dailyCalories: 2000, dailyProtein: 150, weeklyWorkoutTarget: 3)
}