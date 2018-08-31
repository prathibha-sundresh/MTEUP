//
//  WSProductCollectionViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 15/11/2017.
//

import UIKit

class WSProductCollectionViewCell: UICollectionViewCell {
  
    @IBOutlet weak var htConstRcmndLbl: NSLayoutConstraint!
    @IBOutlet weak var LoyaltyView: UIView!
    @IBOutlet weak var LoyaltyPriceViewconstraints: NSLayoutConstraint!
    @IBOutlet weak var PriceLabelConstraints: NSLayoutConstraint!
    @IBOutlet weak var pointsTitle: UFSLoyaltyPointLabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var recomendLabel: UILabel!
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var loyaltyPointLabel: UILabel!
  @IBOutlet weak var moreInformationBtnHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var moreInformationBtn: WSDesignableButton!
  @IBOutlet weak var moreBtnTopConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor
  }
  
  func setUI(){
    
    moreInformationBtn.setTitle(WSUtility.getlocalizedString(key: "More information", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    pointsTitle.text = WSUtility.getlocalizedString(key:"Points", lang: WSUtility.getLanguage(), table: "Localizable")
    
    if WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
      recomendLabel.isHidden = true
    }else{
      recomendLabel.isHidden = false
      recomendLabel.text = WSUtility.getlocalizedString(key:"Recommended price from UFS", lang: WSUtility.getLanguage(), table: "Localizable")
    }
    
   // recomendLabel.text = WSUtility.getlocalizedString(key:"Recommended price from UFS", lang: WSUtility.getLanguage(), table: "Localizable")
    
  }
  
  func updateUI(productInfo: [String: Any]){
    
    if let productname = productInfo["product_name"] as? String {
      productNameLabel.text = productname
    }else if let productName = productInfo["productName"] as? String {
      productNameLabel.text = productName
    } else if let productName = productInfo["name"] as? String {
        productNameLabel.text = productName
    }
    
    if let product_price = productInfo["product_price"] {
        if WSUtility.getCountryCode() == "CH" {
            priceLabel.text = "CHF \(product_price)"
        }
        else{
            priceLabel.text = "€ \(product_price)"
        }
    }else if let productPriceSifu = productInfo["duPriceInCents"] {
      let price = (productPriceSifu as! Float)/100
      var stringPrice = "\(price)"
      stringPrice = stringPrice.replacingOccurrences(of: ".", with: ",")
        if WSUtility.getCountryCode() == "CH" {
            priceLabel.text = "CHF " + stringPrice
        }
        else{
            priceLabel.text = "€ " + stringPrice
        }
    }
    
    if let product_image_url = productInfo["product_image_url"] as? String {
      productImageView.sd_setImage(with: URL.init(string:product_image_url), placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }else if let product_Image_Url = productInfo["packshotUrl"] as? String{
      
      productImageView.sd_setImage(with: URL.init(string:product_Image_Url), placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }
    
    if let loyalty_points = productInfo["loyalty_points"] as? String{
      loyaltyPointLabel.text = "\(loyalty_points)"
    }else if let loyalty_Point = productInfo["duLoyaltyPoints"] {
      loyaltyPointLabel.text = "\(loyalty_Point)"
    }
    
    moreInformationBtnHeightConstraint.constant = 0
    moreBtnTopConstraint.constant = 0
    moreInformationBtn.setTitle("", for: .normal)
    pointsTitle.text = WSUtility.getlocalizedString(key:"Points", lang: WSUtility.getLanguage(), table: "Localizable")
    
    if WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
      recomendLabel.isHidden = true
    }else{
      recomendLabel.isHidden = false
      recomendLabel.text = WSUtility.getlocalizedString(key:"Recommended price from UFS", lang: WSUtility.getLanguage(), table: "Localizable")
    }
    
    
    
    
  }
  @IBAction func moreInformationButtonAction(_ sender: UIButton) {
  }
    
    func isViewHidden(hide:Bool) {
        loyaltyPointLabel.isHidden = hide
        priceLabel.isHidden = hide
        pointsTitle.isHidden = hide
        LoyaltyView.isHidden = hide
        recomendLabel.isHidden = hide
        if hide {
            htConstRcmndLbl.constant = 0.0
            PriceLabelConstraints.constant = 0.0
            LoyaltyPriceViewconstraints.constant = 0.0
        }
    }
}
