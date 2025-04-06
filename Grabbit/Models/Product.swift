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

