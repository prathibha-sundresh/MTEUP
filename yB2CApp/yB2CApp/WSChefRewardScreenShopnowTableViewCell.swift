//
//  WSChefRewardScreenShopnowTableViewCell.swift
//  yB2CApp
//
//  Created by Lakshminarayana on 05/12/17.
//

import UIKit

class WSChefRewardScreenShopnowTableViewCell: UITableViewCell {
  @IBOutlet weak var shopViewContainerView: WSChefRewardShopNowView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
  }
    
    func setUI(){
        if WSUtility.isUserPlacedFirstOrder(){
            shopViewContainerView.subviews.forEach { $0.isHidden = true }
            
            let doubleLoyaltyProductCachedResponse = WSCacheSingleton.shared.cache.object(forKey: Cached_Double_Loyalty_Product_KEY as NSString) as Any
            
            if let prodcutDict = doubleLoyaltyProductCachedResponse as? [String:Any]{
                
                if prodcutDict.count > 0{
                    //let prodcutDict = dobleLoyaltyProductArray[0]
                    shopViewContainerView.subviews.forEach { $0.isHidden = false }
                    var productname = ""
                    if let str = prodcutDict["productName"] as? String{
                        productname = str
                    }
                    else if let str = prodcutDict["name"] as? String{
                        productname = str
                    }
                    if productname != ""{
                        let productName:String = productname
                        
                        shopViewContainerView.termsText.isHidden = true
                      
                      var captionText = ""
                      if (prodcutDict["productLoyaltyRemark"] as? String)?.range(of:"2x") != nil || (prodcutDict["productLoyaltyRemark"] as? String)?.range(of:"2 fach") != nil {
                        
                        captionText = String(format: WSUtility.getlocalizedString(key: "Order product and get double loyatly points", lang: WSUtility.getLanguage(), table: "Localizable")!, productName)
                        
                        shopViewContainerView.placeTextLabel.attributedText = self.makeAttributeText(stringVal: captionText, typeStr: WSUtility.getlocalizedString(key: "double loyalty points", lang: WSUtility.getLanguage(), table: "Localizable")!, productName: productName)
                      }else if (prodcutDict["productLoyaltyRemark"] as? String)?.range(of:"3x") != nil || (prodcutDict["productLoyaltyRemark"] as? String)?.range(of:"3 fach") != nil {
                        captionText = String(format: WSUtility.getlocalizedString(key: "Order product and get triple loyatly points", lang: WSUtility.getLanguage(), table: "Localizable")!, productName)
                        shopViewContainerView.placeTextLabel.attributedText = self.makeAttributeText(stringVal: captionText, typeStr: WSUtility.getlocalizedString(key: "triple loyatly points", lang: WSUtility.getLanguage(), table: "Localizable")!, productName: productName)
                      }else{
                        captionText = String(format: WSUtility.getlocalizedString(key: "Order product and get extra loyatly points", lang: WSUtility.getLanguage(), table: "Localizable")!, productName)
                        shopViewContainerView.placeTextLabel.attributedText = self.makeAttributeText(stringVal: captionText, typeStr: WSUtility.getlocalizedString(key: "extra loyatly points", lang: WSUtility.getLanguage(), table: "Localizable")!, productName: productName)
                      }
                        
                    }
                    
                    
                    if let product_image_url = prodcutDict["packshotUrl"] as? String {
                        //shopNowcontainerView.shopNowImageView.image = #imageLiteral(resourceName: "thai-yellow-curry-paste")
                        shopViewContainerView.shopNowImageView.sd_setImage(with: URL.init(string:product_image_url), placeholderImage: #imageLiteral(resourceName: "placeholder"))
                    }
                    
                    shopViewContainerView.doubleLoyaltyProductcode = "\(prodcutDict["productNumber"] ?? "")"
                    
                }
                
            }
            
        }
    }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
    func makeAttributeText(stringVal: String, typeStr: String, productName: String)-> NSMutableAttributedString{
        let range = NSString(string: stringVal).range(of: productName)
        let attributedString = NSMutableAttributedString(string: stringVal)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "DINPro-Bold", size: 16.0)!, range: range)
        let range2 = NSString(string: stringVal).range(of: typeStr)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "DINPro-Bold", size: 16.0)!, range: range2)
        return attributedString
    }
    
}
