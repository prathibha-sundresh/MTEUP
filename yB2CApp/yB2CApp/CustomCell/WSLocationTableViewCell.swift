//
//  WSLocationTableViewCell.swift
//  yB2CApp
//
//  Created by Anandita on 11/30/17.
//

import UIKit

class WSLocationTableViewCell: UITableViewCell {

  @IBOutlet weak var changeBtn: UIButton!
  @IBOutlet weak var selectedLocationLabel: UILabel!
  @IBAction func changeLocationPressed(_ sender: Any) {
        
    }
    @IBOutlet weak var leadingSpaceLocationChangeConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationLabel: UILabel!
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
    selectedLocationLabel.text = (WSUtility.getlocalizedString(key: "Selected Location", lang: WSUtility.getLanguage(), table: "Localizable"))
  }

}
