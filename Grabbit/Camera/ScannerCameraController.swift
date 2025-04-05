import UIKit
import AVFoundation

class ScannerCameraController: UIViewController {
    var captureSession: AVCaptureSession!
    var delegate: AVCaptureMetadataOutputObjectsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              captureSession.canAddInput(videoInput) else { return }
        
        if videoCaptureDevice.isFocusModeSupported(.continuousAutoFocus) {
            try? videoCaptureDevice.lockForConfiguration()
            videoCaptureDevice.focusMode = .continuousAutoFocus
            videoCaptureDevice.unlockForConfiguration()
        }


        captureSession.addInput(videoInput)

        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean13, .upce, .code128]
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        let scanRect = CGRect(x: 0.5 - 0.25, y: 0.5 - 0.1, width: 0.5, height: 0.2)
        metadataOutput.rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect:
            CGRect(x: view.bounds.midX - 125, y: view.bounds.midY - 50, width: 250, height: 100)
        )

        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }
}
