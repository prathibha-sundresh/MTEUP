//
//  SummaryViewController.swift
//  yB2CApp
//
//  Created by Ajay on 29/11/17.
//

import UIKit
import WebKit
class SummaryViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
  var strSelectedPmntMode = "cash"
  
    @IBOutlet weak var topCnstCCDetailsLbl: NSLayoutConstraint!
    @IBOutlet weak var htConstBlueNote: NSLayoutConstraint!
    @IBOutlet weak var lblTRBlueNote: UILabel!
    @IBOutlet weak var vwBlueNoteBase: UIView!

    var totalPriceForPayment_TR = ""
  @IBOutlet weak var lblSubPymntHdr: UILabel!
  @IBOutlet weak var lblPaymentHdr: UILabel!
  @IBOutlet weak var btmCnstPaymentVw: NSLayoutConstraint!
  @IBOutlet weak var htConstPaymentVw: NSLayoutConstraint!
  @IBOutlet weak var paymentConstX: NSLayoutConstraint!
  @IBOutlet weak var heightConstantRewardsView: NSLayoutConstraint!
  @IBOutlet weak var promoCodeLoyaltyPointsLabel: UILabel!
  @IBOutlet weak var rewardLoyanltyPointsLabel: UILabel!
  @IBOutlet weak var promoCodeTextLabel: UILabel!
  @IBOutlet weak var rewardPointTextLabel: UILabel!
  @IBOutlet weak var rewardPointLabelsView: UIView!
  @IBOutlet weak var recommendedProceLabel: UILabel!
  @IBOutlet weak var changeBillingButton: UIButton!
  @IBOutlet weak var changeButton: UIButton!
  @IBOutlet weak var termsLabel: UILabel!
  @IBOutlet weak var rewardPointsLabel: UILabel!
  @IBOutlet weak var termsButton: UIButton!
  @IBOutlet weak var myCartLabel: UILabel!
  @IBOutlet weak var billingLabel: UILabel!
  @IBOutlet weak var deliveryLabel: UILabel!
  @IBOutlet weak var tradePartnerLabel: UILabel!
  @IBOutlet weak var myDetailLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var placeOrderButton: WSDesignableButton!
  @IBOutlet weak var checkoutLabel: UILabel!
  @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var detailName: UILabel!
  @IBOutlet weak var detailAddress: UILabel!
  @IBOutlet weak var detailPhone: UILabel!
  @IBOutlet weak var tradeName: UILabel!
  @IBOutlet weak var childName: UILabel!
  @IBOutlet weak var accountNo: UILabel!
  @IBOutlet weak var deliveryName: UILabel!
  @IBOutlet weak var deliveryStreet: UILabel!
  @IBOutlet weak var deliveryAddress: UILabel!
  @IBOutlet weak var billingStreet: UILabel!
  @IBOutlet weak var billingAddress: UILabel!
  @IBOutlet weak var billingName: UILabel!
  @IBOutlet var tableView: UITableView!
  @IBOutlet weak var totalItemsLbl: UILabel!
  @IBOutlet weak var priceLbl: UILabel!
  @IBOutlet weak var totalItemsLbl1: UILabel!
  
  @IBOutlet weak var cartContainerView: UIView!
  @IBOutlet weak var deliveryContainerView: UIView!
  @IBOutlet weak var billingContainerView: UIView!
  @IBOutlet weak var tradePartnerContainerView: UIView!
  @IBOutlet weak var summaryContainerView: UIView!
  @IBOutlet weak var changeMyDetailBtn: UIButton!
  @IBOutlet weak var changeTradePartnerBtn: UIButton!
  @IBOutlet weak var changeDeliveryBtn: UIButton!
  @IBOutlet weak var changeBillingBtn: UIButton!
  @IBOutlet weak var changeMyCartBtn: UIButton!
  @IBOutlet weak var loyaltyPointsCount: UILabel!
  @IBOutlet weak var loyaltyPointsLbl: UILabel!
  @IBOutlet weak var placeOrderBtn2: WSDesignableButton!
  @IBOutlet weak var myDetailProcessLbl: UILabel!
  @IBOutlet weak var deliveryProcessLbl: UILabel!
  @IBOutlet weak var summaryProcessLbl: UILabel!
  @IBOutlet weak var vwTopBase: UIView!
  @IBOutlet weak var vwCenterBase: UIView!
  @IBOutlet weak var vwBottomBase: UIView!
  @IBOutlet weak var vwInfoBase: UIView!
  @IBOutlet weak var lblInfo: UILabel!
  @IBOutlet weak var btnChangeInfo: UIButton!
  @IBOutlet weak var lblDeliveryDate: UILabel!
  @IBOutlet weak var vwPaymentBase: UIView!
  @IBOutlet weak var lblDeliveryNotesDesc: UILabel!
  @IBOutlet weak var lblDeliveryNotesHdr: UILabel!
  @IBOutlet weak var htConstDelivryNotesHdr: NSLayoutConstraint!
  @IBOutlet weak var vwBaseCCDetails: UIView!
  @IBOutlet weak var lblNoOfPayments: UILabel!
  @IBOutlet weak var lblPerMonth: UILabel!
  @IBOutlet weak var lblCCDetails: UILabel!
  @IBOutlet weak var imgVwCC: UIImageView!
  @IBOutlet weak var btnEditPayment: UIButton!
    @IBOutlet weak var textViewTnCTR: UITextView!
    
  var detailDictionary = [String: Any]()
  var addressDictionary = [String: Any]()
  var billingAddressDictionary = [String: Any]()
  var cartArr: [String] = [String]()
  // let cellReuseIdentifier = "checkoutcell"
  var tradeNameTxt = ""
  var childTradeNameTxt = ""
  var totalPrice = ""
  var earnedLoyaltyPoints = ""
  var promoCode = ""
  var sameBilling = 0
  var summaryDeliveryDate = ""
  var validPromoDict: [String: Any] = [:]
  var paymentCardID = ""
  
  var totalItemsQunatity: Int = 0
  var strDeliveryNotes = ""
  var paymentMode = "email"
  var paymentDetailDict = [String:Any]()
  var selectedTradePartnerId = ""
  let underlineAttributes : [String: Any] = [
    NSFontAttributeName : UIFont(name: "DinPro-Regular", size: 16.0)!,
    NSForegroundColorAttributeName : ApplicationOrangeColor,
    NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
  
  @IBOutlet weak var tpContentViewHeight: NSLayoutConstraint!
  @IBOutlet weak var tpBottomViewY: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    manageBlueNoteForTurkey()
    
    termsButton.titleLabel?.adjustsFontSizeToFitWidth = true
    UserDefaults.standard.set(true, forKey: "isFromSummary")
    if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
      tpContentViewHeight.constant = 0
      tpBottomViewY.constant = 0
      tradePartnerContainerView.isHidden = true
    }
    
    if promoCode != ""{
      
      rewardPointLabelsView.isHidden = false
      rewardPointTextLabel.isHidden = false
      promoCodeTextLabel.isHidden = false
      rewardLoyanltyPointsLabel.isHidden = false
      promoCodeLoyaltyPointsLabel.isHidden = false
      heightConstantRewardsView.constant = 55
      
      rewardPointTextLabel.text = WSUtility.getlocalizedString(key: "Reward Points", lang: WSUtility.getLanguageCode(), table: "Localizable")
      
      if let promoName = validPromoDict["promoname"]as? String{
        promoCodeTextLabel.text = String(format: "%@: %@:",WSUtility.getlocalizedString(key: "Promo", lang: WSUtility.getLanguageCode(), table: "Localizable")!,promoName)
      }
      
      if let points = validPromoDict["points"]as? String{
        let totalStr = String(format: "+%@ %@",points,WSUtility.getlocalizedString(key: "Loyalty Points", lang: WSUtility.getLanguageCode(), table: "Localizable")!)
        promoCodeLoyaltyPointsLabel.attributedText = makeAttributeText(totalStr: totalStr, subStr: String(format: "+%@",points), fontSize:12.0)
        
        let rewardsPoints = Int(earnedLoyaltyPoints)! - Int(points)!
        
        let totalStr2 = String(format: "%@ %@","\(rewardsPoints)",WSUtility.getlocalizedString(key: "Loyalty Points", lang: WSUtility.getLanguageCode(), table: "Localizable")!)
        rewardLoyanltyPointsLabel.attributedText = makeAttributeText(totalStr: totalStr2, subStr: String(format: "%@","\(rewardsPoints)"), fontSize:12.0)
      }
      
      
    }
    else{
      
      rewardPointLabelsView.isHidden = true
      rewardPointTextLabel.isHidden = true
      promoCodeTextLabel.isHidden = true
      rewardLoyanltyPointsLabel.isHidden = true
      promoCodeLoyaltyPointsLabel.isHidden = true
      heightConstantRewardsView.constant = 20
    }
    WSWebServiceBusinessLayer().trackingScreens(screenName: "Checkout Summary Screen")
    UFSGATracker.trackScreenViews(withScreenName: "Checkout Summary Screen")
    FireBaseTracker.ScreenNaming(screenName: "Checkout Summary Screen", ScreenClass: String(describing: self))
    FBSDKAppEvents.logEvent("Checkout Summary Screen")
    // Do any additional setup after loading the view.
    //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    //    tableViewHeightConstraint.constant = CGFloat(cartArr.count * 44)
    applyDefoultStyle()
    
    if WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
      recommendedProceLabel.isHidden = true
    }else{
      recommendedProceLabel.isHidden = false
      recommendedProceLabel.text = WSUtility.getlocalizedString(key: "Recommended price from UFS", lang: WSUtility.getLanguageCode(), table: "Localizable")
    }
    
    
    
    
    //    if summaryDeliveryDate == ""{
    //      orderAddedTextLabel.text = WSUtility.getlocalizedString(key: "This order will be added to the next delivery", lang: WSUtility.getLanguage(), table: "Localizable")
    //    }
    //    else{
    //      let str = WSUtility.getlocalizedString(key: "Your order will be delivered on", lang: WSUtility.getLanguage(), table: "Localizable")
    //      let strLngCode = WSUtility.getLanguage()
    //
    //      let dateFormatter = DateFormatter()
    //      dateFormatter.dateFormat = "MM/dd/yyyy"
    //
    //      if let date = dateFormatter.date(from: summaryDeliveryDate){
    //        dateFormatter.dateFormat = "dd MMM yy"
    //        if  strLngCode == "de" {
    //          orderAddedTextLabel.text = str! + " " + dateFormatter.string(from: date) + " " +  "geliefert"
    //        }
    //        else{
    //          orderAddedTextLabel.text = str! + " " + dateFormatter.string(from: date)
    //        }
    //      }
    //    }
    
    lblInfo.text = WSUtility.getlocalizedString(key: "This order will be added to the next delivery", lang: WSUtility.getLanguage(), table: "Localizable")
    if self.view.frame.size.width < 376{
      lblInfo.font =  UIFont(name: "DinPro-Regular", size: 12.0)
    }
    
    if summaryDeliveryDate != ""{
      
      let calendar = Calendar.current
      
        var str = WSUtility.getlocalizedString(key: "Your order will be delivered on", lang: WSUtility.getLanguage(), table: "Localizable")
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MM/dd/yyyy"
      dateFormatter.locale = NSLocale(localeIdentifier: "\(WSUtility.getLanguageCode())_\(WSUtility.getCountryCode())") as Locale?
      
      if let date = dateFormatter.date(from: summaryDeliveryDate){
        dateFormatter.dateFormat = "MMM yyyy"
        let dateComponents = calendar.component(.day, from: date)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        let day = numberFormatter.string(from: dateComponents as NSNumber)
        let dateString = "\(day!) \(dateFormatter.string(from: date))"
        
        //            if  strLngCode == "de" {
        if self.view.frame.size.width < 376{
          lblInfo.font =  UIFont(name: "DinPro-Regular", size: 12.0)
            if (str?.contains(find: "…"))!{
                str = str?.replacingOccurrences(of:"…", with: dateString)
                lblInfo.attributedText = makeAttributeText(totalStr: str!, subStr: dateString, fontSize:12.0)
            }
            else{
                lblInfo.attributedText = makeAttributeText(totalStr: str! + " " + dateString, subStr: dateString, fontSize:12.0)
            }
        }
        else{
            if (str?.contains(find: "…"))!{
                str = str?.replacingOccurrences(of:"…", with: dateString)
                lblInfo.attributedText = makeAttributeText(totalStr: str!, subStr: dateString, fontSize:14.0)
            }
            else{
                lblInfo.attributedText = makeAttributeText(totalStr: str! + "  " + dateString, subStr: dateString, fontSize:14.0)
            }

          
        }
        
        //            }
        //            else{
        //                lblInfo.text = str!
        //            }
        //            lblDeliveryDate.text = dateFormatter.string(from: date)
      }
    }
    summaryLabel.text = WSUtility.getlocalizedString(key: "Summary", lang: WSUtility.getLanguage(), table: "Localizable")
    
    termsLabel.text = WSUtility.getlocalizedString(key: "By continuing you are agree with our", lang: WSUtility.getLanguage(), table: "Localizable")
    rewardPointsLabel.text = WSUtility.getlocalizedString(key: "Reward Points", lang: WSUtility.getLanguage(), table: "Localizable")
    billingLabel.text = WSUtility.getlocalizedString(key: "Billing", lang: WSUtility.getLanguage(), table: "Localizable")
    myCartLabel.text = WSUtility.getlocalizedString(key: "My Cart", lang: WSUtility.getLanguage(), table: "Localizable")
    myDetailLabel.text = WSUtility.getlocalizedString(key: "My Detail", lang: WSUtility.getLanguage(), table: "Localizable")
    
    tradePartnerLabel.text = WSUtility.getlocalizedString(key: "Trade partner", lang: WSUtility.getLanguage(), table: "Localizable")
    placeOrderButton.setTitle(WSUtility.getlocalizedString(key: "Place Order", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    placeOrderBtn2.setTitle(WSUtility.getlocalizedString(key: "Place Order", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    if WSUtility.isLoginWithTurkey(){
        setUpTextViewTnCForTR()
        termsLabel.isHidden = true
        termsButton.isHidden = true
        
    }
    else{
        textViewTnCTR.isHidden = true
        termsLabel.isHidden = false
        termsButton.isHidden = false
    }
    let attributeString = NSMutableAttributedString(string: (WSUtility.getlocalizedString(key: "edit", lang: WSUtility.getLanguage(), table: "Localizable"))!,
                                                    attributes: [
                                                      NSFontAttributeName : UIFont(name: "DinPro-Regular", size: 16.0)!,
                                                      NSForegroundColorAttributeName : ApplicationOrangeColor,
                                                      NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue])
    changeBillingButton.setAttributedTitle(attributeString, for: .normal)
    changeButton.setAttributedTitle(attributeString, for: .normal)
    changeMyDetailBtn.setAttributedTitle(attributeString, for: .normal)
    changeTradePartnerBtn.setAttributedTitle(attributeString, for: .normal)
    changeMyCartBtn.setAttributedTitle(attributeString, for: .normal)
    btnEditPayment.setAttributedTitle(attributeString, for: .normal)
    
    let attributeStr = NSMutableAttributedString(string: (WSUtility.getlocalizedString(key: "Change-Summary", lang: WSUtility.getLanguage(), table: "Localizable"))!,
                                                 attributes: [
                                                  NSFontAttributeName : UIFont(name: "DinPro-Regular", size: 16.0)!,
                                                  NSForegroundColorAttributeName : UIColor(red: 106.0 / 255.0, green: 179.0 / 255.0, blue: 219.0 / 255.0, alpha: 1),
                                                  NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue])
    btnChangeInfo.setAttributedTitle(attributeStr, for: .normal)

    termsButton.setTitle(WSUtility.getlocalizedString(key: "Terms and Conditions", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    //let currentLoyaltyBalance =  WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "currentLoyaltyBalance"))
    loyaltyPointsLbl.text = "\(earnedLoyaltyPoints)"+" "+"\(String(describing: WSUtility.getlocalizedString(key: "Loyalty Points", lang: WSUtility.getLanguage(), table: "Localizable")!))"
    
    myDetailProcessLbl.text = WSUtility.getlocalizedString(key: "My Detail", lang: WSUtility.getLanguage(), table: "Localizable")
    deliveryProcessLbl.text = WSUtility.getlocalizedString(key: "Delivery", lang: WSUtility.getLanguage(), table: "Localizable")
    summaryProcessLbl.text = WSUtility.getlocalizedString(key: "Summary", lang: WSUtility.getLanguage(), table: "Localizable")
    
    //loyaltyPointsCount.text = ""
    
    //        @IBOutlet weak var changeMyDetailBtn: UIButton!
    //        @IBOutlet weak var changeTradePartnerBtn: UIButton!
    //        @IBOutlet weak var changeDeliveryBtn: UIButton!
    //        @IBOutlet weak var changeBillingBtn: UIButton!
    //        @IBOutlet weak var changeMyCartBtn: UIButton!
  }
    func manageBlueNoteForTurkey(){
        vwBlueNoteBase.isHidden = true
        htConstBlueNote.constant = 0.0
        let user:WSUser = WSUser().getUserProfile()
        if WSUtility.isLoginWithTurkey() && (user.userGroup == WSUser.UserGroupType().DTBO || user.userGroup == WSUser.UserGroupType().DTT){
            vwBlueNoteBase.isHidden = false
            htConstBlueNote.constant = 60.0
            if self.view.frame.size.width < 376{
                lblTRBlueNote.font =  UIFont(name: "DinPro-Regular", size: 13.0)
            }
        }
    }
    func setUpTextViewTnCForTR(){
        let termsAndConditionsURL = "TermsAndConditions";
        let privacyURL = "OnlineSellingContract";

        let str = (WSUtility.getlocalizedString(key: "By continuing, you agree with our Terms and Conditions and Online Selling Contract", lang: WSUtility.getLanguage(), table: "Localizable"))
        let attributedString = NSMutableAttributedString(string: str!)
        let foundRange2 = attributedString.mutableString.range(of: (WSUtility.getlocalizedString(key: "Online Selling Contract", lang: WSUtility.getLanguage(), table: "Localizable"))!)
        attributedString.addAttribute(NSLinkAttributeName, value: privacyURL, range: foundRange2)
        let foundRange = attributedString.mutableString.range(of: (WSUtility.getlocalizedString(key: "Terms and Conditions", lang: WSUtility.getLanguage(), table: "Localizable"))!)
        attributedString.addAttribute(NSLinkAttributeName, value: termsAndConditionsURL, range: foundRange)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.init(name: "DINPro-Regular", size: 16.0)!, range: NSMakeRange(0, attributedString.length))
        textViewTnCTR.linkTextAttributes = [
            NSForegroundColorAttributeName: UIColor.orange,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,
        ]
        textViewTnCTR.attributedText = attributedString
        textViewTnCTR.delegate = self
        textViewTnCTR.isHidden = false
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return textViewShouldInteractWithURL(URL: URL)
    }
    func textViewShouldInteractWithURL(URL: URL) -> Bool {
        if URL.absoluteString == "TermsAndConditions"{
            let stryBoard : UIStoryboard = UIStoryboard(name: "Signup", bundle:nil)
            let nextViewController = stryBoard.instantiateViewController(withIdentifier: "WSTermsAndConditionsViewControllerID")
            nextViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.navigationController?.present(nextViewController, animated: true, completion: nil)
        }
        if URL.absoluteString == "OnlineSellingContract"{
            let stryBoard : UIStoryboard = UIStoryboard(name: "Signup", bundle:nil)
            let nextViewController = stryBoard.instantiateViewController(withIdentifier: "WSTermsAndConditionsViewControllerID") as! WSTermsAndConditionsViewController
            nextViewController.loadOnlineContractDocx = true
            nextViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.navigationController?.present(nextViewController, animated: true, completion: nil)

        }
        return false
    }

  func makeAttributeText(totalStr: String, subStr: String, fontSize:Float)-> NSMutableAttributedString{
    let range = NSString(string: totalStr).range(of: subStr)
    let attributedString = NSMutableAttributedString(string: totalStr)
    attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "DINPro-Bold", size: CGFloat(fontSize))!, range: range)
    
    return attributedString
  }
  
  func applyDefoultStyle(){
    
    let totalItemsText = WSUtility.getlocalizedString(key: "Total items", lang: WSUtility.getLanguage(), table: "Localizable")
    let fName =  detailDictionary["firstName"] as! String
    let lName = detailDictionary["lastName"] as! String
    self.detailName.text = fName + " " + lName
    self.detailAddress.text = detailDictionary["email"] as? String
    self.detailPhone.text = detailDictionary["phone"] as? String
    self.tradeName.text =  self.tradeNameTxt
    self.childName.text = self.childTradeNameTxt
    self.accountNo.text = detailDictionary["toAccountNumber"] as? String
    self.deliveryName.text = (addressDictionary["line1"] as? String)!
    self.deliveryStreet.text = (addressDictionary["line2"] as? String)!
    self.deliveryAddress.text = addressDictionary["town"] as? String
    
    self.billingName.text = billingAddressDictionary["line1"] as? String//fName + " " + lName
    self.billingStreet.text = billingAddressDictionary["line2"] as? String
    self.billingAddress.text = billingAddressDictionary["town"] as? String
    
    self.totalItemsLbl.text = "\(self.totalItemsQunatity)" + " " + "\(WSUtility.getlocalizedString(key: "Items", lang: WSUtility.getLanguage(), table: "Localizable")!)"
    self.totalItemsLbl1.text =   " \(totalItemsText!) [\(self.totalItemsQunatity)]"
    let stringPrice = "\(totalPrice)"
    //    if WSUtility.getCountryCode() != "CH" {
    //        stringPrice = stringPrice.replacingOccurrences(of: ".", with: "")
    //    }
    //    else{
    //
    //    }
    self.priceLbl.text = stringPrice
    
    
    cartContainerView.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor
    summaryContainerView.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor
    deliveryContainerView.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor
    billingContainerView.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor
    tradePartnerContainerView.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor
    vwPaymentBase.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor
    
    lblDeliveryNotesHdr.text = WSUtility.getlocalizedString(key: "Delivery notes", lang: WSUtility.getLanguage(), table: "Localizable")
    checkoutLabel.text = WSUtility.getlocalizedString(key: "Checkout", lang: WSUtility.getLanguage(), table: "Localizable")
    
    let button: UIButton = UIButton(type: UIButtonType.custom)
    button.setImage(UIImage(named: "lock.png"), for: UIControlState.normal)
    let barButton = UIBarButtonItem(customView: button)
    self.navigationItem.rightBarButtonItem = barButton
    
    if strDeliveryNotes == ""{
      lblDeliveryNotesDesc.text = ""
      lblDeliveryNotesDesc.isHidden = true
      htConstDelivryNotesHdr.constant = 0
    }
    else{
      lblDeliveryNotesDesc.text = strDeliveryNotes
      lblDeliveryNotesDesc.isHidden = false
      htConstDelivryNotesHdr.constant = 20
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    goBack()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    putDeliveryMode()
  }
  
  func goBack()
  {
    WSUtility.addNavigationBarBackToCartButton(controller:self)
  }
  @IBAction func backAction(_ sender: UIButton) {
    //self.navigationController?.popViewController(animated: true)
    UserDefaults.standard.set(false, forKey: "isFromSummary")
    UserDefaults.standard.set(nil, forKey: "userDeliveryDetails")
    self.popBack(toControllerType: HYBCartController.self)
  }
  
  @IBAction func termsAndConditionsPressed(_ sender: Any) {
//        let stryBoard : UIStoryboard = UIStoryboard(name: "AppSettings", bundle:nil)
//        let nextViewController = stryBoard.instantiateViewController(withIdentifier: "WSTermsAndConditionsViewController")
//    self.navigationController?.present(nextViewController, animated: true, completion: nil)
  }
  
  
  @IBAction func placeOrderClicked(_ sender: Any) {
    postPaymentAndBilling()
  }
  
  @IBAction func myDetailChangeClicked(_ sender: Any) {
    self.popBack(toControllerType: MyDetailViewController.self)
  }
  
  @IBAction func tradePartnerChangeClicked(_ sender: Any) {
    self.popBack(toControllerType: MyDetailViewController.self)
  }
  @IBAction func deliveryChangeClicked(_ sender: Any) {
    self.popBack(toControllerType: DeliveryViewController.self)
  }
  @IBAction func billingChangeClicked(_ sender: Any) {
    self.popBack(toControllerType: DeliveryViewController.self)
  }
  @IBAction func btnEditPaymentTapped(_ sender: Any) {
    let user:WSUser = WSUser().getUserProfile()
    
    if user.userGroup == WSUser.UserGroupType().DTBO{
        self.popBack(toControllerType: DeliveryViewController.self)
    }
    else{
        self.popBack(toControllerType: PaymentViewController.self)
    }
  }
  @IBAction func myCartChangeClicked(_ sender: Any) {
    self.popBack(toControllerType: HYBCartController.self)
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
  
  // number of rows in table view
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.cartArr.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  // create a cell for each table view row
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // create a new cell if needed or reuse an old one
    let cell = tableView.dequeueReusableCell(withIdentifier: "CartSummaryTableViewCell") as? CartSummaryTableViewCell
    
    // set the text from the data model
    cell?.productNameLabel.text = self.cartArr[indexPath.row]
    
    return cell!
  }
  
  func putDeliveryMode(){
    UFSProgressView.showWaitingDialog("")
    
    let cartId = UFSHybrisUtility.uniqueCartId
    let email_id = UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)!
    let url = "users/\(email_id)/carts/\(cartId)/deliverymode?deliveryModeId=premium-gross&vendorId=\(selectedTradePartnerId)"
    let webServiceBusinessLayer = WSWebServiceBusinessLayer()
    webServiceBusinessLayer.putAddressToCart(productID: url, successResponse: { (response) in
      print("response:%@",response)
      UFSProgressView.stopWaitingDialog()
    }) { (errorMessage) in
      print("error")
      UFSProgressView.stopWaitingDialog()
    }
  }
  
  func postPaymentAndBilling(){
    
    UFSProgressView.showWaitingDialog("")
    let cartId = UFSHybrisUtility.uniqueCartId
    let email_id = UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)!
    var sameBillingAdd = ""
    if(sameBilling == 0){
      sameBillingAdd = "false"
    }else{
      sameBillingAdd = "true"
    }
    let url = "users/\(email_id)/carts/\(cartId)/paymentdetails?sameAddress=\(sameBillingAdd)&vendorId=\(selectedTradePartnerId)"
    let webServiceBusinessLayer = WSWebServiceBusinessLayer()
    webServiceBusinessLayer.postPaymentAndBilling(productID: url,params:billingAddressDictionary as NSDictionary, successResponse: { (response) in
      print("response:%@",response)
      
 
      self.placePostOrder()
      
    }) { (errorMessage) in
      print("error")
      UFSProgressView.stopWaitingDialog()
      
    }
  }
  func fetchUserProfile() {
    let webServiceBusinessLayer = WSWebServiceBusinessLayer()
    webServiceBusinessLayer.getBasicUserProfile(parameter: [String:Any](), methodName: GET_BASIC_PROFILE_API, successResponse: { (response) in
      UFSProgressView.stopWaitingDialog()
      //            let firstName = response["firstName"] as? String
      //            let lastName = response["lastName"] as? String
      //            UserDefaults.standard.setValue(lastName, forKey:"LastName")
      //            UserDefaults.standard.setValue(firstName, forKey:"FirstName")
      //
      //            if let zipCode = response["zipCode"]{
      //                UserDefaults.standard.set("\(zipCode)", forKey: USER_ZIP_CODE)
      //            }else{
      //                UserDefaults.standard.set("9999", forKey: USER_ZIP_CODE)
      //            }
      //
      //            self.userId = response["userId"] as! String
      //            self.userInfoDict = response
      //            self.profileTableView.reloadData()
      //            self.updatePercentageVal(userDict: self.userInfoDict, tradeDict: self.tradePartnerDict)
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
    }
  }
  
  func placePostOrder(){
    
    let cartId = UFSHybrisUtility.uniqueCartId
    let email_id = UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)!
    
    let url = "users/\(email_id)/orders?cartId=\(cartId)&paymentMode=\(paymentMode)&sifuToken=\(WSUtility.getSifuToken())"

    if (paymentMode == "payu" && paymentDetailDict["isPaymentFromSavedCard"] as! Bool == true  ){
        paymentDetailDict["CardNumber"] = ""
        paymentDetailDict["NameOnCard"] = ""
        paymentDetailDict["CVV"] = ""
        paymentDetailDict["Expiration_Month"] = ""
        paymentDetailDict["Expiration_Year"] = ""
    }
    detailDictionary["PaymentDetail"] = paymentDetailDict
    detailDictionary["PaymentMode"] = paymentMode
    detailDictionary["amount"] = totalPriceForPayment_TR
    detailDictionary["VendorID"] = selectedTradePartnerId
    
    let webServiceBusinessLayer = WSWebServiceBusinessLayer()
    webServiceBusinessLayer.placePostOrder(productID: url, orderInfoDetail: detailDictionary, successResponse: { (response) in
      print("response#####:%@",response)
      
      // Campaign tracking
      self.campaignTracking(dictionary: response)
      
      var priceNumber: NSNumber = 0
      if let priceData = response["subTotal"] as? [String: Any]{
        if let price = priceData["value"] as? NSNumber{
          priceNumber = price
        }
      }
        if WSUtility.getCountryCode() == "TR" {
            AdjustTracking.EventTracking(token: "kv66ls")
        }
        
        
      if let sifuOrderID = response["sifuOrderId"] as? String{
        FireBaseTracker.fireBaseTrackingWith(Events: "ECOMMERCE_PURCHASE", params: ["TRANSACTION_ID":sifuOrderID, "VALUE" :priceNumber,  "CURRENCY":"EUR"])
        FireBaseTracker.fireBaseTrackerWith(Events: "Orders", Category: "Product Order", Action: "Order Number - \(sifuOrderID)", Label: "Product Order Success")
        UFSGATracker.trackEvent(withCategory: "Product Order", action: "Order Number - \(sifuOrderID)", label: "Product Order Success", value: nil)
        WSUtility.sendTrackingEvent(events: "Orders", categories: "Product order",actions:"Order Number - \(sifuOrderID)")
      } else if let sifuOrderID = response["code"] as? String {
        FireBaseTracker.fireBaseTrackingWith(Events: "ECOMMERCE_PURCHASE", params: ["TRANSACTION_ID":sifuOrderID, "VALUE" :priceNumber,  "CURRENCY":"EUR"])
        FireBaseTracker.fireBaseTrackerWith(Events: "Orders", Category: "Product Order", Action: "Order Number - \(sifuOrderID)", Label: "Product Order Success")
        UFSGATracker.trackEvent(withCategory: "Product Order", action: "Order Number - \(sifuOrderID)", label: "Product Order Success", value: nil)
        WSUtility.sendTrackingEvent(events: "Orders", categories: "Product order",actions:"Order Number - \(sifuOrderID)")
        }

      FireBaseTracker.ScreenNaming(screenName: "tracion completed", ScreenClass: String(describing: self))
      
      
      //Reset Cart Value
      UFSHybrisUtility.cartData = ["":""]
      
      let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "OrderSuccessView") as! OrderSuccessViewController
      secondViewController.orderStatusDictionary = response
      secondViewController.earnedLoyaltyPoints = self.earnedLoyaltyPoints
      secondViewController.promoCode = self.promoCode
      self.navigationController?.pushViewController(secondViewController, animated: true)
      UFSProgressView.showWaitingDialog("")
      
    }) { (errorMessage) in
      print("error")
      UFSProgressView.stopWaitingDialog()
      
      if errorMessage == "Please enter a valid card detail."{
        WSUtility.showAlertWith(message: WSUtility.getlocalizedString(key: errorMessage, lang: WSUtility.getLanguage())!, title: "", forController: self)
      }else{
        
          WSUtility.showAlertWith(message: WSUtility.getlocalizedString(key: errorMessage, lang: WSUtility.getLanguage())!, title: "", forController: self)
      //DTO user: When user tries to checkout with the excluded products in the list
      self.tabBarController?.selectedIndex = 0
      self.navigationController?.popToRootViewController(animated: true)
    }
    }
  }
  
  
  @IBAction func btnChangeInfoTapped(_ sender: Any) {
    summaryDeliveryDate = ""
    self.popBack(toControllerType: DeliveryViewController.self)
  }
  
  func campaignTracking(dictionary:[String: Any]){
    let action = GAIEcommerceProductAction()
    action.setAction(kGAIPAPurchase)
    if let sifuOrderID = dictionary["sifuOrderId"] as? String{
      action.setTransactionId(sifuOrderID)
    }
    
    //        action.setAffiliation("Google Store - Online")
    if let priceData = dictionary["subTotal"] as? [String: Any]{
      if let price = priceData["value"] as? NSNumber{
        action.setRevenue(price)
      }
    }
    
    //        action.setCouponCode(discountCode ?? "")
    
    let builder = GAIDictionaryBuilder.createEvent(withCategory: "Ecommerce", action: "Purchase", label: nil, value: nil)
    builder?.setProductAction(action)
    //        builder.addProduct(product)
    
    let build: [NSObject: AnyObject] = builder!.build() as [NSObject : AnyObject]
    
    let tracker = GAI.sharedInstance().defaultTracker
    tracker?.set("&cu", value: "EUR")
    tracker?.send(build)
    
    
  }
  
  override func viewDidLayoutSubviews(){
    
    if sameBilling == 1{
      billingContainerView.isHidden = true
      deliveryLabel.text = WSUtility.getlocalizedString(key: "Delivery and Billing", lang: WSUtility.getLanguage(), table: "Localizable")
      paymentConstX.constant = 23
    }
    else{
      billingContainerView.isHidden = false
      deliveryLabel.text = WSUtility.getlocalizedString(key: "Delivery", lang: WSUtility.getLanguage(), table: "Localizable")
      paymentConstX.constant = billingContainerView.frame.size.height + 50
    }
    
    let countryCode =  WSUtility.getCountryCode()
    if countryCode == "TR"{
        lblPerMonth.isHidden = true
//        topCnstCCDetailsLbl.constant = 0.0

      vwPaymentBase.isHidden = false
      lblPaymentHdr.isHidden = false
      lblSubPymntHdr.isHidden = false
        lblPaymentHdr.text = WSUtility.getlocalizedString(key: "Payment", lang: WSUtility.getLanguage())

      switch strSelectedPmntMode {
      case "cash":
        htConstPaymentVw.constant = 76.0
        btmCnstPaymentVw.constant = 17.0
        vwBaseCCDetails.isHidden = true
        lblSubPymntHdr.text = WSUtility.getlocalizedString(key: "Payment by mail order", lang: WSUtility.getLanguage())
      case "cc":
        lblNoOfPayments.isHidden = true
        htConstPaymentVw.constant = 175.0
        btmCnstPaymentVw.constant = 17.0
        vwBaseCCDetails.isHidden = false
        let str = paymentDetailDict["CardNumber"] as? String
        let mySubstring = str?.suffix(4)
        lblSubPymntHdr.text = WSUtility.getlocalizedString(key: "Pay by Credit Card", lang: WSUtility.getLanguage())
        let strEnd = WSUtility.getlocalizedString(key: "Card ending in", lang: WSUtility.getLanguage())
        let strExpiry = WSUtility.getlocalizedString(key: "Expiry date", lang: WSUtility.getLanguage())
        lblCCDetails.text = "\(mySubstring ?? "") \(strEnd ?? "")\n\(paymentDetailDict["NameOnCard"] ?? "")\n\(strExpiry ?? "") \(paymentDetailDict["Expiration_Month"] ?? "")/\(paymentDetailDict["Expiration_Year"] ?? "")"
        

      case "moneytransfer":
        htConstPaymentVw.constant = 175.0
        btmCnstPaymentVw.constant = 17.0
        vwBaseCCDetails.isHidden = false
        lblSubPymntHdr.text = WSUtility.getlocalizedString(key: "Pay by Money Transfer", lang: WSUtility.getLanguage())
        
        lblNoOfPayments.font = UIFont(name: "DinPro-Regular", size: 13.0)
        lblNoOfPayments.textColor = UIColor(red: 69.0/255.0, green: 69.0/255.0, blue: 69.0/255.0, alpha: 1)
        lblNoOfPayments.text = "IBAN: \(paymentDetailDict["accountNumber"] ?? "")"
        
        lblCCDetails.font = UIFont(name: "DinPro-Regular", size: 12.0)
        lblCCDetails.textColor = UIColor(red: 205.0/255.0, green: 205.0/255.0, blue: 205.0/255.0, alpha: 1)
        lblCCDetails.text = "\(paymentDetailDict["name"] ?? "")"

      default: break
      }
      
    }
    else{
      vwPaymentBase.isHidden = true
      htConstPaymentVw.constant = 0.0
      btmCnstPaymentVw.constant = 0.0
      lblPaymentHdr.isHidden = true
      lblSubPymntHdr.isHidden = true
    }
    
    tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)
    tableViewHeightConstraint.constant = CGFloat(tableView.frame.size.height)
    
    tableView.reloadData()
    vwTopBase.dropShadowForCheckout()
    vwCenterBase.dropTopAndBottomShadow()
    vwBottomBase.dropTopShadow()
    
    
  }
}

