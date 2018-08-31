//
//  UFSRecipeDetailSegmentTableViewCell.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 24/07/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit

@objc protocol UFSRecipeDetailSegmentTableViewCellDelegate{
  func ingredientsButtonAction(segmentTableViewCell:UFSRecipeDetailSegmentTableViewCell)
  
  func preparationButtonAction(segmentTableViewCell:UFSRecipeDetailSegmentTableViewCell)
}
class UFSRecipeDetailSegmentTableViewCell: UITableViewCell {

  @IBOutlet weak var rightBorderView: UIView!
  @IBOutlet weak var leftBorderView: UIView!
  @IBOutlet weak var buttonPreparation: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var buttonIngredient: UIButton!
  
  weak var delegate:UFSRecipeDetailSegmentTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      /*
      buttonPreparation.layer.borderColor = (ApplicationOrangeColor).cgColor
      buttonPreparation.backgroundColor = UIColor(red: 250.0 / 255.0, green: 242.0 / 255.0, blue: 233.0 / 255.0, alpha: 1)
      buttonPreparation.setTitleColor(ApplicationOrangeColor, for: .normal)
      */
      leftBorderView.layer.borderColor = (ApplicationOrangeColor).cgColor
      rightBorderView.layer.borderColor = UIColor.clear.cgColor
      
     buttonIngredient.setTitle(WSUtility.getlocalizedString(key:"Ingredients", lang:WSUtility.getLanguage(), table: "Localizable"), for: .normal)
       buttonPreparation.setTitle(WSUtility.getlocalizedString(key:"Preparation", lang:WSUtility.getLanguage(), table: "Localizable"), for: .normal)
      
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  @IBAction func ingredientsButtonAction(_ sender: UIButton) {
    leftBorderView.backgroundColor = (ApplicationOrangeColor)
   // sender.backgroundColor = UIColor(red: 250.0 / 255.0, green: 242.0 / 255.0, blue: 233.0 / 255.0, alpha: 1)
    sender.setTitleColor(ApplicationBlackColor, for: .normal)
    buttonPreparation.setTitleColor(UIColor(red: 183.0 / 255.0, green: 183.0 / 255.0, blue: 183.0 / 255.0, alpha: 1), for: .normal)
    
   // buttonPreparation.backgroundColor = UIColor.white
    rightBorderView.backgroundColor = UIColor.clear
    
    
    delegate?.ingredientsButtonAction(segmentTableViewCell: self)
  }
  @IBAction func preparationButtonAction(_ sender: UIButton) {
    rightBorderView.backgroundColor = (ApplicationOrangeColor)
  //  sender.backgroundColor = UIColor(red: 250.0 / 255.0, green: 242.0 / 255.0, blue: 233.0 / 255.0, alpha: 1)
    sender.setTitleColor(ApplicationBlackColor, for: .normal)
    
    buttonIngredient.setTitleColor(UIColor(red: 183.0 / 255.0, green: 183.0 / 255.0, blue: 183.0 / 255.0, alpha: 1), for: .normal)
   // buttonIngredient.backgroundColor = UIColor.white
    leftBorderView.backgroundColor = UIColor.clear
    
    delegate?.preparationButtonAction(segmentTableViewCell: self)
  }
}
