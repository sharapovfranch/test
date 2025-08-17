import SwiftUI

enum NutritionSubTab: String, CaseIterable, Identifiable {
	case chat = "Chat"
	case history = "History"
	var id: String { rawValue }
}

struct NutritionView: View {
	@State private var subTab: NutritionSubTab = .chat

	var body: some View {
		VStack(spacing: 16) {
			Picker("Mode", selection: $subTab) {
				ForEach(NutritionSubTab.allCases) { tab in
					Text(tab.rawValue).tag(tab)
				}
			}
			.pickerStyle(.segmented)
			.padding(.horizontal, 16)

			if subTab == .chat {
				FoodChatView()
			} else {
				FoodHistoryView()
			}
		}
		.navigationTitle("Nutrition")
	}
}