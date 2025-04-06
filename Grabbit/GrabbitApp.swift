import SwiftUI
import Stripe

@main
struct GrabbitApp: App {
    @StateObject private var storeModel = StoreModel()
    @StateObject private var cart = CartModel()
    @StateObject private var viewRouter = ViewRouter()

    @State private var showSplash = true

    init() {
        StripeAPI.defaultPublishableKey = "pk_test_..."
    }

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreenView(isActive: $showSplash)
            } else {
                ZStack {
                    switch viewRouter.currentScreen {
                    case .home(let id):
                        NavigationStack {
                            HomeView()
                        }
                        .id(id)

                    case .confirmation:
                        NavigationStack {
                            Confirmation()
                        }

                    case .map:
                        NavigationStack {
                            MapStoreView()
                        }
                    }
                }
                .environmentObject(storeModel)
                .environmentObject(cart)
                .environmentObject(viewRouter)
            }
        }
    }
}

