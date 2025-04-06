//
//  ReceiptsView.swift
//  Grabbit
//
//  Created by Yahir Salas on 4/6/25.
//

import SwiftUI
import FirebaseAuth

struct ReceiptsView: View {
    @EnvironmentObject var cart: CartModel
    @State private var isLoading = true

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading Receipts...")
            } else if cart.receipts.isEmpty {
                Text("No receipts yet.")
                    .foregroundColor(.gray)
            } else {
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
            }
        }
        .onAppear {
            loadReceipts()
        }
        .navigationTitle("My Receipts")
    }

    func loadReceipts() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("❌ User not logged in.")
            return
        }

        FirebaseService.shared.fetchReceipts(for: userId) { fetchedReceipts in
            DispatchQueue.main.async {
                cart.receipts = fetchedReceipts
                isLoading = false
            }
        }
    }
}
