//
//  ChangeTPTableViewCell.swift
//  yB2CApp
//
//  Created by Ramakrishna on 12/7/17.
//

import UIKit

class ChangeTPTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectedTradePartner: UILabel!
    @IBOutlet weak var changeTradePartnerButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setUI(){
        
        let tpName = WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "tradePartnerName"))
      let tradepartnerLabel = WSUtility.getlocalizedString(key: "Selected tradepartner:", lang: WSUtility.getLanguage(), table: "Localizable")!
        let range = NSString(string:tradepartnerLabel + " \(tpName)").range(of: tpName)
        let attributedString = NSMutableAttributedString(string:tradepartnerLabel + " \(tpName)")
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "DINPro-Medium", size: 16.0)!, range: range)
        
        selectedTradePartner.attributedText = attributedString
        changeTradePartnerButton.setTitle(WSUtility.getlocalizedString(key: "Change tradepartner", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    }
}

