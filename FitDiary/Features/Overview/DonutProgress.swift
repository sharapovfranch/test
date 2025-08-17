import SwiftUI

struct DonutProgress: View {
	var pct: Double // 0...1
	var lineWidth: CGFloat = 6

	var body: some View {
		ZStack {
			Circle()
				.stroke(Color.gray.opacity(0.2), lineWidth: lineWidth)
			Circle()
				.trim(from: 0, to: CGFloat(max(0, min(1, pct))))
				.stroke(Color.green, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
				.rotationEffect(.degrees(-90))
				.animation(.easeInOut(duration: 0.3), value: pct)
		}
	}
}