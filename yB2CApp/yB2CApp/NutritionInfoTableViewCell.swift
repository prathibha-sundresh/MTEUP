//
//  NutritionInfoTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 10/12/2017.
//

import UIKit

class NutritionInfoTableViewCell: UITableViewCell {

  @IBOutlet weak var nutritionNameLabel: UILabel!
  @IBOutlet weak var nutritionQuantityLabel: UILabel!
  @IBOutlet weak var nutritionUnitLabel: UILabel!
    
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
