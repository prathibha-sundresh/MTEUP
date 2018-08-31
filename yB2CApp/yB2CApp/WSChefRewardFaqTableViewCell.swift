
//
//  WSChefRewardFaqTableViewCell.swift
//  yB2CApp
//
//  Created by Lakshminarayana on 05/12/17.
//

import UIKit

class WSChefRewardFaqTableViewCell: UITableViewCell {

    @IBOutlet weak var seeChefRewardsButton: WSDesignableButton!
    @IBOutlet weak var moreQuestionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    func setUI(){
        moreQuestionLabel.text = WSUtility.getlocalizedString(key:"Have more questions?", lang: WSUtility.getLanguage(), table: "Localizable")
        seeChefRewardsButton.setTitle(WSUtility.getlocalizedString(key: "See Chef Rewards FAQs", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
