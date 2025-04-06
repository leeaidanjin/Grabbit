import SwiftUI

struct SplashScreenView: View {
    @Binding var isActive: Bool

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image("GrabbitTransparent")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isActive = false
            }
        }
    }
}
