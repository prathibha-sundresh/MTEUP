//
//  UFSRecipeDetailIngredientsImageTableViewCell.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 24/07/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit


class UFSRecipeDetailIngredientsImageTableViewCell: UITableViewCell {

    @IBOutlet weak var priceLblHight: NSLayoutConstraint!
    @IBOutlet weak var layaltyVHight: NSLayoutConstraint!
    @IBOutlet weak var loyaltyV: UIView!
    @IBOutlet weak var pointsLabel:UILabel!
    @IBOutlet weak var recommendedLabel:UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var buyNowButton: UIButton! {
    didSet{
      buyNowButton.setTitle(WSUtility.getlocalizedString(key: "More information", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    }
  }
  @IBOutlet weak var loyaltyPointLabel: UILabel!
  
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUI(){
        pointsLabel.text = WSUtility.getlocalizedString(key: "Points", lang: WSUtility.getLanguage(), table: "Localizable")
      if WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
        
        recommendedLabel.isHidden = true
        priceLabel.isHidden = true
        pointsLabel.isHidden = true
        loyaltyPointLabel.isHidden = true
        loyaltyV.isHidden = true
        layaltyVHight.constant = 0
       /* self.contentView.addConstraint(NSLayoutConstraint(item: self.productImageView, attribute: .bottom, relatedBy: .equal, toItem: self.buyNowButton, attribute:.bottom, multiplier: 1, constant: 0))*/


      }else{
        
        loyaltyV.isHidden = false
        recommendedLabel.isHidden = false
        priceLabel.isHidden = false
        pointsLabel.isHidden = false
        loyaltyPointLabel.isHidden = false
        layaltyVHight.constant = 25
       /* self.contentView.removeConstraint((NSLayoutConstraint(item: self.productImageView, attribute: .bottom, relatedBy: .equal, toItem: self.buyNowButton, attribute:.bottom, multiplier: 1, constant: 0)))*/
        recommendedLabel.text = WSUtility.getlocalizedString(key:"Recommended price from UFS", lang: WSUtility.getLanguage(), table: "Localizable")
      }
       // recommendedLabel.text = WSUtility.getlocalizedString(key: "Recommended price from UFS", lang: WSUtility.getLanguage(), table: "Localizable")
    }
}
