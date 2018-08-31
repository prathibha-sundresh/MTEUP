//
//  WSChefRewardShopNowView.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 20/11/2017.
//

import UIKit
@objc protocol WSChefRewardShopNowDelegate{
  func shopNowActionOnProduct(productCode:String)
  
}
class WSChefRewardShopNowView: UIView {
  
  @IBOutlet var view: UIView!
  @IBOutlet weak var placeTextLabel: UILabel!
  @IBOutlet weak var shopNowImageView: UIImageView!
  @IBOutlet weak var shopNowButton : UIButton!
  @IBOutlet weak var termsText : UILabel!
  
  var doubleLoyaltyProductcode = ""
  var isFromHomeOrChefRewards: String = ""
  weak var delegate:WSChefRewardShopNowDelegate?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    Bundle.main.loadNibNamed("ChefRewardShopNowView", owner: self, options: nil)
    self.addSubview(view)
    view.frame = self.bounds

    setAttributedText()
  }
  
    func setAttributedText() {
        shopNowButton.titleLabel?.adjustsFontSizeToFitWidth = true
        shopNowButton.setTitle(WSUtility.getlocalizedString(key: "Shop now", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        
        let fnt = UIFont(name:"DINPro-Regular", size:10.0)
        let attributedTCString = NSMutableAttributedString(string:"*"+WSUtility.getlocalizedString(key: "Only applicable upon first purchase", lang: WSUtility.getLanguage(), table: "Localizable")!, attributes:[NSFontAttributeName : fnt!])
        termsText.attributedText = attributedTCString
        
    guard let dict = UserDefaults.standard.value(forKey: "First_Order_Incentive_Data") as? [String: Any] ,dict.count != 0 else{
        return
    }
    shopNowImageView.sd_setImage(with: URL(string: "\(dict["image_url"]!)"), placeholderImage: UIImage(named: "placeholder.png"))
        var strProductName = ""
        if let productName = dict["product_name"] as? String{
            strProductName = productName
        }
    var attributedString = NSMutableAttributedString(string: String(format: WSUtility.getTranslatedString(forString: "Get 250 FREE points on your first order. Spend over €300 and get a FREE digital roast barometer*."),"\(dict["loyalty_points"]!)","\(dict["minimum_order_amount"]!)",strProductName), attributes: [
      NSFontAttributeName: UIFont(name: "DINPro-Regular", size: 12.0)!,
      NSForegroundColorAttributeName: UIColor(white: 51.0 / 255.0, alpha: 1.0)
      ])
    
        if let points = dict["loyalty_points"]{
            if "\(points)" == "0"{
                if WSUtility.isLoginWithTurkey(){
                    if "\(dict["minimum_order_amount"]!)" == "0"{
                        
                        let tmpString = NSMutableAttributedString(string: String(format: WSUtility.getTranslatedString(forString: "Free XXX gift for first order"),strProductName), attributes: [
                            NSFontAttributeName: UIFont(name: "DINPro-Regular", size: 12.0)!,
                            NSForegroundColorAttributeName: UIColor(white: 51.0 / 255.0, alpha: 1.0)
                            ])
                        attributedString = tmpString
                    }
                }
                else{
                    let array = attributedString.string.components(separatedBy: ".")
                    if array.count > 1{
                        
                        var str = array[1]
                        if WSUtility.getCountryCode() == "CH" && WSUtility.getLanguageCode() == "de"{
                            str =  str.replacingOccurrences(of: "€", with: "CHF")
                        }
                        attributedString = NSMutableAttributedString(string: str)
                    }
                }
            }
            else{
                
                if WSUtility.getCountryCode() == "CH" && WSUtility.getLanguageCode() == "de"{
                    var str = attributedString.string
                    str =  str.replacingOccurrences(of: "€", with: "CHF")
                    attributedString = NSMutableAttributedString(string: str)
                }
            }
        }
        
    let text1 = WSUtility.getTranslatedString(forString: "250 FREE").replacingOccurrences(of: "%@", with: "\(dict["loyalty_points"]!)")
    
    let range = attributedString.mutableString.range(of: text1, options: .caseInsensitive)
    if range.location != NSNotFound {
      
      attributedString.addAttributes([NSFontAttributeName: UIFont(name: "DINPro-Bold", size: 12.0)!], range: range)
    }
    
    let text2 = WSUtility.getTranslatedString(forString: "first order")
    
    let range2 = attributedString.mutableString.range(of: text2, options: .caseInsensitive)
    if range2.location != NSNotFound {
      
      attributedString.addAttributes([NSFontAttributeName: UIFont(name: "DINPro-Bold", size: 12.0)!], range: range2)
    }
        
    let text3 = String(format: WSUtility.getTranslatedString(forString: "FREE digital roast barometer*."),strProductName)
    
    let range3 = attributedString.mutableString.range(of: text3, options: .caseInsensitive)
    if range3.location != NSNotFound {
      
      attributedString.addAttributes([NSFontAttributeName: UIFont(name: "DINPro-Bold", size: 12.0)!], range: range3)
    }
    
    placeTextLabel.attributedText = attributedString
     
  }
  
  @IBAction func shopNowAction(_ sender: UIButton) {
    if isFromHomeOrChefRewards == "Home"{
      WSUtility.sendTrackingEvent(events: "Other", categories: "Banner click",actions:"Home screen")
        FireBaseTracker .fireBaseTrackerWith(Events: "Other", Category: "Banner click", Action: "Placement of clicked banner - Home screen")
    }
    else{
      WSUtility.sendTrackingEvent(events: "Other", categories: "Banner click",actions:"Chef Rewards")
        FireBaseTracker .fireBaseTrackerWith(Events: "Other", Category: "Banner click", Action: "Placement of clicked banner - Chef Rewards")
    }
    UFSGATracker.trackScreenViews(withScreenName: "JBL Speaker Order")
    delegate?.shopNowActionOnProduct(productCode: doubleLoyaltyProductcode)
    
  }
}
