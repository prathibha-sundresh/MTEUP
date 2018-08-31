//
//  SampleOrderSummaryTableViewCell.swift
//  yB2CApp
//
//  Created by Ramakrishna on 12/10/17.
//

import UIKit

@objc protocol SampleOrderSummaryTableViewCellDelegate{
    func didSelectItem(indexNo:Int)
}


class SampleOrderSummaryTableViewCell: UITableViewCell {
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var changeBtn: UIButton!
  weak var delegate:SampleOrderSummaryTableViewCellDelegate? = nil
    @IBOutlet weak var borderView: UIView!{
        didSet{
            borderView.layer.borderWidth = 1.0
            borderView.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
            
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
    
    @IBAction func changeNow(_ sender: UIButton) {
        delegate?.didSelectItem(indexNo: changeBtn.tag)
    }
    
    func SetUIForCell(row: Int, dict: [String: Any]){
        if row == 0{
            headerLabel.text = WSUtility.getlocalizedString(key: "My details", lang: WSUtility.getLanguage(), table: "Localizable")
            discriptionLabel.text = String(format: "%@ %@\n%@\n%@","\(dict["firstName"]!)","\(dict["lastName"]!)","\(dict["email"]!)","\(dict["mobileNumber"]!)")
        }
        else{
            headerLabel.text = WSUtility.getTranslatedString(forString: "Delivery")
            discriptionLabel.text = String(format: "%@\n%@ %@\n%@ %@","\(dict["businessName"]!)","\(dict["streetName"]!)","\(dict["buildingNo"]!)","\(dict["postalCode"]!)","\(dict["city"]!)")
            
        }
        changeBtn.tag = row
        let underlineAttributes : [String: Any] = [
            NSFontAttributeName : UIFont(name: "DinPro-Regular", size: 16.0)!,
            NSForegroundColorAttributeName : ApplicationOrangeColor,
            NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
        let attributeString = NSMutableAttributedString(string: (WSUtility.getlocalizedString(key: "Change", lang: WSUtility.getLanguage(), table: "Localizable"))!,
                                                        attributes: underlineAttributes)
        changeBtn.setAttributedTitle(attributeString, for: .normal)
    }
}
