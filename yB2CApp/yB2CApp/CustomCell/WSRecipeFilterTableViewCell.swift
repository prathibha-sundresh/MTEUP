//
//  WSRecipeFilterTableViewCell.swift
//  yB2CApp
//
//  Created by Sahana Rao on 01/12/17.
//

import UIKit

class WSRecipeFilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var filterOptionLabel: UILabel!
    @IBOutlet weak var filterOptionCheckboxButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
