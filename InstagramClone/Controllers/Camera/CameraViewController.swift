//
//  CameraViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/14/21.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
  private let dismissButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "right_arrow_shadow"), for: .normal)
    button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    return button
  }()
  
  private let capturePhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "capture_photo"), for: .normal)
    button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCaptureSession()
    
    setupHUD()
  }
  
  // MARK: - Action Methods
  @objc private func handleDismiss() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func handleCapturePhoto() {
    print("Capturing photo...")
  }
  
  // MARK: - Helper Methods
  private func setupHUD() {
    view.addSubview(capturePhotoButton)
    capturePhotoButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, centerX: view.centerXAnchor, centerY: nil, padding: .init(top: 0, left: 0, bottom: 50, right: 0), size: .init(width: 80, height: 80))
    
    view.addSubview(dismissButton)
    dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 24, left: 0, bottom: 0, right: 12), size: .init(width: 50, height: 50))
  }
  
  private func setupCaptureSession() {
    let captureSession = AVCaptureSession()
    
    // 1. Setup Inputs
    guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
    
    do {
      let input = try AVCaptureDeviceInput(device: captureDevice)
      if captureSession.canAddInput(input) {
        captureSession.addInput(input)
      }
    } catch let error {
      print("Could not set up camera input: ", error)
    }

    // 2. Setup Outputs
    let output = AVCapturePhotoOutput()
    if captureSession.canAddOutput(output) {
      captureSession.addOutput(output)
    }
    // 3. Setup Outputs preview
    let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer.frame = view.frame
    view.layer.addSublayer(previewLayer)
    
    captureSession.startRunning()
  }
  
  
}
