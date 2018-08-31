//
//  UFSRecipeDetailIngredientTableViewCell.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 24/07/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit

class UFSRecipeDetailIngredientTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var quantityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
