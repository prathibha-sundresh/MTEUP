//
//  DeliveryViewController.swift
//  yB2CApp
//
//  Created by Ajay on 29/11/17.
//

import UIKit

class DeliveryViewController: UIViewController, UITextFieldDelegate {
  var totalPriceForPayment_TR = ""
  
  @IBOutlet weak var vwBasePayment: UIView!
  @IBOutlet weak var trailingCnstHdr2: NSLayoutConstraint!
  @IBOutlet weak var leadingConstHdr3: NSLayoutConstraint!
  @IBOutlet weak var leadingConstHdr2: NSLayoutConstraint!
  @IBOutlet weak var widthCnstHdr2: NSLayoutConstraint!
  @IBOutlet weak var widthCnstHdr3: NSLayoutConstraint!
  @IBOutlet weak var widthCnstHdr1: NSLayoutConstraint!
  @IBOutlet weak var vwTopBase: UIView!
  @IBOutlet weak var vwDeliveryAddressBase: UIView!
  @IBOutlet weak var vwCalenderVwBase: UIView!
  @IBOutlet weak var vwBottomBase: UIView!
  @IBOutlet weak var nextStepButton: WSDesignableButton!
  @IBOutlet weak var backToDetails: UIButton!
  @IBOutlet weak var orderAddedNextDelivery: UILabel!
  @IBOutlet weak var checkOutLabel: UILabel!
    @IBOutlet weak var checkoutLabel_Turkey: UILabel!
    @IBOutlet weak var deliveryAddresslabel: UILabel!
  @IBOutlet weak var deliveredByLabel: UILabel!
  @IBOutlet weak var billingAddressSameLabel: UILabel!
  @IBOutlet weak var billingAddresslabel: UILabel!
  @IBOutlet weak var businessName: UITextField!
  @IBOutlet weak var houseNumberTxtField: UITextField!
  @IBOutlet weak var streetTxtField: UITextField!
  @IBOutlet weak var postelCodeTxtField: UITextField!
  @IBOutlet weak var cityTextField: UITextField!
  @IBOutlet weak var billingBusinessTxtField: UITextField!
  @IBOutlet weak var billingHouseTxtField: UITextField!
  @IBOutlet weak var billingStreetTextField: UITextField!
  @IBOutlet weak var billingCityTextField: UITextField!
  @IBOutlet weak var billingPostelTextField: UITextField!
  @IBOutlet weak var myDetailProcessLbl: UILabel!
  @IBOutlet weak var deliveryProcessLbl: UILabel!
  @IBOutlet weak var summaryProcessLbl: UILabel!
  @IBOutlet weak var scrollView: UIScrollView!
  
  var validPromoDict: [String: Any] = [:]
  // delivery errors
  @IBOutlet weak var deliveryCompanyNameErrorLbl: UILabel!
  @IBOutlet weak var deliveryHouseNoErrorLbl: UILabel!
  @IBOutlet weak var deliveryStreetErrorLbl: UILabel!
  @IBOutlet weak var deliveryCityErrorLbl: UILabel!
  @IBOutlet weak var deliveryPostalCodeErrorLbl: UILabel!
  
  // billing errors
  @IBOutlet weak var billingCompanyNameErrorLbl: UILabel!
  @IBOutlet weak var billingHouseNoErrorLbl: UILabel!
  @IBOutlet weak var billingStreetErrorLbl: UILabel!
  @IBOutlet weak var billingCityErrorLbl: UILabel!
  @IBOutlet weak var billingPostalCodeErrorLbl: UILabel!
  @IBOutlet weak var MyDeliveryLabel_2: UILabel!
  var OrderDictInfo: [String: Any] = [:]
  @IBOutlet weak var deliveryNotesTextView: FloatLabelTextView!{
    didSet{
      deliveryNotesTextView.layer.borderWidth = 1.0
      deliveryNotesTextView.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
      deliveryNotesTextView.layer.cornerRadius = 5.0
      deliveryNotesTextView.clipsToBounds = true
    }
  }
  @IBOutlet weak var checkboxBtn: UIButton!
  @IBOutlet weak var calanderButton: UIButton!
  
  var totalItemsQunatity: Int = 0
  
  var sameBilling = 0
  var detailDictionary = [String: Any]()
  var cartArr: [String] = [String]()
  var addressDictionary = [String: Any]()
  var billingAddressDictionary = [String: Any]()
  var tradeNameTxt = ""
  var childTradeNameTxt = ""
  var totalPrice = ""
  var earnedLoyaltyPoints = ""
  var promoCode = ""
  //var backendService:HYBB2CService = (UIApplication.shared.delegate as! HYBAppDelegate).backEndService
  var checkOutDetailInfoArray = [String:Any]()
  var deliveryDate = ""
  var summaryDate = ""
  var selectedTradePatrnerId = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    UFSGATracker.trackScreenViews(withScreenName: "Checkout Delivery Screen")
    self.calanderButton.backgroundColor = .clear
    self.calanderButton.layer.cornerRadius = 5
    self.calanderButton.layer.borderWidth = 1
    self.calanderButton.layer.borderColor = UIColor.lightGray.cgColor
    
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeliveryViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
    //        let tapOutTextView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeliveryViewController.commentTextViewChanged))
    //        self.deliveryNotesTextView.addGestureRecognizer(tapOutTextView)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    applyDefaultStyle()
    // updateDataWithUI()
    getUserDetailsFromSifu()
    
