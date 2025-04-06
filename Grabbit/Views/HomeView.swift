import SwiftUI
import Auth0

struct HomeView: View {
    @EnvironmentObject var cart: CartModel
    @State private var isShowingCart = false
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Grabbit")
                .font(.largeTitle)

            NavigationLink("Scan Item", destination: ScannerView())
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .navigationTitle("Grabbit")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    viewRouter.currentScreen = .map
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Stores")
                    }
                }
            }

            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    Auth0
                        .webAuth()
                        .clearSession { result in
                            switch result {
                            case .success:
                                print("✅ Logged out")
                                DispatchQueue.main.async {
                                    viewRouter.currentScreen = .login
                                }
                            case .failure(let error):
                                print("❌ Logout failed: \(error)")
                            }
                        }
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }

                Button(action: {
                    isShowingCart = true
                }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "cart")
                            .font(.title2)

                        if cart.count > 0 {
                            Text("\(cart.count)")
                                .font(.caption2)
                                .padding(4)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .offset(x: 8, y: -8)
                        }
                    }
                }
            }
        }
        .navigationDestination(isPresented: $isShowingCart, destination: {
            CartView()
        })
        .navigationBarBackButtonHidden(true)
    }
}

