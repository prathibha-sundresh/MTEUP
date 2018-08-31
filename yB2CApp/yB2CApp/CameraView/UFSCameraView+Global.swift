//
//  UFSCameraView+Global.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 13/07/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class UFSCameraViewGlobal {
  
  let queue = DispatchQueue(label: "AACameraViewSessionQueue", attributes: [])
  
  let devicesVideo = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]
  
  let deviceAudio = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
  
  lazy var cameraFront: AVCaptureDevice? = {
    return self.devicesVideo.filter{$0.position == .front}.first
  }()
  
  lazy var cameraBack: AVCaptureDevice? = {
    return self.devicesVideo.filter{$0.position == .back}.first
  }()
  
  
  let status: AVAuthorizationStatus = {
    guard
      UIImagePickerController.isCameraDeviceAvailable(.rear) ||
        UIImagePickerController.isCameraDeviceAvailable(.front)
      else {
        //fatalError("AACameraView - No camera device found")
        return AVAuthorizationStatus.notDetermined
        
    }
    
    return AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
  }()
  
  lazy var tempMoviePath: URL = {
    let tempPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("AACameraViewMovie").appendingPathExtension("mp4").absoluteString
    if FileManager.default.fileExists(atPath: tempPath) {
      do {
        try FileManager.default.removeItem(atPath: tempPath)
      } catch {
        print("AACameraView - Error saving file")
      }
    }
    return URL(string: tempPath)!
  }()
  
  
}

public enum OUTPUT_MODE {
  case image, videoAudio, video
}

public enum OUTPUT_QUALITY {
  case low, medium, high
}
