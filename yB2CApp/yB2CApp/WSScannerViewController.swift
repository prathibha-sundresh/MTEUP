//
//  WSScannerViewController.swift
//  UFSDev
//
//  Created by Guddu Gaurav on 15/01/2018.
//

import UIKit
import AVFoundation

protocol BarcodeDelegate {
  func barcodeReaded(barcode: String)
}

class WSScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  
  var delegate: BarcodeDelegate?
  
  var videoCaptureDevice: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
  var device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
  var output = AVCaptureMetadataOutput()
  var previewLayer: AVCaptureVideoPreviewLayer?
  
  var captureSession = AVCaptureSession()
  var code: String?
  
  @IBOutlet weak var UFSTextLable: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    UFSTextLable.text = WSUtility.getlocalizedString(key: "Scan UFS product barcode", lang: WSUtility.getLanguage(), table: "Localizable")
    checkPermissions()
    WSUtility.addNavigationBarBackButton(controller: self)
    WSUtility.addNavigationRightBarButton(toViewController: self)
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.trackingScreens(screenName: "Scan")
    
  }
  
    func checkPermissions() {
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        switch authStatus {
        case .authorized:
            setupCamera()
        case .denied:
            alertPromptToAllowCameraAccessViaSetting()
        default:
            // Not determined fill fall here - after first use, when is't neither authorized, nor denied
            // we try to use camera, because system will ask itself for camera permissions
            setupCamera()
        }
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        
        let errorMessage = WSUtility.getlocalizedString(key: "Please give the permission to use Camera/Gallery for this app feature.", lang: WSUtility.getLanguage())
        let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: WSUtility.getlocalizedString(key: "Open Settings", lang: WSUtility.getLanguage()), style: .default, handler: { (_) in
            DispatchQueue.main.async {
                if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(settingsURL)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: WSUtility.getlocalizedString(key: "NotNow", lang: WSUtility.getLanguage()), style: .cancel, handler: { (_)in
            self.navigationController?.popViewController(animated: true)

        }))
        self.present(alert, animated: true, completion: nil)
    }
  
  func btnTaxTapped(sender:UIButton)  {
    let storyBoard: UIStoryboard = UIStoryboard(name: "EnterTaxNumberStoryboard", bundle: nil)
    let vc:WSEnterTaxNumberViewController = storyBoard.instantiateViewController(withIdentifier: "WSEnterTaxNumberViewController") as! WSEnterTaxNumberViewController
    vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    vc.callBack = {
      if let view = self.view.viewWithTag(9006){
        view.removeFromSuperview()
      }
    
    }
    present(vc, animated: true, completion: nil)
    
  }
  
  private func setupCamera() {
    
    let input = try? AVCaptureDeviceInput(device: videoCaptureDevice)
    
    if self.captureSession.canAddInput(input) {
      self.captureSession.addInput(input)
    }
    
    self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    if let videoPreviewLayer = self.previewLayer {
      videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
      videoPreviewLayer.frame = self.view.bounds
      view.layer.addSublayer(videoPreviewLayer)
    }
    
  
    self.view.bringSubview(toFront: UFSTextLable)
    
    drawRectangle()
    
    let metadataOutput = AVCaptureMetadataOutput()
    if self.captureSession.canAddOutput(metadataOutput) {
      self.captureSession.addOutput(metadataOutput)
      
      metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      metadataOutput.metadataObjectTypes =  [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeDataMatrixCode,AVMetadataObjectTypeCode39Mod43Code]
    } else {
      print("Could not add metadata output")
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if (captureSession.isRunning == false) {
      captureSession.startRunning();
    }
    
     WSUtility.setCartBadgeCount(ViewController: self)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    if !WSUtility.isTaxNumberAvailable(VCview: self.view){
      WSUtility.addTaxNumberView(viewController: self)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if (captureSession.isRunning == true) {
      captureSession.stopRunning();
    }
  }
  
  @IBAction func backAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func rightBarButtonPressed(_ sender: UIButton)  {
    WSUtility.cartButtonPressed(viewController: self)
    
  }
  
  func drawRectangle() {

    let cgRect = CGRect(x: 40, y: 150, width: self.view.bounds.width - 80, height: self.view.bounds.width - 80)
    let myView = UIImageView()
    myView.frame = cgRect
    myView.backgroundColor = UIColor.clear
    myView.isOpaque = false
    myView.layer.cornerRadius = 10
    myView.layer.borderColor =  UIColor.white.cgColor
    myView.layer.borderWidth = 2
    myView.layer.masksToBounds = true
    previewLayer?.addSublayer(myView.layer)
    
    

    /*
     let k = UIView(frame: CGRect(x: 75, y: 75, width: 150, height: 150))
    k.draw(CGRect(
      origin: CGPoint(x: 50, y: 50),
      size: CGSize(width: 100, height: 100)))
    
    // Add the view to the view hierarchy so that it shows up on screen
    self.view.addSubview(k)
    
    
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    let img = renderer.image { ctx in
      ctx.cgContext.setFillColor(UIColor.red.cgColor)
      ctx.cgContext.setStrokeColor(UIColor.green.cgColor)
      ctx.cgContext.setLineWidth(10)
     
      let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
      ctx.cgContext.addRect(rectangle)
      ctx.cgContext.drawPath(using: .fillStroke)
    }
    */
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.destination is WSScanDetailViewController){
      let scanDetailVC = segue.destination as? WSScanDetailViewController
      scanDetailVC?.currentProduct = sender as! [String : Any]
    }
  }
  
  func getProductDetailFromScannedCode(productID:String)  {
    UFSProgressView.showWaitingDialog("")
    
    let businessLayer = WSWebServiceBusinessLayer()
    businessLayer.getScanProductDetail(productEanCode: productID, successResponse: { (response) in
      UFSProgressView.stopWaitingDialog()
      if (response["error"] != nil){
        
        let errorMessage = WSUtility.getTranslatedString(forString: "Product Not found")
       self.showAlertMessage(translatedMessage: errorMessage)
        
      }else{
        self.performSegue(withIdentifier: "ShowScanProductDetail", sender: response)
      }
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
      let errorMessage = WSUtility.getTranslatedString(forString: "Product Not found")
      self.showAlertMessage(translatedMessage: errorMessage)
    }
  }
  
  
  func showAlertMessage(translatedMessage:String)  {
    let alertView = UIAlertController(title: "", message: translatedMessage, preferredStyle: .alert)
    let action = UIAlertAction(title: WSUtility.getTranslatedString(forString: "Ok"), style: .default, handler: { (alert) in
      self.captureSession.startRunning()
    })
    alertView.addAction(action)
    self.present(alertView, animated: true, completion: nil)
  }
  
  func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
    // This is the delegate'smethod that is called when a code is readed
    for metadata in metadataObjects {
      let readableObject = metadata as! AVMetadataMachineReadableCodeObject
      let code = readableObject.stringValue
      
      
     // self.dismiss(animated: true, completion: nil)
     // self.delegate?.barcodeReaded(barcode: code!)
      self.captureSession.stopRunning()
      self.getProductDetailFromScannedCode(productID: code!)
      
      print(code!)
    }
  }
}
