//
//  WSPhotoUploadViewController.swift
//  yB2CApp
//
//  Created by Ramakrishna on 12/2/17.
//

import UIKit
import Photos
import PhotosUI

class WSPhotoUploadViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    var asset : Any?
  
    @IBOutlet weak var uploadImage: UIImageView!
    var thumbnailImage: UIImage!
    @IBOutlet weak var blurrView: UIVisualEffectView!
    fileprivate let imageManager = PHCachingImageManager()
   
    @IBOutlet weak var retakePhotoButton: UIButton!
    
    @IBOutlet weak var usePhotoButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.trackingScreens(screenName: "Profile Photo Upload screen")
        UFSGATracker.trackScreenViews(withScreenName: "Profile Photo Upload screen")
        FireBaseTracker.ScreenNaming(screenName: "Profile Photo Upload screen", ScreenClass: String(describing: self))
        FBSDKAppEvents.logEvent("Profile Photo Upload screen")
        retriveImageFromPHAssetManagerAndUpdateToAdminServer()
        // Do any additional setup after loading the view.
        retakePhotoButton.setTitle(WSUtility.getlocalizedString(key: "Retake photo", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        usePhotoButton.setTitle(WSUtility.getlocalizedString(key: "Use photo", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        backButton.setTitle(WSUtility.getlocalizedString(key: "Back", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        uploadImage.image = thumbnailImage
    }
    @IBAction func backButtonAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
  @IBAction func reTakeButtonAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  @IBAction func usePhotoButtonAction(sender: UIButton){
        self.performSegue(withIdentifier: "unWindToMyAccount", sender: self)
    }
    func retriveImageFromPHAssetManagerAndUpdateToAdminServer()  {
        
        UFSProgressView.showWaitingDialog("")
        var imageData = [Data]()
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        imageManager.requestImageData(for: asset as! PHAsset, options: options) { (result, string, orientation, info) -> Void in
            if result != nil {
                imageData.append(result!)
            } else {
                
            }
        }
        self.uploadProfileImage(image: imageData)
    }
    func uploadProfileImage(image:[Data]) {
        
        WSImageUploadFileManager.uploadImages(imageData: image, apiMethodName: UPLOAD_PROFILE_IMAGE, imageName: "profile_image", successResponse: { (responseObject) in
            
            self.blurrView.isHidden = true
            UFSProgressView.stopWaitingDialog()
            
            let profileImagePath = WSUtility.saveImageDocumentDirectory(imageData: image[0], ImageName: "MyProfile")
            UserDefaults.standard.set(profileImagePath, forKey: USER_PROFILE_IMAGE_URL)
            
            UFSProgressView.stopWaitingDialog()
            
            
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
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

}
