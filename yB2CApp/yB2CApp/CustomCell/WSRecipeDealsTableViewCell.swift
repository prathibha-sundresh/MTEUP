//
//  WSRecipeDealsTableViewCell.swift
//  yB2CApp
//
//  Created by Sahana Rao on 30/11/17.
//

import UIKit

class WSRecipeDealsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeDealText: UILabel!
    
    @IBOutlet weak var shopNowButton: UIButton!
    @IBOutlet weak var carefulLabel: UILabel!
    @IBOutlet weak var yourDealLabel: UILabel!
    @IBAction func shopNowButtonClicked(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    func setUI(){
        yourDealLabel.text = WSUtility.getlocalizedString(key: "Your deal", lang: WSUtility.getLanguage(), table: "Localizable")
        carefulLabel.text = WSUtility.getlocalizedString(key: "Careful these are hot 🔥", lang: WSUtility.getLanguage(), table: "Localizable")
        
        recipeDealText.text = WSUtility.getlocalizedString(key: "20% of all dairy alternative products", lang: WSUtility.getLanguage(), table: "Localizable")
        shopNowButton.setTitle(WSUtility.getlocalizedString(key: "Shop now", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        shopNowButton.titleLabel?.adjustsFontSizeToFitWidth = true

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

