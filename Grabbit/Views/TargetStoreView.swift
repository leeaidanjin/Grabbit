import SwiftUI
import Auth0

struct TargetStoreView: View {
    @EnvironmentObject var cart: CartModel
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var isShowingCart = false
    @State private var searchText = ""

    let allProducts: [Product] = [
        Product(name: "HERSHEY'S Bar", barcode: "001", price: 1.49, imageURL: "https://images.hersheys.com/assets/hershey/images/products/her_milk_1_55oz_500x500.png"),
        Product(name: "Coke Bottle", barcode: "002", price: 1.29, imageURL: nil),
        Product(name: "Chips", barcode: "003", price: 2.99, imageURL: nil),
        Product(name: "Gatorade", barcode: "004", price: 1.99, imageURL: nil),
        Product(name: "Oreos", barcode: "005", price: 3.49, imageURL: nil),
        Product(name: "Trail Mix", barcode: "006", price: 2.49, imageURL: nil),
        Product(name: "Apple Juice", barcode: "007", price: 1.89, imageURL: nil),
        Product(name: "Cheese Crackers", barcode: "008", price: 2.79, imageURL: nil),
        Product(name: "Granola Bar", barcode: "009", price: 1.19, imageURL: nil),
        Product(name: "Pretzels", barcode: "010", price: 2.59, imageURL: nil),
        Product(name: "Water Bottle", barcode: "011", price: 1.00, imageURL: nil),
        Product(name: "Soda Can", barcode: "012", price: 1.25, imageURL: nil)
    ]

    var filteredProducts: [Product] {
        if searchText.isEmpty { return allProducts }
        return allProducts.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
    }

    var productRows: [[Product]] {
        stride(from: 0, to: filteredProducts.count, by: 4).map {
            Array(filteredProducts[$0..<min($0 + 4, filteredProducts.count)])
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack {
                TextField("Search items", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing)
                    }
                }
            }
            .padding(.top)

            ScrollView {
                VStack(spacing: 20) {
                    ForEach(productRows.indices, id: \.self) { rowIndex in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(productRows[rowIndex], id: \.barcode) { product in
                                    NavigationLink(destination: ProductDetailView(product: product)) {
                                        VStack(spacing: 8) {
                                            if let url = URL(string: product.imageURL ?? "") {
                                                AsyncImage(url: url) { phase in
                                                    if let image = phase.image {
                                                        image.resizable().scaledToFit()
                                                    } else {
                                                        Color.gray
                                                    }
                                                }
                                                .frame(width: 100, height: 100)
                                                .cornerRadius(8)
                                            } else {
                                                Color.gray.frame(width: 100, height: 100).cornerRadius(8)
                                            }

                                            Text(product.name)
                                                .font(.caption)
                                                .multilineTextAlignment(.center)

                                            Text("$\(product.price, specifier: "%.2f")")
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                        .frame(width: 110)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 90)
            }

            VStack {
                NavigationLink("Scan Item", destination: ScannerView())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            .background(Color(UIColor.systemBackground))
        }
        .navigationTitle("Target")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { viewRouter.currentScreen = .map }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Stores")
                    }
                }
            }

            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    Auth0.webAuth().clearSession { result in
                        switch result {
                        case .success:
                            viewRouter.currentScreen = .login
                        case .failure(let error):
                            print("Logout failed: \(error)")
                        }
                    }
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }

                Button(action: {
                    isShowingCart = true
                }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "cart")
                            .font(.title2)
                        if cart.count > 0 {
                            Text("\(cart.count)")
                                .font(.caption2)
                                .padding(4)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .offset(x: 8, y: -8)
                        }
                    }
                }
            }
        }
        .navigationDestination(isPresented: $isShowingCart) {
            CartView()
        }
        .navigationBarBackButtonHidden(true)
    }
}

