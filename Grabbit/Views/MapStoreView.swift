import SwiftUI
import MapKit
import CoreLocation

struct StoreLocation: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D

    func distance(from location: CLLocationCoordinate2D) -> CLLocationDistance {
        let storeLoc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let userLoc = CLLocation(latitude: location.latitude, longitude: location.longitude)
        return storeLoc.distance(from: userLoc)
    }

    static func == (lhs: StoreLocation, rhs: StoreLocation) -> Bool {
        lhs.id == rhs.id
    }
}

struct MapStoreView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var storeModel: StoreModel
    @EnvironmentObject var cart: CartModel
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var locationManager = LocationManager()


    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 32.8793, longitude: -117.2372),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    @State private var selectedStore: StoreLocation? = nil
    @State private var searchText = ""
    @FocusState private var isSearching: Bool
    @State private var hasCenteredOnUser = false

    let grabbitStores = [
        StoreLocation(name: "Target", coordinate: CLLocationCoordinate2D(latitude: 32.8793, longitude: -117.2372)),
        StoreLocation(name: "Trader Joe's", coordinate: CLLocationCoordinate2D(latitude: 32.8670, longitude: -117.2321)),
        StoreLocation(name: "CVS", coordinate: CLLocationCoordinate2D(latitude: 32.8694, longitude: -117.2306))
    ]

    var sortedStores: [StoreLocation] {
        guard let userLoc = locationManager.userLocation else { return grabbitStores }
        return grabbitStores
            .sorted { $0.distance(from: userLoc) < $1.distance(from: userLoc) }
            .filter { searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased()) }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ZStack(alignment: .topTrailing) {
                    Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: grabbitStores) { store in
                        MapAnnotation(coordinate: store.coordinate) {
                            VStack {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.red)
                                Text(store.name)
                                    .font(.caption)
                            }
                            .onTapGesture {
                                handleStoreTap(store)
                            }
                        }
                    }
                    .ignoresSafeArea()
                    .mapStyle(.standard(pointsOfInterest: []))
                    .onReceive(locationManager.$userLocation) { location in
                        if let location = location, !hasCenteredOnUser {
                            region.center = location
                            hasCenteredOnUser = true
                        }
                    }

                    Button(action: {
                        if let location = locationManager.userLocation {
                            region.center = location
                        }
                    }) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                            .padding()
                    }
                }

                VStack(spacing: 10) {
                    HStack {
                        TextField("Search Stores", text: $searchText)
                            .padding(10)
                            .background(colorScheme == .dark ? Color(red: 0.23, green: 0.23, blue: 0.25) : Color(.systemGray6))
                            .cornerRadius(10)
                            .focused($isSearching)

                        if isSearching {
                            Button(action: {
                                searchText = ""
                                isSearching = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.title3)
                            }
                        }
                    }
                    .padding(.horizontal)

                    if !isSearching {
                        HStack {
                            Text("Nearby")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.top, 5)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }

                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(sortedStores) { store in
                                Button(action: {
                                    handleStoreTap(store)
                                }) {
                                    VStack(alignment: .leading) {
                                        Text(store.name)
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                            .font(.headline)

                                        if let userLoc = locationManager.userLocation {
                                            let distance = store.distance(from: userLoc) / 1609.34
                                            Text(String(format: "%.1f miles away", distance))
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                Divider().background(Color.gray)
                            }
                        }
                        .background(colorScheme == .dark ? Color(red: 0.23, green: 0.23, blue: 0.25) : Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 10)
                }
                .padding(.top)
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height / 3)
                .background(colorScheme == .dark ? Color(red: 0.13, green: 0.13, blue: 0.15) : Color(.systemBackground))
                .cornerRadius(20)
            }
        }
    }

    private func handleStoreTap(_ store: StoreLocation) {
        storeModel.selectedStore = store.name
        cart.currentStore = store.name
        switch store.name {
        case "CVS":
            viewRouter.currentScreen = .cvs
        case "Trader Joe's":
            viewRouter.currentScreen = .traderJoes
        case "Target":
            viewRouter.currentScreen = .target
        default:
            viewRouter.currentScreen = .home(id: UUID())
        }
    }
}

