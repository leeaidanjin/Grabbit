//
//  CartModel.swift
//  Grabbit
//
//  Created by Yahir Salas on 4/6/25.
//

import Foundation

struct CartItem: Identifiable, Codable, Hashable {
    let id = UUID()
    let name: String
    let price: Double
    let barcode: String
    let imageURL: String?
}

class CartModel: ObservableObject {
    @Published var carts: [String: [CartItem]] = [:]
    @Published var currentStore: String = ""

    var items: [CartItem] {
        carts[currentStore, default: []]
    }

    var count: Int {
        items.count
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

    var total: Double {
        carts[currentStore]?.reduce(0) { $0 + $1.price } ?? 0
    }

    func clearCart() {
        carts[currentStore] = []
    }
}
