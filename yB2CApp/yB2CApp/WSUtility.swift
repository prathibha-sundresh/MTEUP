//
//  WSUtilityClass.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 09/11/17.
//

import UIKit
import Photos


@objc class WSUtility: NSObject {
    
  
    static var productCodeList : [String] = [ ]
    //static let taxNumberFooterView:WSTaxNumberFooterView = WSTaxNumberFooterView.loadnib()
    
    class func UISetUpForTextField(textField:UITextField, withBorderColor color:CGColor)  {
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = color
        textField.layer.cornerRadius = 6
        
    }
    
    class func getValueFromUserDefault(key: String) -> String{
        if let value = UserDefaults.standard.value(forKey: key){
            return value as! String
        }
        return ""
    }
    
    class  func getValueFromDict(dict:[String : Any], key:String) -> String {
        
        if let dictValue = dict[key] as? String{
            return dictValue
        } else {
            return ""
        }
        
    }
    
    class func getBaseSiteCodeForHybris() -> String  {
        return "ufs_\(WSUtility.getCountryCode().lowercased())"
    }
    
    class func getLanguageCode() -> String  {
        let languageCode =  WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "lang"))
        
        return languageCode
        
    }
    
    class func getCountryName() -> String {
        return WSUtility.getValueFromString(stringValue:UserDefaults.standard.value(forKey: "SelectedLocation"))
    }
    
    class func getCountryCode() -> String{
        let countryCode =  WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "CountryCode"))
        
        return countryCode.uppercased()
    }
    class func getQty() -> String{
        let strQty =  WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "strQtySticky"))
        
        return strQty
    }
    class func setQty(strQty:String){
        UserDefaults.standard.setValue(strQty, forKey: "strQtySticky")
    }
    class func getProductType() -> String{
        let strType =  WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "strTypeSticky"))
        
        return strType
    }
    class func setProductType(strType:String){
        UserDefaults.standard.setValue(strType, forKey: "strTypeSticky")
    }
    
    
    class func getValueFromString(stringValue: Any!) -> String{
        if let value = stringValue{
            return value as! String
        }
        
        return ""
    }
    
    class func getHybrisBaseUrlWithBaseSiteId() -> String{
        let hybrisBaseUrl = WSConfigurationFile().getHybrisBaseURL()
        return hybrisBaseUrl.replacingOccurrences(of: "BASE_SITE_ID", with: WSUtility.getBaseSiteCodeForHybris())
        
    }
    
    class func addVendorIDForTurkey() -> String{
        if WSUtility.isLoginWithTurkey(){
            if WSUtility.getValueFromUserDefault(key: TRADE_PARTNER_ID) != ""{
                return "&vendorId=\(WSUtility.getValueFromUserDefault(key: TRADE_PARTNER_ID))"
            }
            else{
                return ""
            }
        }
        else{
            return ""
        }
        
    }
    
    class func getSiteCode() -> String {
        return "ufs-\(WSUtility.getCountryCode().lowercased())"
    }
    
    class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    class func getSifuToken() -> String{
        /*
         let userKey:String = UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY) as! String
         let dictUserInfo = UserDefaults.standard.value(forKey: userKey) as! [String:Any]
         print(dictUserInfo["sifuToken"] ?? "")
         */
        
        return getValueFromUserDefault(key: SIFU_TOKEN_KEY)
    }
    
    class func addNavigationBarBackButton(controller:UIViewController) {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 90, height: 35)
        backButton.setImage(UIImage(named: "signup_back.png"), for: .normal)
        backButton.setTitle(WSUtility.getlocalizedString(key: "Back", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        backButton.contentHorizontalAlignment = .left
        backButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)
        
        backButton.setTitleColor(ApplicationOrangeColor, for: .normal)
        backButton.titleLabel?.font = UIFont(name: "DINPro-Regular", size: 12)
        backButton.addTarget(controller, action: #selector(self.backAction(_:)), for: .touchUpInside)
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    class func addNavigationBarBackToCartButton(controller:UIViewController) {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 90, height: 35)
        backButton.setImage(UIImage(named: "signup_back.png"), for: .normal)
        backButton.setTitle(WSUtility.getlocalizedString(key: "Back to cart", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        backButton.contentHorizontalAlignment = .left
        backButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)
        backButton.titleLabel?.adjustsFontSizeToFitWidth = true
        backButton.setTitleColor(ApplicationOrangeColor, for: .normal)
        backButton.titleLabel?.font = UIFont(name: "DINPro-Regular", size: 12)
        backButton.addTarget(controller, action: #selector(self.backAction(_:)), for: .touchUpInside)
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        
    }
    
    class func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    class func getImagePathFor(imageName:String) -> String{
        let fileManager = FileManager.default
        let imagePath = (self.getDirectoryPath() as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            return imagePath
        }else{
            print("No Image")
            return ""
        }
    }
    
    class func setCartBadgeCount(ViewController:UIViewController) {
        //let backendService:HYBB2CService = (UIApplication.shared.delegate as! HYBAppDelegate).backEndService
        let rightBarButtons = ViewController.navigationItem.rightBarButtonItems
        let lastBarButton = rightBarButtons?.last
        
        var cartDetail = UFSHybrisUtility.cartData
        
        if  (cartDetail!["deliveryItemsQuantity"]) == nil {
            if let _ = UserDefaults.standard.value(forKey: Cart_Detail_Key) as? NSDictionary{
                cartDetail = UserDefaults.standard.value(forKey: Cart_Detail_Key) as? NSDictionary
            }
            
        }
        
        if let bCount = (cartDetail!["deliveryItemsQuantity"] as? NSNumber)?.stringValue {
            if ((cartDetail!["deliveryItemsQuantity"] as! NSNumber).intValue > 0) {
                lastBarButton?.addBadge(text: bCount)
            }else{
                lastBarButton?.addBadge(text: "0")
            }
        }else{
            
            lastBarButton?.addBadge(text: "0")
        }
        
    }
    
    class func addNavigationRightBarButton(toViewController viewController:UIViewController) {
        let btnShowCart = UIButton(type: UIButtonType.system)
        btnShowCart.setImage(#imageLiteral(resourceName: "WebShop-ShoppingCart"), for: UIControlState())
        btnShowCart.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        btnShowCart.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btnShowCart.addTarget(viewController, action: #selector(self.rightBarButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customRightBarItem = UIBarButtonItem(customView: btnShowCart)
        viewController.navigationItem.rightBarButtonItem = customRightBarItem;
        
    }
    @IBAction func rightBarButtonPressed(_ sender: UIButton)  {
        
    }
    
    class func cartButtonPressed(viewController:UIViewController){
        //    if let loadCart : HYBCart = backendService.currentCartFromCache() {
        //        if((UFSHybrisUtility.cartData!["deliveryItemsQuantity"] as! NSNumber).intValue > 0){
        //            let storyboard = UIStoryboard(name: "Cart", bundle: nil)
        //            let cartView =  storyboard.instantiateViewController(withIdentifier: "CartViewC") as! HYBCartController
        //            viewController.navigationController?.pushViewController(cartView, animated: true)
        //        }else{
        //            callEmptyCart(viewController: viewController)
        //        }
        //        //    }else{
        //        //      callEmptyCart(viewController: viewController)
        //        //    }
        
        let storyboard = UIStoryboard(name: "Cart", bundle: nil)
        let cartView =  storyboard.instantiateViewController(withIdentifier: "CartViewC") as! HYBCartController
        viewController.navigationController?.pushViewController(cartView, animated: true)
    }
    
    class func callEmptyCart(viewController:UIViewController){
        let storyboard = UIStoryboard(name: "Cart", bundle: nil)
        let cartView =  storyboard.instantiateViewController(withIdentifier: "EmptyCartView") as! EmptyCartViewController
        viewController.navigationController?.pushViewController(cartView, animated: true)
    }
    
    // To get localizedString
    
    class func getlocalizedString(key: String, lang: String, table: String? = nil) -> String? {
        
        guard Bundle.main.path(forResource: lang, ofType: "lproj") != nil  else {
            return nil
        }
        //print("\(Bundle(path: Bundle.main.path(forResource: lang, ofType: "lproj")!)?.localizedString(forKey: key, value: nil, table: table) ?? "")")
        return Bundle(path: Bundle.main.path(forResource: lang, ofType: "lproj")!)?.localizedString(forKey: key, value: nil, table: table)
        
    }
    /*
     class func getGoalID() -> String {
     let goalProductID = UserDefaults.standard.value(forKey: USER_LOYALTY_GOAL_ID_KEY)
     if (goalProductID as AnyObject).count == 0 || goalProductID == nil {
     return ""
     }else{
     return goalProductID as! String
     }
     }
     */
    class func getLanguage() -> String{
        guard let lang = UserDefaults.standard.value(forKey: "lang") as? String else {
            return ""
        }
        return lang
    }
    
    
    class func checkPhotoLibraryAccessPermission() -> Bool   {
        
        var permissionStatus = false
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.authorized) {
            permissionStatus = true
        } else if (status == PHAuthorizationStatus.denied) {
            permissionStatus = false
        } else if (status == PHAuthorizationStatus.notDetermined) {
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    permissionStatus = true
                }
            })
        } else if (status == PHAuthorizationStatus.restricted) {
            //Restricted
        }
        return permissionStatus
    }
    
    class func checkCameraPermission() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if status == .restricted || status == .denied {
            return false
        }
        return true
    }
    
    class func setBottomShadowToNavigationBar(viewController:UIViewController)  {
        
        viewController.navigationController?.navigationBar.layer.borderColor = UIColor.white.cgColor;
        viewController.navigationController?.navigationBar.layer.borderWidth = 1
        viewController.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        viewController.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 1, height: 1)
        viewController.navigationController?.navigationBar.layer.shadowRadius = 1.0
        viewController.navigationController?.navigationBar.layer.shadowOpacity = 0.3
        viewController.navigationController?.navigationBar.layer.masksToBounds = false
        
    }
    class func addTaxNumberView(viewController:UIViewController)  {
        if WSUtility.isLoginWithTurkey() {
          
          if let view = viewController.view.viewWithTag(9006){
            view.removeFromSuperview()
          }

          let taxNumberFooterView:WSTaxNumberFooterView = WSTaxNumberFooterView.loadnib()
            //if !viewController.view.subviews.contains(taxNumberFooterView){
                //if taxNumberFooterView != nil {
            taxNumberFooterView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
            if (viewController.hidesBottomBarWhenPushed){ // Without tabBar
              
                if let view = viewController.view.viewWithTag(1010101){//payContiner @cart
                    taxNumberFooterView.frame = CGRect(x: 5, y: UIScreen.main.nativeBounds.height == 2436 ? (viewController.view.frame.size.height - 150) : (viewController.view.frame.size.height - 120), width: (UIScreen.main.bounds.width - 10), height: 69)
                }else{
                    taxNumberFooterView.frame = CGRect(x: 5, y: UIScreen.main.nativeBounds.height == 2436 ? (viewController.view.frame.size.height - 124) : (viewController.view.frame.size.height - 80), width: (UIScreen.main.bounds.width - 10), height: 69)
                }
              
            }else{//With TabBar
                 taxNumberFooterView.frame = CGRect(x: 5, y: UIScreen.main.nativeBounds.height == 2436 ? (viewController.view.frame.size.height - 160) : (viewController.view.frame.size.height - 127), width: (UIScreen.main.bounds.width - 10), height: 69)
            }
            taxNumberFooterView.labelMessage.text = WSUtility.getlocalizedString(key: "Complete your details to get personalised pricing and points", lang: WSUtility.getLanguage())
            taxNumberFooterView.btnTaxNum.addTarget(viewController, action: #selector(btnTaxTapped(sender:)), for: .touchUpInside)
            viewController.view.addSubview(taxNumberFooterView)
                //}
           // }
        }
    }
    func btnTaxTapped(sender:UIButton)  {
        
    }

  class func isTaxNumberAvailable(VCview:UIView)-> Bool {
        if WSUser().getUserProfile().taxNumber != ""{
            return true
        }
        if let view = VCview.viewWithTag(9006){
          view.removeFromSuperview()
      }
        return false
    }
    class func UISetUpForTextFieldWithImage(textField:UITextField ,boolValue: Bool)  {
        
        if boolValue == true {
            
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 50))
            let checkedImage: UIImageView = UIImageView()
            checkedImage.frame = CGRect(x: 0, y: 17.5, width: 15, height: 15)
            checkedImage.contentMode = .scaleAspectFit
            
            if textField.text != "" {
                checkedImage.image = #imageLiteral(resourceName: "checked_Icon")
                textField.layer.borderColor = unselectedTextFieldBorderColor
            }
            else{
                checkedImage.image = #imageLiteral(resourceName: "error_icon")
                textField.layer.borderColor = selectedTextFieldBorderColor
            }
            
            rightView.addSubview(checkedImage)
            textField.rightView = rightView
            textField.rightViewMode = UITextFieldViewMode.always
        }
        else{
            textField.layer.borderWidth = 1.5
            textField.layer.borderColor = unselectedTextFieldBorderColor
            textField.layer.cornerRadius = 6
        }
        
    }
    class func saveImageDocumentDirectory(imageData:Data, ImageName imageName:String) ->String{
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(imageName).png")
        print(paths)
        //let imageData = UIImagePNGRepresentation(image)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        
        return "\(imageName).png"
    }
    
    class  func setProfileImageFor(imageView:UIImageView)  {
        
        let profileImageUrl = getValueFromUserDefault(key: USER_PROFILE_IMAGE_URL)
        
        if profileImageUrl.characters.count > 0 && !profileImageUrl.hasPrefix("http") {
            let profileImage = UIImage(contentsOfFile: getImagePathFor(imageName: "\(USER_PROFILE_IMAGE_NAME).png"))
            imageView.image = self.makeUIImageRoundCorner(image: profileImage!)
        }else{
            imageView.sd_setImage(with: URL(string:profileImageUrl), placeholderImage: UIImage(named:"user_default_pic"),options: .refreshCached, completed: { (image, error, cacheType, imageURL) in
                // Perform operation.
                if image != nil{
                    
                    let imageData: Data = UIImageJPEGRepresentation(image!, 1)!
                    let imagePath = saveImageDocumentDirectory(imageData: imageData , ImageName: USER_PROFILE_IMAGE_NAME)
                    
                    UserDefaults.standard.set(imagePath, forKey: USER_PROFILE_IMAGE_URL
                    )
                }
            })
        }
    }
    
    class func showAlertWith(message:String,title:String,forController controller:UIViewController) {
        
        let alert  = UIAlertController(title: title, message: WSUtility.getlocalizedString(key:message, lang:WSUtility.getLanguage(), table: "Localizable")!, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: WSUtility.getlocalizedString(key:"Ok", lang:WSUtility.getLanguage(), table: "Localizable")!, style: .default, handler: nil))
        
        controller.present(alert, animated: true, completion: nil)
        
    }
    
    class func getGoalId() -> String {
        if let goalID = UserDefaults.standard.value(forKey: USER_LOYALTY_GOAL_ID_KEY) as? String{
            if goalID == "0"{
                return ""
            }
            return goalID
        }else{
            return ""
        }
    }
    
    class func isUserPlacedFirstOrder() -> Bool{
        if let orderHasPlaced = UserDefaults.standard.object(forKey: IS_USER_HAS_PLACED_FIRST_ORDER){
            return orderHasPlaced as! Bool
        }
        return false
    }
    class func getAppVersion() -> String {
        var appVersion = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        return appVersion
    }
    
    class  func setLoyaltyPoint(label:UILabel)  {
        let loyaltyPoint = UserDefaults.standard.value(forKey: LOYALTY_BALANCE_KEY) as! String
        
        let pointsBalanceText = WSUtility.getlocalizedString(key: "Your points balance", lang: WSUtility.getLanguage(), table: "Localizable")
        let attributedString = NSMutableAttributedString(string: pointsBalanceText! + " \(loyaltyPoint)")
        attributedString.setColorForText(loyaltyPoint, with: UIColor(red: 250.0/255.0, green: 90.0/255.0, blue: 0, alpha: 1), with: nil)
        label.attributedText = attributedString
    }
    
    class func setAttributedLabel(originalText:String, attributedText:String, forLabel label:UILabel?, withFont font:UIFont, withColor color:UIColor )  {
        
        let attributedString = NSMutableAttributedString(string: originalText)
        attributedString.setColorForText(attributedText, with: color, with: font)
        label?.attributedText = attributedString
        
    }
    
    class func isUserLoggedIn() -> Bool{
        
        if let value = UserDefaults.standard.object(forKey: USER_LOGGEDIN_KEY){
            return value as! Bool
        }
        
        return false
    }
    
    class func getTranslatedString(forString text:String) -> String{
        
        let transaltedString = WSUtility.getlocalizedString(key: text, lang: WSUtility.getLanguage(), table: "Localizable")
        
        return transaltedString!
    }
    
    class func sendTrackingEvent(events:String,categories:String,actions:String = "",labels:String = ""){
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.trackingEvent(event: events, category: categories,action:actions,label:labels, successResponse: { (response) in
            print(response)
        }) { (errorMessage) in
            print(errorMessage)
        }
        
    }
    class func triggerPushnotification(action:String, email:String){
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.triggerRegistrationPushNotification(action: action, email: email, successResponse: { (response) in
            print(response)
        }) { (errorMessage) in
            print(errorMessage)
        }
    }
    
    
    class func fetchurrentWithFormat() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD'T'hh:mm:ss'Z'"
        
        let date = dateFormatter.string(from: Date())
        return date
        
    }
    
    class func loadNoInternetView( internetView:inout UFSNoInternetView?, controllerView:UIViewController)  {
        let tabbarcontroller = UITabBarController()
        let tabBarHeight = tabbarcontroller.tabBar.frame.size.height
        let window = UIApplication.shared.keyWindow!
        internetView = UFSNoInternetView.instanceFromNib()
        internetView?.awakeFromNib()
        internetView?.delegate = controllerView as? NoInternetDelegate
        internetView?.noInternetLabel.text = WSUtility.getlocalizedString(key:"No_Internet", lang:WSUtility.getLanguage(), table: "Localizable")
        let screenWidth = window.frame.width
        internetView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: window.frame.height - tabBarHeight)
        internetView?.backgroundColor = UIColor.white
        internetView?.layoutIfNeeded()
        window.addSubview(internetView!)
    }
    
    class func removeNoNetworkView(internetView:inout UFSNoInternetView?)  {
        if internetView != nil {
            internetView?.removeFromSuperview()
            internetView = nil
        }
    }
    
    class func isEnableDisableForCurrentReleaseId(ReleaseId : String) -> Bool {
        if WSUtility.getAppVersion() == ReleaseId {
            return true
        }
        return false
    }
    
    /// This API method is to get feture enable/disable values from Admin
    class func checkDataForenableDisableFeature() {
        
        /// Commented guard,because we need to fetch updated feature enable/disable value every time whenever user come to home screen
        
        // guard (UserDefaults.standard.value(forKey: "enableDisbleFeature") as? [[String : Any]]) != nil else {
        
        let webservice = WSWebServiceBusinessLayer()
        webservice.featureEnableDisableForcountries(success: { (response) in
            let temp = response["data"] as! [String:Any]
            let appReleaseFeature = temp["app_release_feature"] as! [[String:Any]]
            let baseUrlDic = temp["app_release"] as! [String:Any]
            if appReleaseFeature.count != 0 {
                UserDefaults.standard.setValue(appReleaseFeature, forKey: "enableDisbleFeature")
                UserDefaults.standard.setValue(baseUrlDic, forKey: "baseURlFeature")
            }
        }) { (error) in
            //Error
        }
        return
        // }
        
    }
    
    
    class func isFeatureEnabled(feature: String) ->Bool {
        guard let enableDisableFeatureList = (UserDefaults.standard.value(forKey: "enableDisbleFeature") as? [[String : Any]]) else{
            return true
        }
        
        for valuelist in enableDisableFeatureList
        {
            let feature_id : String =  "\(valuelist["feature_id"] ?? "0")"
            let status = "\(valuelist["status"] ?? "0")"
            
            if feature_id == feature  {
                let value = status == "1" ? true : false
                return value
            }
        }
        return false
    }
    
    class func makeUIImageRoundCorner(image:UIImage) -> UIImage{
        
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: image.size)
        UIGraphicsBeginImageContextWithOptions(image.size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: image.size.height
            ).addClip()
        image.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    class func removeFavoriteItem(item:String) {
        if (productCodeList.contains(item)) {
            if let index  = productCodeList.index(of: item) {
                productCodeList.remove(at: index)
            }
        }
        return
    }
    
    class func removeProductCode() {
        productCodeList.removeAll()
    }
    
    class func getProductCode() -> [String] {
        return productCodeList
    }
    
    class func setProductCode(productNumber:String) {
        productCodeList.append(productNumber)
    }
    class func isLoginWithTurkey()->Bool{
        if WSUtility.getCountryCode() == "TR"{
            return true
        }
        else{
            return false
        }
    }
    
    class func getBaseUrlDictFromUserDefault() -> [String:Any] {
        if let urlDict = UserDefaults.standard.dictionary(forKey: "baseURlFeature"){
            return urlDict
        }
        
        return self.getBaseURLsDictForStageAndLive(isLive: UserDefaults.standard.bool(forKey: "isForLiveOrStage"))
        
    }
    class func getBaseURLsDictForStageAndLive(isLive: Bool) -> [String:Any] {
        
        var dict = [String: Any]()
        // SAP -> "https://apihbs.ufs.com/
        if isLive{
            dict = ["app_admin_panel_url":"http://adminp.ufs.com/ufsglobal/api/v2/","app_is_live":"1","app_sifu_url":"https://api.ufs.com/","hybris_base_url":"https://52.31.80.240:9002/","hybris_base_url_path":"ufscommercewebservices/v2/","hybris_forgot_password":"ufscommercewebservices/forgottenpasswordtokens?email=","hybris_token_path":"authorizationserver/oauth/token?client_id=android&client_secret=android123&grant_type=client_credentials"]
        }
        else{
            //stage https://52.31.80.240:9006/
            //tmp url: https://52.208.230.100:9002/
           //https://52.208.230.100:9006/
          
            dict = ["app_admin_panel_url":"https://techstage.nl/ufsapp_global/api/v2/","app_is_live":"0","app_sifu_url":"https://stage-api.ufs.com/","hybris_base_url":"https://52.208.230.100:9006/","hybris_base_url_path":"ufscommercewebservices/v2/","hybris_forgot_password":"ufscommercewebservices/forgottenpasswordtokens?email=","hybris_token_path":"authorizationserver/oauth/token?client_id=android&client_secret=android123&grant_type=client_credentials"]
        }
        
        return dict
    }
}

extension UILabel {
    func imageIconWithLabel(text:String, imageName:String) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        attachment.bounds = CGRect(x: 0, y: -3, width: 18, height: 18)
        let attachmentStr = NSAttributedString(attachment: attachment)
        
        let imageAttach = NSMutableAttributedString(string: " ")
        imageAttach.append(attachmentStr)
        
        let myText = NSMutableAttributedString(string: "  \(text)")
        imageAttach.append(myText)
        return imageAttach
    }
}


extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


