import SwiftUI

struct NumberField: View {
	var title: String
	@Binding var value: Int
	@State private var text: String = ""

	var body: some View {
		TextField(title, text: Binding(
			get: { text },
			set: { newValue in
				text = newValue.filter { $0.isNumber }
				value = Int(text) ?? 0
			}
		))
		.textFieldStyle(.roundedBorder)
		.keyboardType(.numberPad)
		.onAppear {
			text = String(value)
		}
	}
}