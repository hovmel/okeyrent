//
//  CameraViewController.swift
//  Abonent
//
//  Created by Mikhail Koroteev on 21.12.2020.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    class func openCameraViewController(viewController: UIViewController, type: DocumentViewType, viewModel: ProfileViewModel) {
        let storyboard = UIStoryboard(name: "Documents", bundle: nil)
        var controllers: [UIViewController] = viewController.navigationController?.viewControllers ?? [viewController]
        let photoController = storyboard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        photoController.viewModel = viewModel
        photoController.type = type
        controllers.append(photoController)
        viewController.navigationController?.setViewControllers(controllers, animated: true)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var centerView: UIView!
    
    var viewModel: ProfileViewModel!
    var type: DocumentViewType = .passport
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var resultsPreviewView: UIView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var rescanView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var recaptureButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var capturedImagePreview: UIImageView!
    var captureSession = AVCaptureSession()
    var capturePhotoOutput: AVCapturePhotoOutput?
    private var captureDevice: AVCaptureDevice!

    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private let SessionPreset = AVCaptureSession.Preset.hd1280x720
    
    @IBAction func captureAction(_ sender: UIButton) {
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        //photoSettings.flashMode = .auto
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = Colors.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = Colors.mainBlack
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.centerView.layer.cornerRadius = 20
        self.centerView.layer.borderWidth = 4
        self.centerView.layer.borderColor = UIColor.white.cgColor
        
        self.commonSetup()
        
        self.navigationController?.navigationBar.tintColor = Colors.white
        
        self.titleLabel.text = self.type.cameraTitle
        self.descrLabel.text = self.type.cameraDescr
        
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput?.isHighResolutionCaptureEnabled = true
        captureSession.addOutput(capturePhotoOutput!)
        
        switch self.type {
        case .selfie:
            captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
        case .passport:
            captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        }
        
        if captureDevice != nil {
            try! captureDevice.lockForConfiguration()
            //captureDevice.focusMode = .continuousAutoFocus
            captureDevice.unlockForConfiguration()
            
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.sessionPreset = SessionPreset
                captureSession.addInput(input)
                
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                
            } catch {
                print(error)
                return
            }
        } else {
            print("Can't access device for capture video")
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.insertSublayer(videoPreviewLayer!, at: 0)
        
        self.captureButton.layer.cornerRadius = self.captureButton.frame.size.height/2
//        self.captureButton.backgroundColor = Config.Colors.color
//        self.captureButton.setImage(UIImage(named: "capture", in: Config.System.bundle, compatibleWith: nil)!, for: .normal)
        
        updatePreviewLayerFrame()
        captureSession.startRunning()
        
//        self.button?.setImage(UIImage(named: "support", in: Config.System.bundle, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate), for: .normal)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button!)
    }

    private func updatePreviewLayerFrame()
    {
        let orientation = UIApplication.shared.statusBarOrientation
        if let previewLayer = self.videoPreviewLayer, let connection = previewLayer.connection {
            connection.videoOrientation = self.videoOrientation(orientation)
            let viewBounds = self.view.frame
            self.videoPreviewLayer?.frame = viewBounds
        }
    }
    
    private func videoOrientation(_ orientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation
    {
        switch orientation {
        case UIInterfaceOrientation.portrait:
            return AVCaptureVideoOrientation.portrait
        case UIInterfaceOrientation.portraitUpsideDown:
            return AVCaptureVideoOrientation.portraitUpsideDown
        case UIInterfaceOrientation.landscapeLeft:
            return AVCaptureVideoOrientation.landscapeLeft
        case UIInterfaceOrientation.landscapeRight:
            return AVCaptureVideoOrientation.landscapeRight
        default:
            return AVCaptureVideoOrientation.portrait
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first! as UITouch
        let screenSize = previewView.bounds.size
        let focusPoint = CGPoint(x: touchPoint.location(in: previewView).y / screenSize.height, y: 1.0 - touchPoint.location(in: previewView).x / screenSize.width)
        
        if let device = captureDevice  {
            do {
                try device.lockForConfiguration()
                if device.isFocusPointOfInterestSupported {
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = AVCaptureDevice.FocusMode.autoFocus
                }
                if device.isExposurePointOfInterestSupported {
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
                }
                device.unlockForConfiguration()
                
            } catch {
                // Handle errors here
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func useCurrentPhoto(_ sender: Any) {
        if let image = capturedImagePreview.image {
            switch self.type {
            case .selfie:
                self.viewModel.selfiePhoto = image
            case .passport:
                self.viewModel.passportPhoto = image
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func retakePhoto(_ sender: Any) {
        captureSession.startRunning()
        self.capturedImagePreview.image = nil
        self.captureButton.alpha = 1
        self.rescanView.alpha = 0
        self.titleLabel.text = self.type.cameraTitle
        self.descrLabel.text = self.type.cameraDescr
//        self.resultsPreviewView.isHidden = true
    }

}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {

        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        // Convert photo same buffer to a jpeg image data by using // AVCapturePhotoOutput
        guard let imageData =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
                return
        }
        
        let capturedImage = UIImage(data: imageData)
        if let image = capturedImage?.fixedOrientation() {
            
//            if let croppedImage = image.crop(bounds: scaledCropArea) {
                captureSession.stopRunning()
                self.capturedImagePreview.image = image
                self.captureButton.alpha = 0
            self.rescanView.alpha = 1
            self.titleLabel.text = self.type.photoTitle
            self.descrLabel.text = self.type.photoDescr
//                self.resultsPreviewView.isHidden = false
//            } else {
//                self.delegate?.didCaptureImageFailure(controller: self)
//            }
        } else {
//            self.delegate?.didCaptureImageFailure(controller: self)
        }
    }
}

extension UIImage {
    func crop(bounds: CGRect) -> UIImage? {
        return UIImage(cgImage: (self.cgImage?.cropping(to: bounds)!)!,
                       scale: 0.0, orientation: self.imageOrientation)
    }
}
