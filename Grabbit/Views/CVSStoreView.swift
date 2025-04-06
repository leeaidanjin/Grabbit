//
//  CVSStoreView.swift
//  Grabbit
//
//  Created by Yahir Salas on 4/6/25.
//

import SwiftUI
import Auth0

struct CVSStoreView: View {
    @EnvironmentObject var cart: CartModel
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var isShowingCart = false
    @State private var searchText = ""

    let allProducts: [Product] = [
        Product(name: "HERSHEY'S Bar", barcode: "001", price: 1.49, imageURL: "https://upload.wikimedia.org/wikipedia/commons/1/1b/Hershey%27s_Milk_Chocolate_wrapper_%282012-2015%29.png"),
        Product(name: "Coke Bottle", barcode: "002", price: 1.29, imageURL: "https://pngimg.com/d/cocacola_PNG22.png"),
        Product(name: "Chips", barcode: "003", price: 2.99, imageURL: "https://purepng.com/public/uploads/large/purepng.com-lays-potato-chipsfood-potato-tasty-pack-lays-chips-taste-product-snaks-9415246340529nj3f.png"),
        Product(name: "Gatorade", barcode: "004", price: 1.99, imageURL: "https://images.squarespace-cdn.com/content/v1/54e22d6be4b00617871820ca/1594743773195-1LHT4ME1I635H18TLGS3/28oz+Fruit+Punchq.png?format=500w"),
        Product(name: "Oreos", barcode: "005", price: 3.49, imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdRJw6SdgJcEppytjsKUwbxsb-3hVCPK6I7g&s"),
        Product(name: "Trail Mix", barcode: "006", price: 2.49, imageURL: "https://static.vecteezy.com/system/resources/previews/042/796/820/non_2x/trail-mix-and-snacks-on-transparent-background-png.png"),
        Product(name: "Apple Juice", barcode: "007", price: 1.89, imageURL: "https://www.pepsicoschoolsource.com/prod/s3fs-public/styles/pepsico_school_source_product_image_style_for_mobile_fallback/public/2021-06/Tropicana%C2%AE%20Apple%20Juice%20-%2010oz..png?itok=B1dk5n5k"),
        Product(name: "Cheezits", barcode: "008", price: 2.79, imageURL: "https://atlas-content-cdn.pixelsquid.com/stock-images/cheez-it-cracker-L6O2AMA-600.jpg"),
        Product(name: "Granola Bar", barcode: "009", price: 1.19, imageURL: "https://www.pepsicoschoolsource.com/prod/s3fs-public/2021-06/QUAKER%C2%AE%20CHEWY%20GRANOLA%20BAR%2025%25%20LESS%20SUGAR%20CHOCOLATE%20CHIP.png"),
        Product(name: "Pretzels", barcode: "010", price: 2.59, imageURL: "https://cdn.prod.website-files.com/61e097c0733ea2d37f803a02/655b54b4f8181fbefff6bd4c_Mini-Pretzels_Mock_Front%20COMPRESSED.png"),
        Product(name: "Water Bottle", barcode: "011", price: 1.00, imageURL: "https://purepng.com/public/uploads/large/purepng.com-ice-water-bottle-aquafinabottle-water-drink-aquafina-9415246348499t1u0.png"),
        Product(name: "Soda Can", barcode: "012", price: 1.25, imageURL: "https://pngimg.com/d/sprite_PNG98773.png")
    ]

    var filteredProducts: [Product] {
            if searchText.isEmpty { return allProducts }
            return allProducts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }

        var productRows: [[Product]] {
            stride(from: 0, to: filteredProducts.count, by: 4).map {
                Array(filteredProducts[$0..<min($0 + 4, filteredProducts.count)])
            }
        }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
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
                .padding(.top,5)
                .padding(.bottom,5)

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
                    .padding(.bottom, 120)
                }
            }

            ZStack {
                HStack {
                    Button(action: {
                        print("👤 Profile tapped")
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "person.circle")
                                .font(.system(size: 26))
                            Text("Profile").font(.caption)
                        }
                    }

                    Spacer()

                    NavigationLink(destination: ReceiptsView()) {
                        VStack(spacing: 4) {
                            Image(systemName: "doc.plaintext")
                                .font(.system(size: 26))
                            Text("Receipts").font(.caption)
                        }
                    }
                }
                .padding(.horizontal, 50)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(.horizontal)
                .padding(.bottom, 20)
                .shadow(radius: 4)

                NavigationLink(destination: ScannerView()) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 70, height: 70)
                            .shadow(radius: 6)

                        Image(systemName: "barcode.viewfinder")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                }
                .offset(y: -35)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle("CVS")
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
