
//
//  MyDetailViewController.swift
//  yB2CApp
//
//  Created by Ajay on 29/11/17.
//

import UIKit


class MyDetailViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {
    var totalPriceForPayment_TR = ""
    @IBOutlet weak var vwBasePaymentForTurkey: UIView!
    @IBOutlet weak var trailingCnstHdr3: NSLayoutConstraint!
    @IBOutlet weak var widthCnstHdr1: NSLayoutConstraint!
    @IBOutlet weak var leadingCnstHdr3: NSLayoutConstraint!
    @IBOutlet weak var widthCnstHdr3: NSLayoutConstraint!
    @IBOutlet weak var widthCnstHdr2: NSLayoutConstraint!
    @IBOutlet weak var leadingCnstHdr2: NSLayoutConstraint!
    @IBOutlet weak var trailingCnstHdrLbl: NSLayoutConstraint!
    @IBOutlet weak var htConstTradePartner: NSLayoutConstraint!
    @IBOutlet weak var errorLblBusinesstaxNum: UILabel!
    @IBOutlet weak var checkoutLabel: UILabel!
    @IBOutlet weak var topConstraintBottomVw: NSLayoutConstraint!
    
    @IBOutlet weak var checkoutLabel_turkey: UILabel!
    @IBOutlet weak var tfBusinessTaxNum: FloatLabelTextField!
    @IBOutlet weak var vwBottomBase: UIView!
    @IBOutlet weak var vwMyTradePartnerBase: UIView!
    @IBOutlet weak var vwMyDetailsBase: UIView!
    @IBOutlet weak var vwTopBase: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var nextButton: WSDesignableButton!
    @IBOutlet weak var myTradePartnerDetails: UILabel!
    @IBOutlet weak var myDetailsLabel: UILabel!
    
    @IBOutlet weak var firstNameTxtField: FloatLabelTextField!
    @IBOutlet weak var lastNameTxtField: FloatLabelTextField!
    @IBOutlet weak var phoneTxtField: FloatLabelTextField!
    @IBOutlet weak var tradePartnerLocationTextField: FloatLabelTextField!
    @IBOutlet weak var tradePartnerAccountNumberTextField: FloatLabelTextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var pickerTool: UIToolbar!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tradePartnerNameTextField: UITextField!
    @IBOutlet weak var ContentPickerView: UIView!
    @IBOutlet weak var doneToolbarBtn: UIBarButtonItem!
    @IBOutlet weak var myDetailProcessLbl: UILabel!
    @IBOutlet weak var deliveryProcessLbl: UILabel!
    @IBOutlet weak var summaryProcessLbl: UILabel!
    
    @IBOutlet weak var MyDetailsLabel_1: UILabel!
    @IBOutlet weak var emailErrorLbl: UILabel!
    @IBOutlet weak var firstNameErrorLbl: UILabel!
    @IBOutlet weak var lastNameErrorLbl: UILabel!
    @IBOutlet weak var phoneNoErrorLbl: UILabel!
    @IBOutlet weak var tpnameErrorLbl: UILabel!
    @IBOutlet weak var tpLocationErrorLbl: UILabel!
    @IBOutlet weak var tpAccountErrorLbl: UILabel!
    @IBOutlet weak var selectTPNameButton: UIButton!
    @IBOutlet weak var selectTPLocationNameButton: UIButton!
    @IBOutlet weak var scorllViewContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var htCnstBusTaxNum: NSLayoutConstraint!
    @IBOutlet weak var htConstBusTaxErrLbl: NSLayoutConstraint!
    @IBOutlet weak var btmCnstBusTaxErrLbl: NSLayoutConstraint!
    @IBOutlet weak var htCnstMyDetailsBase: NSLayoutConstraint!
    // let TRADE_PARTNER_URL = "http://stage-sifu.ufs.com:80/ecom/tradepartners?siteCode=ufs-at"
    //let TRADE_PARTNER_CHIELD_URL = "https://stage-api.ufs.com/ecom/tradepartners/1087/children?siteCode=ufs-at"
    var totalItemsQunatity: Int = 0
    var pickerTradeData: [String] = [String]()
    var pickerTradeDataLocation: [String] = [String]()
    var pickerTradeId: [AnyObject] = [AnyObject]()
    var pickerTradeLocationId: [AnyObject] = [AnyObject]()
    var cartArr: [String] = [String]()
    //var backendService:HYBB2CService = (UIApplication.shared.delegate as! HYBAppDelegate).backEndService
    var selectedTradePartne = ""
    var selectedTradePartneLocation = ""
    var totalPrice = ""
    var earnedLoyaltyPoints = ""
    var promoCode = ""
    var selectedTradeId = ""
    var selectedTradelocationId = ""
    var pickerFlag = "tradePartner"
    var tempTradePartnerLocation = ""
    
    var recentOrderDictInfo: [String: Any] = [:]
    
    var validPromoDict: [String: Any] = [:]
    
