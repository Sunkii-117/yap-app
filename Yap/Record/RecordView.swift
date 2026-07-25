import SwiftUI

/// The studio (design doc §7.4): spotlight, prompt pinned, a gold mic ringed by a
/// timer arc. Now backed by the real `RecordingEngine` (AVAudioRecorder + mic
/// permission). Reports `(audioURL, duration)` on stop. Video capture is a
/// follow-up — audio is the first-class default (design §7.4).
struct RecordView: View {
    let onStop: (URL?, Double) -> Void
    let onCancel: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @StateObject private var engine = RecordingEngine()
    @State private var bloom = false
    @State private var pulse = false
    @State private var mode = Mode.audio

    private let target: Double = 60
    private let prompt = PromptProvider(library: PromptLibrary.all).prompt(for: .now)
    private enum Mode: Hashable { case audio, video }

    var body: some View {
        ZStack {
            YapGradient.spotlight.ignoresSafeArea()
                .opacity(reduceMotion ? 1 : (bloom ? 1 : 0.55))
                .scaleEffect(reduceMotion ? 1 : (bloom ? 1 : 0.9))

            if engine.state == .permissionDenied {
                denied
            } else {
                studio
            }
        }
        .onAppear(perform: animateIn)
        .onChange(of: engine.state) { _, new in
            if new == .stopped { onStop(engine.audioURL, engine.elapsed) }
        }
        .onDisappear {
            if engine.state == .recording { engine.stop() } // don't leak the recorder/session on cancel
        }
    }

    private var studio: some View {
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
                RingProgress(progress: engine.elapsed / target, lineWidth: 8,
                             track: YapColor.studioRoyal.opacity(0.5), fill: YapColor.foilSun)
                    .frame(width: 210, height: 210)
                Button(action: engine.toggle) {
                    Image(systemName: engine.state == .recording ? "stop.fill" : "mic.fill")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(YapColor.studioInk)
                        .frame(width: 112, height: 112)
                        .background(YapGradient.foil, in: Circle())
                        .yapShadow(YapShadow.glowGold)
                        .scaleEffect((pulse && !reduceMotion && engine.state != .recording) ? 1.04 : 1)
                }
                .accessibilityLabel(engine.state == .recording ? "Stop recording" : "Start recording")
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

            Text(engine.state == .recording ? "Tap the mic to finish" : "Tap the mic to start")
                .font(YapType.caption)
                .foregroundStyle(YapColor.textMute)
        }
        .padding(YapSpacing.s5)
    }

    private var denied: some View {
        VStack(spacing: YapSpacing.s5) {
            Image(systemName: "mic.slash.fill")
                .font(.system(size: 44, weight: .bold))
                .foregroundStyle(YapColor.foilGold)
            Text("Mic access is off")
                .font(YapType.title).foregroundStyle(YapColor.textWhite)
            Text("Turn on the microphone in Settings and come back — nothing's lost.")
                .font(YapType.bodyL).foregroundStyle(YapColor.textSoft)
                .multilineTextAlignment(.center)
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .buttonStyle(CandyButtonStyle(.gold))
            Button("Not now", action: onCancel)
                .buttonStyle(CandyButtonStyle(.ghost))
        }
        .padding(YapSpacing.s6)
    }

    private func animateIn() {
        if reduceMotion { bloom = true; return }
        withAnimation(.easeOut(duration: 0.5)) { bloom = true }
        withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) { pulse = true }
    }

    private var timeString: String {
        func fmt(_ t: Double) -> String { let s = Int(t); return String(format: "%02d:%02d", s / 60, s % 60) }
        return "\(fmt(engine.elapsed)) / \(fmt(target))"
    }
}
