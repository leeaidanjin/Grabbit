import SwiftUI

struct HomeView: View {
    @EnvironmentObject var cart: CartModel
    @State private var isShowingCart = false

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
    }
}
