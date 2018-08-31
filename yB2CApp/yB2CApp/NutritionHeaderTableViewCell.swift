//
//  NutritionHeaderTableViewCell.swift
//  UFSDev
//
//  Created by Newlaptop on 13/08/18.
//

import UIKit

class NutritionHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameHebLb: UILabel!
    @IBOutlet weak var attributrHebLb: UILabel!
    @IBOutlet weak var quatityHedLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
