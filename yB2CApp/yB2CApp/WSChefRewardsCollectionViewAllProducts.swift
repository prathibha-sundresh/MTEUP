//
//  WSChefRewardsCollectionViewAllProducts.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 18/12/2017.
//

import UIKit

class WSChefRewardsCollectionViewAllProducts: UICollectionViewCell {

    @IBOutlet weak var viewAllRewardsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setUI(){
        viewAllRewardsLabel.text = WSUtility.getlocalizedString(key: "View all rewards", lang: WSUtility.getLanguage(), table: "Localizable")
    }
}
