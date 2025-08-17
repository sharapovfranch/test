import SwiftUI

struct Card<Content: View>: View {
	var content: () -> Content

	init(@ViewBuilder content: @escaping () -> Content) {
		self.content = content
	}

	var body: some View {
		content()
			.padding(16)
			.background(.thinMaterial)
			.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
	}
}