import SwiftUI
import AVFoundation
import Vision

struct ScannerView: View {
    @State private var selectedProduct: Product? = nil
    @State private var isLoading = false
    @State private var zoomFactor: CGFloat = 1.0
    @EnvironmentObject var cart: CartModel
    @State private var showBasketAnimation = false
    @State private var animateShake = false
    @State private var isShowingCart = false


    var body: some View {
        
        ZStack {
            if showBasketAnimation {
                Image(systemName: "basket.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.green)
                    .scaleEffect(showBasketAnimation ? 1.2 : 0.1)
                    .rotationEffect(.degrees(animateShake ? -15 : 0))
                    .offset(y: -150)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.3), value: showBasketAnimation)
                    .animation(.default.repeatCount(3, autoreverses: true), value: animateShake)
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isShowingCart = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 60, height: 60)

                            Image(systemName: "basket")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                        }
                    }
                    .padding()
                }
            }

            CameraCaptureView(imageHandler: handleCapturedImage, zoomFactor: zoomFactor)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Color.black.opacity(0.6).frame(height: 200)
                Spacer()
                Color.black.opacity(0.6).frame(height: 200)
            }
            .edgesIgnoringSafeArea(.all)

            Rectangle()
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
                .foregroundColor(.white)
                .frame(width: 250, height: 100)

            VStack {
                Spacer()

                VStack(spacing: 20) {
                    HStack {
                        Text("−")
                            .foregroundColor(.white)
                            .frame(width: 30)
                        Slider(value: $zoomFactor, in: 1.0...5.0, step: 0.1)
                        Text("+")
                            .foregroundColor(.white)
                            .frame(width: 30)
                    }
                    .padding([.horizontal, .bottom], 40)

                    Button("Capture Barcode") {
                        isLoading = true
                        NotificationCenter.default.post(name: .triggerPhotoCapture, object: nil)
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                }
                .padding(.bottom, 30)
            }

            if isLoading {
                ZStack {
                    Color.black.opacity(0.6).ignoresSafeArea()
                    ProgressView("Analyzing...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .foregroundColor(.white)
                        .font(.title2)
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                isShowingCart = true
                            }) {
                                ZStack {
                                    // Outer ZStack for the green circle & basket icon
                                    ZStack {
                                        Circle()
                                            .fill(Color.green)
                                            .frame(width: 60, height: 60)

                                        Image(systemName: "basket")
                                            .foregroundColor(.white)
                                            .font(.system(size: 24))
                                    }

                                    // Overlay the badge in top-right corner
                                    if cart.count > 0 {
                                        Text("\(cart.count)")
                                            .font(.caption2)
                                            .padding(6)
                                            .background(Color.red)
                                            .foregroundColor(.white)
                                            .clipShape(Circle())
                                            .offset(x: 20, y: -20) // Fine-tune position
                                    }
                                }
                            }
                            .padding()

                        }
                    }

                    .padding()
                }
            }
        }
        .navigationTitle("Scan Item")
        .sheet(item: $selectedProduct) { product in
            ProductDetailView(product: product)
        }
        .navigationDestination(isPresented: $isShowingCart) {
            CartView()
        }

    }
    
    

    func handleCapturedImage(_ image: UIImage) {
        print("🔍 Running Vision on image")

        DispatchQueue.global(qos: .userInitiated).async {
            guard let resized = image.resize(to: CGSize(width: 640, height: 480)),
                  let cgImage = resized.cgImage else {
                DispatchQueue.main.async { isLoading = false }
                return
            }

            let request = VNDetectBarcodesRequest { request, error in
                guard let results = request.results as? [VNBarcodeObservation],
                      let first = results.first,
                      let payload = first.payloadStringValue else {
                    print("❌ No barcode detected")
                    DispatchQueue.main.async { isLoading = false }
                    return
                }

                print("✅ Detected barcode: \(payload)")
                DispatchQueue.main.async {
                    fetchProductInfo(for: payload) { fetchedProduct in
                        isLoading = false
                        if let fetchedProduct = fetchedProduct {
                            self.selectedProduct = fetchedProduct
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                showBasketAnimation = true
                                animateShake = true
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                withAnimation {
                                    showBasketAnimation = false
                                    animateShake = false
                                }
                            }

                        }
                    }
                }
            }

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }
    }
}


extension Notification.Name {
    static let triggerPhotoCapture = Notification.Name("triggerPhotoCapture")
}

extension UIImage {
    func resize(to targetSize: CGSize) -> UIImage? {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        return UIGraphicsImageRenderer(size: targetSize, format: format).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

