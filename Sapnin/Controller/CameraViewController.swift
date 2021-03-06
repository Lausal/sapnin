//
//  CameraViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 11/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import AVFoundation
import UIKit

class CameraViewController: UIViewController {
    
    @IBOutlet weak var hint: UIStackView!
    @IBOutlet weak var flashIcon: UIButton!
    @IBOutlet weak var challengeHintIcon: UIImageView!
    @IBOutlet weak var hintText: UILabel!
    @IBOutlet weak var challengeIconButton: UIButton!
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var image: UIImage?
    
    var challengeSelected: String? = nil
    var challengeDidChange = false
    
    // Camera zoom factors
    let minimumZoom: CGFloat = 1.0
    let maximumZoom: CGFloat = 5.0
    var lastZoomFactor: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up the camera
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        startRunningCaptureSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fadeOutHint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Show and change hint on load if user selects a different challenge
        if challengeDidChange == true {
            hint.alpha = 1
            setChallenge()
        }
        
        // Hide navigation bar
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backButton_TouchUpInside(_ sender: Any) {
        // Show camera via transition from right to left
        let cameraStoryBoard : UIStoryboard = UIStoryboard(name: "Channel", bundle:nil)
        let cameraViewController = cameraStoryBoard.instantiateViewController(withIdentifier: "NavChannelViewController") as UIViewController
        
        let transition = CATransition.init()
        transition.duration = 0
        transition.type = CATransitionType.push //Transition you want like Push, Reveal
        transition.subtype = CATransitionSubtype.fromRight // Direction like Left to Right, Right to Left
        transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.default)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(cameraViewController, animated: false, completion: nil)
    }
    
    func setChallengeType(hasSetChallenge: Bool, challengeButtonTitle: String, hintText: String, challengeHintIcon: UIImage) {
        
        if hasSetChallenge == true {
            // Remove default challenger icon
            challengeIconButton.setImage(nil, for: .normal)
        } else {
            // Use default challenger icon
        }
        
        challengeIconButton.setTitle(challengeButtonTitle, for: .normal)
        self.hintText.text = hintText
        self.challengeHintIcon.image = challengeHintIcon
    }
    
    // Change hint and challenge icon
    func setChallenge() {
        switch challengeSelected {
        case "Copy this"?:
            if let icon = UIImage(named: "copy_icon.png") {
                self.setChallengeType(hasSetChallenge: true, challengeButtonTitle: "🐱", hintText: "Copy this", challengeHintIcon: icon)
            }
        case "Do this dance"?:
            if let icon = UIImage(named: "dance_icon.png") {
                self.setChallengeType(hasSetChallenge: true, challengeButtonTitle: "💃", hintText: "Do this dance", challengeHintIcon: icon)
            }
        case "Sing"?:
            if let icon = UIImage(named: "sing_icon.png") {
                self.setChallengeType(hasSetChallenge: true, challengeButtonTitle: "🎤", hintText: "Sing", challengeHintIcon: icon)
            }
        case "Drink up"?:
            if let icon = UIImage(named: "drink_icon.png") {
                self.setChallengeType(hasSetChallenge: true, challengeButtonTitle: "🍻", hintText: "Drink up", challengeHintIcon: icon)
            }
        case "Draw this"?:
            if let icon = UIImage(named: "sketch_icon.png") {
                self.setChallengeType(hasSetChallenge: true, challengeButtonTitle: "🎨", hintText: "Draw this", challengeHintIcon: icon)
            }
        case "Do this act"?:
            if let icon = UIImage(named: "act_icon.png") {
                self.setChallengeType(hasSetChallenge: true, challengeButtonTitle: "🎭", hintText: "Do this act", challengeHintIcon: icon)
            }
        default:
            return
        }
    }
    
    func setupCaptureSession() {
        // Specify image quality and resolution. Setting to photo will be highest quality.
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    @IBAction func handleCameraZoom(_ sender: UIPinchGestureRecognizer) {
        
        guard let device = currentCamera else { return }
        
        // Return zoom value between the minimum and maximum zoom values
        func minMaxZoom(_ factor: CGFloat) -> CGFloat {
            return min(min(max(factor, minimumZoom), maximumZoom), device.activeFormat.videoMaxZoomFactor)
        }
        
        func update(scale factor: CGFloat) {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.videoZoomFactor = factor
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        
        let newScaleFactor = minMaxZoom(sender.scale * lastZoomFactor)
        
        switch sender.state {
        case .began: fallthrough
        case .changed: update(scale: newScaleFactor)
        case .ended:
            lastZoomFactor = minMaxZoom(newScaleFactor)
            update(scale: lastZoomFactor)
        default: break
        }
    }
    
    @IBAction func photoLibraryButton_TouchUpInside(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func flashButton_TouchUpInside(_ sender: Any) {
        guard let device = currentCamera else { return }
        
        if (device.hasTorch) {
            do {
                // Required lockForConfiguration to alter phone hardware settings
                try device.lockForConfiguration()
                // If torch is on, then turn it off on press, otherwise turn it on
                if (device.torchMode == .on) {
                    device.torchMode = .off
                    flashIcon.setImage(UIImage(named: "flash_off_icon"), for: UIControl.State.normal)
                } else {
                    device.torchMode = .on
                    flashIcon.setImage(UIImage(named: "flash_on_icon"), for: UIControl.State.normal)
                }
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        } else {
            print("Torch is not available")
        }
    }
    
    func setupDevice() {
        
        // Set up device specification
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        
        currentCamera = backCamera
    }
    
    // Input is the image coming in, whilst output is the image after taking a picture/video
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCaptureSession() {
        // Run the camera session in background threat whilst preview layer is created in main thread
        DispatchQueue.global().async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.setupPreviewLayer()
            }
        }
    }
    
    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func toggleCameraButton_TouchUpInside(_ sender: Any) {
        toggleCamera()
    }
    
    @objc func toggleCamera() {
        captureSession.beginConfiguration()
        
        // Change the device based on the current camera
        let newDevice = (currentCamera?.position == AVCaptureDevice.Position.back) ? frontCamera : backCamera
        
        // Remove all inputs from the session
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        
        // Change to the new input
        let cameraInput:AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice!)
        } catch {
            print(error)
            return
        }
        
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }
        
        currentCamera = newDevice
        captureSession.commitConfiguration()
    }
    
    func fadeOutHint() {
        hint.fadeOut(duration: 2, delay: 0) { (bool) in
            // Do something after fade out
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "previewVC" {
            let nav = segue.destination as! UINavigationController
            let previewVC = nav.topViewController as! PreviewViewController
            previewVC.selectedImage = self.image!
        }
    }
    
}

// Handle picture taking
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    // Get information about the captured image after user taps on capture photo
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            // Create image from imageData response, and pass this to the PreviewViewController via the prepare function
            image = UIImage(data: imageData)
            performSegue(withIdentifier: "previewVC", sender: nil)
        }
    }
}

// Handle image picker
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Extract image from photo selection, this is taken from 'info' dictionary response once user selects a picture from photo library then segue to previewVC
        if let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage? {
            self.image = selectedImage
            dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "previewVC", sender: nil)
            })
            
        }
        
    }
}
