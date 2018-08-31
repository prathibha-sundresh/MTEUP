//
//  WSAllergyInfoTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 05/01/2018.
//

import UIKit

class WSAllergyInfoTableViewCell: UITableViewCell {

  @IBOutlet weak var waterLabel: UILabel!
  @IBOutlet weak var productQuantityLabel: UILabel!
  @IBOutlet weak var yieldLabel: UILabel!
  @IBOutlet weak var yieldPerServingLabel: UILabel!
  
  @IBOutlet weak var thirdComponentLabel: UILabel!
  @IBOutlet weak var fourthComponentLabel: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
 
    
}

