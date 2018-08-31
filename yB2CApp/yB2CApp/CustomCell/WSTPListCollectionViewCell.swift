//
//  WSTPListCollectionViewCell.swift
//  yB2CApp
//
//  Created by Ramakrishna on 11/30/17.
//

import UIKit

protocol WSTPListCollectionViewCellDelegate {
    func selectedIndex(index: Int)
    func changeEditForCell(sender: UIButton)
    func editBeforeUpdatingDefaultTradePartner(sender: UIButton)
}
class WSTPListCollectionViewCell: UICollectionViewCell {
    var delegate: WSTPListCollectionViewCellDelegate?
    @IBOutlet weak var tpCityH: NSLayoutConstraint!
    @IBOutlet weak var tpNameY: NSLayoutConstraint!
    
    @IBOutlet weak var tradePartnerCity: UITextField!
    
    @IBOutlet weak var tradePartnerName: UITextField!
    @IBOutlet weak var tradePartnerLocation: UITextField!
    @IBOutlet weak var accountNumber: UITextField!
    @IBOutlet weak var makeDefaultButton: UIButton!
    @IBOutlet weak var selectTradePartnerButton: UIButton!
    @IBOutlet weak var editTradePartnerButton: UIButton!
    @IBOutlet weak var selectedDefalutTextLabel: UILabel!
    
    @IBOutlet weak var enterTradePartnerLabel: UILabel!
    @IBOutlet weak var dropDown_TradePartnerCityButton: UIButton!
    @IBOutlet weak var dropDown_TradePartnerNameButton: UIButton!
    @IBOutlet weak var dropDown_TradePartnerLocationButton: UIButton!
    
