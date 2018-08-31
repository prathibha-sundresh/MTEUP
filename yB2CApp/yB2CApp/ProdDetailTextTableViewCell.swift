//
//  ProdDetailTextTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 09/12/2017.
//

import UIKit

class ProdDetailTextTableViewCell: UITableViewCell {

  @IBOutlet weak var fullProductTextLabel: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
     fullProductTextLabel.text = WSUtility.getlocalizedString(key: "Full product details", lang: WSUtility.getLanguage(), table: "Localizable")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
