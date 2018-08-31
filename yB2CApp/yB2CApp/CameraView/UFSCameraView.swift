//
//  UFSCameraView.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 13/07/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable open class UFSCameraView: UIView {

  /// UFSCameraView Zoom Gesture Enabled
  @IBInspectable open var zoomEnabled: Bool = true {
    didSet {
      setPinchGesture()
    }
  }
  
  /// UFSCameraView Focus Gesture Enabled
  @IBInspectable open var focusEnabled: Bool = true {
    didSet {
      setFocusGesture()
    }
  }
  
  /// UFSCameraViewGlobal object for one time initialization in UFSCameraView
  lazy var global: UFSCameraViewGlobal = {
    return UFSCameraViewGlobal()
  }()
  
  /// Gesture for zoom in/out in UFSCameraView
  lazy var pinchGesture: UIPinchGestureRecognizer = {
    return UIPinchGestureRecognizer(target: self,
                                    action: #selector(UFSCameraView.pinchToZoom(_:)))
  }()
  
  /// Gesture to focus in UFSCameraView
  lazy var focusGesture: UITapGestureRecognizer = {
    let instance = UITapGestureRecognizer(target: self,
                                          action: #selector(UFSCameraView.tapToFocus(_:)))
    instance.cancelsTouchesInView = false
    return instance
  }()
  
  
  /// Callback closure for getting the UFSCameraView response
  open var response: ((_ response: Any?) -> ())?
  
  /// Preview layrer for UFSCameraView
  var previewLayer: AVCaptureVideoPreviewLayer?
  
  /// Zoom factor for UFSCameraView
  var zoomFactor: CGFloat = 1
  
  /// Capture Session for UFSCameraView
  var session: AVCaptureSession! {
    didSet {
      setSession()
    }
  }
  
  /// Current output for capture session
  var output: AVCaptureOutput = AVCaptureStillImageOutput() {
    didSet {
      session.removeOutput(oldValue)
      session.setOutput(output)
    }
  }
  
  /// Video Output
  var outputVideo: AVCaptureMovieFileOutput? {
    return self.output as? AVCaptureMovieFileOutput
  }
  
  /// Image Output
  var outputImage: AVCaptureStillImageOutput? {
    return self.output as? AVCaptureStillImageOutput
  }
  
  /// Getter for current camera device
  var currentDevice: AVCaptureDevice? {
    switch cameraPosition {
    case .back:
      return global.cameraBack
    case .front:
      return global.cameraFront
    default:
      return nil
    }
  }
  
  /// Current output mode for UFSCameraView
  open var outputMode: OUTPUT_MODE = .image {
    didSet {
      guard outputMode != oldValue else {
        return
      }
      
      if oldValue == .videoAudio {
        session.removeMicInput(global.deviceAudio)
      }
      
      setOutputMode()
    }
  }
  
  /// Current camera position for UFSCameraView
  open var cameraPosition: AVCaptureDevicePosition = .back {
    didSet {
      guard cameraPosition != oldValue else {
        return
      }
      setDevice()
    }
  }
  
  /// Current flash mode for UFSCameraView
  open var flashMode: AVCaptureFlashMode = .auto {
    didSet {
      guard flashMode != oldValue else {
        return
      }
      setFlash()
    }
  }
  
  /// Current camera quality for UFSCameraView
  open var quality: OUTPUT_QUALITY = .high {
    didSet {
      guard quality != oldValue else {
        return
      }
      session.setQuality(quality, mode: outputMode)
    }
  }
  
  /// UFSCameraView - Interface Builder View
  open override func prepareForInterfaceBuilder() {
    /*
    let label = UILabel(frame: self.bounds)
    label.text = "UFSCameraView"
    label.textColor = UIColor.white.withAlphaComponent(0.7)
    label.textAlignment = .center
    label.font = UIFont(name: "Gill Sans", size: bounds.width/10)
    label.sizeThatFits(intrinsicContentSize)
    self.addSubview(label)
    self.backgroundColor = UIColor(rgb: 0x2891B1)
 */
    
  }
  
  /// Capture session starts/resumes for UFSCameraView
  open func startSession() {
    if let session = self.session {
      if !session.isRunning {
        session.startRunning()
      }
    } else {
      setSession()
    }
  }
  
  /// Capture session stops for UFSCameraView
  open func stopSession() {
    if let session = self.session {
      if session.isRunning {
        session.stopRunning()
      }
    }
  }
  
  /// Start Video Recording for UFSCameraView
  open func startVideoRecording() {
    guard
      let output = outputVideo,
      !output.isRecording
      else { return }
    
    output.startRecording(toOutputFileURL: global.tempMoviePath, recordingDelegate: self)
  }
  
  /// Stop Video Recording for UFSCameraView
  open func stopVideoRecording() {
    guard
      let output = outputVideo,
      output.isRecording
      else { return }
    
    output.stopRecording()
    
  }
  
  /// Capture image for UFSCameraView
  open func captureImage() {
    guard let output = outputImage else { return }
    
    global.queue.async(execute: {
      let connection = output.connection(withMediaType: AVMediaTypeVideo)
      output.captureStillImageAsynchronously(from: connection, completionHandler: { [unowned self] response, error in
        
        guard
          error == nil,
          
          let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(response),
          
          let image = UIImage(data: data)
          
          else {
            self.response?(error)
            return
        }
        
        self.response?(image)
        
      })
    })
  }
}


// MARK: - UIGestureRecognizer Selectors
extension UFSCameraView {
  
  /// Zoom in/out selector if allowd
  ///
  /// - Parameter gesture: UIPinchGestureRecognizer
  func pinchToZoom(_ gesture: UIPinchGestureRecognizer) {
    guard let device = currentDevice else {
      return
    }
    zoomFactor = device.setZoom(zoomFactor, gesture: gesture)
  }
  
  /// Focus selector if allowd
  ///
  /// - Parameter gesture: UITapGestureRecognizer
  func tapToFocus(_ gesture: UITapGestureRecognizer) {
    guard
      let previewLayer = previewLayer,
      let device = currentDevice
      else {
        return
    }
    device.setFocus(self, previewLayer: previewLayer, gesture: gesture)
  }
}

// MARK: - AVCaptureFileOutputRecordingDelegate
extension UFSCameraView: AVCaptureFileOutputRecordingDelegate {
  
  /// Recording did start
  ///
  /// - Parameters:
  ///   - captureOutput: AVCaptureFileOutput
  ///   - fileURL: URL
  ///   - connections: [Any]
  open func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
    session.beginConfiguration()
    if flashMode != .off {
      setFlash()
    }
    session.commitConfiguration()
  }
  
  /// Recording did end
  ///
  /// - Parameters:
  ///   - captureOutput: AVCaptureFileOutput
  ///   - outputFileURL: URL
  ///   - connections: [Any]
  ///   - error: Error
  open func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
    self.flashMode = .off
    let response: Any = error == nil ? outputFileURL : error
    self.response?(response)
  }
}

