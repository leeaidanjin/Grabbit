import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject var cart: CartModel
    @EnvironmentObject var storeModel: StoreModel
    let product: Product
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            if let imageURL = product.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFit().frame(height: 200)
                    } else if phase.error != nil {
                        Text("Image failed to load")
                    } else {
                        ProgressView()
                    }
                }
            }

            Text(product.name)
                .font(.title)
            Text("$\(product.price, specifier: "%.2f")")
                .font(.title2)

            HStack {
                Button("Add to Cart") {
                    if let store = storeModel.selectedStore {
                        let item = CartItem(
                            name: product.name,
                            price: product.price,
                            barcode: product.barcode,
                            imageURL: product.imageURL
                        )
                        cart.add(item)
                    }
                    dismiss()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Cancel") {
                    dismiss()
                }
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Item Details")
    }
}

