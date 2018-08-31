//
//  UFSProductDetailTableViewCell.swift
//  UFSDev
//
//  Created by Naveen Kumar k N on 29/03/18.
//

import UIKit

class UFSProductDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLbl: UILabel!
    
    @IBOutlet weak var buyNowBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func buyNowBtnClicked(_ sender: Any) {
    
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
