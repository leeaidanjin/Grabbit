import Foundation
import FirebaseAuth

struct CartItem: Identifiable, Codable, Hashable {
    let id = UUID()
    let name: String
    let price: Double
    let barcode: String
    let imageURL: String?
}

struct Receipt: Identifiable, Codable {
    let id: String
    let storeName: String
    let items: [CartItem]
    let total: Double
    let date: Date
    let userId: String
}

extension Date {
    func formattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

class CartModel: ObservableObject {
    @Published var carts: [String: [CartItem]] = [:]
    @Published var currentStore: String = ""
    @Published var receipts: [Receipt] = []

    var items: [CartItem] {
        carts[currentStore, default: []]
    }

    var count: Int {
        items.count
    }

    var total: Double {
        items.reduce(0) { $0 + $1.price }
    }

    func add(_ item: CartItem) {
        var current = carts[currentStore, default: []]
        current.append(item)
        carts[currentStore] = current
    }

    func remove(_ item: CartItem) {
        var current = carts[currentStore, default: []]
        if let index = current.firstIndex(of: item) {
            current.remove(at: index)
            carts[currentStore] = current
        }
    }

    func clearCart() {
        carts[currentStore] = []
    }

    func completeCheckout() {
        let receipt = Receipt(
            id: UUID().uuidString,
            storeName: currentStore,
            items: items,
            total: total,
            date: Date(),
            userId: Auth.auth().currentUser?.uid ?? "unknown"
        )

        receipts.insert(receipt, at: 0)
        FirebaseService.shared.saveReceipt(receipt) // Save to Firestore
        clearCart()
    }
}

