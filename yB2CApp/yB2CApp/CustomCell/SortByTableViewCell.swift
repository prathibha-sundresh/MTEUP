//
//  SortByTableViewCell.swift
//  yB2CApp
//
//  Created by Ramakrishna on 11/26/17.
//

import UIKit

class SortByTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.text = WSUtility.getlocalizedString(key: "Sort by", lang: WSUtility.getLanguage(), table: "Localizable")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
