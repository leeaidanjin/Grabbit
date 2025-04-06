import SwiftUI
import Stripe

@main
struct GrabbitApp: App {
    @StateObject private var storeModel = StoreModel()
    @StateObject private var cart = CartModel()
    @StateObject private var viewRouter = ViewRouter()

    init() {
        StripeAPI.defaultPublishableKey = "pk_test_51RAeRmGaOx80ufGO5yG6icuEpmDI04wXCPbdhYWLCqraRa2RLypjH56KLs6UgH8WvHUHXTQdRVtIFAaNKpMMyDYL00IelWq896"
    }

    var body: some Scene {
        WindowGroup {
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

