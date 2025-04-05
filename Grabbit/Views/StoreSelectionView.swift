import SwiftUI

struct Store: Identifiable {
    let id = UUID()
    let name: String
    let logoURL: String
}

struct StoreSelectionView: View {
    @EnvironmentObject var storeModel: StoreModel

    let stores: [Store] = [
        Store(name: "Target", logoURL: "https://1000logos.net/wp-content/uploads/2017/06/Target-Logo.png"),
        Store(name: "Walmart", logoURL: "https://1000logos.net/wp-content/uploads/2017/06/Walmart-Logo-768x432.png"),
        Store(name: "Vons", logoURL: "https://seeklogo.com/images/V/vons-logo-43737D891F-seeklogo.com.png"),
        Store(name: "CVS", logoURL: "https://seeklogo.com/images/C/cvs-pharmacy-logo-F657D96A1A-seeklogo.com.png")
    ]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Select a Store")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(stores) { store in
                        Button(action: {
                            storeModel.selectedStore = store.name
                        }) {
                            VStack {
                                AsyncImage(url: URL(string: store.logoURL)) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 80)
                                            .padding(.bottom, 8)
                                    } else if phase.error != nil {
                                        Color.gray.frame(height: 80)
                                    } else {
                                        ProgressView().frame(height: 80)
                                    }
                                }

                                Text(store.name)
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
                Spacer()
            }
            .navigationDestination(isPresented: Binding(
                get: { storeModel.selectedStore != nil },
                set: { if !$0 { storeModel.selectedStore = nil } }
            )) {
                HomeView()
            }
        }
    }
}
