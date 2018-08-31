//
//  WSSlideMenuProfileTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 14/11/2017.
//

import UIKit

class WSSlideMenuProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var loyalityPoints: UILabel!
    
    @IBOutlet weak var pointsLabel: UFSLoyaltyPointLabel!
    @IBOutlet weak var selectedTradepartnerLabel: UILabel!
    @IBOutlet weak var editAccountInfoButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var selectedTradePartner: UILabel!
    
    @IBOutlet weak var selectedTradePartnerTextLabel: UILabel!
    @IBOutlet weak var editButtonTextLabel: UIButton!
    
    @IBOutlet weak var tradeParnerNameHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      profileImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUI(){
      
       pointsLabel.text = WSUtility.getlocalizedString(key: "Points", lang: WSUtility.getLanguage(), table: "Localizable")
        
        //selectedTradePartnerTextLabel.text = UserDefaults.standard.bool(forKey: DTO_OPERATOR) ? WSUtility.getlocalizedString(key: "Direct Delivery", lang: WSUtility.getLanguage(), table: "Localizable"): WSUtility.getlocalizedString(key: "Selected trade partner", lang: WSUtility.getLanguage(), table: "Localizable")
        
        selectedTradePartnerTextLabel.text = WSUtility.getlocalizedString(key: "Selected trade partner", lang: WSUtility.getLanguage(), table: "Localizable")
        
        editButtonTextLabel.setTitle("  \(WSUtility.getlocalizedString(key: "Edit account information", lang: WSUtility.getLanguage(), table: "Localizable")!)", for: .normal)
        
        let firstName =  WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "FirstName"))
        let lastName =  WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "LastName"))
        profileName.text = firstName + " " + lastName
        let currentLoyaltyBalance =  WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "currentLoyaltyBalance"))
        loyalityPoints.text = "\(currentLoyaltyBalance)"
        WSUtility.setProfileImageFor(imageView: profileImage)
        
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.clipsToBounds = true
        
        if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
            selectedTradePartner.text = WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "DTO_TP_Name"))
        }
        else{
            
            selectedTradePartner.text = WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: TRADE_PARTNER_NAME))
        }
        
    }
}
