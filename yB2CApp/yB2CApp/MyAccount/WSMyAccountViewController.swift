//
//  WSMyAccountViewController.swift
//  yB2CApp
//
//  Created by Ramakrishna on 11/27/17.
//

import UIKit

class WSMyAccountViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
  
    @IBOutlet weak var changeDefaultTrdaePartnerButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var removePhotoButton: UIButton!
    @IBOutlet weak var uploadFromGalleryButton: UIButton!
    @IBOutlet weak var takeAPhotoButton: UIButton!
    @IBOutlet weak var saveChangesButton: UIButton!
    
    @IBOutlet weak var addTradePartnerButton: UIButton!

    @IBOutlet weak var myloyaltyPoints: UILabel!
    @IBOutlet weak var completeProfileLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileTableView: UITableView!

    var isAddOrUpdateMode: Bool = false
    var tradePartnerDict: [String: Any] = [:]
    var userInfoDict: [String: Any] = [:]
    var expandedArray:[Int] = [0,1,2]

    var userId: String = ""
    var ecomUserID: String = ""
    var selectedBusinessType: String = ""
    var pickerArray:[[String: Any]] = []
    var selectedIndexForBP: String = ""
    var adminDict: [String: Any] = [:]
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var addAnotherTradeButtonView: UIView!
     @IBOutlet weak var photoOptionView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var progresslabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var percentCompleteLabel: UILabel!
  
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileImageLeft: NSLayoutConstraint!
    @IBOutlet weak var profileImageTop: NSLayoutConstraint!
    @IBOutlet weak var profileImageBottom: NSLayoutConstraint!
    @IBOutlet weak var profileImageRight: NSLayoutConstraint!
    
    @IBOutlet weak var progressLabelWidth: NSLayoutConstraint!
    var isMyDetailEditingMode: Bool = false
    var isBusinessEditingMode: Bool = false
    var isTradePartnerEditingMode: Bool = false
    
    @IBOutlet weak var removeButtonTop: NSLayoutConstraint!
    
    @IBOutlet weak var profileViewTop: NSLayoutConstraint!
    @IBOutlet weak var progressViewTop: NSLayoutConstraint!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var bottomBackButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
      
      /*
        var appVersion = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
*/
            UFSGATracker.trackEvent(withCategory: "Edit account", action: "", label: "", value: nil)
        
        
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.trackingScreens(screenName: "My Accounts Screen")
        UFSGATracker.trackScreenViews(withScreenName: "My Accounts Screen")
        FireBaseTracker.ScreenNaming(screenName: "My Accounts Screen", ScreenClass: String(describing: self))
        FBSDKAppEvents.logEvent("My Accounts Screen")
        WSUtility.sendTrackingEvent(events: "Other", categories: "Edit account",actions:"")
        FireBaseTracker .fireBaseTrackerWith(Events: "Other", Category: "Edit account")
        getUserDetailsFromAdmin()
        getUserDetailsFromHybrisOrSifu()
        
        if WSUtility.isLoginWithTurkey(){
            getUserProfileVendors_Turkey()
        }
        else{
            if !UserDefaults.standard.bool(forKey: DTO_OPERATOR){
                getUserTradePartnerProfile()
            }
        }
        
        getBusinessTypes()
        photoOptionView.frame = UIScreen.main.bounds
        self.view.addSubview(photoOptionView)
        photoOptionView.isHidden = true
        
        profileTableView.register(UINib(nibName: "WSMyDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "myDetailCell")
        profileTableView.register(UINib(nibName: "WSBusinessDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "myBusinessDetailCell")
        profileTableView.register(UINib(nibName: "WSTradePartnerTableViewCell", bundle: nil), forCellReuseIdentifier: "TradePartnerCell")
        
        backButton.setTitle(WSUtility.getlocalizedString(key: "Back", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        bottomBackButton.setTitle(WSUtility.getlocalizedString(key: "Back", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)

        // Do any additional setup after loading the view.
        changeDefaultTrdaePartnerButton.setTitle(WSUtility.getlocalizedString(key: "Change my default Trade Partner", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        
        addTradePartnerButton.setTitle("+ \(WSUtility.getlocalizedString(key: "Add another Trade Partner", lang: WSUtility.getLanguage(), table: "Localizable")!)", for: .normal)
        
        saveChangesButton.setTitle(WSUtility.getlocalizedString(key: "Save Changes", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func getUserDetailsFromHybrisOrSifu(){
        if WSUtility.isLoginWithTurkey(){
            self.getUserProfileFromHybrisFor_TR()
        }
        else{
            getUserDetailsFromSifu()
        }
    }
    func getUserProfileFromHybrisFor_TR()  {
        
        UFSProgressView.showWaitingDialog("")
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        
        serviceBussinessLayer.getBasicUserProfileFromHybrisForTurkey(parameter: [String:Any](), methodName: GET_PROFILE_API_HYBRIS_TR, successResponse: { (response) in
            
            UFSProgressView.stopWaitingDialog()
            
            let firstName = response["firstName"] as? String
            let lastName = response["lastName"] as? String
            UserDefaults.standard.setValue(lastName, forKey:"LastName")
            UserDefaults.standard.setValue(firstName, forKey:"FirstName")
            
            if let array = response["myProfileVendorsList"] as? [[String : Any]]{
                UserDefaults.standard.set(array, forKey: "myProfileVendorsList")
            }
            
            if let adressDict = response["defaultAddress"] as? [String: Any]{
                
                var tmpDict: [String: Any] = adressDict
                tmpDict["operatorBusinessName"] = "\(response["operatorBusinessName"] as? String ?? "")"
                UserDefaults.standard.set(tmpDict, forKey: "defaultAddress")
                
                if let zipcodeStr = adressDict["postalCode"] as? String{
                    UserDefaults.standard.set("\(zipcodeStr)", forKey: USER_ZIP_CODE)
                }
                else{
                    UserDefaults.standard.set("9999", forKey: USER_ZIP_CODE)
                }
            }
            
            if let businessType = response["businessType"] as? [String : Any]{
                UserDefaults.standard.set(businessType, forKey: "businessType")
            }

            if let taxNo = response["taxNumber"]{
                UserDefaults.standard.setValue("\(taxNo)", forKey: TAX_NUMBER_KEY)
            }

            if let vendorList = response["vendor"] as? [[String : Any]]{
                if vendorList.count > 0{
                    UserDefaults.standard.set(vendorList[0], forKey: "vendor")
                }
            }
            var vendorDict: [String:Any] = [:]
            if let arrVendors = response["vendor"] as? [[String:Any]], arrVendors.count > 0{

                vendorDict = arrVendors[0]
                let tradePartnerName = vendorDict["name"] as? String
                let tradePartnerID = "\(vendorDict["code"] ?? "")"
                UserDefaults.standard.setValue(tradePartnerName, forKey: TRADE_PARTNER_NAME)
                UserDefaults.standard.setValue(tradePartnerID, forKey: TRADE_PARTNER_ID)

            }
            self.userInfoDict = response
            self.profileTableView.reloadData()
            self.updatePercentageVal(userDict: self.userInfoDict, tradeDict: self.tradePartnerDict)
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
            
        }
        
    }
    func getUserTradePartnerProfile()  {
        
        
        let bussinessLayer:WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        UFSProgressView.showWaitingDialog("")
        bussinessLayer.getUserTradepartnersList(parameter: [String : Any](), methodName: GET_USER_TRADEPARTNERS, successResponse: { (response) in

            self.tradePartnerDict = response as! [String : Any]
            if let ptpTmpDict = self.tradePartnerDict["parentTradePartner"] as? [String: Any]{
                UserDefaults.standard.set("\(ptpTmpDict["name"]!)", forKey: "tradePartnerName")
                UserDefaults.standard.set("\(ptpTmpDict["id"]!)", forKey: TRADE_PARTNER_ID)
            }

            let userProfile_clientNumber = response["clientNumber"] as? Int
            let userProfile_parentTradePartnerId = response["parentTradePartnerId"] as? Int
            let userProfile_TradePartnerId = response["tradePartnerId"] as? Int

            if let array = response["userProfileTradePartners"] as? [[String : Any]]{
                for infoDict in array{
                    if infoDict["parentTradePartnerId"]as? Int == userProfile_parentTradePartnerId{
                        if infoDict["tradePartnerId"]as? Int == userProfile_TradePartnerId{
                            if userProfile_clientNumber == infoDict["clientNumber"] as? Int{
                                self.ecomUserID = "\(infoDict["id"]!)"
                            }
                        }
                    }
                }

            }



            self.profileTableView.reloadData()
            self.updatePercentageVal(userDict: self.userInfoDict, tradeDict: self.tradePartnerDict)
            self.updateTradeParnterToUserToAdmin()

            UFSProgressView.stopWaitingDialog()
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        }
        
//        UFSProgressView.showWaitingDialog("")
//        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
//        serviceBussinessLayer.getUserProfile(parameter: [String:Any](), methodName: GET_PROFILE_API, successResponse: { (response) in
//            UFSProgressView.stopWaitingDialog()
//            self.tradePartnerDict = response
//            if let ptpTmpDict = self.tradePartnerDict["parentTradePartner"] as? [String: Any]{
//                UserDefaults.standard.set("\(ptpTmpDict["name"]!)", forKey: "tradePartnerName")
//                UserDefaults.standard.set("\(ptpTmpDict["id"]!)", forKey: TRADE_PARTNER_ID)
//            }
//            self.profileTableView.reloadData()
//            self.updatePercentageVal(userDict: self.userInfoDict, tradeDict: self.tradePartnerDict)
//            self.updateTradeParnterToUserToAdmin()
//
//        }) { (errorMessage) in
//            UFSProgressView.stopWaitingDialog()
//        }
    }
    
    func getUserDetailsFromAdmin(){
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.getUserDetailsFromAdmin(successResponse: { (response) in
            let tempDictResponse = response["data"] as! [Any]
            let tmpDict = tempDictResponse[0] as! [String:Any]
            self.adminDict = tempDictResponse[0] as! [String:Any]
            if UserDefaults.standard.value(forKey: USER_PROFILE_IMAGE_URL)as? String == "" {
                if let profileImageUrl = tmpDict["profile_image"]{
                    UserDefaults.standard.set(profileImageUrl, forKey: USER_PROFILE_IMAGE_URL)
                }
            }
            self.setImageForProfileImage()
        }) { (errorMessage) in

        }
    }
    
    func getUserDetailsFromSifu(){
        UFSProgressView.showWaitingDialog("")
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.getBasicUserProfile(parameter: [String:Any](), methodName: GET_BASIC_PROFILE_API, successResponse: { (response) in
            UFSProgressView.stopWaitingDialog()
            let firstName = response["firstName"] as? String
            let lastName = response["lastName"] as? String
            UserDefaults.standard.setValue(lastName, forKey:"LastName")
            UserDefaults.standard.setValue(firstName, forKey:"FirstName")
            
            if let confirmedOptIn = response["confirmedOptIn"] as? Bool{
                UserDefaults.standard.set(confirmedOptIn, forKey: "confirmedOptIn")
            }
            if let newsletterOptIn = response["newsletterOptIn"] as? Bool{
                UserDefaults.standard.set(newsletterOptIn, forKey: "newsletterOptIn")
            }
            if let oldNewsletterOptIn = response["oldNewsletterOptIn"] as? Bool{
                UserDefaults.standard.set(oldNewsletterOptIn, forKey: "oldNewsletterOptIn")
            }
            if let confirmedNewsletterOptIn = response["confirmedNewsletterOptIn"] as? Bool{
                UserDefaults.standard.set(confirmedNewsletterOptIn, forKey: "confirmedNewsletterOptIn")
            }
          
          if let zipCode = response["zipCode"] as? String{
            UserDefaults.standard.set("\(zipCode)", forKey: USER_ZIP_CODE)
          }else{
            UserDefaults.standard.set("9999", forKey: USER_ZIP_CODE)
          }
          
            self.userId = response["userId"] as! String
            self.userInfoDict = response
            self.profileTableView.reloadData()
            self.updatePercentageVal(userDict: self.userInfoDict, tradeDict: self.tradePartnerDict)
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        }
    }
    
    func getBusinessTypes(){
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.getBusinessTypesFromHybris(successResponse: { (response) in
            self.pickerArray = response["businessList"] as! [[String: Any]]
        }) { (errorMessage) in
            
        }
    }
    
    /* get user vendor details for turkey
     1. get UserProfileVendors
     */
    func getUserProfileVendors_Turkey(){
        UFSProgressView.showWaitingDialog("")
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.getUserProfileVendorsList(successResponse: { (response) in
            
            UFSProgressView.stopWaitingDialog()
            
            if let array = response["myProfileVendors"] as? [[String : Any]]{
                let tpPredicate = NSPredicate(format: "isDefault = true")
                let filterArray = array.filter { tpPredicate.evaluate(with: $0) }
                if filterArray.count > 0{
                    print("Matched")
                    self.tradePartnerDict = filterArray[0]
                }
            }
            
            if let dict = self.tradePartnerDict["assignedVendor"] as? [String: Any]{
                
                UserDefaults.standard.set("\(dict["name"] ?? "")", forKey: TRADE_PARTNER_NAME)
                UserDefaults.standard.set("\(dict["code"] ?? "")", forKey: TRADE_PARTNER_ID)
            }
            self.ecomUserID = "\(self.tradePartnerDict["code"] ?? "")"
            
            self.profileTableView.reloadData()
            self.updatePercentageVal(userDict: self.userInfoDict, tradeDict: self.tradePartnerDict)
            self.updateTradeParnterToUserToAdmin()
            
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        }
    }
    func updatePercentageVal(userDict : [String: Any], tradeDict: [String: Any]){
        
        // my details
        var userTotalItemsCount: Int = 0
        var userCompletedItemsCount: Int = 0
        let firstName = userDict["firstName"] as? String
        let lastName = userDict["lastName"] as? String
        
        var mobileNo = ""
        
        if let str = userDict["phoneNumber"] as? String{
            mobileNo = str
        }
        else{
            if let tmpdict = userDict["defaultAddress"] as? [String: Any]{
                if let str1 = tmpdict["phone"] as? String{
                    mobileNo = str1
                }
            }
        }
        var email = ""
        
        if let str = userDict["email"] as? String{
            email = str
        }
        else if let str = userDict["uid"] as? String{
            email = str
        }
        
        var percetage: CGFloat = 0.0
        
        if firstName != nil && firstName != ""{
            userCompletedItemsCount += 1
        }
        userTotalItemsCount += 1
        
        if lastName != nil && lastName != ""{
            userCompletedItemsCount += 1
        }
        userTotalItemsCount += 1
        
        if mobileNo != nil && mobileNo != ""{
            userCompletedItemsCount += 1
        }
        userTotalItemsCount += 1
        
        if email != nil && email != ""{
            userCompletedItemsCount += 1
        }
        userTotalItemsCount += 1
        
        // tradeParnter details
        
        var tpTotalItemsCount: Int = 0
        var tpCompletedItemsCount: Int = 0
        
        if WSUtility.isLoginWithTurkey(){
            
            if let ptpTmpDict = tradeDict["assignedVendor"] as? [String: Any]{
                let tpName = ptpTmpDict["name"] as? String
                if tpName != nil && tpName != ""{
                    tpCompletedItemsCount += 1
                }
            }
            tpTotalItemsCount += 1
            
            if let tpTmpDict = tradeDict["assignedVendorAddress"] as? [String: Any]{
                let tpName = tpTmpDict["locationName"] as? String
                if tpName != nil && tpName != ""{
                    tpCompletedItemsCount += 1
                }
                
                let city = tpTmpDict["town"] as? String
                if city != nil && city != ""{
                    tpCompletedItemsCount += 1
                }
                
            }
            
            tpTotalItemsCount += 2
           
            if let clientNo = tradeDict["customerNumber"] as? String{
                if clientNo != ""{
                    tpCompletedItemsCount += 1
                }
            }
            
            tpTotalItemsCount += 1
        }
        else{
        
            if let ptpTmpDict = tradeDict["parentTradePartner"] as? [String: Any]{
                let tpName = ptpTmpDict["name"] as? String
                if tpName != nil && tpName != ""{
                    tpCompletedItemsCount += 1
                }
            }
            tpTotalItemsCount += 1
            
            if let tpTmpDict = tradeDict["tradePartner"] as? [String: Any]{
                let tpName = tpTmpDict["name"] as? String
                if tpName != nil && tpName != ""{
                    tpCompletedItemsCount += 1
                }
            }
            tpTotalItemsCount += 1
            
            if let clientNo = tradeDict["clientNumber"] as? String{
                if clientNo != ""{
                    tpCompletedItemsCount += 1
                }
            }
            tpTotalItemsCount += 1
            
        }
        
        // busniess details
        var businessTotalItemsCount: Int = 0
        var businessCompletedItemsCount: Int = 0
        
        var businessType: String?
        var businessName: String?
        var houseNo: String?
        var street: String?
        var city: String?
        var zipCode: String?
        
        if WSUtility.isLoginWithTurkey(){
            
            if let businessNameStr = userDict["operatorBusinessName"] as? String{
                businessName = businessNameStr
            }
            
            businessType = WSUser().getUserProfile().businessname
            
            if let addressDict = userDict["defaultAddress"] as? [String: Any]{
                
                if let addressLine1 = addressDict["line1"] as? String{
                    houseNo = addressLine1
                }
                
                if let addressLine2 = addressDict["line2"] as? String{
                    street = addressLine2
                }
                
                if let cityStr = addressDict["town"] as? String{
                    city = cityStr
                }
                if let zipCodeStr = addressDict["postalCode"] as? String{
                    zipCode = zipCodeStr
                }
            }
            
            if let taxNumber = userDict["taxNumber"] as? String{
                if taxNumber != nil && taxNumber != "" {
                    businessCompletedItemsCount += 1
                }
            }
            businessTotalItemsCount += 1
            
        }
        else{
            businessType = userDict["typeOfBusiness"] as? String
            businessName = userDict["businessName"] as? String
            houseNo = userDict["houseNumber"] as? String
            street = userDict["street"] as? String
            city = userDict["city"] as? String
            zipCode = userDict["zipCode"] as? String
        }
        
        if businessType != nil && businessType != "" {
            businessCompletedItemsCount += 1
        }
        businessTotalItemsCount += 1
        
        if businessName != nil && businessName != "" {
            businessCompletedItemsCount += 1
        }
        businessTotalItemsCount += 1
        
        if houseNo != nil && houseNo != ""{
            businessCompletedItemsCount += 1
        }
        businessTotalItemsCount += 1
        
        if street != nil && street != ""{
            businessCompletedItemsCount += 1
        }
        businessTotalItemsCount += 1
        
        if city != nil && city != ""{
            businessCompletedItemsCount += 1
        }
        businessTotalItemsCount += 1
        
        if zipCode != nil && zipCode != ""{
            businessCompletedItemsCount += 1
        }
        businessTotalItemsCount += 1
        
        
        //Progress weight-age Personal(20%), Business(40%), Trade Partner (20%) & Profile Image (20%)
        
        percetage = CGFloat((userCompletedItemsCount * 20)/userTotalItemsCount);
        
        if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
            //For DTO
            percetage = percetage + 20
        }
        else{
            //For normal user
            percetage = percetage + CGFloat((tpCompletedItemsCount * 20)/tpTotalItemsCount);
        }
        
        percetage = percetage + CGFloat((businessCompletedItemsCount * 40)/businessTotalItemsCount);
        
        // profile pic
        let profileImageUrl = WSUtility.getValueFromUserDefault(key: USER_PROFILE_IMAGE_URL)
        if profileImageUrl.count > 0 || profileImageUrl.hasPrefix("http") {
            percetage = percetage + 20;
        }
        progressLabelWidth.constant = (UIScreen.main.bounds.size.width - 100) * (percetage/100)
        
        percentCompleteLabel.text = WSUtility.getlocalizedString(key: "%@ Complete", lang: WSUtility.getLanguage(), table: "Localizable")
        if percetage >= 100.0{
            profileViewTop.constant = 140
            progressViewTop.constant = 0
            progressView.backgroundColor = UIColor(red:0.95, green:1.00, blue:0.95, alpha:1.0)
            progresslabel.backgroundColor = UIColor(red:0.46, green:0.72, blue:0.18, alpha:1.0)
            percentCompleteLabel.text = "\(Int(percetage))%"
            completeProfileLabel.text = WSUtility.getlocalizedString(key: "Profile Complete", lang: WSUtility.getLanguage(), table: "Localizable")
        }
        else{
            profileViewTop.constant = 0
            progressViewTop.constant = 204
            progressView.backgroundColor = UIColor.white
            progresslabel.backgroundColor = UIColor(red:1.00, green:0.35, blue:0.00, alpha:1.0)
            percentCompleteLabel.text = percentCompleteLabel.text?.replacingOccurrences(of: "%@", with: "\(Int(percetage))%")
            completeProfileLabel.text = WSUtility.getlocalizedString(key: "Complete your profile", lang: WSUtility.getLanguage(), table: "Localizable")
        }
        profileTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
        backButton.setTitle(WSUtility.getlocalizedString(key: "Back", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        
        cancelButton.setTitle("\(WSUtility.getTranslatedString(forString: "Cancel")) X", for: .normal)
        
        takeAPhotoButton.setTitle(WSUtility.getlocalizedString(key: "Take a photo", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        
        uploadFromGalleryButton.setTitle(WSUtility.getlocalizedString(key: "Upload from gallery", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        
        removePhotoButton.setTitle(WSUtility.getlocalizedString(key: "Remove Photo", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.removeSavedVlaues()
    }
    
    func checkImageEmptyOrNot(){
        if UserDefaults.standard.value(forKey: USER_PROFILE_IMAGE_URL)as? String == "" {
            self.removeButton.isHidden = true
            self.removeButtonTop.constant = 12
        }
        else{
            self.removeButton.isHidden = false
            self.removeButtonTop.constant = 73
        }
    }
    @objc func keyboardWillShow(aNotification:Notification) {
        let info = aNotification.userInfo! as NSDictionary
        let kbSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, (kbSize?.height)!, 0.0)
        
        profileTableView.contentInset = contentInsets;
        profileTableView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = view.frame
        aRect.size.height -= (kbSize?.height)!;
        
    }
    
    @objc func keyboardWillBeHidden(aNotification:Notification)  {
        let  contentInsets = UIEdgeInsets.zero;
        profileTableView.contentInset = contentInsets;
        profileTableView.scrollIndicatorInsets = contentInsets;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func unwindSegueToMyAcccount(segue: UIStoryboardSegue){
        if segue.identifier == "updateMyAccount" {
            //self.showNotifyMessage(WSUtility.getlocalizedString(key: "Profile Updated Successfully", lang: WSUtility.getLanguage(), table: "Localizable"))
            self.updatePercentageVal(userDict: self.userInfoDict, tradeDict: self.tradePartnerDict)
        }
        self.setImageForProfileImage()
    }
    @IBAction func removeButtonAction(sender: UIButton){
        photoOptionView.isHidden = true
        UFSProgressView.showWaitingDialog("")
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.removeUserPicFromAdminPanel(successResponse: { (response) in
            UFSProgressView.stopWaitingDialog()
            UserDefaults.standard.set("", forKey: USER_PROFILE_IMAGE_URL)
            self.setImageForProfileImage()
            self.updatePercentageVal(userDict: self.userInfoDict, tradeDict: self.tradePartnerDict)
        }, faliureResponse: { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        })
    }
    func setUI(){
        //headerView.frame.size.height = 240
       // progressView.isHidden = true
        profileTableView.tableHeaderView = headerView
        profileTableView.tableFooterView = footerView
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        let loytlyPoints = WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "currentLoyaltyBalance"))
        let pointString = WSUtility.getlocalizedString(key: "Your points balance", lang: WSUtility.getLanguage(), table: "Localizable")?.appending("  \(loytlyPoints)")
        let str = NSString(string:pointString!)
        let attributedStr = NSMutableAttributedString(string: str as String)
        attributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 255.0/255.0, green: 90.0/255.0, blue: 0, alpha: 1.0), range: str.range(of: "\(loytlyPoints)"))
        myloyaltyPoints.attributedText = attributedStr
        
        profileView.layer.borderWidth = 5.0
        profileView.layer.borderColor = UIColor.white.cgColor
    }
    
    func setImageForProfileImage(){
        
        let profileImageUrl = WSUtility.getValueFromUserDefault(key: USER_PROFILE_IMAGE_URL)
        if profileImageUrl.count > 0 && !profileImageUrl.hasPrefix("http") {
            self.profileImage.image = UIImage(contentsOfFile: WSUtility.getImagePathFor(imageName: "\(USER_PROFILE_IMAGE_NAME).png"))
            self.setConstraintsForProfileImage(isDefaultImage: self.profileImage.image!)
        }else{
            self.profileImage.sd_setImage(with: URL(string:profileImageUrl), placeholderImage: UIImage(named:"user_default_pic"),options: .refreshCached, completed: { (image, error, cacheType, imageURL) in
                // Perform operation.
                if image != nil{
                    
                    let imageData: Data = UIImagePNGRepresentation(image!)!
                    let imagePath = WSUtility.saveImageDocumentDirectory(imageData: imageData , ImageName: USER_PROFILE_IMAGE_NAME)
                    
                    UserDefaults.standard.set(imagePath, forKey: USER_PROFILE_IMAGE_URL
                    )
                }
                self.setConstraintsForProfileImage(isDefaultImage: self.profileImage.image!)
            })
        }
    }
    
    func setConstraintsForProfileImage(isDefaultImage: UIImage){
        if profileImage.image != #imageLiteral(resourceName: "user_default_pic") {
            profileImageLeft.constant = 0
            profileImageTop.constant = 0
            profileImageBottom.constant = 0
            profileImageRight.constant = 0
            profileImage.layer.cornerRadius = 52.5
            profileImage.clipsToBounds = true
            profileImage.layer.masksToBounds = true
            
        }
        else{
            profileImageLeft.constant = 26
            profileImageTop.constant = 21
            profileImageBottom.constant = 21
            profileImageRight.constant = 26
            profileImage.layer.cornerRadius = 0
            profileImage.clipsToBounds = true
        }
        self.checkImageEmptyOrNot()
    }
    @IBAction func editButton_click(sender: UIButton){
        photoOptionView.isHidden = false
    }
    @IBAction func editCancelButton_click(sender: UIButton){
        photoOptionView.isHidden = true
    }
    @IBAction func backButton_click(sender: UIButton){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: false)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        photoOptionView.isHidden = true
        if segue.identifier == "AddTradePartnerVC"{
            let addTPVC: WSAddTradePartnerViewController = segue.destination as! WSAddTradePartnerViewController
            addTPVC.isUpdateMode = isAddOrUpdateMode
            if isAddOrUpdateMode {
                addTPVC.updateDict = tradePartnerDict
            }
            addTPVC.userTradePartnerResponse = tradePartnerDict
            addTPVC.delegate = self
        }
        else if segue.identifier == "ChangeTPList"{
            let addTPVC: WSTradePartnerListViewController = segue.destination as! WSTradePartnerListViewController
            addTPVC.delegate = self
        }
        else if segue.identifier == "BusinessTypesVC"{

            let popUpVC = segue.destination as! UFSPopUpViewController
            popUpVC.titleString = "Select a business type"
            popUpVC.isSearchBarHidden = true
            
            let myBusinessDetailsCell: WSBusinessDetailTableViewCell = profileTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! WSBusinessDetailTableViewCell
            let businessNames = pickerArray.map({$0["businessName"]! as! String})
            popUpVC.arrayItems = businessNames
            popUpVC.selectedItem = myBusinessDetailsCell.businessTypeTextFeild.text!
            
            popUpVC.callBack = { selectedItemValue in
                
                myBusinessDetailsCell.businessTypeTextFeild.text = selectedItemValue
                let index = businessNames.index(of: selectedItemValue)
                let dict = self.pickerArray[index!]
                if let id = dict["businessCode"] as? String {
                    self.selectedIndexForBP = id
                }
            }
        }
        
    }

    func assignBusinessCodeID(){
        
        if selectedIndexForBP.isEmpty{
            let businessNames = pickerArray.map({$0["businessName"]! as! String})
            let index = businessNames.index(of: selectedBusinessType)
            if index != nil{
                let dict = self.pickerArray[index!]
                if let id = dict["businessCode"] as? String {
                    self.selectedIndexForBP = id
                }
            }
            else{
                
                if pickerArray.count > 0{
                    let dict = self.pickerArray[0]
                    if let id = dict["businessCode"] as? String {
                        self.selectedIndexForBP = id
                    }
                }
                
            }
            
        }
        
    }
    @IBAction func saveChangesButton_click(sender: UIButton){
        
        expandedArray.removeAll()
        expandedArray = [0,1,2]
        profileTableView.reloadData()
        isMyDetailEditingMode = true
        isBusinessEditingMode = true
        let detailCell = profileTableView.dequeueReusableCell(withIdentifier: "myDetailCell", for: IndexPath(row: 0, section: 0))as! WSMyDetailsTableViewCell
        
        let firstName = WSUtility.getValueFromUserDefault(key: "fname")
        let lastName = WSUtility.getValueFromUserDefault(key: "lname")
        let email = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
        let mobileNo = detailCell.mobileTextfield.text!
        
        let myBusinessDetailsCell = profileTableView.dequeueReusableCell(withIdentifier: "myBusinessDetailCell", for: IndexPath(row: 0, section: 2))as! WSBusinessDetailTableViewCell
        let businessName = myBusinessDetailsCell.businessNameTextFeild.text!
        let businessType = myBusinessDetailsCell.businessTypeTextFeild.text!
        let buildingNo = myBusinessDetailsCell.buildingNumberTextFeild.text!
        let street = myBusinessDetailsCell.streetTextFeild.text!
        let areaCode = myBusinessDetailsCell.areaCodeTextFeild.text!
        let city = myBusinessDetailsCell.cityNameTextFeild.text!
        
        selectedBusinessType = businessType
        
        var isFieldsEmpty: Bool = false
        
        if firstName == "" {
            WSUtility.UISetUpForTextFieldWithImage(textField: detailCell.firstNameTextfield, boolValue: true)
            isFieldsEmpty = true
        }
        if lastName == "" {
            WSUtility.UISetUpForTextFieldWithImage(textField: detailCell.lastNameTextfield, boolValue: true)
            isFieldsEmpty = true
        }
        if businessName == "" {
            WSUtility.UISetUpForTextFieldWithImage(textField: myBusinessDetailsCell.businessNameTextFeild, boolValue: true)
            isFieldsEmpty = true
        }
        if businessType == "" {
            WSUtility.UISetUpForTextFieldWithImage(textField: myBusinessDetailsCell.businessTypeTextFeild, boolValue: true)
            isFieldsEmpty = true
        }
        if buildingNo == "" {
            WSUtility.UISetUpForTextFieldWithImage(textField: myBusinessDetailsCell.buildingNumberTextFeild, boolValue: true)
            isFieldsEmpty = true
        }
        if street == "" {
            WSUtility.UISetUpForTextFieldWithImage(textField: myBusinessDetailsCell.streetTextFeild, boolValue: true)
            isFieldsEmpty = true
        }
        if city == "" {
            WSUtility.UISetUpForTextFieldWithImage(textField: myBusinessDetailsCell.cityNameTextFeild, boolValue: true)
            isFieldsEmpty = true
        }
        if !WSUtility.isLoginWithTurkey(){
            if areaCode == "" {
                WSUtility.UISetUpForTextFieldWithImage(textField: myBusinessDetailsCell.areaCodeTextFeild, boolValue: true)
                isFieldsEmpty = true
            }
        }
        if WSUtility.isLoginWithTurkey(){
            if myBusinessDetailsCell.businessTaxNoTextFeild.text == "" {
                WSUtility.UISetUpForTextFieldWithImage(textField: myBusinessDetailsCell.businessTaxNoTextFeild, boolValue: true)
                isFieldsEmpty = true
            }
        }
        if isFieldsEmpty {
            return
        }
        
        // This dict for DACH countries and admin pannel, not for Turkey
        
        UFSProgressView.showWaitingDialog("")
        var paramsDict: [String: Any] = [:]
        paramsDict["firstName"] = firstName
        paramsDict["lastName"] = lastName
        paramsDict["email"] = email
        paramsDict["mobileNo"] = mobileNo
        paramsDict["businessName"] = businessName
        paramsDict["businessType"] = businessType
        paramsDict["buildingNo"] = buildingNo
        paramsDict["street"] = street
        paramsDict["areaCode"] = areaCode
        paramsDict["city"] = city
        paramsDict["userId"] = userId
        
        if WSUtility.isLoginWithTurkey(){
            assignBusinessCodeID()
            let tmpDict = WSUser().getUserProfile().defaultAddress
            
            let addressDict:[String: Any] = ["country": ["isocode": "TR"],
                                                "defaultAddress": true,
                                                "firstName": firstName,
                                                "id": "\(tmpDict["id"] ?? "")",
                                                "lastName": lastName,
                                                "line1": buildingNo,
                                                "line2": street,
                                                "phone": mobileNo,
                                                "postalCode": areaCode,
                                                "region": ["isocode": "TR-2"],
                                                "shippingAddress": true,
                                                "town": city]
            let bodyparams:[String: Any] = ["firstName": firstName,
                                            "lastName": lastName,
                                            "name": "\(firstName) \(lastName)",
                                            "uid": email,
                                            "businessType": ["businessCode": self.selectedIndexForBP],
                                            "defaultAddress":addressDict,
                                            "operatorBusinessName": businessName,
                                            "titleCode": "ms",
                                        "taxNumber":myBusinessDetailsCell.businessTaxNoTextFeild.text!]
            
            
            let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
            
            businessLayer.updateUserProfileToHybrisForTurkey(parameter: bodyparams, successResponse: { (response) in
                self.removeSavedVlaues()
                self.updateUserToAdmin(paramsDict: paramsDict)
                self.getUserDetailsFromHybrisOrSifu()
                WSUtility.sendTrackingEvent(events: "Other", categories: "Onboarding",actions:"End Onboarding",labels: "Complete")
            }, failureResponse: { (errorMessage) in
                UFSProgressView.stopWaitingDialog()
                WSUtility.sendTrackingEvent(events: "Other", categories: "Onboarding",actions:"End Onboarding",labels: "InComplete")
            })
        }
        else{
            let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
            businessLayer.UpdateUserProfileForSifu(parameter: paramsDict, methodName: UPDATE_USER_DETAILS_TO_SIFU,responseDict:self.userInfoDict, successResponse: { (response) in
                self.removeSavedVlaues()
                self.updateUserToAdmin(paramsDict: paramsDict)
                self.getUserDetailsFromHybrisOrSifu()
                WSUtility.sendTrackingEvent(events: "Other", categories: "Onboarding",actions:"End Onboarding",labels: "Complete")
                
            }) { (errorMessage) in
                UFSProgressView.stopWaitingDialog()
                WSUtility.sendTrackingEvent(events: "Other", categories: "Onboarding",actions:"End Onboarding",labels: "InComplete")
                
            }
        }
        
    }
    func removeSavedVlaues(){
        UserDefaults.standard.set("", forKey: "fname")
        UserDefaults.standard.set("", forKey: "lname")
        UserDefaults.standard.set("", forKey: "fullname")
        
        //
        UserDefaults.standard.set("", forKey: "bname")
        UserDefaults.standard.set("", forKey: "btype")
        UserDefaults.standard.set("", forKey: "hNo")
        UserDefaults.standard.set("", forKey: "street")
        UserDefaults.standard.set("", forKey: "city")
        
    }
    func updateUserToAdmin(paramsDict: [String: Any]){
        
        var zipcode = paramsDict["areaCode"] as? String
        if zipcode?.count == 0{
            zipcode = "1001"
        }
        
        
        assignBusinessCodeID()
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.addUserToAdminPanel(params: ["firstName": paramsDict["firstName"]!,"lastName": paramsDict["lastName"]!,"bt_id": selectedIndexForBP,"pin_code":zipcode!,"deviceToken":UserDefaults.standard.value(forKey: "DeviceToken")!,"business_name":paramsDict["businessType"]!,"business_code":selectedIndexForBP], actionType: "update", successResponse: { (response) in
            
            if let tempDictResponse = response["data"] as? [Any]{
                if let adminDict = tempDictResponse[0] as? [String:Any]{
                    UserDefaults.standard.set(adminDict, forKey: "adminUserResponse")
                }
            }
            UFSProgressView.stopWaitingDialog()
            //self.showNotifyMessage(WSUtility.getlocalizedString(key: "Profile Updated Successfully", lang: WSUtility.getLanguage(), table: "Localizable"))
            //WSUtility.showAlertWith(message: WSUtility.getTranslatedString(forString: "Profile Updated Successfully"), title: "", forController: self)
        }, faliureResponse: { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        })
    }
    
    func updateTradeParnterToUserToAdmin(){
        
        if !adminDict.isEmpty{
            let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
            businessLayer.addUserToAdminPanel(params: ["firstName": "\(adminDict["first_name"] ?? "")","lastName": "\(adminDict["last_name"] ?? "")","bt_id": "\(adminDict["business_code"] ?? "")","pin_code":"\(adminDict["pin_code"] ?? "")","deviceToken":WSUtility.getValueFromUserDefault(key: "DeviceToken"),"business_name":"\(adminDict["business_name"] ?? "")","business_code":"\(adminDict["business_code"] ?? "")"], actionType: "update", successResponse: { (response) in
                
                if let tempDictResponse = response["data"] as? [Any]{
                    if let adminDict = tempDictResponse[0] as? [String:Any]{
                        UserDefaults.standard.set(adminDict, forKey: "adminUserResponse")
                    }
                }
                
            }, faliureResponse: { (errorMessage) in
                
            })
        }
    }
    
    @IBAction func selectBusinessType(sender: UIButton){
        self.performSegue(withIdentifier: "BusinessTypesVC", sender: self)
    }
    @IBAction func bottomBackButton_click(){
        isMyDetailEditingMode = false
        isBusinessEditingMode = false
        profileTableView.reloadData()
    }
}

extension WSMyAccountViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expandedArray.contains(section){
            if section == 1{
                if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
                    return 0
                }
            }
            return 1
        }
        else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0{
            let detailCell: WSMyDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "myDetailCell", for: indexPath) as! WSMyDetailsTableViewCell
            detailCell.setUI(editModeForCell: isMyDetailEditingMode,dict: userInfoDict)
            detailCell.delegate = self
            cell = detailCell
        }
        else if indexPath.section == 1 {
            let tpCell: WSTradePartnerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TradePartnerCell", for: indexPath) as! WSTradePartnerTableViewCell
            tpCell.delegate = self
            tpCell.setUI(editModeForCell: isTradePartnerEditingMode, dict:tradePartnerDict)
            cell = tpCell
        }
        else if indexPath.section == 2 {
            let businessDetailCell: WSBusinessDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "myBusinessDetailCell", for: indexPath) as! WSBusinessDetailTableViewCell
            businessDetailCell.delegate = self
            businessDetailCell.setUI(editModeForCell: isBusinessEditingMode,dict: userInfoDict)
            businessDetailCell.dropDownBusinessTypeButton.addTarget(self, action: #selector(selectBusinessType), for: .touchUpInside)
            cell = businessDetailCell
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 80))
        let namelabel = UILabel(frame: CGRect(x: 15, y: 20, width: tableView.frame.size.width - 50, height: 50))
        if section == 0{
            namelabel.text = WSUtility.getlocalizedString(key: "My details", lang: WSUtility.getLanguage(), table: "Localizable")
        }
        else if section == 1 {
            namelabel.text = WSUtility.getlocalizedString(key: "My trade partners details", lang: WSUtility.getLanguage(), table: "Localizable")
        }
        else if section == 2 {
            namelabel.text = WSUtility.getlocalizedString(key: "Business details", lang: WSUtility.getLanguage(), table: "Localizable")
        }
        
        view.backgroundColor = UIColor.white
        namelabel.font = UIFont.init(name: "DINPro-Bold", size: 18)
        view.addSubview(namelabel)
        let separtorLabel = UILabel(frame: CGRect(x: 15, y: 78, width: tableView.frame.size.width - 30, height: 1))
        separtorLabel.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        
        let plusMinusImage = UIImageView(frame: CGRect(x: tableView.frame.size.width - 30, y: 36, width: 16, height: 16))
        if expandedArray.contains(section){
            plusMinusImage.image = #imageLiteral(resourceName: "minusIcon_black")
        }
        else{
            plusMinusImage.image = #imageLiteral(resourceName: "plusIcon_black")
            view.addSubview(separtorLabel)
        }
        
        plusMinusImage.contentMode = .scaleAspectFit
        view.addSubview(plusMinusImage)
        let expandedButton = UIButton(type: .custom)
        expandedButton.frame = CGRect(x: 0, y: 30, width: tableView.frame.size.width, height: 50)
        expandedButton.addTarget(self, action: #selector(expandedbutton(sender:)), for: .touchUpInside)
        expandedButton.tag = section
        view.addSubview(expandedButton)
        
        return view
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return addAnotherTradeButtonView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1{
            if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
                return 0
            }
        }
        return 80
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if expandedArray.contains(section){
            if section == 1{
                if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
                    return 0
                }
                return 100
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if isMyDetailEditingMode{
                return 325
            }
            else{
                return 310
            }
        }
        else if indexPath.section == 1{
            if !WSUtility.isLoginWithTurkey(){
                return 375
            }
            else{
                return 460
            }
        }
        else {
            return heightForbusinessCell()
        }
    
    }
    func heightForbusinessCell()->CGFloat{
        if !WSUtility.isLoginWithTurkey(){
            if isBusinessEditingMode{
                return 485
            }
            else{
                return 550
            }
        }
        else{
            if isBusinessEditingMode{
                return 555
            }
            else{
                return 620
            }
        }
    }
    func expandedbutton(sender: UIButton){
        let section = sender.tag
        if let index = expandedArray.index(of: section) {
            expandedArray.remove(at: index)
        }
        else{
            expandedArray.append(section)
        }
        profileTableView.reloadData()
    }
    @IBAction func addAnotherTradePartner(sender: UIButton){
        isAddOrUpdateMode = false
        self.performSegue(withIdentifier: "AddTradePartnerVC", sender: self)
    }
}
extension WSMyAccountViewController: WSMyDetailsDelegate{
    func changeframeForCell(editMode: Bool){
        isMyDetailEditingMode = editMode
        profileTableView.reloadData()
    }
}
extension WSMyAccountViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardView))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboardView() {
        self.view.endEditing(true)
    }
}
extension WSMyAccountViewController: WSBusinessDetailTableViewCellDelegate{
    func changeframeForBusinessCell(editMode: Bool) {
        isBusinessEditingMode = editMode
        profileTableView.reloadData()
    }
}
extension WSMyAccountViewController: WSTradePartnerTableViewCellDelegate{
    func changeframeForTradePartnerCell(editMode: Bool) {
        isAddOrUpdateMode = true
        self.performSegue(withIdentifier: "AddTradePartnerVC", sender: self)
//        isTradePartnerEditingMode = editMode
//        profileTableView.reloadData()
    }
}
extension WSMyAccountViewController: WSAddTradePartnerViewControllerDelegate {
    func reloadTradePartnerAPI(isDefalut: Bool){
        if isDefalut{
            
            //self.showNotifyMessage(WSUtility.getlocalizedString(key: "Profile Updated Successfully", lang: WSUtility.getLanguage(), table: "Localizable"))
            
            if WSUtility.isLoginWithTurkey(){
                getUserProfileVendors_Turkey()
            }
            else{
                self.getUserTradePartnerProfile()
            }
        }
    }
}
extension WSMyAccountViewController: WSTradePartnerListViewControllerDelegate {
    func updateTPName() {
        
    }
    
    func reloadTPAPI(isDefalut: Bool){
        if isDefalut{
            //self.showNotifyMessage(WSUtility.getlocalizedString(key: "Profile Updated Successfully", lang: WSUtility.getLanguage(), table: "Localizable"))
            if WSUtility.isLoginWithTurkey(){
                getUserProfileVendors_Turkey()
            }
            else{
                self.getUserTradePartnerProfile()
            }
        }
    }
}
