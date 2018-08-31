//
//  WSChefsRewardReachedGoalPopupTableViewCell.swift
//  yB2CApp
//
//  Created by Lakshminarayana on 06/12/17.
//

import UIKit

class WSChefsRewardReachedGoalPopupTableViewCell: UITableViewCell {
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var visitButton: WSDesignableButton!
    @IBOutlet weak var congratsLabel: UILabel!
    @IBOutlet weak var blurView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        progressView.layer.cornerRadius = 12.5
        progressView.layer.masksToBounds = true
        congratsLabel.text = WSUtility.getlocalizedString(key: "Congrats on reaching your goal", lang: WSUtility.getLanguage(), table: "Localizable")
        visitButton.setTitle(WSUtility.getlocalizedString(key: "Visit UFS.com to redeem your reward", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func closeBlurrView(_ sender: UIButton) {
        blurView.isHidden = true
    }
    
    @IBAction func redeemGift(_ sender: UIButton) {
        blurView.isHidden = false
        
    }
}
