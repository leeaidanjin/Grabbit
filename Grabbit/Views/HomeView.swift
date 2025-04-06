import SwiftUI

struct HomeView: View {
    @EnvironmentObject var cart: CartModel
    @State private var isShowingCart = false
    @EnvironmentObject var viewRouter: ViewRouter // ✅ Add this

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
            // ✅ Custom back button on the left
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

            // 🛒 Cart button on the right (keep this as-is)
            ToolbarItem(placement: .navigationBarTrailing) {
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

        .navigationDestination(isPresented: $isShowingCart) {
            CartView()
        }
        .navigationBarBackButtonHidden(true)
    }
    
}
