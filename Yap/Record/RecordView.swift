import SwiftUI

/// The studio (design doc §7.4): spotlight gradient, prompt pinned, a gold mic ringed
/// by a timer arc, audio/video toggle. Capture is mocked (a timer) — the real
/// `AVAudioRecorder`/`Speech` path lands with the M1 record engine.
struct RecordView: View {
    let onStop: () -> Void
    let onCancel: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var elapsed: Double = 0
    @State private var recording = false
    @State private var bloom = false
    @State private var pulse = false
    @State private var mode = Mode.audio

    private let target: Double = 60
    private let tick = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    private let prompt = PromptProvider(library: PromptLibrary.all).prompt(for: .now)

    private enum Mode: Hashable { case audio, video }

    var body: some View {
        ZStack {
            YapGradient.spotlight.ignoresSafeArea()
                .opacity(reduceMotion ? 1 : (bloom ? 1 : 0.55))
                .scaleEffect(reduceMotion ? 1 : (bloom ? 1 : 0.9))

            VStack(spacing: 0) {
                HStack {
                    Button(action: onCancel) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(YapColor.textSoft)
                            .frame(width: 44, height: 44)
                    }
                    .accessibilityLabel("Cancel")
                    Spacer()
                }

                Text(prompt.text)
                    .font(YapType.subhead)
                    .foregroundStyle(YapColor.textWhite)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, YapSpacing.s6)

                Spacer()

                ZStack {
                    RingProgress(progress: elapsed / target, lineWidth: 8,
                                 track: YapColor.studioRoyal.opacity(0.5), fill: YapColor.foilSun)
                        .frame(width: 210, height: 210)
                    Button(action: toggleRecord) {
                        Image(systemName: recording ? "stop.fill" : "mic.fill")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(YapColor.studioInk)
                            .frame(width: 112, height: 112)
                            .background(YapGradient.foil, in: Circle())
                            .yapShadow(YapShadow.glowGold)
                            .scaleEffect((pulse && !reduceMotion && !recording) ? 1.04 : 1)
                    }
                    .accessibilityLabel(recording ? "Stop recording" : "Start recording")
                }

                Text(timeString)
                    .font(.custom(YapFontName.frauncesBlack, size: 32))
                    .foregroundStyle(YapColor.textWhite)
                    .monospacedDigit()
                    .padding(.top, YapSpacing.s5)

                Spacer()

                Picker("Mode", selection: $mode) {
                    Text("Audio").tag(Mode.audio)
                    Text("Video").tag(Mode.video)
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 220)
                .padding(.bottom, YapSpacing.s4)

                Text(recording ? "Tap the mic to finish" : "Tap the mic to start")
                    .font(YapType.caption)
                    .foregroundStyle(YapColor.textMute)
            }
            .padding(YapSpacing.s5)
        }
        .onAppear {
            if reduceMotion {
                bloom = true
            } else {
                withAnimation(.easeOut(duration: 0.5)) { bloom = true }
                withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) { pulse = true }
            }
        }
        .onReceive(tick) { _ in
            guard recording else { return }
            elapsed = min(elapsed + 0.05, target)
            if elapsed >= target { finish() }
        }
    }

    private func toggleRecord() {
        if recording { finish() } else { recording = true }
    }

    private func finish() {
        recording = false
        onStop()
    }

    private var timeString: String {
        func fmt(_ t: Double) -> String { let s = Int(t); return String(format: "%02d:%02d", s / 60, s % 60) }
        return "\(fmt(elapsed)) / \(fmt(target))"
    }
}