// MARK: - Setters for UFSCameraView
extension UFSCameraView {
  
  /// Set capture session for UFSCameraView
  func setSession() {
    
    guard let session = self.session else {
      if self.global.status == .authorized || self.global.status == .notDetermined {
        self.session = AVCaptureSession()
      }
      return
    }
    
    global.queue.async(execute: {
      session.beginConfiguration()
      session.sessionPreset = AVCaptureSessionPresetHigh
      
      self.setDevice()
      self.setOutputMode()
      self.previewLayer = session.setPreviewLayer(self)
      session.commitConfiguration()
      
      self.setFlash()
      self.setPinchGesture()
      self.setFocusGesture()
      
      session.startRunning()
      
    })
  }
  
  /// Set Output mode for UFSCameraView
  func setOutputMode() {
    
    session.beginConfiguration()
    
    if outputMode == .image {
      output = AVCaptureStillImageOutput()
    }
    else {
      if outputMode == .videoAudio {
        session.addMicInput(global.deviceAudio)
      }
      output = AVCaptureMovieFileOutput()
      outputVideo!.movieFragmentInterval = kCMTimeInvalid
    }
    
    session.commitConfiguration()
    session.setQuality(quality, mode: outputMode)
  }
  
  /// Set camera device for UFSCameraView
  func setDevice() {
    session.setCameraDevice(self.cameraPosition, cameraBack: global.cameraBack, cameraFront: global.cameraFront)
  }
  
  /// Set Flash mode for UFSCameraView
  func setFlash() {
    session.setFlashMode(global.devicesVideo, flashMode: flashMode)
  }
  
  /// Set Zoom in/out gesture for UFSCameraView
  func setPinchGesture() {
    toggleGestureRecognizer(zoomEnabled, gesture: pinchGesture)
  }
  
  /// Set Focus gesture for UFSCameraView
  func setFocusGesture() {
    toggleGestureRecognizer(focusEnabled, gesture: focusGesture)
  }
  
  
}
