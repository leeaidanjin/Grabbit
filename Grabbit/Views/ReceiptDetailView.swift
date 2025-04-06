//
//  ReceiptDetailView.swift
//  Grabbit
//
//  Created by Yahir Salas on 4/6/25.
//

import SwiftUI

struct ReceiptDetailView: View {
    let receipt: Receipt

    var body: some View {
        VStack(spacing: 16) {
            Text("🧾 \(receipt.storeName)")
                .font(.largeTitle)
            Text(receipt.date.formattedString())
                .foregroundColor(.gray)

            List(receipt.items) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text("$\(item.price, specifier: "%.2f")")
                        .foregroundColor(.gray)
                }
            }

            Text("Total: $\(receipt.total, specifier: "%.2f")")
                .font(.title2)
                .bold()
                .padding(.top)

            Spacer()
        }
        .padding()
        .navigationTitle("Receipt")
    }
}
