import SwiftUI
import Stripe

@main
struct GrabbitApp: App {
    @StateObject private var storeModel = StoreModel()
    @StateObject private var cart = CartModel()
    
    init() {
        StripeAPI.defaultPublishableKey =  "pk_test_51RAeRmGaOx80ufGO5yG6icuEpmDI04wXCPbdhYWLCqraRa2RLypjH56KLs6UgH8WvHUHXTQdRVtIFAaNKpMMyDYL00IelWq896"
    }

    var body: some Scene {
        WindowGroup {
            StoreSelectionView()
                .environmentObject(storeModel)
                .environmentObject(cart)
        }
    }
}



