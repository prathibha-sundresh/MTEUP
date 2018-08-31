//
//  WSLanguageTableViewCell.swift
//  yB2CApp
//
//  Created by Anandita on 11/30/17.
//

import UIKit

class WSLanguageTableViewCell: UITableViewCell {

  @IBOutlet weak var selectedLanguageLabel: UILabel!
  @IBOutlet weak var leadingSpaceChangeConstraint: NSLayoutConstraint!
    @IBOutlet weak var languageLabel: UILabel!
  @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var countryImage: UIImageView!
  override func awakeFromNib() {
        super.awakeFromNib()
       changeBtn.titleLabel?.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func updateCellContent()  {
    changeBtn.setTitle(WSUtility.getlocalizedString(key: "Setting_Change", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    selectedLanguageLabel.text = (WSUtility.getlocalizedString(key: "Selected Language", lang: WSUtility.getLanguage(), table: "Localizable"))
  }

}
