import SwiftUI
import MapKit
import CoreLocation

struct StoreLocation: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D

    static func == (lhs: StoreLocation, rhs: StoreLocation) -> Bool {
        lhs.id == rhs.id
    }
}

struct MapStoreView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var storeModel: StoreModel
    @StateObject private var locationManager = LocationManager()

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 32.87931538763469, longitude: -117.23726645218227),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    @State private var selectedStore: StoreLocation? = nil
    @State private var showHome = false
    @State private var searchText = ""
    @FocusState private var isSearching: Bool
    @State private var hasCenteredOnUser = false

    let grabbitStores = [
        StoreLocation(name: "Target", coordinate: CLLocationCoordinate2D(latitude: 32.87931538763469, longitude: -117.23726645218227)),
        StoreLocation(name: "Target", coordinate: CLLocationCoordinate2D(latitude: 32.87931538763469, longitude: -117.23726645218227)),
        StoreLocation(name: "Target", coordinate: CLLocationCoordinate2D(latitude: 32.87931538763469, longitude: -117.23726645218227))
    ]

    var filteredStores: [StoreLocation] {
        if searchText.isEmpty { return grabbitStores }
        return grabbitStores.filter { $0.name.lowercased().contains(searchText.lowercased()) }
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
                                selectedStore = store
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

                    // 🧭 Recenter button
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
                    // Search bar
                    HStack {
                        TextField("Search Stores", text: $searchText)
                            .padding(10)
                            .background(Color(red: 0.23, green: 0.23, blue: 0.25))
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

                    // Nearby label
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

                    // Store list
                    ScrollView {
                        VStack(spacing: 0) {
                            VStack(spacing: 0) {
                                ForEach(filteredStores) { store in
                                    Button(action: {
                                        selectedStore = store
                                    }) {
                                        VStack(alignment: .leading) {
                                            Text(store.name)
                                                .foregroundColor(.white)
                                                .font(.headline)
                                                .padding()
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    Divider().background(Color.gray)
                                }
                            }
                            .background(Color(red: 0.23, green: 0.23, blue: 0.25))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 10)
                }
                .padding(.top)
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height / 3)
                .background(Color(red: 0.13, green: 0.13, blue: 0.15))
                .cornerRadius(20)
                .padding(.bottom, 0)
            }
            .onChange(of: selectedStore) { newStore in
                if let store = newStore {
                    storeModel.selectedStore = store.name
                    DispatchQueue.main.async {
                        viewRouter.currentScreen = .home(id: UUID()) // ✅ switch with router
                        selectedStore = nil
                    }
                }
            }
            .navigationDestination(isPresented: $showHome) {
                HomeView()
            }
        }
    }
}