    var vendorList_TR: [[String: Any]] = []
    let underlineAttributes : [String: Any] = [
        NSFontAttributeName : UIFont(name: "DinPro-Regular", size: 14.0)!,
        NSForegroundColorAttributeName : ApplicationOrangeColor,
        NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
    
    @IBOutlet weak var previousButton: UIButton!{
        didSet{
            previousButton.layer.borderWidth = 1.0
            previousButton.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
            previousButton.layer.cornerRadius = 5.0
            previousButton.clipsToBounds = true
        }
    }
    
    var checkOutDetailInfoArray = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if WSUtility.isLoginWithTurkey(){
            getOrderHistoryListFromHybris()
        }
        else{
            getOrderHistoryList()
        }
        self.getTradeListOrVendorList()
        
        WSWebServiceBusinessLayer().trackingScreens(screenName: "Checkout Screen")
        UFSGATracker.trackScreenViews(withScreenName: "Checkout Screen")
        UFSGATracker.trackScreenViews(withScreenName: "Checkout Details Screen")
        FireBaseTracker.ScreenNaming(screenName: "Checkout Screen", ScreenClass: String(describing: self))
        FBSDKAppEvents.logEvent("Checkout Screen")
        
        
        ContentPickerView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 245, width: UIScreen.main.bounds.width, height: 245)
        self.view.addSubview(ContentPickerView)
        ContentPickerView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
       
