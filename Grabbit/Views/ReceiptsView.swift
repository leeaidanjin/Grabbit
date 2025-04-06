//
//  ReceiptsView.swift
//  Grabbit
//
//  Created by Yahir Salas on 4/6/25.
//

import SwiftUI

struct ReceiptsView: View {
    @EnvironmentObject var cart: CartModel

    var body: some View {
        List(cart.receipts) { receipt in
            NavigationLink(destination: ReceiptDetailView(receipt: receipt)) {
                VStack(alignment: .leading) {
                    Text("🛍️ \(receipt.storeName)")
                        .font(.headline)
                    Text(receipt.date.formattedString())
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("Total: $\(receipt.total, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("My Receipts")
    }
}
