import SwiftUI

struct CartView: View {
    @EnvironmentObject var cart: CartModel

    var body: some View {
        List {
            ForEach(cart.items) { item in
                HStack {
                    if let urlString = item.imageURL, let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable()
                                     .scaledToFit()
                                     .frame(width: 60, height: 60)
                                     .cornerRadius(8)
                            case .failure(_):
                                Color.gray.frame(width: 60, height: 60).cornerRadius(8)
                            case .empty:
                                ProgressView().frame(width: 60, height: 60)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Color.gray.frame(width: 60, height: 60).cornerRadius(8)
                    }

                    VStack(alignment: .leading) {
                        Text(item.name)
                        Text("$\(item.price, specifier: "%.2f")")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button(action: {
                        cart.remove(item)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Cart")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("Total: $\(cart.total, specifier: "%.2f")")
                    .bold()
            }
        }
    }
}

