import SwiftUI
import AVFoundation
import Vision

struct ScannerView: View {
    @State private var selectedProduct: Product? = nil
    @State private var isLoading = false
    @State private var zoomFactor: CGFloat = 1.0

    var body: some View {
        
        ZStack {
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
        }
        .navigationTitle("Scan Item")
        .sheet(item: $selectedProduct) { product in
            ProductDetailView(product: product)
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
