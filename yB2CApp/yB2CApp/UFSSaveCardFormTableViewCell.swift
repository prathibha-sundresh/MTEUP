//
//  UFSSaveCardFormTableViewCell.swift
//  UFSDev
//
//  Created by Newlaptop on 25/07/18.
//

import UIKit

var updatePikerText :((String) -> ())?
var validateFields : (() -> (Bool))?

class UFSSaveCardFormTableViewCell: UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var btnSaveCard: UIButton!
    
    @IBOutlet weak var securityCodeLbl: UILabel!
    @IBOutlet weak var expiryDateLbl: UILabel!
    @IBOutlet weak var tfYY: FloatLabelTextField!
    @IBOutlet weak var tfMM: FloatLabelTextField!
    @IBOutlet weak var lblErrSecurityCode: UILabel!
    @IBOutlet weak var lblHdrExpDate: UILabel!
    @IBOutlet weak var lblErrNumber: UILabel!
    @IBOutlet weak var lblErrName: UILabel!
    @IBOutlet weak var tfCardNumber: FloatLabelTextField!
    @IBOutlet weak var tfNameOnCard: FloatLabelTextField!
    @IBOutlet weak var ivVisaCard: UIImageView!
    @IBOutlet weak var ivMaximumCard: UIImageView!
    @IBOutlet weak var ivMasterCard: UIImageView!
    @IBOutlet weak var btnAddCard: WSDesignableButton!
    @IBOutlet weak var tfCVV: FloatLabelTextField!
    @IBOutlet weak var lblErrCode: UILabel!
    @IBOutlet weak var lblErrMM: UILabel!
    
    var showPikerV:(([Any],String,String) -> ())?
    var updatePaymentDetils: (([String:Any]) ->())?
    var goToSummaryPage: (() ->())?
    var scrollVaccordingToTextfild : ((UITextField) -> Void)?

    var selectedTF = 0
    var strPopUpTitle = ""
    var strSelectedItem = ""
    var pickerData : [String]?
    var arrMonths = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    var arrYears = ["2018", "2019", "2020", "2021", "2022", "2023", "2024", "2025", "2026", "2027", "2028", "2029", "2030"]
    var indPath:IndexPath?
    var paymentDetail = [String:Any]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.defaultUISetUp()
        
        validateFields = {
            
            var isFieldsEmpty: Bool = false
            
            if(self.tfNameOnCard.text == ""){
                self.showhideErrorLabels(textField: self.tfNameOnCard,errorTextLabel: self.lblErrName)
                WSUtility.UISetUpForTextFieldWithImage(textField: self.tfNameOnCard, boolValue: true)
                isFieldsEmpty = true
            }
            if(self.tfCardNumber.text == ""){
                self.showhideErrorLabels(textField: self.tfCardNumber,errorTextLabel: self.lblErrNumber)
                WSUtility.UISetUpForTextFieldWithImage(textField: self.tfCardNumber, boolValue: true)
                isFieldsEmpty = true
            }
            if(self.tfMM.text == ""){
                self.showhideErrorLabels(textField: self.tfMM,errorTextLabel: self.lblHdrExpDate)
                self.UISetUpForExpirationtextField(textField: self.tfMM, boolValue: true)
                isFieldsEmpty = true
            }
            if(self.tfYY.text == ""){
                self.showhideErrorLabels(textField: self.tfYY,errorTextLabel: self.lblHdrExpDate)
                self.UISetUpForExpirationtextField(textField: self.tfYY, boolValue: true)
                isFieldsEmpty = true
            }
            let code = (self.tfCVV.text?.count)!
            if code != 3{
                self.showhideErrorLabels(textField: self.tfCVV,errorTextLabel: self.lblErrSecurityCode)
                self.UISetUpForPostalCodeTextFields(textField: self.tfCVV, boolValue: true)
                isFieldsEmpty = true
            }
            
            if !isFieldsEmpty{
                
                self.paymentDetail["CardNumber"] = self.tfCardNumber.text
                self.paymentDetail["NameOnCard"] = self.tfNameOnCard.text
                self.paymentDetail["CVV"] = self.tfCVV.text
                self.paymentDetail["Expiration_Month"] = self.tfMM.text
                self.paymentDetail["Expiration_Year"] = self.tfYY.text
                self.paymentDetail["isNeedToSave"] = self.btnSaveCard.isSelected
                self.paymentDetail["isPaymentFromSavedCard"] = false
                self.paymentDetail["savedCardID"] = ""
                self.updatePaymentDetils!(self.paymentDetail)
               
            }
            return isFieldsEmpty
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeliveryViewController.dismissKeyboard))
        self.contentView.addGestureRecognizer(tap)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.contentView.endEditing(true)
    }

    
    //MARK:default set Up
    
    func defaultUISetUp(){
        
        lblErrSecurityCode.text = WSUtility.getlocalizedString(key: "Enter Security card code", lang: WSUtility.getLanguage())
        lblErrName.text = WSUtility.getlocalizedString(key: "Enter Name on Card", lang: WSUtility.getLanguage())
        lblErrNumber.text = WSUtility.getlocalizedString(key: "Enter the card number", lang: WSUtility.getLanguage())
        lblHdrExpDate.text = WSUtility.getlocalizedString(key: "Enter a valid expiration date", lang: WSUtility.getLanguage())
        
        btnAddCard.setTitle(WSUtility.getlocalizedString(key: "Add your card", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        
        tfNameOnCard.placeholder = WSUtility.getlocalizedString(key: "Name on Card", lang: WSUtility.getLanguage(), table: "Localizable")
        tfCardNumber.placeholder = WSUtility.getlocalizedString(key: "CARD NUMBER", lang: WSUtility.getLanguage(), table: "Localizable")
        lblHdrExpDate.text = WSUtility.getlocalizedString(key: "Expiry date", lang: WSUtility.getLanguage(), table: "Localizable")!
        lblErrSecurityCode.text = WSUtility.getlocalizedString(key: "Security Code", lang: WSUtility.getLanguage(), table: "Localizable")!
        btnSaveCard.setTitle(WSUtility.getlocalizedString(key: "Save these details for next time", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        
        expiryDateLbl.text = WSUtility.getlocalizedString(key: "Expiry date", lang: WSUtility.getLanguage(), table: "Localizable")!
        securityCodeLbl.text = WSUtility.getlocalizedString(key: "Security Code", lang: WSUtility.getLanguage(), table: "Localizable")!
                
        addBorderColor(textfiled: tfNameOnCard)
        addBorderColor(textfiled: tfCardNumber)
        addBorderColor(textfiled: tfMM)
        addBorderColor(textfiled: tfYY)
        addBorderColor(textfiled: tfCVV)
        
        UISetUpForIV(iv: ivVisaCard, withBorderColor: unselectedTextFieldBorderColor)
        UISetUpForIV(iv: ivMasterCard, withBorderColor: unselectedTextFieldBorderColor)
        UISetUpForIV(iv: ivMaximumCard, withBorderColor: unselectedTextFieldBorderColor)

    }
    
    func showhideErrorLabels(textField:UITextField, errorTextLabel: UILabel){
        if textField == tfCVV{
            let currentCharacterCount = textField.text?.count ?? 0
            if currentCharacterCount != 3{
                errorTextLabel.isHidden = false
            }
            else{
                errorTextLabel.isHidden = true
            }
            return
        }
        
        if textField.text != "" {
            errorTextLabel.isHidden = true
        }
        else{
            errorTextLabel.isHidden = false
        }
    }
    
    func UISetUpForExpirationtextField(textField:UITextField ,boolValue: Bool)  {
        if !boolValue{
            textField.layer.borderWidth = 1.5
            textField.layer.borderColor = unselectedTextFieldBorderColor
            textField.layer.cornerRadius = 6
        }
        else{
            textField.layer.borderColor = selectedTextFieldBorderColor
        }
    }
    
    func UISetUpForPostalCodeTextFields(textField:UITextField ,boolValue: Bool)  {
       
        if boolValue == true {
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 50))
            let checkedImage: UIImageView = UIImageView()
            checkedImage.frame = CGRect(x: 0, y: 17.5, width: 15, height: 15)
            checkedImage.contentMode = .scaleAspectFit
            
            let billingCode = (textField.text?.count)!
            
            if billingCode == 3 {
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
    
    func addBorderColor(textfiled: UITextField){
        textfiled.setLeftPaddingPoints(10)
        WSUtility.UISetUpForTextField(textField: textfiled, withBorderColor: unselectedTextFieldBorderColor)
    }
    func UISetUpForIV(iv:UIImageView, withBorderColor color:CGColor)  {
        iv.layer.borderWidth = 1.0
        iv.layer.borderColor = color
        iv.layer.cornerRadius = 3.8
    }
    
    func manageErrorLabels(){
        if tfMM.text == "" && tfYY.text == "" {
            self.showhideErrorLabels(textField: self.tfYY,errorTextLabel: self.lblErrMM)
        }
        else{
            self.showhideErrorLabels(textField: self.tfYY,errorTextLabel: self.lblErrMM)
        }
        if tfMM.text == ""{
            self.UISetUpForExpirationtextField(textField: self.tfMM, boolValue: true)
        }else{
            self.UISetUpForExpirationtextField(textField: self.tfMM, boolValue: false)
        }
        if tfYY.text == ""{
            self.UISetUpForExpirationtextField(textField: self.tfYY, boolValue: true)
        }else{
            self.UISetUpForExpirationtextField(textField: self.tfYY, boolValue: false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate methods
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        if  textField == tfMM || textField == tfYY{
            self.endEditing(true)
            if textField == tfMM {
                selectedTF = 0
                pickerData = arrMonths
                strPopUpTitle = "Select a month"
                if let str = tfMM.text{
                    strSelectedItem = str
                }
            }
            else{
                selectedTF = 1
                pickerData = arrYears
                strPopUpTitle = "Select a year"
                if let str = tfYY.text{
                    strSelectedItem = str
                }
            }
            if self.selectedTF == 0{
                showPikerV!(pickerData!, strPopUpTitle, strSelectedItem)
                updatePikerText = { stringValue in
                     self.tfMM.text = stringValue
                }
            }
            else{
                showPikerV!(pickerData!, strPopUpTitle, strSelectedItem)
                updatePikerText = { stringValue in
                    self.tfYY.text = stringValue
                    
                }
            }
            return false
        }
        else{
            self.scrollVaccordingToTextfild!(textField)
            return true
        }
    }
    
    //MARK : ACTIONS
    
    @IBAction func btnAddYourCardBtn(_ sender: Any) {
        if (!validateFields!()){
            self.goToSummaryPage!()
        }
    }
    
    @IBAction func textDidchange(_ textField: UITextField){
        
        switch textField {
        case tfNameOnCard:
            self.showhideErrorLabels(textField: textField,errorTextLabel: lblErrName)
            WSUtility.UISetUpForTextFieldWithImage(textField: tfNameOnCard, boolValue: true)
        case tfCardNumber:
            self.showhideErrorLabels(textField: textField,errorTextLabel: lblErrNumber)
            WSUtility.UISetUpForTextFieldWithImage(textField: tfCardNumber, boolValue: true)
        case tfCVV:
            self.showhideErrorLabels(textField: textField,errorTextLabel: lblErrSecurityCode)
            self.UISetUpForPostalCodeTextFields(textField: tfCVV, boolValue: true)
        default:
            break
        }
    }
    @IBAction func btnSaveCardTapped(_ sender: Any) {
        
        let btn = sender as? UIButton
        btn?.isSelected = !(btn?.isSelected)!
        
    }
}
