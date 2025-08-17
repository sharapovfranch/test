import SwiftUI

struct WorkoutsView: View {
	@EnvironmentObject var store: Store
	@State private var showingAdd = false

	private var grouped: [(day: Date, entries: [WorkoutEntry])] {
		let cal = Calendar.current
		let grouped = Dictionary(grouping: store.workouts) { entry in
			cal.startOfDay(for: entry.date)
		}
		return grouped.keys.sorted(by: >).map { day in (day, grouped[day]!.sorted { $0.date > $1.date }) }
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
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

			List {
				ForEach(grouped, id: \.day) { day, entries in
					Section(header: Text(DateFormatter.dayHeader.string(from: day))) {
						ForEach(entries, id: \.id) { entry in
							WorkoutRow(entry: entry)
						}
					}
				}
			}
			.listStyle(.insetGrouped)
		}
		.navigationTitle("Workouts")
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					showingAdd = true
				} label: {
					Label("Add", systemImage: "plus")
				}
				.buttonStyle(.bordered)
			}
		}
		.sheet(isPresented: $showingAdd) {
			AddWorkoutSheet()
				.environmentObject(store)
		}
	}
}