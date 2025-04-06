//
//  Product.swift
//  Grabbit
//  Trying this again
//  Created by Aidan Lee on 4/5/25.
//


import Foundation

struct Product: Identifiable, Hashable, Codable {
    var id: String { barcode }
    let name: String
    let barcode: String
    let price: Double
    let imageURL: String?
}

class CartModel: ObservableObject {
    @Published var items: [Product] = []

    var count: Int { items.count }
    var total: Double { items.reduce(0) { $0 + $1.price } }

    func add(_ product: Product) {
        items.append(product)
    }

    func remove(_ product: Product) {
        items.removeAll { $0.id == product.id }
    }
    func clear () {
        for PRODUCT in items {
            remove(PRODUCT) 
        }
    }
}
