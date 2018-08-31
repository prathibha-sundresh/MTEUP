//
//  WSRecommendationProdCollectionViewCell.swift
//  yB2CApp
//
//  Created by Anandita on 11/29/17.
//

import UIKit
class WSRecommendationProdCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var htConstRcmdLbl: NSLayoutConstraint!
    @IBOutlet weak var ProductPriceHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var LoyaltyPointViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var pointsLabel: UFSLoyaltyPointLabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var prodName: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var recommendedlabel: UILabel!
    @IBOutlet weak var loyalityPoints: UILabel!
    
    func setUI(dict: [String: Any]){
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
        self.clipsToBounds = true
        moreInfoButton.setTitle(WSUtility.getlocalizedString(key:"More information", lang:WSUtility.getLanguage(), table: "Localizable"), for: .normal)
       // recommendedlabel.text = WSUtility.getlocalizedString(key:"Recommended price from UFS", lang:WSUtility.getLanguage(), table: "Localizable")
      
      if WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
        recommendedlabel.isHidden = true
      }else{
        recommendedlabel.isHidden = false
        recommendedlabel.text = WSUtility.getlocalizedString(key:"Recommended price from UFS", lang:WSUtility.getLanguage(), table: "Localizable")
      }
      
        pointsLabel.text = WSUtility.getlocalizedString(key:"Points", lang:WSUtility.getLanguage(), table: "Localizable")
        
        if let productname = dict["product_name"] as? String {
            prodName.text = productname
        }else if let productName = dict["productName"] as? String {
            prodName.text = productName
        } else if let productName = dict["name"] as? String {
            prodName.text = productName
        }
        
        if let product_price = dict["product_price"] {
            productPrice.text = "€ \(product_price)"
            if WSUtility.getCountryCode() == "CH" {
                productPrice.text = "CHF \(product_price) *"
            }

        }
        else if let productPriceSifu = dict["duPriceInCents"] {
            let price = (productPriceSifu as! Float)/100
            var stringPrice = "\(price)"
            stringPrice = stringPrice.replacingOccurrences(of: ".", with: ",")
            if WSUtility.getCountryCode() == "CH" {
                productPrice.text = "CHF " + stringPrice
            }
            else{
                productPrice.text = "€ " + stringPrice
            }
            
        }
        
        if let product_image_url = dict["product_image_url"] as? String {
            productImageView.sd_setImage(with: URL.init(string:product_image_url), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }else if let product_Image_Url = dict["packshotUrl"] as? String{
            
            productImageView.sd_setImage(with: URL.init(string:product_Image_Url), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
        
        if let loyalty_points = dict["loyalty_points"] as? String{
            loyalityPoints.text = "\(loyalty_points)"
        }else if let loyalty_Point = dict["duLoyaltyPoints"] {
            loyalityPoints.text = "\(loyalty_Point)"
        }
        
    }
    func isViewHidden(hide:Bool) {
        loyalityPoints.isHidden = hide
        pointsLabel.isHidden = hide
        productPrice.isHidden = hide
        recommendedlabel.isHidden = hide
        moreInfoButton.isHidden = hide
        if hide {
            htConstRcmdLbl.constant = 0
            ProductPriceHeightConstraints.constant = 0
            LoyaltyPointViewHeightConstraints.constant = 0
        } else {
            htConstRcmdLbl.constant = 30
            ProductPriceHeightConstraints.constant = 20
            LoyaltyPointViewHeightConstraints.constant = 25
        }
    }
}
