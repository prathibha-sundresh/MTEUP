//
//  WSBusinessDetailTableViewCell.swift
//  yB2CApp
//
//  Created by Ramakrishna on 11/28/17.
//

import UIKit
protocol WSBusinessDetailTableViewCellDelegate {
    func changeframeForBusinessCell(editMode: Bool)
}
class WSBusinessDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var businessNameTextFeild: UITextField!
    @IBOutlet weak var businessTaxNoTextFeild: UITextField!
    @IBOutlet weak var businessTypeTextFeild: UITextField!
    @IBOutlet weak var buildingNumberTextFeild: UITextField!
    @IBOutlet weak var streetTextFeild: UITextField!
    @IBOutlet weak var areaCodeTextFeild: UITextField!
    @IBOutlet weak var cityNameTextFeild: UITextField!
    @IBOutlet weak var dropDownBusinessTypeButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    var delegate: WSBusinessDetailTableViewCellDelegate?
    @IBOutlet weak var businessTypeY: NSLayoutConstraint!
    @IBOutlet weak var businessTaxNumberH: NSLayoutConstraint!
    @IBOutlet weak var businessTaxNumberSeperatorH: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUI(editModeForCell: Bool,dict: [String: Any]){
        
        if !WSUtility.isLoginWithTurkey(){
            businessTypeY.constant = 15
            businessTaxNumberH.constant = 0
            businessTaxNumberSeperatorH.constant = 0
            
        }
        else{
            businessTypeY.constant = 90
            businessTaxNumberH.constant = 50
            businessTaxNumberSeperatorH.constant = 1
            
            if let taxNumber = dict["taxNumber"] as? String{
                //updateValuesForTF(textfield: businessTaxNoTextFeild, keyValue: TAX_NUMBER_KEY, name: "\(taxNumber)")
                updateValuesForTF(textfield: businessTaxNoTextFeild, keyValue: "bTax", name: "\(taxNumber)")
                
            }
        }
        
        editButton.isHidden = editModeForCell
        editButton.setTitle("  \(WSUtility.getlocalizedString(key: "Edit Business Details", lang: WSUtility.getLanguage(), table: "Localizable")!)", for: .normal)
        businessNameTextFeild.placeholder = WSUtility.getlocalizedString(key: "Business name", lang: WSUtility.getLanguage(), table: "Localizable")?.uppercased()
        businessTypeTextFeild.placeholder = WSUtility.getlocalizedString(key: "Business type", lang: WSUtility.getLanguage(), table: "Localizable")?.uppercased()
        if WSUtility.isLoginWithTurkey(){
            
            businessTaxNoTextFeild.placeholder = WSUtility.getlocalizedString(key: "Business Tax Number", lang: WSUtility.getLanguage(), table: "Localizable")
            buildingNumberTextFeild.placeholder = WSUtility.getlocalizedString(key: "Address Line 1", lang: WSUtility.getLanguage(), table: "Localizable")?.uppercased()
            streetTextFeild.placeholder = WSUtility.getlocalizedString(key: "Address Line 2", lang: WSUtility.getLanguage(), table: "Localizable")?.uppercased()
        }
        else{
            buildingNumberTextFeild.placeholder = WSUtility.getlocalizedString(key: "Building number", lang: WSUtility.getLanguage(), table: "Localizable")?.uppercased()
            streetTextFeild.placeholder = WSUtility.getlocalizedString(key: "Street", lang: WSUtility.getLanguage(), table: "Localizable")?.uppercased()
            
        }
        areaCodeTextFeild.placeholder = WSUtility.getlocalizedString(key: "Area Code", lang: WSUtility.getLanguage(), table: "Localizable")?.uppercased()
        cityNameTextFeild.placeholder = WSUtility.getlocalizedString(key: "City", lang: WSUtility.getLanguage(), table: "Localizable")?.uppercased()
        if WSUtility.isLoginWithTurkey(){
            
            if let businessName = dict["operatorBusinessName"] as? String{
                updateValuesForTF(textfield: businessNameTextFeild, keyValue: "bname", name: "\(businessName)")
            }
            
            updateValuesForTF(textfield: businessTypeTextFeild, keyValue: "btype", name: "\(WSUser().getUserProfile().businessname)")
            
            if let addressDict = dict["defaultAddress"] as? [String: Any]{
                
                if let houseNo = addressDict["line1"] as? String{
                    updateValuesForTF(textfield: buildingNumberTextFeild, keyValue: "hNo", name: "\(houseNo)")
                }
                
                if let street = addressDict["line2"] as? String{
                    updateValuesForTF(textfield: streetTextFeild, keyValue: "street", name: "\(street)")
                }
                
                if let city = addressDict["town"] as? String{
                    updateValuesForTF(textfield: cityNameTextFeild, keyValue: "city", name: "\(city)")
                }
                if let zipCode = addressDict["postalCode"] as? String{
                    updateValuesForTF(textfield: areaCodeTextFeild, keyValue: USER_ZIP_CODE, name: "\(zipCode)")
                    self.UISetUpForPostalCode(textField: areaCodeTextFeild, boolValue: false)
                }
            }
            
        }
        else{
            if let businessType = dict["typeOfBusiness"] as? String{
                updateValuesForTF(textfield: businessTypeTextFeild, keyValue: "btype", name: "\(businessType)")
            }
            
            if let businessName = dict["businessName"] as? String{
                updateValuesForTF(textfield: businessNameTextFeild, keyValue: "bname", name: "\(businessName)")
            }
            
            if let houseNo = dict["houseNumber"] as? String{
                updateValuesForTF(textfield: buildingNumberTextFeild, keyValue: "hNo", name: "\(houseNo)")
            }
            
            if let street = dict["street"] as? String{
                updateValuesForTF(textfield: streetTextFeild, keyValue: "street", name: "\(street)")
            }
            
            if let city = dict["city"] as? String{
                updateValuesForTF(textfield: cityNameTextFeild, keyValue: "city", name: "\(city)")
            }
            if let zipCode = dict["zipCode"] as? String{
                updateValuesForTF(textfield: areaCodeTextFeild, keyValue: USER_ZIP_CODE, name: "\(zipCode)")
                self.UISetUpForPostalCode(textField: areaCodeTextFeild, boolValue: false)
            }
        }
        
        
        dropDownBusinessTypeButton.isHidden = !editModeForCell
        changeBackgroundColorAndBorder(textfiled: businessNameTextFeild, textMode: businessNameTextFeild.text == "" ? true: false,isEditMode:editModeForCell)
        changeBackgroundColorAndBorder(textfiled: businessTaxNoTextFeild, textMode: businessTaxNoTextFeild.text == "" ? true: false,isEditMode:editModeForCell)
        changeBackgroundColorAndBorder(textfiled: businessTypeTextFeild, textMode: businessTypeTextFeild.text == "" ? true: false,isEditMode:editModeForCell)
        changeBackgroundColorAndBorder(textfiled: buildingNumberTextFeild, textMode: buildingNumberTextFeild.text == "" ? true: false,isEditMode:editModeForCell)
        changeBackgroundColorAndBorder(textfiled: streetTextFeild, textMode: streetTextFeild.text == "" ? true: false,isEditMode:editModeForCell)
        changeBackgroundColorAndBorder(textfiled: areaCodeTextFeild, textMode: areaCodeTextFeild.text == "" ? true: false,isEditMode:editModeForCell)
        changeBackgroundColorAndBorder(textfiled: cityNameTextFeild, textMode: cityNameTextFeild.text == "" ? true: false,isEditMode:editModeForCell)
        changeBackgroundColorAndBorder(textfiled: businessTaxNoTextFeild, textMode: businessTaxNoTextFeild.text == "" ? true: false,isEditMode:editModeForCell)
        if editModeForCell {
            updateTextfeilds(isBool: true)
        }
        else{
            updateTextfeilds(isBool: false)
        }
    }
    
    func updateValuesForTF(textfield: UITextField, keyValue: String, name: String){
        if let checkName = UserDefaults.standard.value(forKey: keyValue) as? String, checkName != ""{
            textfield.text = "\(checkName)"
        }
        else{
            textfield.text = "\(name)"
            UserDefaults.standard.set(name, forKey: keyValue)
        }
    }
    func changeBackgroundColorAndBorder(textfiled: UITextField, textMode: Bool, isEditMode:Bool){
        
        if !isEditMode{
            if !textMode {
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
        else{
            textfiled.setLeftPaddingPoints(10)
            textfiled.backgroundColor = UIColor.white
            WSUtility.UISetUpForTextField(textField: textfiled, withBorderColor: UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor)
        }
    }
    @IBAction func editbutton_click(sender: UIButton){
        delegate?.changeframeForBusinessCell(editMode: true)
    }
    func updateTextfeilds(isBool: Bool){
        if isBool{
            businessNameTextFeild.isUserInteractionEnabled = true
            buildingNumberTextFeild.isUserInteractionEnabled = true
            streetTextFeild.isUserInteractionEnabled = true
            areaCodeTextFeild.isUserInteractionEnabled = true
            cityNameTextFeild.isUserInteractionEnabled = true
            businessTaxNoTextFeild.isUserInteractionEnabled = true
        }
        else{
            businessNameTextFeild.isUserInteractionEnabled = false
            buildingNumberTextFeild.isUserInteractionEnabled = false
            streetTextFeild.isUserInteractionEnabled = false
            areaCodeTextFeild.isUserInteractionEnabled = false
            cityNameTextFeild.isUserInteractionEnabled = false
            businessTaxNoTextFeild.isUserInteractionEnabled = false
        }
    }
    func isValidInput(Input:String) -> Bool {
        let myCharSet=CharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ")
        let output: String = Input.trimmingCharacters(in: myCharSet.inverted)
        let isValid: Bool = (Input == output)
        //print("\(isValid)")
        
        return isValid
    }
}
extension WSBusinessDetailTableViewCell: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case businessNameTextFeild:
            buildingNumberTextFeild.becomeFirstResponder()
        case buildingNumberTextFeild:
            streetTextFeild.becomeFirstResponder()
        case streetTextFeild:
            areaCodeTextFeild.becomeFirstResponder()
        case areaCodeTextFeild:
            cityNameTextFeild.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    @IBAction func textDidchange(_ textField: UITextField){
        switch textField {
        case businessNameTextFeild:
            UserDefaults.standard.set(businessNameTextFeild.text, forKey: "bname")
            WSUtility.UISetUpForTextFieldWithImage(textField: businessNameTextFeild, boolValue: true)
        case businessTaxNoTextFeild:
            UserDefaults.standard.set(businessTaxNoTextFeild.text, forKey: "bTax")
            WSUtility.UISetUpForTextFieldWithImage(textField: businessTaxNoTextFeild, boolValue: true)
        case buildingNumberTextFeild:
            UserDefaults.standard.set(buildingNumberTextFeild.text, forKey: "hNo")
            WSUtility.UISetUpForTextFieldWithImage(textField: buildingNumberTextFeild, boolValue: true)
        case streetTextFeild:
            UserDefaults.standard.set(streetTextFeild.text, forKey: "street")
            WSUtility.UISetUpForTextFieldWithImage(textField: streetTextFeild, boolValue: true)
        case areaCodeTextFeild:
            UserDefaults.standard.set(areaCodeTextFeild.text, forKey: "zipcode")
            if !WSUtility.isLoginWithTurkey(){
                self.UISetUpForPostalCode(textField: areaCodeTextFeild, boolValue: true)
            }
        case cityNameTextFeild:
            UserDefaults.standard.set(cityNameTextFeild.text, forKey: "city")
            WSUtility.UISetUpForTextFieldWithImage(textField: cityNameTextFeild, boolValue: true)
        default:
            break
        }
        UserDefaults.standard.set(businessTypeTextFeild.text, forKey: "btype")
    }
    
     func UISetUpForPostalCode(textField:UITextField ,boolValue: Bool)  {
        
        textField.rightViewMode = .never
        if boolValue == true {
            
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 50))
            let checkedImage: UIImageView = UIImageView()
            checkedImage.frame = CGRect(x: 0, y: 17.5, width: 15, height: 15)
            checkedImage.contentMode = .scaleAspectFit
            
            let currentCharacterCount = textField.text?.count ?? 0
            if currentCharacterCount == 5 || currentCharacterCount == 4{
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

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == areaCodeTextFeild {
            
            let currentCharacterCount = textField.text?.count ?? 0
            if currentCharacterCount>5{
                return true
            }
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 5
        }
        if textField == cityNameTextFeild{
            return self.isValidInput(Input: string)
        }
        else if textField == areaCodeTextFeild {
            
            let currentCharacterCount = textField.text?.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 4
        }
        return true
    }
}

