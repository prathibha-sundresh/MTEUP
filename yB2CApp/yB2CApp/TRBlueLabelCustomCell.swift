//
//  TRBlueLabelCustomCell.swift
//  UFS
//
//  Created by Rajesh Reddy on 18/07/18.
//

import UIKit

class TRBlueLabelCustomCell: UITableViewCell {
    @IBOutlet weak var vwBase: UIView!
    @IBOutlet weak var htConstVwBase: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vwBase.isHidden = true
        htConstVwBase.constant = 0.0

    }
    func vwHide(hide:Bool)
    {
    vwBase.isHidden = hide
        if hide {
            htConstVwBase.constant = 0.0
        }
        else{
            htConstVwBase.constant = 50.0
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
