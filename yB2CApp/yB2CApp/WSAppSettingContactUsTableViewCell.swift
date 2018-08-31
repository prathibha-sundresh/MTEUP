//
//  WSAppSettingContactUsTableViewCell.swift
//  UFSDev
//
//  Created by Guddu Gaurav on 30/01/2018.
//

import UIKit

class WSAppSettingContactUsTableViewCell: UITableViewCell {

    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var sendMailButton: UIButton!
    @IBOutlet weak var haveQuestionsLabel: UILabel!{
        didSet{
            haveQuestionsLabel.text = WSUtility.getlocalizedString(key: "Have questions about the app, shop, loyalty program, products etc?", lang: WSUtility.getLanguage(), table: "Localizable")
            
        }
    }
    @IBOutlet weak var mondayToFridayLabel: UILabel!{
        didSet{
            
            let str = NSString(string:WSUtility.getlocalizedString(key: "We are available Monday - Friday 08.00 - 19.00", lang: WSUtility.getLanguage(), table: "Localizable")! + "\n" + WSUtility.getlocalizedString(key: "(except public holidays)", lang: WSUtility.getLanguage(), table: "Localizable")!)
            
            let hoidaysLabel = WSUtility.getlocalizedString(key: "(except public holidays)", lang: WSUtility.getLanguage(), table: "Localizable")!
            
            let attributedStr = NSMutableAttributedString(string: str as String)
            attributedStr.addAttribute(NSFontAttributeName, value: UIFont(name: "DINPro-Regular", size: 12.0)!, range: str.range(of: "\(hoidaysLabel)"))
            mondayToFridayLabel.attributedText = attributedStr
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
