//
//  WSAddTPCollectionViewCell.swift
//  yB2CApp
//
//  Created by Ramakrishna on 11/29/17.
//

import UIKit

class WSAddTPCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var selectNewTradepartnerLabel: UILabel!
    
    @IBOutlet weak var enterTradePartnetAccNumber: UILabel!
    
    @IBOutlet weak var makeThisDTPLabel: UILabel!
    
    @IBOutlet weak var addNewTradepartnerButton: UIButton!
    @IBOutlet weak var tpCityH: NSLayoutConstraint!
    @IBOutlet weak var tpNameY: NSLayoutConstraint!
    @IBOutlet weak var tradePartnerCity: UITextField!{
        didSet{
            changeBackgroundColorAndBorder(textfiled: tradePartnerCity)
        }
    }
    
    @IBOutlet weak var tradePartnerName: UITextField!{
        didSet{
            changeBackgroundColorAndBorder(textfiled: tradePartnerName)
        }
    }
    @IBOutlet weak var tradePartnerLocation: UITextField!{
        didSet{
            changeBackgroundColorAndBorder(textfiled: tradePartnerLocation)
        }
    }
    @IBOutlet weak var accountNumber: UITextField!{
        didSet{
            changeBackgroundColorAndBorder(textfiled: accountNumber)
        }
    }
    @IBOutlet weak var makeDefaultButton: UIButton!{
        didSet{
            makeDefaultButton.layer.borderWidth = 1.0
            makeDefaultButton.layer.borderColor = UIColor(red: 183.0/255.0, green: 183.0/255.0, blue: 183.0/255.0, alpha: 1.0).cgColor
        }
    }
    @IBOutlet weak var dropDown_TpCityButton: UIButton!
    @IBOutlet weak var tpButton: UIButton!
    @IBOutlet weak var tplocationButton: UIButton!
    @IBOutlet weak var addTPButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func changeBackgroundColorAndBorder(textfiled: UITextField){
        textfiled.setLeftPaddingPoints(10)
        WSUtility.UISetUpForTextField(textField: textfiled, withBorderColor: UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor)
    }
    func emptyAllFeilds(){
        tradePartnerCity.text = ""
        tradePartnerCity.rightViewMode = .never
        tradePartnerName.text = ""
        tradePartnerName.rightViewMode = .never
        tradePartnerLocation.text = ""
        tradePartnerLocation.rightViewMode = .never
        accountNumber.text = ""
        accountNumber.rightViewMode = .never
        makeDefaultButton.isSelected = false
    }
    func translateUI(){
       
        tradePartnerCity.placeholder = WSUtility.getlocalizedString(key: "Trade Partner City", lang: WSUtility.getLanguage())
        tradePartnerName.placeholder = WSUtility.getlocalizedString(key:"Trade partner name", lang: WSUtility.getLanguage(), table: "Localizable")
        tradePartnerLocation.placeholder = WSUtility.getlocalizedString(key:"Trade partner location", lang: WSUtility.getLanguage(), table: "Localizable")
       selectNewTradepartnerLabel.text = WSUtility.getlocalizedString(key: "Select a new trade partner", lang: WSUtility.getLanguage(), table: "Localizable")
        enterTradePartnetAccNumber.text = WSUtility.getlocalizedString(key: "Enter Your Trade Partner Account Number", lang: WSUtility.getLanguage(), table: "Localizable")
        
        accountNumber.placeholder = WSUtility.getlocalizedString(key:"Trade partner account number for popup", lang: WSUtility.getLanguage(), table: "Localizable")
        
        makeThisDTPLabel.text = WSUtility.getlocalizedString(key: "Make this my default trade partner", lang: WSUtility.getLanguage(), table: "Localizable")
        
        addNewTradepartnerButton.setTitle(WSUtility.getlocalizedString(key: "Add new Trade Partner", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        
        if !WSUtility.isLoginWithTurkey(){
            tpCityH.constant = 0
            tpNameY.constant = 16
            dropDown_TpCityButton.isHidden = true
        }
        else{
            tpCityH.constant = 50
            tpNameY.constant = 80
            dropDown_TpCityButton.isHidden = false
        }
        
    }
    @IBAction func makeDefaultButton_Click(_ sender: Any) {
        if !makeDefaultButton.isSelected{
            makeDefaultButton.isSelected = true
        }
        else{
            makeDefaultButton.isSelected = false
        }
    }
}
extension WSAddTPCollectionViewCell: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    @IBAction func textDidchange(_ textField: UITextField){
        switch textField {
        case tradePartnerCity:
            UISetUpForTextFieldWithImage(textField: tradePartnerCity, boolValue: true)
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
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == accountNumber{
//            UISetUpForAccountNoTextFieldWithImage(textField: accountNumber, boolValue: true)
//        }
//    }
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
}
