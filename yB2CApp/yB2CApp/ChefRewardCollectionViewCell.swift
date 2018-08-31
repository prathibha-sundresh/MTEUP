//
//  ChefRewardCollectionViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 20/11/2017.
//

import UIKit

class ChefRewardCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var rewardPointLabel: UILabel!
  @IBOutlet weak var itemImageView: UIImageView!
  @IBOutlet weak var pointsTextLabel: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    pointsTextLabel.text = WSUtility.getlocalizedString(key:"Points", lang:WSUtility.getLanguage(), table: "Localizable")
    
    }

}
