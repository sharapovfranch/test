import Foundation
import SwiftUI

enum Effort: String, Codable, CaseIterable, Identifiable {
	case easy
	case normal
	case hard

	var id: String { rawValue }

	var displayName: String {
		switch self {
		case .easy: return "Easy"
		case .normal: return "Normal"
		case .hard: return "Hard"
		}
	}

	var color: Color {
		switch self {
		case .easy: return .green
		case .normal: return .blue
		case .hard: return .red
		}
	}
}

struct WorkoutSet: Identifiable, Codable, Hashable {
	let id: UUID
	var weight: Double
	var reps: Int

	init(id: UUID = UUID(), weight: Double, reps: Int) {
		self.id = id
		self.weight = weight
		self.reps = reps
	}
}

struct WorkoutEntry: Identifiable, Codable, Hashable {
	let id: UUID
	var title: String
	var date: Date
	var sets: [WorkoutSet]
	var effort: Effort

	init(id: UUID = UUID(), title: String, date: Date = Date(), sets: [WorkoutSet], effort: Effort) {
		self.id = id
		self.title = title
		self.date = date
		self.sets = sets
		self.effort = effort
	}
}