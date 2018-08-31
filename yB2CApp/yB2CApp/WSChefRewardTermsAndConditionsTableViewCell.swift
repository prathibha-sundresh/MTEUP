//
//  WSChefRewardTermsAndConditionsTableViewCell.swift
//  yB2CApp
//
//  Created by Lakshminarayana on 06/12/17.
//

import UIKit

extension String {
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}

class WSChefRewardTermsAndConditionsTableViewCell: UITableViewCell {

    @IBOutlet weak var termsAndConditionsButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  func termAndConditionButtonMultilineSetUp()  {
    termsAndConditionsButton.titleLabel!.numberOfLines = 0
    termsAndConditionsButton.titleLabel!.adjustsFontSizeToFitWidth = true
    termsAndConditionsButton.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
    termsAndConditionsButton.titleLabel!.textAlignment = .center
  }
  
func setUI()
{

    let tcString = WSUtility.getlocalizedString(key: "Chef Rewards Terms and Conditions apply", lang: WSUtility.getLanguage(), table: "Localizable")
  termAndConditionButtonMultilineSetUp()
//    var tcMutableString = NSMutableAttributedString()
//    tcMutableString = NSMutableAttributedString(string: tcString!, attributes: [NSFontAttributeName:UIFont(name: "DINPro-Regular", size: 12.0)!])
//    tcMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: NSRange(location:0,length:(tcString?.count)!))
//
//    if WSUtility.getLanguage() == "de" {
//        // Search for one string in another.
//        let result = tcString?.range(of: "Allgemeinen Geschäftsbedingungen (AGB's)")
//        let nsRange = tcString?.nsRange(from: result!)
//        tcMutableString.addAttribute(NSForegroundColorAttributeName, value: ApplicationOrangeColor, range: nsRange!)
//    }
//    else if WSUtility.getLanguage() == "en" {
//        let result = tcString?.range(of: "Terms and Conditions")
//        let nsRange = tcString?.nsRange(from: result!)
//        tcMutableString.addAttribute(NSForegroundColorAttributeName, value: ApplicationOrangeColor, range: nsRange!)
//    }
//
//    termsAndConditionsButton.setAttributedTitle(tcMutableString, for: .normal)
    
    let attributedString = NSMutableAttributedString(string: tcString!)
    
    let range = NSString(string: tcString!).range(of:  WSUtility.getlocalizedString(key: "Terms and Conditions", lang: WSUtility.getLanguage(), table: "Localizable")!)
    attributedString.addAttributes([NSFontAttributeName: UIFont(name: "DINPro-Medium", size: 12.0)!, NSForegroundColorAttributeName: ApplicationOrangeColor], range: range)
    termsAndConditionsButton.setAttributedTitle(attributedString, for: .normal)
    
}
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
