//
//  WSOrderSummaryTableViewCell.swift
//  yB2CApp
//
//  Created by Sahana Rao on 06/12/17.
//

import UIKit

class WSOrderSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var orderDetailTypeLabel: UILabel!
    @IBOutlet weak var orderDetailsLabel: UILabel!
    var string1 : String = ""
    var string2 : String = ""
    var string3 : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setMydetailsUI(dict:[String:Any]){
        if let orderInfo = dict["orderInfo"] as? NSDictionary{
            if let fullName = orderInfo["fullName"] as? String{
                string1 = fullName
            }
            if let email = orderInfo["email"] as? String{
                string2 = email
            }
            if let phone = orderInfo["mobilePhone"] as? String{
                string3 = phone
            }
            
        }
        
        let summaryDetails = "\(string1) \n\(string2) \n\(string3)"
        orderDetailsLabel.text = summaryDetails
        orderDetailTypeLabel.text = WSUtility.getlocalizedString(key: "My details", lang: WSUtility.getLanguage(), table: "Localizable")
    }
    func setTradePartnerUI(dict:[String:Any]){
        var name:String = ""
        if let parentTradePartner = dict["parentTradePartner"] as? NSDictionary{
            if let Name = parentTradePartner["name"] as? String{
                name = Name
                string1 = name
            }
        }
        if WSUtility.isLoginWithTurkey() {
            if let tradePartner = dict["parentTradePartner"] as? NSDictionary{

                if WSUtility.isLoginWithTurkey() {
                    if let arrAddress = tradePartner["vendorAddress"] as? [[String:Any]]{
                        if let obj = arrAddress[0] as? [String:Any]{
                            string2 = "\(obj["town"] ?? "")"
                            string3 = "\(obj["postalCode"] ?? "")"
                        }
                    }
                }
            }
        }
        if let tradePartner = dict["tradePartner"] as? NSDictionary{
            if let Name = tradePartner["name"] as? String{
                string1 = name
            }
            if let city = tradePartner["city"] as? String{
                string2 = city
            }
            if let postCode = tradePartner["postCode"] as? String{
                string3 = postCode
            }
        }
        let summaryDetails = "\(string1) \n\(string2) \n\(string3)"
        orderDetailsLabel.text = summaryDetails
        orderDetailTypeLabel.text = WSUtility.getlocalizedString(key: "Trade partner", lang: WSUtility.getLanguage(), table: "Localizable")
    }
    func translateUI(){
        orderDetailTypeLabel.text = WSUtility.getlocalizedString(key: "My details", lang: WSUtility.getLanguage(), table: "Localizable")
        orderDetailTypeLabel.text = WSUtility.getlocalizedString(key: "Delivery and Billing", lang: WSUtility.getLanguage(), table: "Localizable")
        orderDetailTypeLabel.text = WSUtility.getlocalizedString(key: "Trade partner", lang: WSUtility.getLanguage(), table: "Localizable")
    }
    func setBillingUI(dict:[String:Any]){
        if let orderInfo = dict["orderInfo"] as? NSDictionary{
            if let billingAddres = orderInfo["billingAddress"] as? NSDictionary{
                if let businessName = billingAddres["businessName"] as? String{
                    string1 = businessName
                }
                if let houseNumber = billingAddres["houseNumber"] as? String{
                    if let street = billingAddres["street"] as? String{
                        string2 = "\(street) \(houseNumber)"
                    }
                }
                
                if let countryCode = billingAddres["zipCode"] as? String{
                    if let city = billingAddres["city"] as? String{
                        string3 = "\(countryCode) \(city)"
                    }
                }
            }
        }
        let summaryDetails = "\(string1) \n\(string2) \n\(string3)"
        orderDetailsLabel.text = summaryDetails
        orderDetailTypeLabel.text = WSUtility.getlocalizedString(key: "Delivery and Billing", lang: WSUtility.getLanguage(), table: "Localizable")

    }

    
}

