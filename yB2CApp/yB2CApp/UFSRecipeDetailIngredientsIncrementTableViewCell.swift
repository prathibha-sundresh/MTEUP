//
//  UFSRecipeDetailIngredientsIncrementTableViewCell.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 24/07/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit

@objc protocol RecipeDetailIngredientsIncrementCellDelegate{
  
  func recipeDetailIngredientIncrementPlusAction(cell:UFSRecipeDetailIngredientsIncrementTableViewCell, quantity:Double)
  
  func recipeDetailIngredientIncrementMinusAction(cell:UFSRecipeDetailIngredientsIncrementTableViewCell, quantity:Int)
  
}

class UFSRecipeDetailIngredientsIncrementTableViewCell: UITableViewCell {
  @IBOutlet weak var quantityView: UIView!
  @IBOutlet weak var quantityLabel: UILabel!
  @IBOutlet weak var portionSelectorLabel: UILabel!{
    didSet {
        portionSelectorLabel.text = WSUtility.getlocalizedString(key: "Portion Selector", lang: WSUtility.getLanguage(), table: "Localizable")

    }
  }

  var deleagte:RecipeDetailIngredientsIncrementCellDelegate?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
      quantityLabel.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor
      quantityView?.layer.borderColor = unselectedTextFieldBorderColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  @IBAction func plusButtonAction(_ sender: UIButton) {
    let ingredientQuantity = Double(quantityLabel.text!)
    quantityLabel.text = "\(ingredientQuantity! + 1)"
    let yeildQuantity = ingredientQuantity! + 1
    deleagte?.recipeDetailIngredientIncrementPlusAction(cell: self, quantity: yeildQuantity)
  }
  
  @IBAction func minusButtonAction(_ sender: UIButton) {
    let ingredientQuantity = Int(quantityLabel.text!)
    
    guard (ingredientQuantity! - 1)  > 0 else {
      return
    }
    
    quantityLabel.text = "\(ingredientQuantity! - 1)"
    deleagte?.recipeDetailIngredientIncrementMinusAction(cell: self, quantity: (ingredientQuantity! - 1))
  }
}
