import SwiftUI
import Stripe

struct CartView: View {
    @EnvironmentObject var cart: CartModel
    @State private var showConfirmation = false
    @State private var isActive = false
    @State private var isLoading = false

    private func startCheckout(completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://wry-complete-bathroom.glitch.me/create-payment-intent")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["items": cart.items]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion(nil)
                return
            }

            let checkoutIntentResponse = try? JSONDecoder().decode(CheckoutIntentResponse.self, from: data)
            completion(checkoutIntentResponse?.clientSecret)
        }.resume()
    }

    var body: some View {
        VStack {
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

            if cart.count > 0 {
                Button("Checkout") {
                    isLoading = true
                    startCheckout { clientSecret in
                        DispatchQueue.main.async {
                            isLoading = false
                            if let clientSecret = clientSecret {
                                PaymentConfig.shared.paymentIntentClientSecret = clientSecret
                                isActive = true
                            } else {
                                print("❌ Failed to fetch client secret")
                            }
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .disabled(isLoading)

                if isLoading {
                    ProgressView("Preparing Checkout...")
                        .padding()
                }
            }
        }
        .navigationDestination(isPresented: $isActive) {
            CheckoutView()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("Total: $\(cart.total, specifier: "%.2f")")
            }
        }
        .navigationTitle("\(cart.currentStore) Cart")
    }
}
