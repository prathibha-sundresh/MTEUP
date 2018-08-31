//
//  WSChefRewardState3TableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 21/11/2017.
//

import UIKit

@objc protocol ChefRewardState3Delegate{
  func reloadTableViewAfterReedemGift()
  func didSelectOnDoubleLoyaltyProduct(productCode:String)
  
}

class WSChefRewardState3TableViewCell: UITableViewCell {
    @IBOutlet weak var joinLoyaltyLogoImage: UIImageView!
  @IBOutlet weak var loyaltyPointLabel: UILabel!
  @IBOutlet weak var progressLabelEndValue: UILabel!
  @IBOutlet weak var progressLabelStartValue: UILabel!
  @IBOutlet weak var transparentView: UIView!
  @IBOutlet weak var shopNowContainerView: WSChefRewardShopNowView!
  @IBOutlet weak var progressView: UIProgressView!
  
  @IBOutlet weak var goalLoyaltyPointLabel: UILabel!
  @IBOutlet weak var productName: UILabel!
  @IBOutlet weak var productImage: UIImageView!
  @IBOutlet weak var reachGoalMessageLabel: UILabel!
  @IBOutlet weak var shopNowButton: WSDesignableButton!
  @IBOutlet weak var buyAndEarnChefRewardTextLabel: UILabel!
  
  @IBOutlet weak var redeemBtn: WSDesignableButton!
  var loyaltyBalanceAfterReedemGift = 0
  var doubleLoyaltyProductcode = ""
  var delegate:ChefRewardState3Delegate?
  //var isReedemViewDisplaying = false
  @IBOutlet weak var congratsOnReachGoalTextLabel: UILabel!
  
  @IBOutlet weak var shopNowContainerHeightConstraint: NSLayoutConstraint!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    progressView.layer.cornerRadius = 12.5
    progressView.layer.masksToBounds = true
    
    // Set the rounded edge for the inner bar
    progressView.layer.sublayers![1].cornerRadius = 12
    progressView.subviews[1].clipsToBounds = true
    
    transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    
  }
  
  func shopNowButtonMultilineSetUp()  {
    shopNowButton.titleLabel!.numberOfLines = 0
    shopNowButton.titleLabel!.adjustsFontSizeToFitWidth = true
    shopNowButton.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
    shopNowButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    shopNowButton.titleLabel!.textAlignment = .center
  }
  
  func updateCellContent()  {
    
    joinLoyaltyLogoImage.image = UIImage(named: WSUtility.isLoginWithTurkey() ? "trLoyaltyProgrammeIcon" : "TutorialchefRewards")
    shopNowButtonMultilineSetUp()
    shopNowButton.setTitle(WSUtility.getlocalizedString(key: "Shop now", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    shopNowButton.layer.borderWidth = 1.0
    shopNowButton.titleLabel?.adjustsFontSizeToFitWidth = true
    buyAndEarnChefRewardTextLabel.text = WSUtility.getTranslatedString(forString: "Buy and earn Chef rewards")
    
    if let userDict = UserDefaults.standard.value(forKey: USER_GOAL_DETAIL_KEY){
      let dictProductInfo = userDict as! [String:Any]
      if dictProductInfo.count > 0 {
        if let prodName = dictProductInfo["ProductName"] as? String{
          productName.text = prodName
        }
        
        productImage.sd_setImage(with: URL(string: dictProductInfo["ImageUrl"] as! String), placeholderImage: UIImage(named: "placeholder.png"))
        goalLoyaltyPointLabel.text = "\(dictProductInfo["LoyaltyPoint"]!) \(WSUtility.getTranslatedString(forString: "Points"))"
        let goalLoyaltyPoint = "\(dictProductInfo["LoyaltyPoint"]!)"
        
        congratsOnReachGoalTextLabel.text = WSUtility.getTranslatedString(forString: "Congrats on reaching your goal")
        redeemBtn.setTitle(WSUtility.getTranslatedString(forString: "Visit UFS.com to redeem your reward"), for: .normal)
        if let myLoyaltyPoint = UserDefaults.standard.value(forKey: LOYALTY_BALANCE_KEY) as? String {
          
          WSUtility.setLoyaltyPoint(label: loyaltyPointLabel)
          
          guard myLoyaltyPoint.count > 0  else {
            return
          }
          
          let intGoalLoyaltyPoint = Int(goalLoyaltyPoint)
          let intMyLoyaltyPoint = Int(myLoyaltyPoint)
          
          if intMyLoyaltyPoint! >= intGoalLoyaltyPoint! {
            
            reachGoalMessageLabel.text = WSUtility.getlocalizedString(key:"Nice one!You reached your goal", lang: WSUtility.getLanguage(), table: "Localizable")
            reachGoalMessageLabel.font = UIFont(name: "DINPro-Medium", size: 13)
            progressView.progressTintColor = UIColor(red: 118.0/255.0, green: 183.0/255.0, blue: 47.0/255.0, alpha: 1)
            progressView.setProgress(1, animated: true)
            var appVersion = ""
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                appVersion = version
            }

                //UFSGATracker.trackEvent(withCategory: "reach loyalty goal", action: "Button click", label: "Loyalty Goal Reached", value: nil)
                
            shopNowButton.setTitle(WSUtility.getlocalizedString(key:"Redeem your gift", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
            shopNowButton.tag = 100
            loyaltyBalanceAfterReedemGift = (intMyLoyaltyPoint! - intGoalLoyaltyPoint!)
            // progressLabelEndValue.isHidden = true
            //progressLabelStartValue.isHidden = true
            progressLabelEndValue.textColor = UIColor.white
            progressLabelEndValue.text  = goalLoyaltyPoint
            
          }else{
            
            progressLabelEndValue.isHidden = false
            progressLabelStartValue.isHidden = false
            
            shopNowButton.setTitle(WSUtility.getlocalizedString(key:"Shop now to earn more points", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
            shopNowButton.tag = 200
            progressView.progressTintColor = UIColor(red: 255.0/255.0, green: 90.0/255.0, blue: 2.0/255.0, alpha: 1)
            
            print(Double(intMyLoyaltyPoint!)/Double(intGoalLoyaltyPoint!))
            
            let percentageComplete = (Double(intMyLoyaltyPoint!)/Double(intGoalLoyaltyPoint!)) * 100
            progressView.setProgress((Float(percentageComplete/100)), animated: true)
            let pointRemaining = intGoalLoyaltyPoint! - intMyLoyaltyPoint!
            progressLabelEndValue.text  = goalLoyaltyPoint
            if pointRemaining > 0{
              
              var firstName = ""
              if let name = UserDefaults.standard.value(forKey: "FirstName"){
                firstName = name as! String
              }
              
              reachGoalMessageLabel.font = UIFont(name: "DINPro-Regular", size: 13)
              let reachGoalLocalizedString = String(format:WSUtility.getTranslatedString(forString: "Hey James, earn 400 points to reach your goal"),firstName,"\(pointRemaining)")
              
              let attributedString = NSMutableAttributedString(string:reachGoalLocalizedString)
              attributedString.setColorForText("\(pointRemaining) " + WSUtility.getlocalizedString(key: "Points", lang: WSUtility.getLanguage(), table: "Localizable")!, with: UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1), with: UIFont(name: "DINPro-Medium", size: 15.0)!)
              reachGoalMessageLabel.attributedText = attributedString
              
            }
            
          }
          
        }
        
      }
    }
    
    if WSUtility.isUserPlacedFirstOrder(){
      
       shopNowContainerView.subviews.forEach { $0.isHidden = true }
      
      let doubleLoyaltyProductCachedResponse = WSCacheSingleton.shared.cache.object(forKey: Cached_Double_Loyalty_Product_KEY as NSString) as Any
      
      if let dobleLoyaltyProductDict = doubleLoyaltyProductCachedResponse as? [String:Any]{
        
        if dobleLoyaltyProductDict.count > 0{
          
           shopNowContainerView.subviews.forEach { $0.isHidden = false }
         // let prodcutDict = dobleLoyaltyProductArray[0]
          
            var productname = ""
            if let str = dobleLoyaltyProductDict["productName"] as? String{
                productname = str
            }
            else if let str = dobleLoyaltyProductDict["name"] as? String{
                productname = str
            }
            
          if productname != ""{
            let productName:String = productname
            
            shopNowContainerView.termsText.isHidden = true
            
            var captionText = ""
            if (dobleLoyaltyProductDict["productLoyaltyRemark"] as? String)?.range(of:"2x") != nil || (dobleLoyaltyProductDict["productLoyaltyRemark"] as? String)?.range(of:"2 fach") != nil {
              
              captionText = String(format: WSUtility.getlocalizedString(key: "Order product and get double loyatly points", lang: WSUtility.getLanguage(), table: "Localizable")!, productName)
              shopNowContainerView.placeTextLabel.attributedText = self.makeAttributeText(stringVal: captionText, typeStr: WSUtility.getlocalizedString(key: "double loyalty points", lang: WSUtility.getLanguage(), table: "Localizable")!, productName: productName)
            }else if (dobleLoyaltyProductDict["productLoyaltyRemark"] as? String)?.range(of:"3x") != nil || (dobleLoyaltyProductDict["productLoyaltyRemark"] as? String)?.range(of:"3 fach") != nil {
              captionText = String(format: WSUtility.getlocalizedString(key: "Order product and get triple loyatly points", lang: WSUtility.getLanguage(), table: "Localizable")!, productName)
              shopNowContainerView.placeTextLabel.attributedText = self.makeAttributeText(stringVal: captionText, typeStr: WSUtility.getlocalizedString(key: "triple loyatly points", lang: WSUtility.getLanguage(), table: "Localizable")!, productName: productName)
            }else{
              captionText = String(format: WSUtility.getlocalizedString(key: "Order product and get extra loyatly points", lang: WSUtility.getLanguage(), table: "Localizable")!, productName)
              shopNowContainerView.placeTextLabel.attributedText = self.makeAttributeText(stringVal: captionText, typeStr: WSUtility.getlocalizedString(key: "extra loyatly points", lang: WSUtility.getLanguage(), table: "Localizable")!, productName: productName)
            }
            
            shopNowContainerView.placeTextLabel.text = captionText
          }
          
          
          if let product_image_url = dobleLoyaltyProductDict["packshotUrl"] as? String {
            //shopNowcontainerView.shopNowImageView.image = #imageLiteral(resourceName: "thai-yellow-curry-paste")
            shopNowContainerView.shopNowImageView.sd_setImage(with: URL.init(string:product_image_url), placeholderImage: #imageLiteral(resourceName: "placeholder"))
          }
          
          doubleLoyaltyProductcode = "\(dobleLoyaltyProductDict["productNumber"] ?? "")"
          shopNowContainerView.doubleLoyaltyProductcode = doubleLoyaltyProductcode
          
        }
        
      }
      
      
    }
    
  }
  
    func makeAttributeText(stringVal: String, typeStr: String, productName: String)-> NSMutableAttributedString{
        let range = NSString(string: stringVal).range(of: productName)
        let attributedString = NSMutableAttributedString(string: stringVal)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "DINPro-Bold", size: 16.0)!, range: range)
        let range2 = NSString(string: stringVal).range(of: typeStr)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "DINPro-Bold", size: 16.0)!, range: range2)
        return attributedString
    }
    
  @IBAction func visitUFSSiteAction(_ sender: UIButton) {
    //http://stage.unileverfoodsolutions.at/treueprogramm.html
    
    /*
    var reedemUrl = Reedem_GIFT_BASE_URL().REEDEM_GIFT_URL_AT
    let countryCode = WSUtility.getCountryCode()
    if countryCode == "AT"{
      reedemUrl = Reedem_GIFT_BASE_URL().REEDEM_GIFT_URL_AT
    }else if countryCode == "DE"{
      reedemUrl = Reedem_GIFT_BASE_URL().REEDEM_GIFT_URL_DE
    }else if countryCode == "CH"{
      reedemUrl = Reedem_GIFT_BASE_URL().REEDEM_GIFT_URL_CH
    }else if countryCode == "TR"{
      reedemUrl = Reedem_GIFT_BASE_URL().REEDEM_GIFT_URL_TR
    }
 */
    let reedemUrl = WSConfigurationFile().getReedemGiftUrl(countryCode: WSUtility.getCountryCode())
    guard let url = URL(string: reedemUrl) else {
      return //be safe
    }
    
  
    
    if #available(iOS 10.0, *) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
      UIApplication.shared.openURL(url)
    }
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  @IBAction func shopNowButtonAction(_ sender: UIButton) {
    if sender.tag == 200 {
      let tabBarController = window?.rootViewController as? UITabBarController
      tabBarController?.selectedIndex = 2
     // delegate?.didSelectOnDoubleLoyaltyProduct(productCode: doubleLoyaltyProductcode)
    }else {
      // Reedem your gift
      //resetGoalOnGiftReedem()
      self.showReedemTransparentView()
    }
  }
  
  func resetGoalOnGiftReedem()  {
    
    UFSProgressView.showWaitingDialog("")
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.setGoalForProduct(productID: "0", successResponse: { (response) in
      
      UserDefaults.standard.set("", forKey: USER_LOYALTY_GOAL_ID_KEY)
      UserDefaults.standard.removeObject(forKey: USER_GOAL_DETAIL_KEY)
      UserDefaults().set("\(self.loyaltyBalanceAfterReedemGift)", forKey: LOYALTY_BALANCE_KEY)
      UserDefaults.standard.set(true, forKey: USER_REEDEMED_GIFT_KEY)
      
      self.showReedemTransparentView()
      UFSProgressView.stopWaitingDialog()
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
    }
  }
  @IBAction func cancelTransparentViewAction(_ sender: UIButton) {
    hideTransparntView()
    // resetGoalOnGiftReedem()
   // self.delegate?.reloadTableViewAfterReedemGift()
  }
  
  func showReedemTransparentView()  {
    
    self.transparentView.alpha = 0
    self.transparentView.isHidden = false
    UIView.animate(withDuration: 0.3) {
      self.transparentView.alpha = 1
    }
  }
  
  func hideTransparntView()  {
    
    UIView.animate(withDuration: 0.3, animations: {
      self.transparentView.alpha = 0
    }) { (finished) in
      self.transparentView.isHidden = finished
    }
    
  }
    
    func toHideShowNowContainer(hide:Bool) {
        if hide {
            shopNowContainerView.isHidden = true
          shopNowContainerHeightConstraint.constant = 0
        }else{
          shopNowContainerView.isHidden = false
          shopNowContainerHeightConstraint.constant = 210
      }
    }
  
}
