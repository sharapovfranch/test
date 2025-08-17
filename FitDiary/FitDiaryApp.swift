import SwiftUI

@main
struct FitDiaryApp: App {
	@StateObject private var store = Store()

	var body: some Scene {
		WindowGroup {
			TabView {
				NavigationStack {
					OverviewView()
				}
				.tabItem {
					Label("Overview", systemImage: "house")
				}

				NavigationStack {
					NutritionView()
				}
				.tabItem {
					Label("Nutrition", systemImage: "fork.knife")
				}

				NavigationStack {
					WorkoutsView()
				}
				.tabItem {
					Label("Workouts", systemImage: "figure.strengthtraining.traditional")
				}
			}
			.environmentObject(store)
		}
	}
}