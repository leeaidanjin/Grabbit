//
//  FirebaseService.swift
//  Grabbit
//
//  Created by Yahir Salas on 4/6/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseService {
    static let shared = FirebaseService()
    private let db = Firestore.firestore()

    func saveReceipt(_ receipt: Receipt) {
        guard let user = Auth.auth().currentUser else { return }

        do {
            let data = try Firestore.Encoder().encode(receipt)
            db.collection("users")
                .document(user.uid)
                .collection("receipts")
                .document(receipt.id)
                .setData(data)
        } catch {
            print("❌ Error saving receipt: \(error.localizedDescription)")
        }
    }


    func fetchReceipts(for userId: String, completion: @escaping ([Receipt]) -> Void) {
        db.collection("users")
            .document(userId)
            .collection("receipts")
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching receipts: \(error.localizedDescription)")
                    completion([])
                    return
                }

                let receipts = snapshot?.documents.compactMap {
                    try? $0.data(as: Receipt.self)
                } ?? []

                completion(receipts)
            }
    }
}