    func setUI(editModeForCell: Bool){
        tradePartnerCity.placeholder = WSUtility.getlocalizedString(key: "Trade Partner City", lang: WSUtility.getLanguage())
        
        changeBackgroundColorAndBorder(textfiled: tradePartnerCity, editMode: editModeForCell)
        changeBackgroundColorAndBorder(textfiled: tradePartnerName, editMode: editModeForCell)
        changeBackgroundColorAndBorder(textfiled: tradePartnerLocation, editMode: editModeForCell)
        changeBackgroundColorAndBorder(textfiled: accountNumber, editMode: editModeForCell)
        tradePartnerName.placeholder = WSUtility.getlocalizedString(key: "Trade partner name", lang: WSUtility.getLanguage(), table: "Localizable")
        tradePartnerLocation.placeholder = WSUtility.getlocalizedString(key: "Trade partner location", lang: WSUtility.getLanguage(), table: "Localizable")
        accountNumber.placeholder = WSUtility.getlocalizedString(key: "Trade Partner's Account Number", lang: WSUtility.getLanguage(), table: "Localizable")
        
        
           selectedDefalutTextLabel.text = WSUtility.getlocalizedString(key: "Make this my default trade partner", lang: WSUtility.getLanguage(), table: "Localizable")
        selectTradePartnerButton.setTitle(WSUtility.getlocalizedString(key: "Select this Trade Partner", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        enterTradePartnerLabel.text = WSUtility.getlocalizedString(key: "your trade partner's account number", lang: WSUtility.getLanguage(), table: "Localizable")
        if editModeForCell{
            editTradePartnerButton.setTitle(WSUtility.getlocalizedString(key: "Save Changes", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        }
        else{
            editTradePartnerButton.setTitle(WSUtility.getlocalizedString(key: "Edit Trade Partner Details", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
            emptyAllFeilds()
        }
        
        if !WSUtility.isLoginWithTurkey(){
            tpCityH.constant = 0
            tpNameY.constant = 15
        }
        else{
        
            tpCityH.constant = 50
            tpNameY.constant = 80
        }
        
        if WSUtility.isLoginWithTurkey(){
            if editModeForCell{
                // for time being purpose: Ram
                changeBackgroundColorAndBorder(textfiled: tradePartnerCity, editMode: false)
                changeBackgroundColorAndBorder(textfiled: tradePartnerName, editMode: false)
                changeBackgroundColorAndBorder(textfiled: tradePartnerLocation, editMode: false)
                self.backgroundColor = UIColor.white
            }
        }
    }
    
    func emptyAllFeilds(){
        
        tradePartnerName.rightViewMode = .never
        tradePartnerLocation.rightViewMode = .never
        accountNumber.rightViewMode = .never
        
    }
    
    func setDataForTradePartnerCell(infoDict: [String: Any],response: [String: Any]){
        print("infoDict ******* \(infoDict)")
        
        if WSUtility.isLoginWithTurkey(){
            
            let isMakeDefalt: Bool = (infoDict["isDefault"] as? Bool) ?? false
            accountNumber.text = "\(infoDict["customerNumber"] ?? "")"
            
            if isMakeDefalt{
                makeDefaultButton.isHidden = false
                selectedDefalutTextLabel.isHidden = false
                
                if let dict = infoDict["assignedVendor"] as? [String: Any]{
                    
                    UserDefaults.standard.set("\(dict["name"] ?? "")", forKey: "tradePartnerName")
                    UserDefaults.standard.set("\(dict["code"] ?? "")", forKey: TRADE_PARTNER_ID)
                }
                
            }
            else{
                makeDefaultButton.isHidden = true
                selectedDefalutTextLabel.isHidden = true
            }
            makeDefaultButton.isSelected = isMakeDefalt
            
            if let dict = infoDict["assignedVendor"] as? [String: Any]{
                tradePartnerName.text = "\(dict["name"] ?? "")"
                if let parentTPId = dict["code"]{
                    tradePartnerName.tag = Int("\(parentTPId)")!
                }
            }
            
            if let tradePartnerDict = infoDict["assignedVendorAddress"] as? [String: Any]{
                tradePartnerLocation.text = "\(tradePartnerDict["locationName"] ?? "")"
                if let childID = tradePartnerDict["locationId"]{
                    tradePartnerLocation.tag = Int("\(childID)")!
                }
                tradePartnerCity.text = "\(tradePartnerDict["town"] ?? "")"
            }
            return
        }
        else{
            
            var isMakeDefalt: Bool = false
            let userProfile_clientNumber = response["clientNumber"] as? Int
            var userProfile_parentTradePartnerId = 0
            if let profileTPId = response["parentTradePartnerId"] as? Int{
                userProfile_parentTradePartnerId = profileTPId
            }
            var userProfile_TradePartnerId = 0
            if let tpLocationID = response["tradePartnerId"] as? Int{
                userProfile_TradePartnerId = tpLocationID
            }
            
            if infoDict["parentTradePartnerId"]as? Int == userProfile_parentTradePartnerId{
                if infoDict["tradePartnerId"]as? Int == userProfile_TradePartnerId{
                    if userProfile_clientNumber == infoDict["clientNumber"] as? Int{
                        isMakeDefalt = true
                    }
                    else{
                        
                    }
                }
            }
            
            if isMakeDefalt{
                makeDefaultButton.isHidden = false
                selectedDefalutTextLabel.isHidden = false
            }
            else{
                makeDefaultButton.isHidden = true
                selectedDefalutTextLabel.isHidden = true
            }
            makeDefaultButton.isSelected = isMakeDefalt
            if let parentTradePartnerDict = infoDict["parentTradePartner"] as? [String: Any]{
                if let name = parentTradePartnerDict["name"] as? String {
                    tradePartnerName.text = name
                    
                    if isMakeDefalt{
                        UserDefaults.standard.set("\(name)", forKey: "tradePartnerName")
                        UserDefaults.standard.set("\(userProfile_parentTradePartnerId)", forKey: TRADE_PARTNER_ID)
                    }
                }
            }
            if let tradePartnerDict = infoDict["tradePartner"] as? [String: Any]{
                if let location = tradePartnerDict["name"] as? String{
                    tradePartnerLocation.text = location
                }
            }
            
            if let number = infoDict["clientNumber"]as? String {
                accountNumber.text = "\(number)"
            }
            else{
                accountNumber.text = ""
            }
            
            if let parentTPId = infoDict["parentTradePartnerId"] as? Int{
                tradePartnerName.tag = parentTPId
            }
            
            if let childID = infoDict["tradePartnerId"] as? Int{
                tradePartnerLocation.tag = childID
            }
            
        }
    }
    
    func changeBackgroundColorAndBorder(textfiled: UITextField, editMode: Bool){
        if !editMode {
            textfiled.setLeftPaddingPoints(0)
            self.backgroundColor = UIColor(red: 247.0/255.0, green: 245.0/255.0, blue: 243.0/255.0, alpha: 1.0)
            WSUtility.UISetUpForTextField(textField: textfiled, withBorderColor: UIColor.clear.cgColor)
            dropDown_TradePartnerCityButton.isHidden = true
            dropDown_TradePartnerNameButton.isHidden = true
            dropDown_TradePartnerLocationButton.isHidden = true
        }
        else{
            textfiled.setLeftPaddingPoints(10)
            self.backgroundColor = UIColor.white
            if textfiled.text == ""{
                WSUtility.UISetUpForTextField(textField: textfiled, withBorderColor: selectedTextFieldBorderColor)

            }else{
                WSUtility.UISetUpForTextField(textField: textfiled, withBorderColor: UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor)
            }
            dropDown_TradePartnerCityButton.isHidden = false
            dropDown_TradePartnerNameButton.isHidden = false
            dropDown_TradePartnerLocationButton.isHidden = false
        }
    }
    @IBAction func selectTradePartner(sender: UIButton){
        if accountNumber.text == ""{
            delegate?.editBeforeUpdatingDefaultTradePartner(sender: sender)
            errorTradePartnerClick(sender: sender)
        }
        else{
            delegate?.selectedIndex(index: sender.tag)
        }

    }
    @IBAction func editTradePartner(sender: UIButton){
        //setUI(editModeForCell: true)
        delegate?.changeEditForCell(sender: sender)
    }
    @IBAction func tradePartnerName_DropDownAction(sender: UIButton){
        
    }
    @IBAction func tradePartnerLocation_DropDownAction(sender: UIButton){
        
    }
}
extension WSTPListCollectionViewCell: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    @IBAction func textDidchange(_ textField: UITextField){
        switch textField {
        case tradePartnerName:
            UISetUpForTextFieldWithImage(textField: tradePartnerName, boolValue: true)
        case tradePartnerLocation:
            UISetUpForTextFieldWithImage(textField: tradePartnerLocation, boolValue: true)
        case accountNumber:
            WSUtility.UISetUpForTextFieldWithImage(textField: accountNumber, boolValue: true)
        default:
            break
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var allowedLength: Int?
        switch textField {
        case accountNumber:
            allowedLength = 12
        default:
            return true
        }
        let nsString = NSString(string: textField.text!)
        if nsString.length >= allowedLength! && range.length == 0 {
            return false
        }
        else{
            return true
        }
    }
    
    func UISetUpForAccountNoTextFieldWithImage(textField:UITextField ,boolValue: Bool)  {
        
        if boolValue == true {
            
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 50))
            let checkedImage: UIImageView = UIImageView()
            checkedImage.frame = CGRect(x: 0, y: 17.5, width: 15, height: 15)
            checkedImage.contentMode = .scaleAspectFit
            
            if textField.text?.count == 12{
                checkedImage.image = #imageLiteral(resourceName: "checked_Icon")
                textField.layer.borderColor = unselectedTextFieldBorderColor
            }
            else{
                checkedImage.image = #imageLiteral(resourceName: "error_icon")
                textField.layer.borderColor = selectedTextFieldBorderColor
            }
            
            rightView.addSubview(checkedImage)
            textField.rightView = rightView
            textField.rightViewMode = UITextFieldViewMode.always
        }
        else{
            textField.layer.borderWidth = 1.5
            textField.layer.borderColor = unselectedTextFieldBorderColor
            textField.layer.cornerRadius = 6
        }
    }
    func UISetUpForTextFieldWithImage(textField:UITextField ,boolValue: Bool)  {
        
        if boolValue == true {
            
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 50))
            let checkedImage: UIImageView = UIImageView()
            checkedImage.frame = CGRect(x: -60, y: 17.5, width: 15, height: 15)
            checkedImage.contentMode = .scaleAspectFit
            
            if textField.text != "" {
                checkedImage.image = #imageLiteral(resourceName: "checked_Icon")
                textField.layer.borderColor = unselectedTextFieldBorderColor
            }
            else{
                checkedImage.image = #imageLiteral(resourceName: "error_icon")
                textField.layer.borderColor = selectedTextFieldBorderColor
            }
            
            rightView.addSubview(checkedImage)
            textField.rightView = rightView
            textField.rightViewMode = UITextFieldViewMode.always
        }
        else{
            textField.layer.borderWidth = 1.5
            textField.layer.borderColor = unselectedTextFieldBorderColor
            textField.layer.cornerRadius = 6
        }
        
    }
    
    
    
    
     func errorTradePartnerClick(sender: UIButton){
        
        
        let tpName: String? = self.tradePartnerName.text
        let tpLocation : String? = self.tradePartnerLocation.text
        let tpAccount : String? = self.accountNumber.text
        
        if tpName == "" {
            self.textDidchange(self.tradePartnerName)
        }
        
        if tpLocation == "" {
            self.textDidchange(self.tradePartnerLocation)
        }
        if tpAccount == "" {
            
            self.UISetUpForAccountNoTextFieldWithImage(textField: self.accountNumber, boolValue: true)
        }
        

    }
}
