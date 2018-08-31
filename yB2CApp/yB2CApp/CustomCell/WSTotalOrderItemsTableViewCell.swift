//
//  WSTotalOrderItemsTableViewCell.swift
//  yB2CApp
//
//  Created by Sahana Rao on 06/12/17.
//

import UIKit

@objc protocol WSTotalOrderItemsTableViewCellDelegate{
    func didSelectItem()
}

class WSTotalOrderItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var oredrNowButton: WSDesignableButton!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var orderCostLabel: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    var delegate:WSTotalOrderItemsTableViewCellDelegate? = nil
    var totalPointsText = WSUtility.getlocalizedString(key:"Total points", lang: WSUtility.getLanguage(), table: "Localizable")
    var totalItemsText = WSUtility.getlocalizedString(key:"Total Items", lang: WSUtility.getLanguage(), table: "Localizable")
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func orderNow(_ sender: UIButton) {
        delegate?.didSelectItem()
    }

    func translateUI(){
        oredrNowButton.setTitle(WSUtility.getlocalizedString(key:"Order now", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
       
    }
    func setUI(dict:[String:Any]){
       
        if let totalPoints = dict["totalLoyaltyPoints"] as? Int{
            totalPointsLabel.text = totalPointsText! + " \(totalPoints)"
        }
        if let totalPrice = dict["totalPrice"] as? String{
          /*
            if totalPrice == 0.0 {
                oredrNowButton.isEnabled = false
                oredrNowButton.alpha = 0.25
            } else {
                oredrNowButton.isEnabled = true
                oredrNowButton.alpha = 1
            }
          
          
          let removeDotFromPrice = "\(totalPrice)".replacingOccurrences(of: ".", with: ",")
            if WSUtility.getCountryCode() == "CH"{
                orderCostLabel.text = "CHF \(removeDotFromPrice)"
            }
            else if WSUtility.getCountryCode() == "TR"{
                orderCostLabel.text = "\(removeDotFromPrice) ₺"
            }
            else{
                orderCostLabel.text = "€\(removeDotFromPrice)"
            }
 
 */
          orderCostLabel.text = totalPrice
          
          
        }else{
          orderCostLabel.text = ""
      }
      
      
        if let orderLineItemCount = dict["orderLineItemCount"] as? Int{
            totalItemsLabel.text = totalItemsText! + "(\(orderLineItemCount))"
        }
        else if let orderLineItemCount = dict["quantity"] as? Int{
            totalItemsLabel.text = totalItemsText! + "(\(orderLineItemCount))"
        }
    }
}

