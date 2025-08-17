import SwiftUI

struct WorkoutRow: View {
	var entry: WorkoutEntry

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				Text(entry.title)
					.font(.headline)
				Spacer()
				EffortBadge(effort: entry.effort)
			}
			ForEach(entry.sets) { set in
				Text("\(Int(set.weight)) kg × \(set.reps)")
					.font(.subheadline)
			}
		}
		.padding(.vertical, 4)
	}
}

struct EffortBadge: View {
	var effort: Effort
	var body: some View {
		Text(effort.displayName)
			.font(.caption)
			.padding(.horizontal, 8)
			.padding(.vertical, 4)
			.background(effort.color.opacity(0.15))
			.overlay(
				Capsule()
					.stroke(effort.color.opacity(0.6), lineWidth: 1)
			)
			.clipShape(Capsule())
	}
}