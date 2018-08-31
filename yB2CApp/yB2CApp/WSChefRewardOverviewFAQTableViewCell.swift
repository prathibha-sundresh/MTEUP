
//
//  WSChefRewardOverviewFAQTableViewCell.swift
//  yB2CApp
//
//  Created by Lakshminarayana on 06/12/17.
//

import UIKit

class WSChefRewardOverviewFAQTableViewCell: UITableViewCell {
    @IBOutlet weak var plusMinusButton: UIButton!
    @IBOutlet weak var answerWebView: UIWebView!
    @IBOutlet weak var myWebViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var questionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        questionLabel.numberOfLines = 0
        questionLabel.sizeToFit()
        plusMinusButton.isUserInteractionEnabled = true
 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func showFaqAnswer(_ sender: UIButton) {
        
    }
    
}
