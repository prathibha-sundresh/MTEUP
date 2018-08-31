//
//  UFSRecipeDetailPreparationImageTableViewCell.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 24/07/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit
@objc protocol RecipeDetailPreparationImageCellDelegate{
  func shopButtonAction(sender:UIButton)
}

class UFSRecipeDetailPreparationImageTableViewCell: UITableViewCell {
  
  @IBOutlet weak var containerView: UIView! {
    didSet {
       containerView.layer.borderColor = UIColor(red: 183.0/255.0, green: 183.0/255.0, blue: 183.0/255.0, alpha: 1).cgColor
    }
  }
  @IBOutlet weak var preparationDescriptionLabel: UILabel!
  @IBOutlet weak var headerTitleLabel: UILabel!
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var productTitleLabel: UILabel!
  @IBOutlet weak var productDescriptionLabel: UILabel!
  @IBOutlet weak var shopButton: UIButton! {didSet{
        shopButton.setTitle(WSUtility.getlocalizedString(key:"Buy now", lang:WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    
    }
  }
  
  weak var delegate:RecipeDetailPreparationImageCellDelegate?
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  @IBAction func shopButtonAction(_ sender: UIButton) {
    delegate?.shopButtonAction(sender: sender)
  }
  
}
