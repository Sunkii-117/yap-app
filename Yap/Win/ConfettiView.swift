import SwiftUI

/// Gold-foil confetti for win moments (design doc §5). Purely decorative and
/// non-interactive; callers gate it on `!reduceMotion`.
struct ConfettiView: View {
    private let pieces = (0..<48).map { _ in Piece() }
    @State private var fall = false

    var body: some View {
        GeometryReader { geo in
            ForEach(pieces) { p in
                RoundedRectangle(cornerRadius: 2)
                    .fill(p.color)
                    .frame(width: p.size, height: p.size * 1.6)
                    .rotationEffect(.degrees(fall ? p.spin : 0))
                    .position(x: p.x * geo.size.width,
                              y: fall ? geo.size.height + 60 : -60)
                    .opacity(0.92)
                    .animation(
                        .easeIn(duration: p.duration).delay(p.delay).repeatForever(autoreverses: false),
                        value: fall
                    )
            }
        }
        .allowsHitTesting(false)
        .onAppear { fall = true }
    }

    private struct Piece: Identifiable {
        let id = UUID()
        let x = Double.random(in: 0...1)
        let size = Double.random(in: 6...12)
        let spin = Double.random(in: 180...720)
        let duration = Double.random(in: 1.8...3.2)
        let delay = Double.random(in: 0...1.2)
        let color: Color = [YapColor.foilGold, YapColor.foilSun, YapColor.foilGlow, YapColor.foilAmber]
            .randomElement() ?? YapColor.foilGold
    }
}