    //        deliveryDate = formatter.string(from: Date())
  }
  
  override func viewWillAppear(_ animated: Bool) {
    WSUtility.addNavigationBarBackToCartButton(controller:self)
  }
  
  func updateDataWithUI(){
    
    if UserDefaults.standard.value(forKey: "userDeliveryDetails") == nil && WSUtility.isLoginWithTurkey(){
        setAddressValuesForTurkey(tmpDict: OrderDictInfo)
        return
    }
    
    if let str = OrderDictInfo["deliveryNotes"] as? String{
        deliveryNotesTextView.text = str
    }
    if let str = OrderDictInfo["deliveryDate"] as? String{
        summaryDate = str
        getSelectedDate(dateStr: str)
    }
    if let tmpDict = OrderDictInfo["billingAddress"] as? [String: Any]{
      if let name = tmpDict["businessName"] as? String{
        businessName.text = "\(name)"
      }
      if let hNo = tmpDict["houseNumber"] as? String{
        houseNumberTxtField.text = "\(hNo)"
      }
      if let name = tmpDict["street"] as? String{
        streetTxtField.text = "\(name)"
      }
      if let name = tmpDict["city"] as? String{
        cityTextField.text = "\(name)"
      }
      if let code = tmpDict["zipCode"] as? String{
        postelCodeTxtField.text = "\(code)"
      }
    }
    if let tmpDict = OrderDictInfo["shippingAddress"] as? [String: Any]{
      if let name = tmpDict["businessName"] as? String{
        billingBusinessTxtField.text = "\(name)"
      }
      if let hNo = tmpDict["houseNumber"] as? String{
        billingHouseTxtField.text = "\(hNo)"
      }
      if let name = tmpDict["street"] as? String{
        billingStreetTextField.text = "\(name)"
      }
      if let name = tmpDict["city"] as? String{
        billingCityTextField.text = "\(name)"
      }
      if let code = tmpDict["zipCode"] as? String{
        billingPostelTextField.text = "\(code)"
      }
    }
    
    //        if let name = OrderDictInfo["deliveryNotes"] as? String{
    //            deliveryNotesTextView.text = "\(name)"
    //        }
    //
    ////        if let date = OrderDictInfo["deliveryDate"] as? String{
    ////            billingBusinessTxtField.text = "\(date)"
    ////        }
    
    if UserDefaults.standard.bool(forKey: "isFromSummary"){
      checkBoxClicked(checkboxBtn)
    }
  }
  
    func setAddressValuesForTurkey(tmpDict: [String: Any]){
        
        if let name = tmpDict["operatorBusinessName"] as? String{
            businessName.text = "\(name)"
        }
        if let hNo = tmpDict["line1"] as? String{
            houseNumberTxtField.text = "\(hNo)"
        }
        if let name = tmpDict["line2"] as? String{
            streetTxtField.text = "\(name)"
        }
        if let name = tmpDict["town"] as? String{
            cityTextField.text = "\(name)"
        }
        if let code = tmpDict["postalCode"] as? String{
            postelCodeTxtField.text = "\(code)"
        }
        if let shippingAddressBool = tmpDict["shippingAddress"] as? Bool, shippingAddressBool == true{
            checkBoxClicked(checkboxBtn)
        }
        
    }
    
  func applyDefaultStyle(){
    
    let countryCode =  WSUtility.getCountryCode()
    if (countryCode == "TR") && WSUser().getUserProfile().isPaymentByCreditCard == true{
        
      vwBasePayment.isHidden = false
      vwTopBase.isHidden = true
      if self.view.frame.width == 320{
        widthCnstHdr1.constant = 68.0
        widthCnstHdr3.constant = 68.0
        leadingConstHdr2.constant = 80.0
        leadingConstHdr3.constant = 12.0
        trailingCnstHdr2.constant = 20.0
      }
    }
    else{
      vwBasePayment.isHidden = true
      vwTopBase.isHidden = false
    }
    MyDeliveryLabel_2.text = "2. \(WSUtility.getlocalizedString(key: "Delivery", lang: WSUtility.getLanguage(), table: "Localizable")!)"
    deliveryCompanyNameErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter the name of your company.", lang: WSUtility.getLanguage(), table: "Localizable")
    deliveryHouseNoErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter your house number.", lang: WSUtility.getLanguage(), table: "Localizable")
    deliveryStreetErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter your street.", lang: WSUtility.getLanguage(), table: "Localizable")
    deliveryCityErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter your location.", lang: WSUtility.getLanguage(), table: "Localizable")
    deliveryPostalCodeErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter your postal code.", lang: WSUtility.getLanguage(), table: "Localizable")
    
    billingCompanyNameErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter the name of your company.", lang: WSUtility.getLanguage(), table: "Localizable")
    billingHouseNoErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter your house number.", lang: WSUtility.getLanguage(), table: "Localizable")
    billingStreetErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter your street.", lang: WSUtility.getLanguage(), table: "Localizable")
    billingCityErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter your location.", lang: WSUtility.getLanguage(), table: "Localizable")
    billingPostalCodeErrorLbl.text = WSUtility.getlocalizedString(key: "Please enter your postal code.", lang: WSUtility.getLanguage(), table: "Localizable")
    
    addBorderColor(textfiled: businessName)
    addBorderColor(textfiled: houseNumberTxtField)
    addBorderColor(textfiled: streetTxtField)
    addBorderColor(textfiled: cityTextField)
    addBorderColor(textfiled: postelCodeTxtField)
    
    addBorderColor(textfiled: billingBusinessTxtField)
    addBorderColor(textfiled: billingHouseTxtField)
    addBorderColor(textfiled: billingStreetTextField)
    addBorderColor(textfiled: billingCityTextField)
    addBorderColor(textfiled: billingPostelTextField)
    
    checkOutLabel.text = WSUtility.getlocalizedString(key: "Checkout", lang: WSUtility.getLanguage(), table: "Localizable")
    checkoutLabel_Turkey.text = WSUtility.getlocalizedString(key: "Checkout", lang: WSUtility.getLanguage(), table: "Localizable")
    deliveryAddresslabel.text = WSUtility.getlocalizedString(key: "Delivery Address", lang: WSUtility.getLanguage(), table: "Localizable")
    billingAddressSameLabel.text = WSUtility.getlocalizedString(key: "Billing address is the same as delivery address.", lang: WSUtility.getLanguage(), table: "Localizable")
    billingAddresslabel.text = WSUtility.getlocalizedString(key: "Billing Address", lang: WSUtility.getLanguage(), table: "Localizable")
    
    /*
     var tradePartnerName : String = ""
     if let name = UserDefaults.standard.value(forKey: "tradePartnerName"){
     tradePartnerName = " " + "\(name)"
     }
     */
    
    
    if tradeNameTxt.count == 0{
      if let name = UserDefaults.standard.value(forKey: "tradePartnerName"){
        tradeNameTxt = " " + "\(name)"
      }
    }
    
    if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
      deliveredByLabel.text = " Unilever Food Solutions " + (WSUtility.getlocalizedString(key: "Delivered by", lang: WSUtility.getLanguage(), table: "Localizable"))!
    }
    else{
      deliveredByLabel.text = " \(tradeNameTxt) " + (WSUtility.getlocalizedString(key: "Delivered by", lang: WSUtility.getLanguage(), table: "Localizable"))!
    }
    
    orderAddedNextDelivery.text = WSUtility.getlocalizedString(key: "This order will be added to the next delivery", lang: WSUtility.getLanguage(), table: "Localizable")
    calanderButton.setTitle(WSUtility.getlocalizedString(key: "Choose different day (optional)", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    deliveryNotesTextView.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    deliveryNotesTextView.hint = "   \(WSUtility.getlocalizedString(key: "Delivery notes (optional)", lang: WSUtility.getLanguage(), table: "Localizable")!)"
    
    //backToDetails.text = WSUtility.getlocalizedString(key: "Back to details", lang: WSUtility.getLanguage(), table: "Localizable")
    backToDetails.titleLabel?.adjustsFontSizeToFitWidth = true
    
    let underlineAttributes : [String: Any] = [
      NSFontAttributeName : UIFont(name: "DinPro-Regular", size: 14.0)!,
      NSForegroundColorAttributeName : ApplicationOrangeColor,
      NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
    let attributeString = NSMutableAttributedString(string: (WSUtility.getlocalizedString(key: "Back to details", lang: WSUtility.getLanguage(), table: "Localizable"))!,
                                                    attributes: underlineAttributes)
    backToDetails.setAttributedTitle(attributeString, for: .normal)
    nextStepButton.setTitle(WSUtility.getlocalizedString(key: "Next Step", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    if countryCode == "TR"{
      houseNumberTxtField.placeholder = WSUtility.getlocalizedString(key: "Address Line 1", lang: WSUtility.getLanguage(), table: "Localizable")
      streetTxtField.placeholder = WSUtility.getlocalizedString(key: "Address Line 2", lang: WSUtility.getLanguage(), table: "Localizable")
      houseNumberTxtField.keyboardType = UIKeyboardType.default
      
      billingHouseTxtField.placeholder = WSUtility.getlocalizedString(key: "Address Line 1", lang: WSUtility.getLanguage(), table: "Localizable")
      billingStreetTextField.placeholder = WSUtility.getlocalizedString(key: "Address Line 2", lang: WSUtility.getLanguage(), table: "Localizable")
      billingHouseTxtField.keyboardType = UIKeyboardType.default
    }
    else{
      houseNumberTxtField.placeholder = WSUtility.getlocalizedString(key: "House number", lang: WSUtility.getLanguage(), table: "Localizable")
      streetTxtField.placeholder = WSUtility.getlocalizedString(key: "Street", lang: WSUtility.getLanguage(), table: "Localizable")
      billingHouseTxtField.placeholder = WSUtility.getlocalizedString(key: "House number", lang: WSUtility.getLanguage(), table: "Localizable")
      billingStreetTextField.placeholder = WSUtility.getlocalizedString(key: "Street", lang: WSUtility.getLanguage(), table: "Localizable")
    }
    businessName.placeholder = WSUtility.getlocalizedString(key: "Business name (optional)", lang: WSUtility.getLanguage(), table: "Localizable")
    cityTextField.placeholder = WSUtility.getlocalizedString(key: "City", lang: WSUtility.getLanguage(), table: "Localizable")
    postelCodeTxtField.placeholder = WSUtility.getlocalizedString(key: "Postal Code", lang: WSUtility.getLanguage(), table: "Localizable")
    billingBusinessTxtField.placeholder = WSUtility.getlocalizedString(key: "Business name (optional)", lang: WSUtility.getLanguage(), table: "Localizable")
    billingCityTextField.placeholder = WSUtility.getlocalizedString(key: "City", lang: WSUtility.getLanguage(), table: "Localizable")
    billingPostelTextField.placeholder = WSUtility.getlocalizedString(key: "Postal Code", lang: WSUtility.getLanguage(), table: "Localizable")
    myDetailProcessLbl.text = WSUtility.getlocalizedString(key: "My Detail", lang: WSUtility.getLanguage(), table: "Localizable")
    deliveryProcessLbl.text = WSUtility.getlocalizedString(key: "Delivery", lang: WSUtility.getLanguage(), table: "Localizable")
    summaryProcessLbl.text = WSUtility.getlocalizedString(key: "Summary", lang: WSUtility.getLanguage(), table: "Localizable")
    
    let button: UIButton = UIButton(type: UIButtonType.custom)
    button.setImage(UIImage(named: "lock.png"), for: UIControlState.normal)
    let barButton = UIBarButtonItem(customView: button)
    self.navigationItem.rightBarButtonItem = barButton
    
    vwTopBase.dropShadowForCheckout()
    vwDeliveryAddressBase.dropTopAndBottomShadow()
    vwCalenderVwBase.dropTopAndBottomShadow()
    vwBottomBase.dropTopShadow()
    
  }
  
  func addBorderColor(textfiled: UITextField){
    textfiled.setLeftPaddingPoints(10)
    WSUtility.UISetUpForTextField(textField: textfiled, withBorderColor: unselectedTextFieldBorderColor)
  }
  
  
  func getUserDetailsFromSifu(){
    UFSProgressView.showWaitingDialog("")
    let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    businessLayer.getBasicUserProfile(parameter: [String:Any](), methodName: GET_BASIC_PROFILE_API, successResponse: { (response) in
      UFSProgressView.stopWaitingDialog()
      
      if response.count > 0{
        
        let dictResponse = response
        
        let businessName = dictResponse["businessName"] as? String
        let houseNo = dictResponse["houseNumber"] as? String
        let street = dictResponse["street"] as? String
        let city = dictResponse["city"] as? String
        let zipCode = dictResponse["zipCode"] as? String
        
        
        if var tmpDict = self.OrderDictInfo["billingAddress"] as? [String: Any]{
          if let name = tmpDict["businessName"] as? String{
            tmpDict["businessName"] = self.getValueFromString(stringValue: businessName, placeHolderString: name)
          }
          if let hNo = tmpDict["houseNumber"] as? String{
            tmpDict["houseNumber"] = self.getValueFromString(stringValue: houseNo, placeHolderString: hNo)
          }
          if let name = tmpDict["street"] as? String{
            tmpDict["street"] = self.getValueFromString(stringValue: street, placeHolderString: name)
          }
          if let name = tmpDict["city"] as? String{
            tmpDict["city"] = self.getValueFromString(stringValue: city, placeHolderString: name)
          }
          if let code = tmpDict["zipCode"] as? String{
            tmpDict["zipCode"] = self.getValueFromString(stringValue: zipCode, placeHolderString: code)
          }
          
          self.OrderDictInfo["billingAddress"] = tmpDict
          
        }else{
          
          var billingAddressDict = [String:Any]()
          billingAddressDict["businessName"] = self.getValueFromString(stringValue: businessName, placeHolderString: "")
          billingAddressDict["houseNumber"] = self.getValueFromString(stringValue: houseNo, placeHolderString: "")
          billingAddressDict["street"] = self.getValueFromString(stringValue: street, placeHolderString: "")
          billingAddressDict["city"] = self.getValueFromString(stringValue: city, placeHolderString: "")
          billingAddressDict["zipCode"] = self.getValueFromString(stringValue: zipCode, placeHolderString: "")
          
          self.OrderDictInfo["billingAddress"] = billingAddressDict
          
          
        }
        
        
      }
      
      self.updateDataWithUI()
      
    }) { (errorMessage) in
      
      self.updateDataWithUI()
      UFSProgressView.stopWaitingDialog()
      
    }
  }
  
  fileprivate let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy"
    return formatter
  }()
  
  func getValueFromString(stringValue:String?, placeHolderString:String) -> String{
    
    if stringValue != nil && stringValue != ""{
      return stringValue!
    }
    return placeHolderString
  }
  
  
  @IBAction func textDidchange(_ textField: UITextField){
    switch textField {
    // delivery
    case businessName:
      self.showhideErrorLabels(textField: businessName,errorTextLabel: deliveryCompanyNameErrorLbl)
      WSUtility.UISetUpForTextFieldWithImage(textField: businessName, boolValue: true)
    case houseNumberTxtField:
      self.showhideErrorLabels(textField: textField,errorTextLabel: deliveryHouseNoErrorLbl)
      WSUtility.UISetUpForTextFieldWithImage(textField: houseNumberTxtField, boolValue: true)
    case streetTxtField:
      self.showhideErrorLabels(textField: streetTxtField,errorTextLabel: deliveryStreetErrorLbl)
      WSUtility.UISetUpForTextFieldWithImage(textField: streetTxtField, boolValue: true)
    case cityTextField:
      self.showhideErrorLabels(textField: cityTextField,errorTextLabel: deliveryCityErrorLbl)
      WSUtility.UISetUpForTextFieldWithImage(textField: cityTextField, boolValue: true)
    case postelCodeTxtField:
      self.showhideErrorLabels(textField: postelCodeTxtField,errorTextLabel: deliveryPostalCodeErrorLbl)
      self.UISetUpForPostalCodeTextFields(textField: postelCodeTxtField, boolValue: true)
      
    //billing
    case billingBusinessTxtField:
      self.showhideErrorLabels(textField: billingBusinessTxtField,errorTextLabel: billingCompanyNameErrorLbl)
      WSUtility.UISetUpForTextFieldWithImage(textField: billingBusinessTxtField, boolValue: true)
    case billingHouseTxtField:
      self.showhideErrorLabels(textField: billingHouseTxtField,errorTextLabel: billingHouseNoErrorLbl)
      WSUtility.UISetUpForTextFieldWithImage(textField: billingHouseTxtField, boolValue: true)
    case billingStreetTextField:
      self.showhideErrorLabels(textField: billingStreetTextField,errorTextLabel: billingStreetErrorLbl)
      WSUtility.UISetUpForTextFieldWithImage(textField: billingStreetTextField, boolValue: true)
    case billingCityTextField:
      self.showhideErrorLabels(textField: textField,errorTextLabel: billingCityErrorLbl)
      WSUtility.UISetUpForTextFieldWithImage(textField: billingCityTextField, boolValue: true)
    case billingPostelTextField:
      self.showhideErrorLabels(textField: textField,errorTextLabel: billingPostalCodeErrorLbl)
      self.UISetUpForPostalCodeTextFields(textField: billingPostelTextField, boolValue: true)
    default:
      break
    }
  }
  func showhideErrorLabels(textField:UITextField, errorTextLabel: UILabel){
    if textField == postelCodeTxtField || textField == billingPostelTextField{
      let currentCharacterCount = textField.text?.count ?? 0
      if currentCharacterCount > 5 || currentCharacterCount < 4{
        errorTextLabel.isHidden = false
      }
      else{
        errorTextLabel.isHidden = true
      }
      return
    }
    
    if textField.text != "" {
      errorTextLabel.isHidden = true
    }
    else{
      errorTextLabel.isHidden = false
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
  
  func popBack<T: UIViewController>(toControllerType: T.Type) {
    if var viewControllers: [UIViewController] = self.navigationController?.viewControllers {
      viewControllers = viewControllers.reversed()
      for currentViewController in viewControllers {
        if currentViewController .isKind(of: toControllerType) {
          self.navigationController?.popToViewController(currentViewController, animated: true)
          break
        }
      }
    }
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if segue.identifier == "CalendarVC"{
      let CalendarVC: ChackoutClndrViewController = segue.destination as! ChackoutClndrViewController
      CalendarVC.delegate = self
      if calanderButton.titleLabel?.text == "CHOOSE DIFFERENT DAY(Optional)"{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        CalendarVC.selectedDateStr = formatter.string(from: Calendar.current.date(byAdding: .day, value: 2, to: Date())!)
      }
      else{
        CalendarVC.selectedDateStr = (calanderButton.titleLabel?.text)!
      }
    }
    else if segue.identifier == "showPaymentSegue"{
      let vc: PaymentViewController = segue.destination as! PaymentViewController
      vc.detailDictionary = detailDictionary
      vc.addressDictionary = addressDictionary
      vc.billingAddressDictionary = billingAddressDictionary
      vc.cartArr = self.cartArr
      vc.totalPrice =  self.totalPrice
      vc.totalPriceForPayment_TR = self.totalPriceForPayment_TR
      
      vc.tradeNameTxt = self.tradeNameTxt
      vc.childTradeNameTxt = self.childTradeNameTxt
      vc.sameBilling = self.sameBilling
      vc.earnedLoyaltyPoints = self.earnedLoyaltyPoints
      vc.promoCode = self.promoCode
      vc.validPromoDict =  self.validPromoDict
      vc.summaryDeliveryDate = summaryDate
      vc.totalItemsQunatity = self.totalItemsQunatity
      vc.strDeliveryNotes = deliveryNotesTextView.text
      vc.selectedTradePartnerId = selectedTradePatrnerId
    }
  }
  
  @IBAction func backAction(_ sender: UIButton) {
    //self.navigationController?.popViewController(animated: true)
    self.popBack(toControllerType: HYBCartController.self)
  }
  
  @IBAction func nextStepClicked(_ sender: Any) {
    checkValidation()
  }
  
  @IBAction func continueShopingClicked(_ sender: Any) {
    self.navigationController?.popViewController(animated: false)
  }
  
  
  //    func commentTextViewChanged() {
  //       self.deliveryNotesTextView.text = ""
  //    }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    switch textField {
      
    case businessName:
      houseNumberTxtField.becomeFirstResponder()
    case houseNumberTxtField:
      streetTxtField.becomeFirstResponder()
    case streetTxtField:
      cityTextField.becomeFirstResponder()
    case cityTextField:
      postelCodeTxtField.becomeFirstResponder()
    case postelCodeTxtField:
      billingBusinessTxtField.becomeFirstResponder()
    case cityTextField:
        billingHouseTxtField.becomeFirstResponder()
    case billingHouseTxtField:
      billingStreetTextField.becomeFirstResponder()
    case billingStreetTextField:
      billingCityTextField.becomeFirstResponder()
    case billingCityTextField:
      billingPostelTextField.becomeFirstResponder()
    default:
      textField.resignFirstResponder()
    }
    return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
    
    if textField == postelCodeTxtField || textField == billingPostelTextField {
      
      let currentCharacterCount = textField.text?.count ?? 0
      if currentCharacterCount>5{
        return true
      }
      if (range.length + range.location > currentCharacterCount){
        return false
      }
      let newLength = currentCharacterCount + string.count - range.length
      return newLength <= 5
    }
    return true
  }
  
  func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
  }
  
  @IBAction func checkBoxClicked(_ sender: Any) {
    if(sameBilling == 0){
      let image = UIImage(named: "check_orange")
      checkboxBtn.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
      sameBilling = 1
      self.billingBusinessTxtField.text = businessName.text
      self.billingHouseTxtField.text = houseNumberTxtField.text
      self.billingStreetTextField.text = streetTxtField.text
      self.billingCityTextField.text = cityTextField.text
      self.billingPostelTextField.text = postelCodeTxtField.text
      
      self.billingBusinessTxtField.isUserInteractionEnabled = false
      self.billingHouseTxtField.isUserInteractionEnabled = false
      self.billingStreetTextField.isUserInteractionEnabled = false
      self.billingCityTextField.isUserInteractionEnabled = false
      self.billingPostelTextField.isUserInteractionEnabled = false
      
      
    }else{
      let image = UIImage(named: "")
      checkboxBtn.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
      sameBilling = 0
      
      self.billingBusinessTxtField.text = ""
      self.billingHouseTxtField.text = ""
      self.billingStreetTextField.text = ""
      self.billingCityTextField.text = ""
      self.billingPostelTextField.text = ""
      
      self.billingBusinessTxtField.isUserInteractionEnabled = true
      self.billingHouseTxtField.isUserInteractionEnabled = true
      self.billingStreetTextField.isUserInteractionEnabled = true
      self.billingCityTextField.isUserInteractionEnabled = true
      self.billingPostelTextField.isUserInteractionEnabled = true
    }
    
    checkValidationWhenCheckBoxIsTapped()
  }
  
  func checkValidationForDeliveryDetails() {
    
    if deliveryNotesTextView.text.count > 0 || deliveryDate.count > 0 {
      submitDeliveryDetails()
      
    }
    
  }
  
  func submitDeliveryDetails()  {
    
    let webServiceBusinessLayer = WSWebServiceBusinessLayer()
    
    //let loadCart : HYBCart = backendService.currentCartFromCache()
    let cartId = UFSHybrisUtility.uniqueCartId
    let dictParam = ["Cart_ID":cartId,"Date":deliveryDate,"deliveryNotes":deliveryNotesTextView.text] as [String : Any]
    webServiceBusinessLayer.setdeliveryDetails(params:dictParam ,selectedVendorId:selectedTradePatrnerId, successResponse: { (response) in
      print("response:%@",response)
      UFSProgressView.stopWaitingDialog()
    }) { (errorMessage) in
      print("error")
      UFSProgressView.stopWaitingDialog()
      // self.showNotifyMessage(errorMessage)
    }
  }
  
  func checkValidation(){
    
    var isFieldsEmpty: Bool = false
    if(self.businessName.text == ""){
      self.showhideErrorLabels(textField: businessName,errorTextLabel: deliveryCompanyNameErrorLbl)
      WSUtility.UISetUpForTextFieldWithImage(textField: businessName, boolValue: true)
      isFieldsEmpty = true
    }
    if(self.houseNumberTxtField.text == ""){
      self.showhideErrorLabels(textField: houseNumberTxtField,errorTextLabel: deliveryHouseNoErrorLbl)
      WSUtility.UISetUpForTextFieldWithImage(textField: houseNumberTxtField, boolValue: true)
      isFieldsEmpty = true
    }
    if(self.streetTxtField.text == ""){
      self.showhideErrorLabels(textField: streetTxtField,errorTextLabel: deliveryStreetErrorLbl)
      WSUtility.UISetUpForTextFieldWithImage(textField: streetTxtField, boolValue: true)
      isFieldsEmpty = true
    }
    
    let code = (self.postelCodeTxtField.text?.count)!
    if code > 5 || code < 4{
      self.showhideErrorLabels(textField: postelCodeTxtField,errorTextLabel: deliveryPostalCodeErrorLbl)
      self.UISetUpForPostalCodeTextFields(textField: postelCodeTxtField, boolValue: true)
      isFieldsEmpty = true
    }
    if(self.cityTextField.text == ""){
      self.showhideErrorLabels(textField: cityTextField,errorTextLabel: deliveryCityErrorLbl)
      WSUtility.UISetUpForTextFieldWithImage(textField: cityTextField, boolValue: true)
      isFieldsEmpty = true
    }
    
    
    if(self.billingBusinessTxtField.text == ""){ //&& sameBilling == 1
      self.showhideErrorLabels(textField: billingBusinessTxtField,errorTextLabel: billingCompanyNameErrorLbl)
      WSUtility.UISetUpForTextFieldWithImage(textField: billingBusinessTxtField, boolValue: true)
      isFieldsEmpty = true
    }
    if(self.billingHouseTxtField.text == ""){
      self.showhideErrorLabels(textField: billingHouseTxtField,errorTextLabel: billingHouseNoErrorLbl)
      WSUtility.UISetUpForTextFieldWithImage(textField: billingHouseTxtField, boolValue: true)
      isFieldsEmpty = true
    }
    if(self.billingStreetTextField.text == ""){
      self.showhideErrorLabels(textField: billingStreetTextField,errorTextLabel: billingStreetErrorLbl)
      WSUtility.UISetUpForTextFieldWithImage(textField: billingStreetTextField, boolValue: true)
      isFieldsEmpty = true
    }
    if(self.billingCityTextField.text == ""){
      self.showhideErrorLabels(textField: billingCityTextField,errorTextLabel: billingCityErrorLbl)
      WSUtility.UISetUpForTextFieldWithImage(textField: billingCityTextField, boolValue: true)
      isFieldsEmpty = true
    }
    let billingCode = (self.billingPostelTextField.text?.count)!
    if  billingCode > 5 || billingCode < 4{
      self.showhideErrorLabels(textField: billingPostelTextField,errorTextLabel: billingPostalCodeErrorLbl)
      self.UISetUpForPostalCodeTextFields(textField: billingPostelTextField, boolValue: true)
      isFieldsEmpty = true
    }
    
    if !isFieldsEmpty{
      submitDeliveryAddress()
    }
  }
  
  func checkValidationWhenCheckBoxIsTapped(){
    
    //        if(self.businessName.text == ""){
    self.showhideErrorLabels(textField: businessName,errorTextLabel: deliveryCompanyNameErrorLbl)
    WSUtility.UISetUpForTextFieldWithImage(textField: businessName, boolValue: true)
    //        }
    //        else{
    //            self.showhideErrorLabels(textField: businessName,errorTextLabel: deliveryCompanyNameErrorLbl)
    //            WSUtility.UISetUpForTextFieldWithImage(textField: businessName, boolValue: false)
    //        }
    //        if(self.houseNumberTxtField.text == ""){
    self.showhideErrorLabels(textField: houseNumberTxtField,errorTextLabel: deliveryHouseNoErrorLbl)
    WSUtility.UISetUpForTextFieldWithImage(textField: houseNumberTxtField, boolValue: true)
    //        }
    //        else{
    //            self.showhideErrorLabels(textField: houseNumberTxtField,errorTextLabel: deliveryHouseNoErrorLbl)
    //            WSUtility.UISetUpForTextFieldWithImage(textField: houseNumberTxtField, boolValue: false)
    //        }
    //        if(self.streetTxtField.text == ""){
    self.showhideErrorLabels(textField: streetTxtField,errorTextLabel: deliveryStreetErrorLbl)
    WSUtility.UISetUpForTextFieldWithImage(textField: streetTxtField, boolValue: true)
    //        }
    //        else{
    //            self.showhideErrorLabels(textField: streetTxtField,errorTextLabel: deliveryStreetErrorLbl)
    //            WSUtility.UISetUpForTextFieldWithImage(textField: streetTxtField, boolValue: false)
    //        }
    //        let code = (self.postelCodeTxtField.text?.count)!
    //        if code > 5 || code < 4{
    self.showhideErrorLabels(textField: postelCodeTxtField,errorTextLabel: deliveryPostalCodeErrorLbl)
    self.UISetUpForPostalCodeTextFields(textField: postelCodeTxtField, boolValue: true)
    //        }
    //        else{
    //            self.showhideErrorLabels(textField: postelCodeTxtField,errorTextLabel: deliveryPostalCodeErrorLbl)
    //            self.UISetUpForPostalCodeTextFields(textField: postelCodeTxtField, boolValue: false)
    //
    //        }
    //        if(self.cityTextField.text == ""){
    self.showhideErrorLabels(textField: cityTextField,errorTextLabel: deliveryCityErrorLbl)
    WSUtility.UISetUpForTextFieldWithImage(textField: cityTextField, boolValue: true)
    //        }
    //        else{
    //            self.showhideErrorLabels(textField: cityTextField,errorTextLabel: deliveryCityErrorLbl)
    //            WSUtility.UISetUpForTextFieldWithImage(textField: cityTextField, boolValue: false)
    //        }
    
    
    //        if(self.billingBusinessTxtField.text == ""){ //&& sameBilling == 1
    self.showhideErrorLabels(textField: billingBusinessTxtField,errorTextLabel: billingCompanyNameErrorLbl)
    WSUtility.UISetUpForTextFieldWithImage(textField: billingBusinessTxtField, boolValue: true)
    //        }
    //        else{
    //            self.showhideErrorLabels(textField: billingBusinessTxtField,errorTextLabel: billingCompanyNameErrorLbl)
    //            WSUtility.UISetUpForTextFieldWithImage(textField: billingBusinessTxtField, boolValue: true)
    //
    //        }
    //        if(self.billingHouseTxtField.text == ""){
    self.showhideErrorLabels(textField: billingHouseTxtField,errorTextLabel: billingHouseNoErrorLbl)
    WSUtility.UISetUpForTextFieldWithImage(textField: billingHouseTxtField, boolValue: true)
    //        }
    //        else{
    //            self.showhideErrorLabels(textField: billingHouseTxtField,errorTextLabel: billingHouseNoErrorLbl)
    //            WSUtility.UISetUpForTextFieldWithImage(textField: billingHouseTxtField, boolValue: true)
    //        }
    //        if(self.billingStreetTextField.text == ""){
    self.showhideErrorLabels(textField: billingStreetTextField,errorTextLabel: billingStreetErrorLbl)
    WSUtility.UISetUpForTextFieldWithImage(textField: billingStreetTextField, boolValue: true)
    //        }
    //        else{
    //            self.showhideErrorLabels(textField: billingStreetTextField,errorTextLabel: billingStreetErrorLbl)
    //            WSUtility.UISetUpForTextFieldWithImage(textField: billingStreetTextField, boolValue: true)
    //        }
    //        if(self.billingCityTextField.text == ""){
    self.showhideErrorLabels(textField: billingCityTextField,errorTextLabel: billingCityErrorLbl)
    WSUtility.UISetUpForTextFieldWithImage(textField: billingCityTextField, boolValue: true)
    //        }
    //        else{
    //            self.showhideErrorLabels(textField: billingCityTextField,errorTextLabel: billingCityErrorLbl)
    //            WSUtility.UISetUpForTextFieldWithImage(textField: billingCityTextField, boolValue: true)
    //
    //        }
    
    self.showhideErrorLabels(textField: billingPostelTextField,errorTextLabel: billingPostalCodeErrorLbl)
    self.UISetUpForPostalCodeTextFields(textField: billingPostelTextField, boolValue: true)
    
  }
  
  func UISetUpForPostalCodeTextFields(textField:UITextField ,boolValue: Bool)  {
    
    if boolValue == true {
      
      let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 50))
      let checkedImage: UIImageView = UIImageView()
      checkedImage.frame = CGRect(x: 0, y: 17.5, width: 15, height: 15)
      checkedImage.contentMode = .scaleAspectFit
      
      let billingCode = (textField.text?.count)!
      
      if billingCode == 5 || billingCode == 4 {
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
  func submitDeliveryAddress(){
    
    let countryDictionary = ["isocode": "JP"]
    let regionDictionary = ["isocode": "JP-27"]
    addressDictionary["firstName"] = detailDictionary["firstName"]
    addressDictionary["lastName"] = detailDictionary["lastName"]
    addressDictionary["titleCode"] = "mr"
    addressDictionary["line1"] = self.houseNumberTxtField.text
    addressDictionary["line2"] = self.streetTxtField.text
    addressDictionary["town"] = self.cityTextField.text
    addressDictionary["postalCode"] = self.postelCodeTxtField.text
    addressDictionary["phone"] = detailDictionary["phone"]
    addressDictionary["companyName"] = self.businessName.text
    addressDictionary["country"] = countryDictionary
    addressDictionary["region"] = regionDictionary
    
    billingAddressDictionary["firstName"] = detailDictionary["firstName"]
    billingAddressDictionary["lastName"] = detailDictionary["lastName"]
    billingAddressDictionary["phone"] = detailDictionary["phone"]
    billingAddressDictionary["titleCode"] = "mr"
    billingAddressDictionary["line1"] = self.billingHouseTxtField.text
    billingAddressDictionary["line2"] = self.billingStreetTextField.text
    billingAddressDictionary["town"] = self.billingCityTextField.text
    billingAddressDictionary["postalCode"] = self.billingPostelTextField.text
    billingAddressDictionary["companyName"] = self.billingBusinessTxtField.text
    
    UFSProgressView.showWaitingDialog("")
    let email_id = UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)!
    let url = "users/\(email_id)/addresses?vendorId=\(selectedTradePatrnerId)"
    let webServiceBusinessLayer = WSWebServiceBusinessLayer()
    webServiceBusinessLayer.setdeliveryAdd(productID: url,params:addressDictionary as NSDictionary, successResponse: { (response) in
      print("response:%@",response)
      UFSProgressView.stopWaitingDialog()
      
      
      self.putAddressToCart(addressId: response["id"] as! NSString)
      self.checkValidationForDeliveryDetails()
    }) { (errorMessage) in
      print("error")
      UFSProgressView.stopWaitingDialog()
      //self.showNotifyMessage(errorMessage)
    }
    
  }
  
  func putAddressToCart(addressId:NSString){
    
    UFSProgressView.showWaitingDialog("")
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SummaryView") as! SummaryViewController
    
    UserDefaults.standard.set(["billingAddress": ["businessName": businessName.text,"houseNumber": houseNumberTxtField.text,"street": streetTxtField.text,"city": cityTextField.text,"zipCode": postelCodeTxtField.text],"shippingAddress": ["businessName": billingBusinessTxtField.text,"houseNumber": billingHouseTxtField.text,"street": billingStreetTextField.text,"city": billingCityTextField.text,"zipCode": billingPostelTextField.text],"deliveryNotes":deliveryNotesTextView.text,"deliveryDate":summaryDate], forKey: "userDeliveryDetails")
    
    vc.detailDictionary = detailDictionary
    vc.addressDictionary = addressDictionary
    vc.billingAddressDictionary = billingAddressDictionary
    vc.cartArr = self.cartArr
    vc.totalPrice =  self.totalPrice
    vc.tradeNameTxt = self.tradeNameTxt
    vc.childTradeNameTxt = self.childTradeNameTxt
    vc.sameBilling = self.sameBilling
    vc.earnedLoyaltyPoints = self.earnedLoyaltyPoints
    vc.promoCode = self.promoCode
    vc.validPromoDict =  self.validPromoDict
    vc.summaryDeliveryDate = summaryDate
    vc.totalItemsQunatity = self.totalItemsQunatity
    vc.strDeliveryNotes = deliveryNotesTextView.text
    vc.selectedTradePartnerId = selectedTradePatrnerId
    //let loadCart : HYBCart = backendService.currentCartFromCache()
    let cartId = UFSHybrisUtility.uniqueCartId
    let email_id = UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)!
    let url = "users/\(email_id)/carts/\(cartId)/addresses/delivery?addressId=\(addressId)&vendorId=\(selectedTradePatrnerId)"
    let webServiceBusinessLayer = WSWebServiceBusinessLayer()
    webServiceBusinessLayer.putAddressToCart(productID: url, successResponse: { (response) in
      print("response:%@",response)
      //HYBActivityIndicator.hide()
      UFSProgressView.stopWaitingDialog()
      let countryCode =  WSUtility.getCountryCode()
      let user:WSUser = WSUser().getUserProfile()
      if countryCode == "TR" && user.isPaymentByCreditCard == true {
        self.performSegue(withIdentifier: "showPaymentSegue", sender: self)
      }
      else{
       self.navigationController?.pushViewController(vc, animated: true)
      }
      
    }) { (errorMessage) in
      print("error")
     
      UFSProgressView.stopWaitingDialog()
        WSUtility.showAlertWith(message: errorMessage, title: WSUtility.getlocalizedString(key: "Error", lang: WSUtility.getLanguage())!, forController: self)
      
    }
    
  }
  
  func showAlert(msg:NSString) {
    let alertController = UIAlertController(title: "", message: msg as String, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(defaultAction)
    present(alertController, animated: true, completion: nil)
  }
  
  override func viewDidLayoutSubviews(){
    //        print(vwTopBase.frame.size.height, vwDeliveryAddressBase.frame.size.height, vwCalenderVwBase.frame.size.height, vwBottomBase.frame.size.height)
  }
}
extension DeliveryViewController: ChackoutClndrViewControllerDelegate{
  func getSelectedDate(dateStr: String) {
    deliveryDate = dateStr
    summaryDate = dateStr
    if summaryDate == ""{
      orderAddedNextDelivery.text = WSUtility.getlocalizedString(key: "This order will be added to the next delivery", lang: WSUtility.getLanguage(), table: "Localizable")
        calanderButton.setTitle(WSUtility.getlocalizedString(key: "Choose different day (optional)", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    }
    else{
        var str = WSUtility.getlocalizedString(key: "Your order will be delivered on", lang: WSUtility.getLanguage(), table: "Localizable")
      let strLngCode = WSUtility.getLanguage()
      
      let dateFormatter = DateFormatter()
      dateFormatter.locale = NSLocale(localeIdentifier: "\(WSUtility.getLanguageCode())_\(WSUtility.getCountryCode())") as Locale?
      dateFormatter.dateFormat = "MM/dd/yyyy"
      
      if let date = dateFormatter.date(from: summaryDate){
        dateFormatter.dateFormat = "dd MMM yy"

        if (str?.contains(find: "…"))!{
                str = str?.replacingOccurrences(of:"…", with: dateFormatter.string(from: date))
            orderAddedNextDelivery.text = str!
            }
            else{
            orderAddedNextDelivery.text = str! + " " + dateFormatter.string(from: date)
            }
        calanderButton.setTitle(dateStr, for: .normal)

      }
    }
    
  }
}



