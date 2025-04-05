import SwiftUI

@main
struct GrabbitApp: App {
    @StateObject private var storeModel = StoreModel()
    @StateObject private var cart = CartModel()

    var body: some Scene {
        WindowGroup {
            StoreSelectionView()
                .environmentObject(storeModel)
                .environmentObject(cart)
        }
    }
}



