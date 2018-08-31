//
//  WSSignUpViewController.swift
//  UFS
//
//  Created by Prathibha Sundresh on 03/07/18.
//

import Foundation

//MARK: values for confirm url and newsletter url
let CONFIRM_URL_ACCOUNT_CH_DE = "de/profil-erstellen/registration-completion.html"
let CONFIRM_URL_ACCOUNT_CH_FR = "fr/creer-un-compte/registration-completion.html"
let NEWSLETTER_CONFIRM_URL_ACCOUNT_CH_DE = "de/newsletter-abonnieren/newsletter-abonnieren-completion.html"
let NEWSLETTER_CONFIRM_URL_ACCOUNT_CH_FR = "fr/newsletter-sabonner/newsletter-sabonner-completion.html"

let hybris_gray = UIColor(red: 183.0/255.0, green: 183.0/255.0, blue: 183.0/255.0, alpha: 1).cgColor
let hybris_red = UIColor(red: 197.0/255.0, green: 0.0/255.0, blue: 26.0/255.0, alpha: 1).cgColor

class WSSignUpViewController: UIViewController,UITextViewDelegate {
    
    // Constants and var
    var pickerBusinessData:[[String:Any]] = []
    var businessTypeNameArray:[String] = []
    var pickerTradeData:[String] = []
    var pickerCityData:[String] = []
    var tradeArr:[[String:Any]] = []
    var pwdSecureFlag = 0
    var checkboxFlag = 0
    var newsLettercheckboxFlag = 0
    var businessOrTradeFlag = 0
    var selectedBusiness = ""
    var selectedCity = ""
    var business_ID = ""
    var selectedTrade = ""

    var signUpParam:[String:Any]?
    var accountOptInConfirmationLink = ""
    
    @IBOutlet weak var btnCheckMark1: UIButton!
    @IBOutlet weak var btnCheckMark2: UIButton!
    @IBOutlet weak var btnCheckMark3: UIButton!
    @IBOutlet weak var btnCheckMark4: UIButton!
    @IBOutlet weak var btnCheckMark5: UIButton!
    @IBOutlet weak var lblCheckMark1: UILabel!
    @IBOutlet weak var lblCheckMark2: UILabel!
    @IBOutlet weak var lblCheckMark3: UILabel!
    @IBOutlet weak var lblCheckMark4: UILabel!
    @IBOutlet weak var lblCheckMark5: UILabel!
    @IBOutlet weak var textViewTnC: UITextView!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var myBusinessLabel: UILabel!
    @IBOutlet weak var registerWithFbButton: UIButton!
    
    @IBOutlet weak var createAPasswordLabel: UILabel!
    @IBOutlet weak var createAFreeAccountButton: WSDesignableButton!
    @IBOutlet weak var myDetailsLabel: UILabel!
    @IBOutlet weak var firstNameTxtField: FloatLabelTextField!
    @IBOutlet weak var lastNameTxtField: FloatLabelTextField!
    @IBOutlet weak var emailTxtField: FloatLabelTextField!
    @IBOutlet weak var firstNameErrorImg: UIImageView!
    @IBOutlet weak var emailerrorImg: UIImageView!
    @IBOutlet weak var lastNameerrorImg: UIImageView!
    @IBOutlet weak var firstNameErrorLbl: UILabel!
    @IBOutlet weak var lastNameErrorLbl: UILabel!
    @IBOutlet weak var emailErrorLbl: UILabel!
    
    @IBOutlet weak var businessTypeTxtField: UITextField!
    @IBOutlet weak var tradePartnerTxtField: UITextField!
    
    @IBOutlet weak var btnCheckMark1_16YearsOld: UIButton!
    @IBOutlet weak var tradePartnerErrorLbl: UILabel!
    @IBOutlet weak var businessTypeErrorLbl: UILabel!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var passwordErrorImg: UIImageView!
    @IBOutlet weak var passwordErrorLbl: UILabel!
    @IBOutlet weak var pwdSecureBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vwBaseCity: UIView!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var lblErrorSelectCity: UILabel!
    //MARK: layoutconstraints
    @IBOutlet weak var htConstantCityVwBase: NSLayoutConstraint!
    @IBOutlet weak var YearsOldTopX: NSLayoutConstraint!
    @IBOutlet weak var verticalConstraintTradePartnerTF: NSLayoutConstraint!
    override func viewDidLoad() {
        super .viewDidLoad()
        applyDefaultStyle()
        varInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLocalizedTextForLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!WSUtility.isLoginWithTurkey()) {
            trade_request()
        } else {
            getVendorListAndCities()
            self.btnCheckMark1.isHidden = true
            self.lblCheckMark1.isHidden = true
            self.btnCheckMark1_16YearsOld.isHidden = true
            self.YearsOldTopX.constant = 0
        }
        
