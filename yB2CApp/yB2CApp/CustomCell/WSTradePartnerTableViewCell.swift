//
//  WSTradePartnerTableViewCell.swift
//  yB2CApp
//
//  Created by Ramakrishna on 11/28/17.
//

import UIKit
protocol WSTradePartnerTableViewCellDelegate {
    func changeframeForTradePartnerCell(editMode: Bool)
}
class WSTradePartnerTableViewCell: UITableViewCell {
    @IBOutlet weak var tradePartnerNameTextFeild: UITextField!
    @IBOutlet weak var tradePartnerLocationTextFeild: UITextField!
    @IBOutlet weak var tradePartnerAccountNumberTextFeild: UITextField!

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var dropDownButton_TP_LOC: UIButton!
    var delegate: WSTradePartnerTableViewCellDelegate?

    @IBOutlet weak var tradePartnerCitySeparatorLabelH: NSLayoutConstraint!
    @IBOutlet weak var dropDownButton_TradePartnerCity: UIButton!
    @IBOutlet weak var tradePartnerCityH: NSLayoutConstraint!
    @IBOutlet weak var tradePartnerNameY: NSLayoutConstraint!
    @IBOutlet weak var tradePartnerCityLabel: FloatLabelTextField!
    
    @IBOutlet weak var selectTradePartner: UILabel!
    
    @IBOutlet weak var tradePartnerAccountNumber: UILabel!
    
    @IBOutlet weak var editTradePartner: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUI(editModeForCell: Bool, dict: [String: Any]){
        
        if !WSUtility.isLoginWithTurkey(){
            tradePartnerCityH.constant = 0
            tradePartnerNameY.constant = 15
            tradePartnerCitySeparatorLabelH.constant = 0
            dropDownButton_TradePartnerCity.isEnabled = true
        }
        else{
            tradePartnerCityH.constant = 50
            tradePartnerNameY.constant = 96
            tradePartnerCitySeparatorLabelH.constant = 1
            dropDownButton_TradePartnerCity.isEnabled = false
        }
        
        dropDownButton_TP_LOC.isHidden = !editModeForCell
        
        tradePartnerCityLabel.placeholder = WSUtility.getlocalizedString(key: "Trade Partner City", lang: WSUtility.getLanguage())
        selectTradePartner.text = WSUtility.getlocalizedString(key: "Selected as my default trade partner", lang: WSUtility.getLanguage(), table: "Localizable")
        tradePartnerAccountNumber.text = WSUtility.getlocalizedString(key: "Trade Partner's Account Number", lang: WSUtility.getLanguage(), table: "Localizable")
        editTradePartner.setTitle(" \(WSUtility.getlocalizedString(key: "Edit Trade Partner Details", lang: WSUtility.getLanguage(), table: "Localizable")!)", for: .normal)
        
        tradePartnerNameTextFeild.placeholder = WSUtility.getlocalizedString(key: "Trade partner name", lang: WSUtility.getLanguage(), table: "Localizable")?.uppercased()
        tradePartnerLocationTextFeild.placeholder = WSUtility.getlocalizedString(key: "Trade partner location", lang: WSUtility.getLanguage(), table: "Localizable")?.uppercased()
        tradePartnerAccountNumberTextFeild.placeholder = WSUtility.getlocalizedString(key: "Trade Partner's Account Number", lang: WSUtility.getLanguage(), table: "Localizable")?.uppercased()
        
        if WSUtility.isLoginWithTurkey(){
            
            if let ptpTmpDict = dict["assignedVendor"] as? [String: Any]{
                tradePartnerNameTextFeild.text = "\(ptpTmpDict["name"] ?? WSUtility.getValueFromUserDefault(key: TRADE_PARTNER_NAME))"
            }
            
            if let tpTmpDict = dict["assignedVendorAddress"] as? [String: Any]{
                tradePartnerLocationTextFeild.text = "\(tpTmpDict["locationName"] ?? "")"
                tradePartnerCityLabel.text = "\(tpTmpDict["town"] ?? "")"
            }
            tradePartnerAccountNumberTextFeild.text = "\(dict["customerNumber"] ?? "")"
        }
        else{
            
            if let ptpTmpDict = dict["parentTradePartner"] as? [String: Any]{
                tradePartnerNameTextFeild.text = "\(ptpTmpDict["name"]!)"
            }
            else{
                tradePartnerNameTextFeild.text = WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: TRADE_PARTNER_NAME))
            }
            if let tpTmpDict = dict["tradePartner"] as? [String: Any]{
                tradePartnerLocationTextFeild.text = "\(tpTmpDict["name"]!)"
            }
            
            if let clientNo = dict["clientNumber"] as? String{
                tradePartnerAccountNumberTextFeild.text = "\(clientNo)"
            }
        }
        changeBackgroundColorAndBorder(textfiled: tradePartnerNameTextFeild, editMode: tradePartnerNameTextFeild.text == "" ? true: false)
        changeBackgroundColorAndBorder(textfiled: tradePartnerLocationTextFeild, editMode: tradePartnerLocationTextFeild.text == "" ? true: false)
        changeBackgroundColorAndBorder(textfiled: tradePartnerAccountNumberTextFeild, editMode: tradePartnerAccountNumberTextFeild.text == "" ? true: false)
        if editModeForCell {
            updateTextfeilds(isBool: true)
        }
        else{
            updateTextfeilds(isBool: false)
        }
    }
    func changeBackgroundColorAndBorder(textfiled: UITextField, editMode: Bool){
        if !editMode {
            textfiled.setLeftPaddingPoints(0)
            textfiled.backgroundColor = UIColor.clear
            WSUtility.UISetUpForTextField(textField: textfiled, withBorderColor: UIColor.clear.cgColor)
        }
        else{
            textfiled.setLeftPaddingPoints(10)
            textfiled.backgroundColor = UIColor.white
            WSUtility.UISetUpForTextField(textField: textfiled, withBorderColor: UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor)
        }
        
    }
    func updateTextfeilds(isBool: Bool){
        if isBool{
            tradePartnerAccountNumberTextFeild.isUserInteractionEnabled = true
        }
        else{
            tradePartnerAccountNumberTextFeild.isUserInteractionEnabled = false
        }
    }
    @IBAction func editbutton_click(sender: UIButton){
        //editButton.isHidden = true
        delegate?.changeframeForTradePartnerCell(editMode: true)
    }
}
