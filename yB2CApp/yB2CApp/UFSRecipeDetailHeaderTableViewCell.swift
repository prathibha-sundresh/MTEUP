//
//  UFSRecipeDetailHeaderTableViewCell.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 24/07/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit


class UFSRecipeDetailHeaderTableViewCell: UITableViewCell {
  @IBOutlet weak var recipeTitleLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var recipeImageView: UIImageView!
  @IBOutlet weak var recipeDescriptionTitle: UILabel!
  
  var recipeLikeStatus = ""
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  

}
