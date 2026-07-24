import SwiftUI

struct CandyButtonStyle: ButtonStyle {
    enum Variant { case gold, violet, ghost }
    let variant: Variant
    init(_ variant: Variant = .gold) { self.variant = variant }

    func makeBody(configuration: Configuration) -> some View {
        CandyButton(configuration: configuration, variant: variant)
    }

    private struct CandyButton: View {
        let configuration: Configuration
        let variant: Variant
        @Environment(\.accessibilityReduceMotion) private var reduceMotion

        private var restEdge: CGFloat { variant == .ghost ? 0 : 6 }
        private var pressEdge: CGFloat { variant == .ghost ? 0 : 2 }

        var body: some View {
            let pressed = configuration.isPressed
            let edge = pressed ? pressEdge : restEdge      // visible darker lip
            let drop = restEdge - edge                     // 0 at rest, 4 when pressed

            configuration.label
                .font(YapType.button)
                .foregroundStyle(faceForeground)
                .padding(.vertical, 16)
                .padding(.horizontal, 26)
                .frame(minHeight: 44)                      // ≥44pt tap target
                .frame(maxWidth: .infinity)
                .background {
                    ZStack {
                        if variant != .ghost {
                            RoundedRectangle(cornerRadius: YapRadius.lg)
                                .fill(edgeColor)
                                .offset(y: edge)           // darker lip peeks below
                        }
                        RoundedRectangle(cornerRadius: YapRadius.lg)
                            .fill(faceFill)
                    }
                }
                .overlay {
                    if variant == .ghost {
                        RoundedRectangle(cornerRadius: YapRadius.lg)
                            .strokeBorder(YapColor.studioLilac, lineWidth: 1.5)
                    }
                }
                .yapShadow(variant == .gold ? YapShadow.glowGold : YapShadowStyle(color: .clear, radius: 0, x: 0, y: 0))
                .offset(y: drop)
                .animation(reduceMotion ? nil : .easeOut(duration: YapMotion.candyPress), value: pressed)
                .contentShape(RoundedRectangle(cornerRadius: YapRadius.lg))
        }

        private var faceFill: AnyShapeStyle {
            switch variant {
            case .gold:   return AnyShapeStyle(YapGradient.foil)
            case .violet: return AnyShapeStyle(YapGradient.violet)
            case .ghost:  return AnyShapeStyle(Color.clear)
            }
        }
        private var edgeColor: Color {
            variant == .gold ? YapColor.foilAmber : YapColor.studioRoyal
        }
        private var faceForeground: Color {
            switch variant {
            case .gold:   return YapColor.studioInk    // dark text on gold reads best
            case .violet: return YapColor.textWhite
            case .ghost:  return YapColor.textSoft
            }
        }
    }
}

#Preview {
    ZStack {
        YapColor.studioInk.ignoresSafeArea()
        VStack(spacing: 20) {
            Button("Record") {}.buttonStyle(CandyButtonStyle(.gold))
            Button("Help me script") {}.buttonStyle(CandyButtonStyle(.violet))
            Button("Save private") {}.buttonStyle(CandyButtonStyle(.ghost))
        }
        .padding(40)
    }
}
