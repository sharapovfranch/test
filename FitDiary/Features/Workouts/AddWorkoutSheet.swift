import SwiftUI

struct AddWorkoutSheet: View {
	@EnvironmentObject var store: Store
	@Environment(\.dismiss) private var dismiss

	@State private var title: String = ""
	@State private var setInputs: [WorkoutSetInput] = Array(repeating: WorkoutSetInput(), count: 5)
	@State private var effort: Effort = .normal

	var body: some View {
		NavigationStack {
			Form {
				Section("Exercise name") {
					TextField("e.g. Bench Press", text: $title)
				}
				Section("Sets") {
					ForEach(setInputs.indices, id: \.self) { idx in
						HStack {
							Text("#\(idx + 1)")
							TextField("kg", text: $setInputs[idx].weight)
								.keyboardType(.decimalPad)
							TextField("reps", text: $setInputs[idx].reps)
								.keyboardType(.numberPad)
						}
						.frame(minHeight: 44)
					}
					Button("Add set") {
						setInputs.append(WorkoutSetInput())
					}
					.buttonStyle(.bordered)
				}
				Section("Effort") {
					Picker("Effort", selection: $effort) {
						ForEach(Effort.allCases) { e in
							Text(e.displayName).tag(e)
						}
					}
					.pickerStyle(.segmented)
				}
			}
			.navigationTitle("Add Workout")
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button("Cancel") { dismiss() }
				}
				ToolbarItem(placement: .confirmationAction) {
					Button("Save") { save() }
						.buttonStyle(.borderedProminent)
				}
			}
		}
	}

	private func save() {
		let sets: [WorkoutSet] = setInputs.compactMap { input in
			guard let reps = Int(input.reps), reps > 0 else { return nil }
			let weight = Double(input.weight.replacingOccurrences(of: ",", with: ".")) ?? 0
			return WorkoutSet(weight: weight, reps: reps)
		}
		guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !sets.isEmpty else { return }
		let entry = WorkoutEntry(title: title, date: Date(), sets: sets, effort: effort)
		store.workouts.append(entry)
		store.save()
		dismiss()
	}
}

struct WorkoutSetInput {
	var weight: String = ""
	var reps: String = ""
}