import SwiftUI
import Stripe
import Firebase

@main
struct GrabbitApp: App {
    @StateObject private var storeModel = StoreModel()
    @StateObject private var cart = CartModel()
    @StateObject private var viewRouter = ViewRouter()

    init() {
        FirebaseApp.configure()
        StripeAPI.defaultPublishableKey = "pk_test_51RAeRmGaOx80ufGO5yG6icuEpmDI04wXCPbdhYWLCqraRa2RLypjH56KLs6UgH8WvHUHXTQdRVtIFAaNKpMMyDYL00IelWq896"
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                switch viewRouter.currentScreen {
                case .login:
                    LoginView()
                case .map:
                    NavigationStack {
                        MapStoreView()
                    }
                case .home(let id):
                    NavigationStack {
                        HomeView()
                    }
                    .id(id)
                case .confirmation:
                    NavigationStack {
                        Confirmation()
                    }
                case .cvs:
                    NavigationStack {
                        CVSStoreView()
                    }
                case .traderJoes:
                    NavigationStack {
                        TraderJoesStoreView()
                    }
                case .target:
                    NavigationStack {
                        TargetStoreView()
                    }
                }
            }
            .environmentObject(storeModel)
            .environmentObject(cart)
            .environmentObject(viewRouter)
        }
    }
}

