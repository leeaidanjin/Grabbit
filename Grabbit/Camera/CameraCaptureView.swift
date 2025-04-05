// MARK: - Camera/CameraCaptureView.swift
import SwiftUI
import AVFoundation

struct CameraCaptureView: UIViewControllerRepresentable {
    let imageHandler: (UIImage) -> Void
    let zoomFactor: CGFloat

    func makeUIViewController(context: Context) -> CameraCaptureController {
        let controller = CameraCaptureController()
        controller.imageHandler = imageHandler
        controller.zoomFactor = zoomFactor
        return controller
    }

    func updateUIViewController(_ uiViewController: CameraCaptureController, context: Context) {
        uiViewController.zoomFactor = zoomFactor
        uiViewController.updateZoom()
    }
}

class CameraCaptureController: UIViewController, AVCapturePhotoCaptureDelegate {
    var session = AVCaptureSession()
    var photoOutput = AVCapturePhotoOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var imageHandler: ((UIImage) -> Void)?
    var zoomFactor: CGFloat = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSession()
        NotificationCenter.default.addObserver(self, selector: #selector(takePhoto), name: .triggerPhotoCapture, object: nil)
    }

    func configureSession() {
        session.beginConfiguration()
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else { return }

        session.sessionPreset = .photo
        if session.canAddInput(input) { session.addInput(input) }
        if session.canAddOutput(photoOutput) { session.addOutput(photoOutput) }

        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)

        session.commitConfiguration()
        session.startRunning()
        updateZoom()
    }

    func updateZoom() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        do {
            try device.lockForConfiguration()
            device.videoZoomFactor = max(1.0, min(zoomFactor, device.activeFormat.videoMaxZoomFactor))
            device.unlockForConfiguration()
        } catch {
            print("⚠️ Could not set zoom: \(error)")
        }
    }

    @objc func takePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }
        imageHandler?(image)
    }
}
