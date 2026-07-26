import SwiftUI

/// The sign-in gate shown until there's a session. Logic-first (visual polish deferred per the
/// M1 build order): Apple / Google buttons + an email field that fires a magic link, driven by
/// `AuthController.phase`. Reuses the design system so it's on-brand without bespoke work.
struct AuthGate: View {
    let auth: AuthController
    @State private var email = ""
    @FocusState private var emailFocused: Bool

    var body: some View {
        ZStack {
            YapColor.studioInk.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: YapSpacing.s5) {
                    YapbotOrb(size: 92)
                        .frame(maxWidth: .infinity)
                        .padding(.top, YapSpacing.s6)

                    VStack(alignment: .leading, spacing: YapSpacing.s2) {
                        Text("Welcome to Yap")
                            .font(YapType.hero).foregroundStyle(YapColor.textWhite)
                        Text("Sign in to save your streak, yaps, and coaching.")
                            .font(YapType.bodyL).foregroundStyle(YapColor.textSoft)
                    }

                    content

                    Spacer(minLength: YapSpacing.s6)
                }
                .padding(YapSpacing.s5)
            }
            .scrollBounceBehavior(.basedOnSize)
            .disabled(auth.isBusy)

            if auth.isBusy {
                ProgressView()
                    .controlSize(.large)
                    .tint(YapColor.foilGold)
            }
        }
    }

    @ViewBuilder private var content: some View {
        switch auth.phase {
        case .awaitingEmailLink(let address):
            checkInbox(address)
        default:
            providers
        }
    }

    private var providers: some View {
        VStack(spacing: YapSpacing.s3) {
            Button { signIn(.apple) } label: {
                Label("Continue with Apple", systemImage: "apple.logo")
            }
            .buttonStyle(CandyButtonStyle(.gold))

            Button { signIn(.google) } label: {
                Label("Continue with Google", systemImage: "g.circle.fill")
            }
            .buttonStyle(CandyButtonStyle(.ghost))

            HStack(spacing: YapSpacing.s3) {
                line; Text("or").font(YapType.caption).foregroundStyle(YapColor.textMute); line
            }
            .padding(.vertical, YapSpacing.s2)

            TextField("you@email.com", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($emailFocused)
                .foregroundStyle(YapColor.textWhite)
                .padding(YapSpacing.s4)
                .frame(minHeight: 44)
                .background(YapColor.studioGrape, in: RoundedRectangle(cornerRadius: YapRadius.lg))
                .submitLabel(.go)
                .onSubmit { signIn(.email) }

            Button("Email me a magic link") { signIn(.email) }
                .buttonStyle(CandyButtonStyle(.violet))
                .disabled(email.isEmpty)
                .opacity(email.isEmpty ? 0.5 : 1)

            if case .failed(let error) = auth.phase, let message = error.userMessage {
                Text(message)
                    .font(YapType.caption)
                    .foregroundStyle(YapColor.foilAmber)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private func checkInbox(_ address: String) -> some View {
        VStack(alignment: .leading, spacing: YapSpacing.s3) {
            Image(systemName: "envelope.badge.fill")
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(YapColor.foilGold)
            Text("Check your inbox")
                .font(YapType.subhead).foregroundStyle(YapColor.textWhite)
            Text("We sent a sign-in link to \(address). Tap it to finish — you can close this and come back.")
                .font(YapType.bodyL).foregroundStyle(YapColor.textSoft)
            Button("Use a different email") { auth.reset() }
                .buttonStyle(CandyButtonStyle(.ghost))
                .padding(.top, YapSpacing.s2)
        }
        .padding(.top, YapSpacing.s2)
    }

    private var line: some View {
        Rectangle().fill(YapColor.studioLilac.opacity(0.25)).frame(height: 1)
    }

    private func signIn(_ provider: AuthProvider) {
        emailFocused = false
        Task { await auth.signIn(with: provider, email: provider == .email ? email : nil) }
    }
}

#if DEBUG
#Preview {
    AuthGate(auth: AuthController(service: UnconfiguredAuthService()))
}
#endif