        aplyDefaultStyle()
        WSUtility.addNavigationBarBackToCartButton(controller: self)
        showHideTradeParnterDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UISetUP()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if WSUtility.isLoginWithTurkey(){
            selectTPNameButton.isUserInteractionEnabled = false
        }
        
    }
    
    
    
    func showHideTradeParnterDetails(){
        
        let isBool: Bool = UserDefaults.standard.bool(forKey: DTO_OPERATOR)
        myTradePartnerDetails.isHidden = isBool
        tradePartnerNameTextField.isHidden = isBool
        selectTPNameButton.isHidden = isBool
        tradePartnerLocationTextField.isHidden = isBool
        selectTPLocationNameButton.isHidden = isBool
        tradePartnerAccountNumberTextField.isHidden = isBool
        
        if isBool{
            htConstTradePartner.constant = 0.0
 //           scorllViewContentViewHeight.constant = 645
        vwMyTradePartnerBase.isHidden = true
//            topConstraintBottomVw.constant = vwBottomBase.frame.origin.y-self.view.frame.size.height
        topConstraintBottomVw.constant = 5.0
                }
        else{
//            scorllViewContentViewHeight.constant = 975
            htConstTradePartner.constant = 288.0
            vwMyTradePartnerBase.isHidden = false
            topConstraintBottomVw.constant = 20.0
        }
    }
    func getOrderHistoryList() {
        
        UFSProgressView.showWaitingDialog("")
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.makeOrderHistoryRequest(methodName: ORDER_HISTORY_API, successResponse: { (response) in
            //print(response)
            UFSProgressView.stopWaitingDialog()
            if response.count > 0{
                if let dict = response.first as? [String: Any]{
                    self.recentOrderDictInfo = dict
                    self.updateUserDetails()
                }
                
            }
        }, faliureResponse: { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        })
    }
    
    func getOrderHistoryListFromHybris() {
        UFSProgressView.showWaitingDialog("")
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.makeOrderHistoryRequestToHybris(methodName: ORDER_HISTORY_API, successResponse: { (response) in
            
            if response.count != 0 {
                
                self.recentOrderDictInfo = response[0]
                self.updateUserDetails()
            }
            
            UFSProgressView.stopWaitingDialog()
            
        }, faliureResponse: { (errorMessage) in
            
            UFSProgressView.stopWaitingDialog()
        })
    }
    
    
    func updateUserDetails(){
        
        if var tmpDict = recentOrderDictInfo["orderInfo"] as? [String: Any]{
            if let name = tmpDict["firstName"] as? String{
                firstNameTxtField.text = "\(name)"
            }
            if let name = tmpDict["lastName"] as? String{
                lastNameTxtField.text = "\(name)"
            }
            if let email = tmpDict["email"] as? String{
                emailTxtField.text = "\(email)"
            }
            
            let number = WSUtility.getValueFromUserDefault(key: "mobileNo")
            if number != ""{
                if number.hasPrefix("+"){
                    phoneTxtField.text = number.replacingOccurrences(of: "+", with: "")
                }
                else{
                    phoneTxtField.text = number
                }
            }
            else{
                if let mobileNo = tmpDict["mobilePhone"] as? String{
                    phoneTxtField.text = "\(mobileNo)"
                }
            }
            
            /*
             tmpDict["firstName"] = "GudduGouravTest"
             tmpDict["lastName"] = "mylastname"
             tmpDict["email"] = ""
             tmpDict["mobilePhone"] = ""
             recentOrderDictInfo["orderInfo"] = tmpDict
             */
            
        }
        /*
         if let ptpTmpDict = recentOrderDictInfo["parentTradePartner"] as? [String: Any]{
         tradePartnerNameTextField.text = "\(ptpTmpDict["name"]!)"
         selectedTradePartne = "\(ptpTmpDict["name"]!)"
         if let Id = ptpTmpDict["id"] as? Int{
         selectedTradeId = Id
         }
         
         }
         
         
         if let tpTmpDict = recentOrderDictInfo["tradePartner"] as? [String: Any]{
         tradePartnerLocationTextField.text = "\(tpTmpDict["name"]!)"
         selectedTradePartneLocation = "\(tpTmpDict["name"]!)"
         if let Id = tpTmpDict["id"] as? Int{
         selectedTradelocationId = Id
         }
         }
         
         */
        if let clientNo = recentOrderDictInfo["clientNumber"] as? String{
            tradePartnerAccountNumberTextField.text = "\(clientNo)"
        }
    }
    @objc func keyboardWillShow(aNotification:Notification) {
        let info = aNotification.userInfo! as NSDictionary
        let kbSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, (kbSize?.height)!, 0.0)
        
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = view.frame
        aRect.size.height -= (kbSize?.height)!;
        
    }
    
    @objc func keyboardWillBeHidden(aNotification:Notification)  {
        let  contentInsets = UIEdgeInsets.zero;
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is UFSPopUpViewController {
            let popUpVC = segue.destination as! UFSPopUpViewController
            popUpVC.titleString = (pickerFlag == "tradePartner") ? "Select tradepartner" : "Select tradepartner location"
            popUpVC.isSearchBarHidden = true //(sender as! UITextField) == workInTextField ? true : false
            
            popUpVC.arrayItems = (pickerFlag == "tradePartner") ?  pickerTradeData : pickerTradeDataLocation
            popUpVC.selectedItem = (pickerFlag == "tradePartner")  ? selectedTradePartne : selectedTradePartneLocation
            
            popUpVC.callBack = { selectedItemValue in
                
                //(sender as! UITextField).text = selectedItemValue
                self.pickerViewHide(selectedValue: selectedItemValue)
                
            }
            
        }else if segue.destination is DeliveryViewController {
            //showDeliverySegue
            
            let deliveryViewController = segue.destination as! DeliveryViewController
            
            var detailDictionary = [String: Any]()
            
            detailDictionary["firstName"] = self.firstNameTxtField.text
            detailDictionary["lastName"] = self.lastNameTxtField.text
            detailDictionary["email"] = self.emailTxtField.text
            detailDictionary["phone"] = self.phoneTxtField.text
            detailDictionary["toAccountNumber"] = self.tradePartnerAccountNumberTextField.text
            if WSUtility.isLoginWithTurkey(){
                deliveryViewController.OrderDictInfo = WSUser().getUserProfile().defaultAddress
            }
            else{
                if let tmpDict = recentOrderDictInfo["orderInfo"] as? [String: Any]{
                    deliveryViewController.OrderDictInfo = tmpDict
                    detailDictionary["orderInfoDict"] = tmpDict
                }
            }
            
            if let tmpDict = UserDefaults.standard.value(forKey: "userDeliveryDetails") as? [String: Any]{
                if tmpDict.count > 0{
                    deliveryViewController.OrderDictInfo = tmpDict
                }
            }
            deliveryViewController.detailDictionary = detailDictionary
            deliveryViewController.cartArr = cartArr
            deliveryViewController.totalItemsQunatity = self.totalItemsQunatity
            deliveryViewController.tradeNameTxt = self.selectedTradePartne
            deliveryViewController.childTradeNameTxt = self.selectedTradePartneLocation
            deliveryViewController.totalPrice = self.totalPrice
            deliveryViewController.earnedLoyaltyPoints = self.earnedLoyaltyPoints
            deliveryViewController.promoCode =  self.promoCode
            deliveryViewController.validPromoDict =  self.validPromoDict
            
            detailDictionary["CartArray"] = cartArr
            detailDictionary["TradePartnerName"] = selectedTradePartne
            detailDictionary["ChildTradePartnerName"] = selectedTradePartneLocation
            detailDictionary["totalPrice"] = totalPrice
            deliveryViewController.totalPriceForPayment_TR = totalPriceForPayment_TR

            detailDictionary["totalLoyaltyPointEarn"] = earnedLoyaltyPoints
            
            checkOutDetailInfoArray["MyDetailInfo"] = detailDictionary
            
            deliveryViewController.checkOutDetailInfoArray = self.checkOutDetailInfoArray
            deliveryViewController.selectedTradePatrnerId = selectedTradeId
            
        }
    }
    
    func populateUIWithLocallySavedData()  {
        
        
    }
    
    func aplyDefaultStyle(){
        

        addBorderColor(textfiled: firstNameTxtField)
        addBorderColor(textfiled: lastNameTxtField)
        addBorderColor(textfiled: emailTxtField)
        addBorderColor(textfiled: phoneTxtField)
        let countryCode =  WSUtility.getCountryCode()
        if (countryCode == "TR") && WSUser().getUserProfile().isPaymentByCreditCard == true{
            
            vwBasePaymentForTurkey.isHidden = false
            vwTopBase.isHidden = true
            if self.view.frame.width == 320{
                widthCnstHdr2.constant = 100.0
                leadingCnstHdr3.constant = 42.0
                trailingCnstHdr3.constant = 75.0
                widthCnstHdr3.constant = 68.0
                widthCnstHdr2.constant = 68.0
                leadingCnstHdr2.constant = -12.0
//                trailingCnstHdrLbl.constant = 0.0
            }
        }
        else{
            vwBasePaymentForTurkey.isHidden = true
            vwTopBase.isHidden = false
        }
        
        if WSUtility.isLoginWithTurkey(){
            let user : WSUser = WSUser().getUserProfile()
            if let str = user.taxNumber as? String, str.count > 0{
                tfBusinessTaxNum.text = str
                tfBusinessTaxNum.isUserInteractionEnabled = false
                tfBusinessTaxNum.isEnabled = false
                tfBusinessTaxNum.isOpaque = true
                
                tfBusinessTaxNum.setLeftPaddingPoints(10)
                WSUtility.UISetUpForTextField(textField: tfBusinessTaxNum, withBorderColor: UIColor.clear.cgColor)
                tfBusinessTaxNum.backgroundColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1)
                WSUtility.UISetUpForTextFieldWithImage(textField: tfBusinessTaxNum, boolValue: true)
            }
            else{
                addBorderColor(textfiled: tfBusinessTaxNum)
            }
        }
        
        addBorderColor(textfiled: tfBusinessTaxNum)
        addBorderColor(textfiled: tradePartnerNameTextField)
        addBorderColor(textfiled: tradePartnerLocationTextField)
        addBorderColor(textfiled: tradePartnerAccountNumberTextField)
        
        let email_id = UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)!
        self.emailTxtField.text = email_id as? String
        WSUtility.UISetUpForTextFieldWithImage(textField: emailTxtField, boolValue: true)
        
        firstNameTxtField.text = WSUtility.getValueFromUserDefault(key: "FirstName")
        lastNameTxtField.text = WSUtility.getValueFromUserDefault(key: "LastName")
        phoneTxtField.text = WSUtility.getValueFromUserDefault(key: "mobileNo")

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyDetailViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        myDetailProcessLbl.text = WSUtility.getlocalizedString(key: "My Detail", lang: WSUtility.getLanguage(), table: "Localizable")
        deliveryProcessLbl.text = WSUtility.getlocalizedString(key: "Delivery", lang: WSUtility.getLanguage(), table: "Localizable")
        summaryProcessLbl.text = WSUtility.getlocalizedString(key: "Summary", lang: WSUtility.getLanguage(), table: "Localizable")
        
        //errors
        
        emailErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter your e-mail address.", lang: WSUtility.getLanguage(), table: "Localizable")
        firstNameErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter your first name.", lang: WSUtility.getLanguage(), table: "Localizable")
        lastNameErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter your last name.", lang: WSUtility.getLanguage(), table: "Localizable")
        phoneNoErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter your valid phone number.", lang: WSUtility.getLanguage(), table: "Localizable")
        //tpnameErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter trade partner name.", lang: WSUtility.getLanguage(), table: "Localizable")
        tpLocationErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter trade partner location.", lang: WSUtility.getLanguage(), table: "Localizable")
        tpAccountErrorLbl.text = WSUtility.getlocalizedString(key: "Enter Your Trade Partner Account Number", lang: WSUtility.getLanguage(), table: "Localizable")
        errorLblBusinesstaxNum.text = WSUtility.getlocalizedString(key: "Please enter all mandatory fields first", lang: WSUtility.getLanguage(), table: "Localizable")
        
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "lock.png"), for: UIControlState.normal)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
          
    }
    
    func addBorderColor(textfiled: UITextField){
        textfiled.setLeftPaddingPoints(10)
        WSUtility.UISetUpForTextField(textField: textfiled, withBorderColor: unselectedTextFieldBorderColor)
    }
    
    @IBAction func continueShoping(_ sender: Any) {
        tabBarController?.selectedIndex = 2
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    @IBAction func tradePartnerLocationClicked(_ sender: Any) {
        pickerFlag = "tradePartnerLocation"
        // ContentPickerView.isHidden = false
        // self.picker.reloadAllComponents()
        firstNameTxtField.resignFirstResponder()
        lastNameTxtField.resignFirstResponder()
        phoneTxtField.resignFirstResponder()
        let countryCode =  WSUtility.getCountryCode()
        if countryCode == "TR"{
            tfBusinessTaxNum.resignFirstResponder()
        }

        tradePartnerAccountNumberTextField.resignFirstResponder()
        if pickerTradeDataLocation.count > 0{
            performSegue(withIdentifier: "ShowCustomPopSegue", sender: sender)
        }else{
            WSUtility.showAlertWith(message: WSUtility.getlocalizedString(key: "No trade partner location available for selected trade partner", lang: WSUtility.getLanguage())!, title: "", forController: self)
        }
        
    }
    
    @IBAction func nextStepClicked(_ sender: Any) {
        let phoneNumber = phoneTxtField.text!
        let business = tfBusinessTaxNum.text!
        var isFieldsEmpty: Bool = false
        let firstName: String? = firstNameTxtField.text
        let lastName: String? = lastNameTxtField.text
        let tpName: String? = tradePartnerNameTextField.text
        let tpLocation : String? = tradePartnerLocationTextField.text
        let tpAccount : String? = tradePartnerAccountNumberTextField.text
        let is_dto_operator = UserDefaults.standard.bool(forKey: DTO_OPERATOR)
        
        if firstName == "" {
            self.showhideErrorLabels(textField: firstNameTxtField,errorTextLabel: firstNameErrorLbl)
            WSUtility.UISetUpForTextFieldWithImage(textField: firstNameTxtField, boolValue: true)
            isFieldsEmpty = true
        }
        
        if lastName == "" {
            self.showhideErrorLabels(textField: lastNameTxtField,errorTextLabel: lastNameErrorLbl)
            WSUtility.UISetUpForTextFieldWithImage(textField: lastNameTxtField, boolValue: true)
            isFieldsEmpty = true
        }
        
        if phoneNumber == "" || !phoneNumber.isPhoneNumber {
            
            UISetUpForPhoneTextFieldWithImage(textField: phoneTxtField, boolValue: true)
            isFieldsEmpty = true
        }
        let countryCode =  WSUtility.getCountryCode()
        if countryCode == "TR"{
            if business == ""{
                UISetUpForBusinessTaxNumTextFieldWithImage(textField: tfBusinessTaxNum, boolValue: true)
                isFieldsEmpty = true
            }
        }

        if tpName == "" && !is_dto_operator{
              //  self.showhideErrorLabels(textField: tradePartnerNameTextField,errorTextLabel: tpnameErrorLbl)
                WSUtility.UISetUpForTextFieldWithImage(textField: tradePartnerNameTextField, boolValue: true)
                tradePartnerNameTextField.rightView?.isHidden = true
                isFieldsEmpty = true
        }
        
        if tpLocation == "" && !is_dto_operator{
                self.showhideErrorLabels(textField: tradePartnerLocationTextField,errorTextLabel: tpLocationErrorLbl)
                WSUtility.UISetUpForTextFieldWithImage(textField: tradePartnerLocationTextField, boolValue: true)
                tradePartnerLocationTextField.rightView?.isHidden = true
                isFieldsEmpty = true
        }
        if tpAccount == "" && !is_dto_operator{
                self.showhideErrorLabels(textField: tradePartnerAccountNumberTextField,errorTextLabel: tpAccountErrorLbl)
                WSUtility.UISetUpForTextFieldWithImage(textField: tradePartnerAccountNumberTextField, boolValue: true)
                tradePartnerAccountNumberTextField.rightView?.isHidden = true
                isFieldsEmpty = true
        }
        
        if !isFieldsEmpty{
            submitTradePartnerData()
        }
    }
    
    func UISetUP()  {
        WSUtility.addNavigationBarBackButton(controller: self)
        
        MyDetailsLabel_1.text = "1. \(WSUtility.getlocalizedString(key: "My details", lang: WSUtility.getLanguage(), table: "Localizable")!)"
        myDetailsLabel.text = WSUtility.getlocalizedString(key: "My details", lang: WSUtility.getLanguage(), table: "Localizable")
        myTradePartnerDetails.text = WSUtility.getlocalizedString(key: "My trade partner", lang: WSUtility.getLanguage(), table: "Localizable")
        checkoutLabel.text = "\(WSUtility.getlocalizedString(key: "Checkout", lang: WSUtility.getLanguage(), table: "Localizable")!)"
        checkoutLabel_turkey.text = WSUtility.getlocalizedString(key: "Checkout", lang: WSUtility.getLanguage(), table: "Localizable")
        //continueButton.setTitle(WSUtility.getlocalizedString(key: "Continue Shopping", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        let attributeString = NSMutableAttributedString(string: (WSUtility.getlocalizedString(key: "Continue Shopping", lang: WSUtility.getLanguage(), table: "Localizable"))!,
                                                        attributes: underlineAttributes)
        continueButton.setAttributedTitle(attributeString, for: .normal)
        nextButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nextButton.setTitle(WSUtility.getlocalizedString(key: "Next Step", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        emailTxtField.placeholder = WSUtility.getlocalizedString(key: "Email", lang: WSUtility.getLanguage(), table: "Localizable")
        firstNameTxtField.placeholder = WSUtility.getlocalizedString(key: "First Name", lang: WSUtility.getLanguage(), table: "Localizable")
        lastNameTxtField.placeholder = WSUtility.getlocalizedString(key: "Surname", lang: WSUtility.getLanguage(), table: "Localizable")
        phoneTxtField.placeholder = WSUtility.getlocalizedString(key: "Mobile Phone", lang: WSUtility.getLanguage(), table: "Localizable")
        let countryCode =  WSUtility.getCountryCode()
        if countryCode == "TR"{
            tfBusinessTaxNum.placeholder = WSUtility.getlocalizedString(key: "Business Tax Number", lang: WSUtility.getLanguage(), table: "Localizable")
        }
        tradePartnerNameTextField.placeholder = WSUtility.getlocalizedString(key: "Trade partner", lang: WSUtility.getLanguage(), table: "Localizable")
        
        tradePartnerLocationTextField.placeholder = WSUtility.getlocalizedString(key: "Trade partner location", lang: WSUtility.getLanguage(), table: "Localizable")
        tradePartnerAccountNumberTextField.placeholder = WSUtility.getlocalizedString(key: "Account number", lang: WSUtility.getLanguage(), table: "Localizable")
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerFlag == "tradePartner"){
            return pickerTradeData.count
        }else{
            return pickerTradeDataLocation.count
        }
        
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerFlag == "tradePartner"){
            selectedTradePartne = pickerTradeData[row]
            return pickerTradeData[row]
        }else{
            selectedTradePartneLocation = pickerTradeDataLocation[row]
            return pickerTradeDataLocation[row]
        }
        
    }
    
    @IBAction func tradePartnerClicked(_ sender: Any) {
        
        pickerFlag = "tradePartner"
        //ContentPickerView.isHidden = false
        //self.picker.reloadAllComponents()
        firstNameTxtField.resignFirstResponder()
        lastNameTxtField.resignFirstResponder()
        phoneTxtField.resignFirstResponder()
        tradePartnerAccountNumberTextField.resignFirstResponder()
        
        if pickerTradeData.count > 0{
            performSegue(withIdentifier: "ShowCustomPopSegue", sender: sender)
        }
    }
    
    @IBAction func doneToolbarClicked(_ sender: Any) {
        //pickerViewHide()
    }
    
    func pickerViewHide(selectedValue:String){
        if(pickerFlag == "tradePartner"){
            //ContentPickerView.isHidden = true
            selectedTradePartne = selectedValue
            tradePartnerNameTextField.text = "\(selectedTradePartne)"
            textDidchange(tradePartnerNameTextField)
            tradePartnerNameTextField.rightView?.isHidden = true
            if WSUtility.isLoginWithTurkey(){
                self.tradeLocationFromVendorList_TR()
            }
            else{
                self.trade_location_request()
            }
        }else{
            // ContentPickerView.isHidden = true
            selectedTradePartneLocation = selectedValue
            tradePartnerLocationTextField.text = "\(selectedTradePartneLocation)"
            textDidchange(tradePartnerLocationTextField)
            tradePartnerLocationTextField.rightView?.isHidden = true
        }
        
        
    }
    
    func trade_request() {
        
        UFSProgressView.showWaitingDialog("")
        let myTradePartnerId = WSUtility.getValueFromUserDefault(key: TRADE_PARTNER_ID)
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.getTradePartenersList(successResponse: { (response) in
            if let trades = response as? [[String: Any]]{
                self.pickerTradeData.removeAll()
                var isTradePartnerIdMatched = false
                var myTradePartnerName = ""
                for tDict in trades {
                    // print(tDict)
                    let tName = tDict["name"] as? String
                    let tId = tDict["id"]
                    self.pickerTradeData.append(tName!)
                    self.pickerTradeId.append(tId! as AnyObject)
                    
                    if Int(myTradePartnerId) == (tId as! Int) {
                        isTradePartnerIdMatched = true
                        myTradePartnerName = tName!
                    }
                }
                if isTradePartnerIdMatched {
                    self.pickerViewHide(selectedValue: myTradePartnerName)
                }
            }
            
            UFSProgressView.stopWaitingDialog()
            
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        }
        
    }
    
    func getVendorList(){
        UFSProgressView.showWaitingDialog("")
        let businesslayer =  WSWebServiceBusinessLayer()
        businesslayer.getVendorsList(successResponse: { (response) in
            UFSProgressView.stopWaitingDialog()
            
            let myTradePartnerId = WSUtility.getValueFromUserDefault(key: TRADE_PARTNER_ID)
            if let vendorList = response["vendorList"] as? [[String: Any]]{
                
                var filteredArray: [[String: Any]] = []
                
                for dict in vendorList{
                    
                    if let tmpArry = dict["vendorAddress"] as? [[String: Any]], tmpArry.count > 0{
                        
                        for dict1 in tmpArry{
                            if let valueStr = dict1["town"] as? String, valueStr.uppercased() == WSUser().getUserProfile().tradePartnerCity.uppercased(){
                                filteredArray.append(dict)
                            }
                        }
                    }
                }
                
                self.vendorList_TR = filteredArray
                self.pickerTradeData.removeAll()
                var isTradePartnerIdMatched = false
                var myTradePartnerName = ""
                for tDict in self.vendorList_TR {
                    
                    let tName = tDict["name"] as? String
                    let tId = tDict["code"]
                    self.pickerTradeData.append(tName!)
                    self.pickerTradeId.append(tId! as AnyObject)
                    
                    if "\(myTradePartnerId)" == "\(tId!)" {
                        isTradePartnerIdMatched = true
                        myTradePartnerName = tName!
                    }
                }
                if isTradePartnerIdMatched {
                    self.pickerViewHide(selectedValue: myTradePartnerName)
                }
                self.getUserProfileFromHybrisFor_TR()
            }
            
            
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        }
    }
    
    func getUserTradePartnerProfile()  {
        
        UFSProgressView.showWaitingDialog("")
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.getUserProfile(parameter: [String:Any](), methodName: GET_PROFILE_API, successResponse: { (response) in
            if let clientNo = response["clientNumber"] as? String{
                self.tradePartnerAccountNumberTextField.text = clientNo
            }
            
            if let tradePartnerLocation = response["tradePartner"] as? [String:Any]{
                
                if let tradePartnerLocationName = tradePartnerLocation["name"]{
                    self.tempTradePartnerLocation = (tradePartnerLocationName as? String)!
                    //self.selectedTradePartneLocation = tradePartnerLocationName as? String
                }
            }
            
            self.trade_request()
            
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
            self.trade_request()
        }
    }
    
    func getUserProfileFromHybrisFor_TR()  {
        
        UFSProgressView.showWaitingDialog("")
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        
        serviceBussinessLayer.getBasicUserProfileFromHybrisForTurkey(parameter: [String:Any](), methodName: GET_PROFILE_API_HYBRIS_TR, successResponse: { (response) in
            
            UFSProgressView.stopWaitingDialog()
            
            if let defaultAddress = response["defaultAddress"] as? [String : Any]{
                var tmpDict: [String: Any] = defaultAddress
                tmpDict["operatorBusinessName"] = "\(response["operatorBusinessName"] as? String ?? "")"
                UserDefaults.standard.set(tmpDict, forKey: "defaultAddress")
            }
            
            if let array = response["myProfileVendorsList"] as? [[String : Any]]{
                let tpPredicate = NSPredicate(format: "isDefault = true")
                let filterArray = array.filter { tpPredicate.evaluate(with: $0) }
                if filterArray.count > 0{
                    print("Matched")
                    let dict = filterArray[0]
                   self.tradePartnerAccountNumberTextField.text = "\(dict["customerNumber"] ?? "")"
                    
                    if let vendor = dict["assignedVendor"] as? [String: Any]{
                        if let locations = vendor["vendorAddress"] as? [[String: Any]]{
                            var tmpArray: [[String: Any]] = []
                            for tmpDict in locations{
                                if let valueStr = tmpDict["town"] as? String, valueStr.uppercased() == WSUser().getUserProfile().tradePartnerCity.uppercased(){
                                    tmpArray.append(tmpDict)
                                }
                            }
                            self.pickerTradeDataLocation = tmpArray.map({$0["locationName"]! as! String})
                            self.pickerTradeLocationId = tmpArray.map({$0["locationId"]! as AnyObject})
                        }
                    }
                    
                    if let locationDict = dict["assignedVendorAddress"] as? [String: Any]{
                        self.tradePartnerLocationTextField.text = "\(locationDict["locationName"] ?? "")"
                        self.selectedTradePartneLocation = self.tradePartnerLocationTextField.text!
                    }
                }
            }
            
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
            
        }
        
    }
    
    func getTradeListOrVendorList(){
        if WSUtility.isLoginWithTurkey(){
            self.getVendorList()
        }
        else{
            getUserTradePartnerProfile()
        }
    }
    func tradeLocationFromVendorList_TR(){
        
        self.pickerTradeDataLocation.removeAll()
        self.pickerTradeLocationId.removeAll()
        self.selectedTradePartneLocation = ""
        self.tradePartnerLocationTextField.text = ""
        
        let indexVal = pickerTradeData.index(of: selectedTradePartne)
        selectedTradeId = "\(pickerTradeId[indexVal!])"
        
        for dict in vendorList_TR{
            if let tradeId = dict["code"]{
                
                if "\(tradeId)" == "\(selectedTradeId)"{
                    if let locations = dict["vendorAddress"] as? [[String: Any]]{
                        
                        var tmpArray: [[String: Any]] = []
                        for tmpDict in locations{
                            if let valueStr = tmpDict["town"] as? String, valueStr.uppercased() == WSUser().getUserProfile().tradePartnerCity.uppercased(){
                                tmpArray.append(tmpDict)
                            }
                        }
                        
                        pickerTradeDataLocation = tmpArray.map({$0["locationName"]! as! String})
                        pickerTradeLocationId = tmpArray.map({$0["locationId"]! as AnyObject})
                        
                    }
                    break;
                }
            }
            
        }
    
    }
    func trade_location_request(){
        UFSProgressView.showWaitingDialog("")
        
        let webServiceBusinessLayer = WSWebServiceBusinessLayer()
        var paramsDictionary = [String: Any]()
        for index in 1...pickerTradeData.count {
            if(selectedTradePartne == pickerTradeData[index-1]){
                selectedTradeId = "\(pickerTradeId[index-1])"
            }
        }
        paramsDictionary["tradePartnerId"] = "\(selectedTradeId)"
        webServiceBusinessLayer.getTradePartnerLocation(parameter: paramsDictionary, methodName: GET_TRADEPARTNERS_LOCATIONS, successResponse: { (response) in
            print("response :%@",response)
            UFSProgressView.stopWaitingDialog()
            self.pickerTradeDataLocation.removeAll()
            self.pickerTradeLocationId.removeAll()
            self.selectedTradePartneLocation = ""
            self.tradePartnerLocationTextField.text = ""
            
            if response.count > 0 {
                for index in 1...response.count {
                    let responseDict = response[index-1] as! [NSString:AnyObject]
                    let name = responseDict["name"]! as! String
                    let tlId = responseDict["id"]
                    self.pickerTradeDataLocation.append(name as String)
                    self.pickerTradeLocationId.append(tlId! as AnyObject)
                }
            if !self.pickerTradeDataLocation.contains(self.tempTradePartnerLocation){
                self.tempTradePartnerLocation = ""
            }
                self.selectedTradePartneLocation = self.tempTradePartnerLocation == "" ?self.pickerTradeDataLocation[0]:self.tempTradePartnerLocation
                self.tempTradePartnerLocation = "" // resetting the value
                self.tradePartnerLocationTextField.text = self.selectedTradePartneLocation
                self.showhideErrorLabels(textField: self.tradePartnerLocationTextField,errorTextLabel: self.tpLocationErrorLbl)
                WSUtility.UISetUpForTextFieldWithImage(textField: self.tradePartnerLocationTextField, boolValue: true)
                self.tradePartnerLocationTextField.rightView?.isHidden = true
            }
        }) { (errorMessage) in
            print("error")
            UFSProgressView.stopWaitingDialog()
        }
    }
    
    
    func submitTradePartnerData(){
        UFSProgressView.showWaitingDialog("")
        
        for index in 1...pickerTradeData.count {
            if(selectedTradePartne == pickerTradeData[index-1]){
                selectedTradeId = "\(pickerTradeId[index-1])"
            }
        }
        if pickerTradeDataLocation.count > 0{
            for index in 1...pickerTradeDataLocation.count {
                if(selectedTradePartneLocation == pickerTradeDataLocation[index-1]){
                    selectedTradelocationId = "\(pickerTradeLocationId[index-1])"
                }
            }
        }
        
        saveUserBasicInfo()
    }
    
    func saveUserBasicInfo()  {
        
        //if  let loadCart : HYBCart = backendService.currentCartFromCache(){
        let cartId = UFSHybrisUtility.uniqueCartId
        let email_id = UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)!
        var tempUrl: String = ""
        if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
            self.performSegue(withIdentifier: "showDeliverySegue", sender: self)
            return
        }
        else{
            tempUrl = "users/\(email_id)/carts/\(cartId)/vendorDetail?vendorId=\(selectedTradeId)&vendorName=\(selectedTradePartne)&vendorLocId=\(selectedTradelocationId)&vendorLocName=\(selectedTradePartneLocation)&vendorAccountNumber=\(tradePartnerAccountNumberTextField.text! as String)"
        }
        
        if let encoded = tempUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let _ = URL(string: encoded) {
            
            let webServiceBusinessLayer = WSWebServiceBusinessLayer()
            webServiceBusinessLayer.settradePartner(productID: encoded, successResponse: { (response) in
                print("response code:%@",response)
                UFSProgressView.stopWaitingDialog()
                self.performSegue(withIdentifier: "showDeliverySegue", sender: self)
            }) { (errorMessage) in
                print("error")
                UFSProgressView.stopWaitingDialog()
                self.performSegue(withIdentifier: "showDeliverySegue", sender: self)
                
            }
        }
        
        // }
        
    }
    
    //MARK: Get Cart From Backend
    func retriveCurrentCart(){
        let addToCartBussinessLogic = WSAddToCartBussinessLogic()
        addToCartBussinessLogic.getCartDetail(forController: self)
        self.saveUserBasicInfo()
    }
    
    func UISetUpForPhoneTextFieldWithImage(textField:UITextField ,boolValue: Bool)  {
        
        if boolValue == true {
            
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 50))
            let checkedImage: UIImageView = UIImageView()
            checkedImage.frame = CGRect(x: 0, y: 17.5, width: 15, height: 15)
            checkedImage.contentMode = .scaleAspectFit
            
            if textField.text!.isPhoneNumber{
                checkedImage.image = #imageLiteral(resourceName: "checked_Icon")
                textField.layer.borderColor = unselectedTextFieldBorderColor
                phoneNoErrorLbl.isHidden = true
            }
            else{
                checkedImage.image = #imageLiteral(resourceName: "error_icon")
                textField.layer.borderColor = selectedTextFieldBorderColor
                phoneNoErrorLbl.isHidden = false
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

func UISetUpForBusinessTaxNumTextFieldWithImage(textField:UITextField ,boolValue: Bool)  {
    
    if boolValue == true {
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 50))
        let checkedImage: UIImageView = UIImageView()
        checkedImage.frame = CGRect(x: 0, y: 17.5, width: 15, height: 15)
        checkedImage.contentMode = .scaleAspectFit
        
        if textField.text! == ""{
            checkedImage.image = #imageLiteral(resourceName: "error_icon")
            textField.layer.borderColor = selectedTextFieldBorderColor
            errorLblBusinesstaxNum.isHidden = false
        }
        else{
            checkedImage.image = #imageLiteral(resourceName: "checked_Icon")
            textField.layer.borderColor = unselectedTextFieldBorderColor
            errorLblBusinesstaxNum.isHidden = true
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
}


extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
extension MyDetailViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            
        case firstNameTxtField:
            lastNameTxtField.becomeFirstResponder()
        case lastNameTxtField:
            phoneTxtField.becomeFirstResponder()
        case phoneTxtField:
            let countryCode =  WSUtility.getCountryCode()
            if countryCode == "TR"{
                tfBusinessTaxNum.becomeFirstResponder()
            }

        default:
            textField.resignFirstResponder()
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == phoneTxtField{
            UISetUpForPhoneTextFieldWithImage(textField: phoneTxtField, boolValue: true)
        }
        let countryCode =  WSUtility.getCountryCode()
        if countryCode == "TR"{
            if textField == tfBusinessTaxNum{
                UISetUpForBusinessTaxNumTextFieldWithImage(textField: tfBusinessTaxNum, boolValue: true)
            }
        }

    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var allowedLength: Int?
        switch textField {
        case tradePartnerAccountNumberTextField:
            allowedLength = 12
        default:
            return true
        }
        let nsString = NSString(string: textField.text!)
        if nsString.length >= allowedLength! && range.length == 0 {
            return false
        }
        else{
            return true
        }
    }
    @IBAction func textDidchange(_ textField: UITextField){
        switch textField {
        case firstNameTxtField:
            self.showhideErrorLabels(textField: textField,errorTextLabel: firstNameErrorLbl)
            WSUtility.UISetUpForTextFieldWithImage(textField: firstNameTxtField, boolValue: true)
        case lastNameTxtField:
            self.showhideErrorLabels(textField: textField,errorTextLabel: lastNameErrorLbl)
            WSUtility.UISetUpForTextFieldWithImage(textField: lastNameTxtField, boolValue: true)
        case phoneTxtField:
            self.showhideErrorLabels(textField: textField,errorTextLabel: phoneNoErrorLbl)
            WSUtility.UISetUpForTextFieldWithImage(textField: phoneTxtField, boolValue: true)
        case tradePartnerNameTextField:
            //self.showhideErrorLabels(textField: tradePartnerNameTextField,errorTextLabel: tpnameErrorLbl)
            WSUtility.UISetUpForTextFieldWithImage(textField: tradePartnerNameTextField, boolValue: true)
        case tradePartnerLocationTextField:
            self.showhideErrorLabels(textField: textField,errorTextLabel: tpLocationErrorLbl)
            WSUtility.UISetUpForTextFieldWithImage(textField: tradePartnerLocationTextField, boolValue: true)
        case tradePartnerAccountNumberTextField:
            self.showhideErrorLabels(textField: textField,errorTextLabel: tpAccountErrorLbl)
            WSUtility.UISetUpForTextFieldWithImage(textField: tradePartnerAccountNumberTextField, boolValue: true)
        default:
            break
        }
    }
    func showhideErrorLabels(textField:UITextField, errorTextLabel: UILabel){
        
        if textField.text != "" {
            errorTextLabel.isHidden = true
        }
        else{
            errorTextLabel.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews(){
        vwTopBase.dropShadowForCheckout()
        vwMyDetailsBase.dropTopAndBottomShadow()
        vwMyTradePartnerBase.dropTopAndBottomShadow()
        vwBottomBase.dropTopShadow()
        let countryCode =  WSUtility.getCountryCode()
        if countryCode == "TR"
        {
            htCnstBusTaxNum.constant = 50.0
            htConstBusTaxErrLbl.constant = 17.0
            btmCnstBusTaxErrLbl.constant = 22.0
            htCnstMyDetailsBase.constant = 415.0
        }
        else{
            htCnstBusTaxNum.constant = 0.0
            htConstBusTaxErrLbl.constant = 0.0
            htCnstBusTaxNum.constant = 0.0
            htCnstMyDetailsBase.constant = 315.0
            vwMyDetailsBase.frame.size.height = 315.0
        }
        

        print(vwTopBase.frame.size.height, vwMyDetailsBase.frame.size.height, vwMyTradePartnerBase.frame.size.height, vwBottomBase.frame.size.height)
    }
}