        getBusinessTypesFromHybris()
        getTrustedClientStatus()
    }
    
    //MARK: textField Methods
    func dismissKeyboard() {
        self.firstNameTxtField.resignFirstResponder()
        self.lastNameTxtField.resignFirstResponder()
        self.emailTxtField.resignFirstResponder()
        self.passwordTxtField.resignFirstResponder()
    }
    
    //MARK:IBAction for Buttons
    //For businessType click
    @IBAction func businessTypeClicked(_ sender: Any) {
        dismissKeyboard()
        if (pickerBusinessData.count > 0) {
            self.businessOrTradeFlag = 0;
            self.performSegue(withIdentifier: "CustomPopUpSegue", sender: self)
        }
    }
    
    // Sign up clicked
    @IBAction func createAccountClicked(_ sender: Any) {
        var firstNameValid = true
        var lastNameValid = true
        var emailValid = true
        var businessValid = true
        var tradeValid  = true
        var cityValid  = true
        var passwordValid = true
        
        
        if !checkTextFielsValidations(textField: firstNameTxtField, errorImage: firstNameErrorImg, errorLabel: firstNameErrorLbl) {
            firstNameValid = false
        }
        
        if !checkTextFielsValidations(textField: lastNameTxtField, errorImage: lastNameerrorImg, errorLabel: lastNameErrorLbl) {
            lastNameValid = false
        }
        
        if !checkTextFielsValidations(textField: emailTxtField, errorImage: emailerrorImg, errorLabel: emailErrorLbl) {
            emailValid = false
        }
        
        if !checkTextFielsValidations(textField: businessTypeTxtField, errorImage: UIImageView(), errorLabel: businessTypeErrorLbl) {
            businessValid = false
        }
        
        if !checkTextFielsValidations(textField: tradePartnerTxtField, errorImage: UIImageView(), errorLabel: tradePartnerErrorLbl) {
            tradeValid = false
        }
        
        if !checkTextFielsValidations(textField: passwordTxtField, errorImage: passwordErrorImg, errorLabel: passwordErrorLbl) || !isValidPassword(passwordString: passwordTxtField.text!) {
            passwordValid = false
        }
    
        if !WSUtility.isLoginWithTurkey() {
            if (!btnCheckMark1.isSelected) {
                btnCheckMark1.setImage(UIImage(named: "checkbox_unchecked_red"), for: UIControlState.normal)
                return
            }
        }
        
        let strCountryCode = WSUtility.getCountryCode()
        if (strCountryCode == "TR"){
            if(!checkTextFielsValidations(textField: tfCity, errorImage: UIImageView(), errorLabel: UILabel())){
                cityValid = false
            }
            
            if(firstNameValid && lastNameValid && emailValid && businessValid && tradeValid && passwordValid &&  cityValid){
                //API call
                processForm()
            }
        }
        else{
            if(firstNameValid && lastNameValid && emailValid && businessValid && tradeValid && passwordValid){
                //API call
                processForm()
            }
        }
    }
    //For tradePartner click
    @IBAction func tradePartnerNameClicked(_ sender: Any) {
        dismissKeyboard()
        if (pickerTradeData.count > 0) {
            self.businessOrTradeFlag = 1;
            self.performSegue(withIdentifier: "CustomPopUpSegue", sender: self)
        }
    }
    //For City Click
    @IBAction func btnCityTapped(_ sender: Any) {
        dismissKeyboard()
        if (pickerCityData.count > 0) {
            self.businessOrTradeFlag = 2;
            self.performSegue(withIdentifier: "CustomPopUpSegue", sender: self)
        }
    }
    
    @IBAction func btnCheckMark1Tapped(_ sender: Any) {
        self.btnCheckMark1.isSelected = !self.btnCheckMark1.isSelected
    }
    
    @IBAction func btnCheckMark2Tapped(_ sender: Any) {
        self.btnCheckMark2.isSelected = !self.btnCheckMark2.isSelected
        self.btnCheckMark3.isSelected = self.btnCheckMark2.isSelected
        self.btnCheckMark4.isSelected = self.btnCheckMark2.isSelected
        self.btnCheckMark5.isSelected = self.btnCheckMark2.isSelected
    }
    
    @IBAction func btnCheckMark3Tapped(_ sender: Any) {
        self.btnCheckMark3.isSelected = !self.btnCheckMark3.isSelected
        
        updateCheckMark2()
    }
    
    @IBAction func btnCheckMark4Tapped(_ sender: Any) {
        self.btnCheckMark4.isSelected = !self.btnCheckMark4.isSelected
        updateCheckMark2()
    }
    
    @IBAction func btnCheckMark5Tapped(_ sender: Any) {
        self.btnCheckMark5.isSelected = !self.btnCheckMark5.isSelected
        updateCheckMark2()
    }
    
    @IBAction func pwdSecureClicked(_ sender: Any) {
        if(pwdSecureFlag == 0){
            let img = UIImage(named: "show_pwd.png")
            pwdSecureBtn.setImage(img, for: UIControlState.normal)
            passwordTxtField.isSecureTextEntry = false
            self.pwdSecureFlag = 1
        } else {
            let img = UIImage(named: "hide_pwd_logo.png")
            pwdSecureBtn.setImage(img, for: UIControlState.normal)
            passwordTxtField.isSecureTextEntry = true
            pwdSecureFlag = 0
        }
    }
    
    @IBAction func emailTFEndEditing(_ sender: Any) {
        if (validateEmailWithString(checkString: self.emailTxtField.text!)) {
            self.emailErrorLbl.isHidden = true;
            self.emailerrorImg.isHidden = false;
            self.emailerrorImg.image = UIImage(named: "right_icon")
            self.emailTxtField.layer.borderColor = hybris_gray;
        } else {
            self.emailErrorLbl.isHidden = false;
            self.emailerrorImg.isHidden = false;
            self.emailerrorImg.image = UIImage(named: "error_icon")
            self.emailTxtField.layer.borderColor = hybris_red ;
        }
    }
    
    //checkbox func
    func updateCheckMark2() {
        
    }
    
    // check textfield validation
    func checkTextFielsValidations(textField:UITextField, errorImage : UIImageView, errorLabel :UILabel) -> Bool {
        if(textField.text == "") {
            errorImage.isHidden = false
            errorLabel.isHidden = false
            errorImage.image = UIImage(named: "error_icon")
            textField.layer.borderColor = hybris_red
            return false
        } else if textField == emailTxtField {
            if validateEmailWithString(checkString: emailTxtField.text!) {
                return true
            } else {
                errorImage.isHidden = false
                errorLabel.isHidden = false
                errorImage.image = UIImage(named: "error_icon")
                textField.layer.borderColor = hybris_red
            }
        }
        
        return true
    }
    
    //MARK:prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is WSEmailVerifictionViewController) {
            let vc = segue.destination as! WSEmailVerifictionViewController
            vc.emailId = self.emailTxtField.text!
            vc.password = self.passwordTxtField.text!
            vc.confirmUrl = self.accountOptInConfirmationLink
            vc.isComeFromSignUpScreen = true
        } else if (segue.destination is UFSPopUpViewController) {
            let VC = segue.destination as! UFSPopUpViewController
            if (self.businessOrTradeFlag == 2) {
                VC.titleString =  "Select a city"
                VC.arrayItems = self.pickerCityData
                VC.selectedItem = self.selectedCity
            }
            else{
                VC.titleString = (self.businessOrTradeFlag == 0) ? "Select a business type" : "Select tradepartner"
                VC.arrayItems = (self.businessOrTradeFlag == 0) ?  self.businessTypeNameArray : self.pickerTradeData
                VC.selectedItem = (self.businessOrTradeFlag == 0)  ? self.selectedBusiness : self.selectedTrade
            }
            VC.isSearchBarHidden = true
            VC.callBack =  {(string) in
                if(self.businessOrTradeFlag == 0){
                    self.selectedBusiness = string;
                    self.businessTypeTxtField.text = self.selectedBusiness;
                    let index = self.businessTypeNameArray.index(of: self.selectedBusiness)
                    let dict = self.pickerBusinessData[index!]
                    // self.business_ID = [dict objectForKey:@"bt_id"];
                    self.business_ID = dict["businessCode"] as! String
                    self.businessTypeErrorLbl.isHidden = true;
                }else if(self.businessOrTradeFlag == 1){
                    self.selectedTrade = string
                    self.tradePartnerTxtField.text = self.selectedTrade
                    self.tradePartnerErrorLbl.isHidden = true
                }
                else
                {
                    self.selectedCity = string;
                    self.tfCity.text = self.selectedCity;
                    self.lblErrorSelectCity.isHidden = true
                    
                    self.selectedTrade = ""
                    self.tradePartnerTxtField.text = ""
                    
                    let vendorListArray : NSMutableArray = []
                    for value in self.tradeArr {
                        if let array  = value["vendorAddress"] as? NSArray {
                            if (array.count > 0){
                                if let tmpArray = array.value(forKeyPath: "town") as? [String] {
                                    if (tmpArray.contains(string)) {
                                        vendorListArray.add(value)
                                    }
                                }else if let townArray = array.value(forKeyPath: "town") as? [NSNull] {
                                    
                                }
                            }
                        }
                    }
                    self.pickerTradeData = vendorListArray.value(forKeyPath: "name") as! [String]
                }
            }
            
        }
    }
    
    //MARK:Request response methods
    func trade_request() {
        UFSProgressView.showWaitingDialog("")
        let businesslayer = WSWebServiceBusinessLayer()
        businesslayer.getTradePartenersList(successResponse: {(response) in
            UFSProgressView.stopWaitingDialog()
            self.pickerTradeData.removeAll()
            self.tradeArr = (response as? [[String : Any]])!
            for value in self.tradeArr {
                if let tName = value["name"] as? String {
                    self.pickerTradeData.append(tName)
                }
            }
        }, faliureResponse: {(error) in
            UFSProgressView.stopWaitingDialog()
        })
    }
    
    func getVendorListAndCities() {
        UFSProgressView.showWaitingDialog("")
        let businesslayer = WSWebServiceBusinessLayer()
        businesslayer.getVendorsList(successResponse: {(response) in
            UFSProgressView.stopWaitingDialog()
            self.pickerTradeData.removeAll()
            self.tradeArr = response["vendorList"] as! [[String : Any]]
            let cityListArray = NSMutableArray()
            for value in self.tradeArr {
                if let tmparray = value["vendorAddress"] as? NSArray {
                    
                    if (tmparray.count) > 0 {
                        if let townArray = tmparray.value(forKeyPath: "town") as? [String] {
                            cityListArray.addObjects(from: townArray)
                        } else if let townArray = tmparray.value(forKeyPath: "town") as? [NSNull] {
                            
                        }
                    }
                }
            }
            
            self.pickerCityData = cityListArray as! [String]//(cityListArray.value(forKeyPath: "distinctUnionOfObjects.self") as! [String])

        }, failureResponse: {(error) in
            UFSProgressView.stopWaitingDialog()
        })
    }
    
    func getBusinessTypesFromHybris() {
        UFSProgressView.showWaitingDialog("")
        let businesslayer = WSWebServiceBusinessLayer()
        businesslayer.getBusinessTypesFromHybris(successResponse: {(response) in
            UFSProgressView.stopWaitingDialog()
            let dict = response as! [String:Any]
            self.pickerBusinessData = (dict["businessList"] as? [[String:Any]])!
            for value in self.pickerBusinessData {
                self.businessTypeNameArray.append(value["businessName"] as! String)
            }
        }, faliureResponse: {(error) in
            UFSProgressView.stopWaitingDialog()
        })
    }
    
    func getTrustedClientStatus() {
        let serviceBussinessLayer = WSWebServiceBusinessLayer()
        serviceBussinessLayer.makeGuestTrustedClientAndExecute(successResponse: {(response) in
            let hybrisToken = response["access_token"]
            UserDefaults.standard.setValue(hybrisToken!, forKey: "HYBRIS_TOKEN_KEY")
        }, faliureResponse: {(error) in
            
        })
    }
    
    func getConfirmURL() -> String {
        var confirmUrl = ""
        let dict = WSUtility.getBaseUrlDictFromUserDefault()
        if "\(dict["app_is_live"] ?? "0")" == "1" {
            confirmUrl = "https://www.unileverfoodsolutions.%@/profil-erstellen/registration-completion.html"
        } else {
            confirmUrl = "http://stage.unileverfoodsolutions.%@/profil-erstellen/registration-completion.html"
        }
        return confirmUrl
    }
    
    func getNewsLetterConfirmURL() -> String {
        var confirmUrl = ""
        let dict : [String:Any] = WSUtility.getBaseUrlDictFromUserDefault()
        if "\(dict["app_is_live"] ?? "0")" == "1" {
            confirmUrl = "https://www.unileverfoodsolutions.%@/newsletter-abonnieren/newsletter-abonnieren-completion.html"
        } else {
            confirmUrl = "http://stage.unileverfoodsolutions.%@/newsletter-abonnieren/newsletter-abonnieren-completion.html"
        }
        return confirmUrl
    }
    
    func moveToEmailconformation() {
        UFSProgressView.stopWaitingDialog()
        let strCountryCode = WSUtility.getCountryCode()
        if (strCountryCode != "TR") {
            self.performSegue(withIdentifier: "EmailVerificationSegue", sender: self)
        }
    }

    func moveToTutorialorHomeScreen() {
        let delegate = UIApplication.shared.delegate as! HYBAppDelegate
        if (!UserDefaults.standard.bool(forKey: "firstInstallation")) {
            delegate.openTutorial()
        } else {
            delegate.openHomeScreen()
        }
    }
    
    func addLoyaltyPointsForTurkey(Points:NSNumber) {
         UFSProgressView.showWaitingDialog("")
        let loyaltyDict = ["points":Points, "Initiated":"description"] as [String : Any]
        let businesslayer = WSWebServiceBusinessLayer()
        businesslayer.addLoyaltyPointsRequest(parameter: loyaltyDict, successResponse: {(response) in
            self.moveToTutorialorHomeScreen()
            UFSProgressView.stopWaitingDialog()
        }, faliureResponse: {(error) in
            self.moveToTutorialorHomeScreen()
            UFSProgressView.stopWaitingDialog()
        })
    }

    func getPendingLoyaltyPointsForTurkey() {
         UFSProgressView.showWaitingDialog("")
        let businesslayer = WSWebServiceBusinessLayer()
        businesslayer.getPendingLoyaltyPointsRequest(successResponse: {(response) in
            UFSProgressView.stopWaitingDialog()
            let loyaltyPointsdisc = response["country_loyalty_points"] as! [String:Any]
            let num = loyaltyPointsdisc["points"] as! NSNumber
            self.addLoyaltyPointsForTurkey(Points: num)
        }, faliureResponse: {(error) in
            UFSProgressView.stopWaitingDialog()
        })
    }
    
    func getSifuAccessTokenForTurkey() {
        UFSProgressView.showWaitingDialog("")
        let businesslayer = WSWebServiceBusinessLayer()
        let params : [String:String] = ["EmailId":self.emailTxtField.text!, "Password":self.passwordTxtField.text!]
        businesslayer.makeLoginRequest(parameter: params, methodName: "auth/authenticate", successResponse: {(response) in
            UserDefaults.standard.set(self.emailTxtField.text!, forKey: "LAST_AUTHENTICATED_USER_KEY")
            UFSProgressView.stopWaitingDialog()
            self.getPendingLoyaltyPointsForTurkey()
        }, faliureResponse: {(error) in
            UFSProgressView.stopWaitingDialog()
        })
    }
    
    func addUserToAdmin() {
        let age_verification = self.btnCheckMark1.isSelected == true ? "1" : "0"
        let news_letter_opt_in = self.btnCheckMark3.isSelected == true ? "1" : "0"
        let promotion_opt_in = self.btnCheckMark4.isSelected == true ? "1" : "0"
        let event_opt_in = self.btnCheckMark5.isSelected == true ? "1" : "0"
        
        let deviceToken = UserDefaults.standard.value(forKey: "DeviceToken")
        var tmpDict : [String:Any] = [:]
        tmpDict["deviceToken"] = deviceToken
        tmpDict["businessCode"] = self.business_ID
        tmpDict["age_verification"] = age_verification
        tmpDict["news_letter_opt_in"] = news_letter_opt_in
        tmpDict["promotion_opt_in"] = promotion_opt_in
        tmpDict["event_opt_in"] = event_opt_in
        
        let businesslayer = WSWebServiceBusinessLayer()
        businesslayer.addUserToAdminPanel(params: tmpDict, actionType: "create", successResponse: {(response) in
            WSUtility.triggerPushnotification(action: "registration_completed", email: self.emailTxtField.text!)
            self.moveToEmailconformation()
        }, faliureResponse: {(error) in
            self.moveToEmailconformation()
        })
    }
    
    func registerUser(dic:[String:Any]) {
        signUpParam = dic
        UFSProgressView.showWaitingDialog("")
        let businesslayer = WSWebServiceBusinessLayer()
        businesslayer.makeSignUpRequest(parameter: dic, successResponse: {(respose) in
            UFSProgressView.stopWaitingDialog()
            if let statusCode = respose["StatusCode"] {
                if (statusCode as! Int == 201) {
                    UserDefaults.standard.set(self.firstNameTxtField.text, forKey: "FirstName")
                    UserDefaults.standard.set(self.lastNameTxtField.text, forKey: "LastName")
                    UserDefaults.standard.set(self.emailTxtField.text, forKey: "UserEmailId")
                  
                    UserDefaults.standard.set(self.signUpParam!["tradePartnerID"], forKey: "tradePartnerID")
                    UserDefaults.standard.set(self.selectedTrade, forKey: "tradePartnerName")
                    UserDefaults.standard.synchronize()
                    self.addUserToAdmin()
                    let strCountryCode = WSUtility.getCountryCode()
                    if strCountryCode == "TR" {
                        UserDefaults.standard.set(true, forKey: "USER_LOGGEDIN_KEY")
                        self.getSifuAccessTokenForTurkey()
                    }
                    UserDefaults.standard.synchronize()
                    FBSDKAppEvents.logEvent(FBSDKAppEventNameCompletedRegistration)
                    
                }
                
            } else {
                if let dictError = respose["MessageType"] as? NSDictionary {
                let errArr = dictError["errors"] as! [String]
                let errDict = errArr[0] as! [String:Any]
                let message = errDict["message"] as! String
                let type = errDict["type"] as! String
                if(type == "DuplicateUidError")
                {
                    WSUtility.showAlertWith(message: WSUtility.getlocalizedString(key: "Email already registered", lang: WSUtility.getLanguageCode())!, title: "", forController: self)

                }
                else if (type == "Error") {
                    if (message.contains(find: "Trade partner")){
                        WSUtility.showAlertWith(message: WSUtility.getlocalizedString(key: "Trade partner is not available", lang: WSUtility.getLanguageCode())!, title: "", forController: self)
                    }
                    else{
                        if message.count != 0 {
                            WSUtility.showAlertWith(message: message, title: "", forController: self)
                        }
                    }
                }
                else{
                    if message.count != 0 {
                        WSUtility.showAlertWith(message: message, title: "", forController: self)
                    }
                }

            }
            }
        }, faliureResponse: {(error) in
            UFSProgressView.stopWaitingDialog()
        })
    }
    
    func processForm() {
        var tradeID = ""
        for tradeValue in tradeArr {
            if let nameValue = tradeValue["name"] as? String {
                if (selectedTrade == nameValue) {
                    if !WSUtility.isLoginWithTurkey() {
                        tradeID = "\(tradeValue["id"])"
                    } else {
                        tradeID = tradeValue["code"] as! String
                    }
                    break
                }
            }
        }
        
        newsLettercheckboxFlag = self.btnCheckMark3.isSelected == true ? 1 : 0
        let newsLetterOptInVal = self.btnCheckMark3.isSelected == true ? "true" : "false" //_newsLettercheckboxFlag == 0 ? @"false" : @"true" ;
        
        let currentDate = WSUtility.fetchurrentWithFormat()
        var strConfirmedOptIn = "false"
        let strCountryCode = WSUtility.getCountryCode()
        var params : [String: Any] = [:]
        
        var confirmURLStr = "\(getConfirmURL())\(strCountryCode.lowercased()))"//[NSString stringWithFormat:[self getConfirmURL],strCountryCode.lowercaseString];
        let newsLetterConfirmURLStr = "\(getNewsLetterConfirmURL())\(strCountryCode.lowercased()))"
        var newsLetterConfirmURL = newsLettercheckboxFlag == 0 ? "" : newsLetterConfirmURLStr
        
        if (strCountryCode == "TR") {
            strConfirmedOptIn = "true"
            confirmURLStr = ""
            newsLetterConfirmURL = ""
        } else if (strCountryCode == "CH") {
            if (WSUtility.getLanguageCode() == "de") {
                confirmURLStr = confirmURLStr.replacingOccurrences(of: "profil-erstellen/registration-completion.html", with: CONFIRM_URL_ACCOUNT_CH_DE)
                newsLetterConfirmURL = newsLetterConfirmURL.replacingOccurrences(of: "newsletter-abonnieren/newsletter-abonnieren-completion.html", with: NEWSLETTER_CONFIRM_URL_ACCOUNT_CH_DE)
            } else if (WSUtility.getLanguageCode() == "fr") {
                confirmURLStr = confirmURLStr.replacingOccurrences(of: "profil-erstellen/registration-completion.html", with: CONFIRM_URL_ACCOUNT_CH_FR)
                newsLetterConfirmURL = newsLetterConfirmURL.replacingOccurrences(of: "newsletter-abonnieren/newsletter-abonnieren-completion.html", with: NEWSLETTER_CONFIRM_URL_ACCOUNT_CH_FR)
            }
        }
        
        params = ["site":UserDefaults.standard.string(forKey: "Site")!,"languageCode":WSUtility.getLanguageCode(),"countryCode":WSUtility.getCountryCode(),"password":passwordTxtField.text!,"confirmPassword":passwordTxtField.text!,"titleCode":"mr","uid":emailTxtField.text!,"firstName":firstNameTxtField.text!,"lastName":lastNameTxtField.text!,"typeOfBusiness":selectedBusiness,"confirmUrl":confirmURLStr,"tradePartnerID":tradeID,"confirmedOptIn":strConfirmedOptIn,"newsletterConfirmUrl":newsLetterConfirmURL,"newsletterOptIn":newsLetterOptInVal,"confirmedOptInDate":currentDate,"accountOptIn":"false","optInDate":currentDate]
        if (strCountryCode == "TR") {
            
            var vendorDict : [String:Any] = [:]
            var cityDict : [String:Any] = [:]
            
            for value in self.tradeArr {
                if let vendorarray = value["vendorAddress"] as? NSArray {
                    
                    if (vendorarray.count) > 0 {
                        if let townArray = vendorarray.value(forKeyPath: "town") as? [String] {
                            if (townArray.contains(selectedCity)) {
                                let index = townArray.index(of: self.selectedCity)
                                cityDict = vendorarray.object(at: index!) as! [String : Any]
                                let code = value["code"] as! String
                                vendorDict["code"] = code
                                break
                                
                            }
                        } else if let townArray = vendorarray.value(forKeyPath: "town") as? [NSNull] {
                            
                        }
                    }
                }
            }
            var array : [[String:Any]] = []
            var LocationTmpDict : [String:Any] = [:]
            LocationTmpDict["locationId"] = cityDict["locationId"]
            LocationTmpDict["city"] = cityDict["town"]
            LocationTmpDict["locationName"] = cityDict["locationName"]
            array.append(LocationTmpDict)
            vendorDict["vendorAddress"] = array
            params["vendor"] = vendorDict
            params["businessCode"] = self.business_ID
            params["email"] = self.emailTxtField.text!
            params["confirmedNewsletterOptIn"] = true
        }
        else{
            params["businessCode"] = self.business_ID
        }
        
        self.accountOptInConfirmationLink = confirmURLStr
        self.registerUser(dic: params)
        
    }
    
    // UI related Funcs
    func AttributedTextInUILabelWithGreenText(grayText:String,boldText:String) {
        let text = "\(grayText) \(boldText)"
        
        // Define general attributes like color and fonts for the entire text
        let setAttributedText : [String:Any] = [NSForegroundColorAttributeName:self.passwordErrorLbl.textColor,NSFontAttributeName:self.passwordErrorLbl.font]
        
        let attributedText = NSMutableAttributedString(string: text, attributes: setAttributedText)
        
        
        // gray text attributes
        let grayColor = UIColor.darkGray
        let grayFont = UIFont(name: "DINPro-Regular", size: self.passwordErrorLbl.font.pointSize)
        let  greenTextRange = text.range(of: grayText)
        attributedText.addAttributes([NSForegroundColorAttributeName:grayColor,NSFontAttributeName:grayFont!], range: text.nsRange(from: greenTextRange!))
        
        
        let blueColor = UIColor.darkGray
        let boldFont = UIFont(name: "DINPro-Regular", size: self.passwordErrorLbl.font.pointSize)
        let  blueBoldTextRange = text.range(of: boldText)
        attributedText.addAttributes([NSForegroundColorAttributeName:blueColor,NSFontAttributeName:boldFont!], range: text.nsRange(from: blueBoldTextRange!))
        self.passwordErrorLbl.attributedText = attributedText
        
    }
    
    func applyDefaultStyle() {
        self.firstNameTxtField.setLeftPaddingPoints(10)
        self.lastNameTxtField.setLeftPaddingPoints(10)
        self.emailTxtField.setLeftPaddingPoints(10)
        self.businessTypeTxtField.setLeftPaddingPoints(10)
        self.tradePartnerTxtField.setLeftPaddingPoints(10)
        self.passwordTxtField.setLeftPaddingPoints(10)
        self.firstNameTxtField.layer.cornerRadius = 5
        self.firstNameTxtField.layer.borderColor = hybris_gray
        self.firstNameTxtField.layer.borderWidth = 1
        self.lastNameTxtField.layer.cornerRadius = 5
        self.lastNameTxtField.layer.borderColor = hybris_gray
        self.lastNameTxtField.layer.borderWidth = 1
        self.emailTxtField.layer.cornerRadius = 5
        self.emailTxtField.layer.borderColor = hybris_gray
        self.emailTxtField.layer.borderWidth = 1
        
        AttributedTextInUILabelWithGreenText(grayText: "Your password needs to be minimum 8 characters long and contain at least one of each: ", boldText: "Upper Case, Lower Case, Number, Special character (eg. !,%,+)")
    }
    
    func varInit() {

        firstNameTxtField.addTarget(self, action: #selector(fnameTextFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        lastNameTxtField.addTarget(self, action: #selector(lnameTextFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        passwordTxtField.addTarget(self, action: #selector(passwordTFDidEndEditing(textField:)), for: UIControlEvents.editingDidEnd)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(aNotification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(aNotification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func fnameTextFieldDidChange(textField:UITextField) {
        if (textField.text?.count == 1) {
            self.firstNameErrorLbl.isHidden = true
            self.firstNameErrorImg.isHidden = false;
            self.firstNameErrorImg.image = UIImage(named: "right_icon")
            self.firstNameTxtField.layer.borderColor = hybris_gray
        } else if (textField.text == "") {
            self.firstNameErrorLbl.isHidden = false
            self.firstNameErrorImg.isHidden = false
            self.firstNameErrorImg.image = UIImage(named: "error_icon")
            self.firstNameTxtField.layer.borderColor = hybris_red
        }
    }
    
    func lnameTextFieldDidChange(textField:UITextField) {
        if (textField.text?.count == 1) {
            self.lastNameErrorLbl.isHidden = true
            self.lastNameerrorImg.isHidden = false
            self.lastNameerrorImg.image = UIImage(named: "right_icon")
            self.lastNameTxtField.layer.borderColor = hybris_gray
        } else if (textField.text == "") {
            self.lastNameErrorLbl.isHidden = false
            self.lastNameerrorImg.isHidden = false
            self.lastNameerrorImg.image = UIImage(named: "error_icon")
            self.lastNameTxtField.layer.borderColor = hybris_red
        }
    }
    
    //    func emailTextFieldDidChange(textField:UITextField) {
    //
    //    }
    
    func passwordTFDidEndEditing(textField:UITextField) {
        if (isValidPassword(passwordString: self.passwordTxtField.text!)) {
            self.passwordErrorLbl.textColor = UIColor.black
            self.passwordErrorImg.isHidden = false
            self.passwordErrorImg.image = UIImage(named: "right_icon")
            self.passwordTxtField.layer.borderColor = hybris_gray ;
        } else {
            self.passwordErrorLbl.isHidden = false;
            self.passwordErrorLbl.textColor = UIColor.red
            self.passwordErrorImg.isHidden = false;
            self.passwordErrorImg.image = UIImage(named: "error_icon")
            self.passwordTxtField.layer.borderColor = hybris_red ;
        }
    }
    
    func isValidPassword(passwordString:String) -> Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[#%!$@^*()_.])[A-Za-z\\d#%!$@^*()_.]{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",regex)
        let isValid = passwordTest.evaluate(with: passwordString)
        return isValid;
    }
    
    func validateEmailWithString(checkString:String) -> Bool {
        //        let stricterFilter = false // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
        //        let stricterFilterString = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let laxString = ".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        //        let emailRegex = stricterFilter ? stricterFilterString : laxString
        let EmailTest = NSPredicate(format: "SELF MATCHES %@",laxString)
        let isValid = EmailTest.evaluate(with: checkString)
        return isValid;
    }
    
    func keyboardWillShow(aNotification:Notification) {
        let info = aNotification.userInfo as! [String:Any]
        let kbsize = (info[UIKeyboardFrameEndUserInfoKey] as! CGRect).size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbsize.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var arect = self.view.frame
        arect.size.height -= kbsize.height
    }
    
    func keyboardWillHide(aNotification:Notification) {
        self.scrollView.contentInset = UIEdgeInsets.zero
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    func setLocalizedTextForLabels() {
        // for checkbox labels
        let currentLanguage = WSUtility.getLanguage()
        lblCheckMark1.text = WSUtility.getlocalizedString(key: "Yes - I confirm that I am over 16 years old", lang: currentLanguage)
        lblCheckMark2.text = WSUtility.getlocalizedString(key: "Yes - I consent to my personal data being processed for all the below marketing purposes", lang: currentLanguage)
        lblCheckMark3.text = WSUtility.getlocalizedString(key: "Yes - I want to receive personalized newsletters from Unilever Food Solutions on new products, recipes ideas and inspirations", lang: currentLanguage)
        lblCheckMark4.text = WSUtility.getlocalizedString(key: "Yes - I want to participate to marketing campaigns and to receive discount, promotional, loyalty offers and competition invites", lang: currentLanguage)
        lblCheckMark5.text = WSUtility.getlocalizedString(key: "Yes - I want to receive personalized communication about event training and surveys invites", lang: currentLanguage)
        
        // for terms and conditions
        let strTnC = WSUtility.getlocalizedString(key: "TnC Signup", lang: currentLanguage)
        let attributedString = NSMutableAttributedString(string: strTnC!)
        let range = NSRangeFromString(strTnC!)
        let foundRange = strTnC?.nsRange(from: (strTnC?.range(of: WSUtility.getlocalizedString(key: "privacy policy", lang: currentLanguage)!))!)
        attributedString.addAttributes([NSFontAttributeName: UIFont(name: "DINPro-Regular", size: 14.0)!,NSForegroundColorAttributeName: UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)], range: range)
        var strURL = "http://www.unileverprivacypolicy.com/de_at/policy.aspx"
        let countryCode = WSUtility.getCountryCode()
        if countryCode == "AT" {
            strURL = "http://www.unileverprivacypolicy.com/de_at/policy.aspx"
        } else if countryCode == "DE" {
            strURL = "http://www.unileverprivacypolicy.com/de_DE/Policy.aspx"
        } else if countryCode == "TR" {
            strURL = "http://www.unileverprivacypolicy.com/turkish/policy.aspx"
        } else if countryCode == "CH" {
            if currentLanguage == "fr" {
                strURL = "http://www.unileverprivacypolicy.com/fr_ch/Policy.aspx"
            } else if countryCode == "de" {
                strURL = "http://www.unileverprivacypolicy.com/de_ch/Policy.aspx"
            }
        }
        attributedString.addAttributes([NSLinkAttributeName:strURL,NSFontAttributeName:UIFont(name: "DINPro-Regular", size: 14.0)!], range: foundRange!)
        let legaltermsrange = strTnC?.nsRange(from: (strTnC?.range(of: WSUtility.getlocalizedString(key: "Legal Terms", lang: currentLanguage)!))!)
        attributedString.addAttributes([NSLinkAttributeName:"legalTerms",NSFontAttributeName:UIFont(name: "DINPro-Regular", size: 14.0)!], range: legaltermsrange!)
        self.textViewTnC.linkTextAttributes = [NSForegroundColorAttributeName:UIColor.orange,NSUnderlineColorAttributeName:NSNumber(value: Int8(NSUnderlineStyle.styleSingle.rawValue))]
        
        self.textViewTnC.attributedText = attributedString
        
        //For textfields and labels
        
        lblErrorSelectCity.text = WSUtility.getlocalizedString(key: "Password", lang: currentLanguage)
        passwordTxtField.placeholder = WSUtility.getlocalizedString(key: "Password", lang: currentLanguage)
        firstNameTxtField.placeholder = WSUtility.getlocalizedString(key: "First Name", lang: currentLanguage)
        lastNameTxtField.placeholder = WSUtility.getlocalizedString(key: "Last Name", lang: currentLanguage)
        emailTxtField.placeholder = WSUtility.getlocalizedString(key: "Email", lang: currentLanguage)
        
        businessTypeTxtField.placeholder = WSUtility.getlocalizedString(key: "Business type", lang: currentLanguage)
        tradePartnerTxtField.placeholder = WSUtility.getlocalizedString(key: "Trade partner", lang: currentLanguage)
        tfCity.placeholder = WSUtility.getlocalizedString(key: "City", lang: currentLanguage)
        firstNameErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter your first name", lang: currentLanguage)
        lastNameErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter your last name", lang: currentLanguage)
        emailErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter a correct email address", lang: currentLanguage)
        businessTypeErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter what type of business you are working in", lang: currentLanguage)
        tradePartnerErrorLbl.text = WSUtility.getlocalizedString(key: "Please select your tradepartner name", lang: currentLanguage)
        
        passwordErrorLbl.text = WSUtility.getlocalizedString(key: "Your password needs to be minimum 8 characters long one and contain at least one of each: upper case, lowercase, number special character [eg. !. %. +]", lang: currentLanguage)
        registerLabel.text = WSUtility.getlocalizedString(key: "Register", lang: currentLanguage)
        
        myDetailsLabel.text = WSUtility.getlocalizedString(key: "My details", lang: currentLanguage)
        myBusinessLabel.text = WSUtility.getlocalizedString(key: "My business", lang: currentLanguage)
        
        createAFreeAccountButton.setTitle(WSUtility.getlocalizedString(key: "Create a FREE account - Register Page", lang: currentLanguage), for: UIControlState.normal)
        
        //REGISTER WITH FB not implemented as of now
        registerWithFbButton.setTitle(WSUtility.getlocalizedString(key: "Register with Facebook", lang: currentLanguage), for: UIControlState.normal)
        
        createAPasswordLabel.text = WSUtility.getlocalizedString(key: "Create a Password", lang: currentLanguage)
        
        WSUtility.addNavigationBarBackButton(controller: self)
        
        if (!WSUtility.isLoginWithTurkey()){
            self.htConstantCityVwBase.constant = 0.0;
            self.verticalConstraintTradePartnerTF.constant = 30.0;
            self.vwBaseCity.isHidden = true
        }
        else{
            self.htConstantCityVwBase.constant = 79.0;
            self.verticalConstraintTradePartnerTF.constant = 5.0;
            self.vwBaseCity.isHidden = false
        }
    }
    
    // TextView Delegate
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if (URL.absoluteString == "legalTerms") {
            self.performSegue(withIdentifier: "TermAndConditonSegue", sender: self)
            return false;
        }
        else{
            return true;
        }
    }
    
}
