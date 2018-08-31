//
//  WSMyDetailsTableViewCell.swift
//  yB2CApp
//
//  Created by Ramakrishna on 11/28/17.
//

import UIKit

protocol WSMyDetailsDelegate {
    func changeframeForCell(editMode: Bool)
}
class WSMyDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var lastNameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lastlineHConstraint: NSLayoutConstraint!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var firstNameTextfield: FloatLabelTextField!
    @IBOutlet weak var lastNameTextfield: FloatLabelTextField!
    @IBOutlet weak var emailTextfield: FloatLabelTextField!
    @IBOutlet weak var mobileTextfield: FloatLabelTextField!
    var delegate: WSMyDetailsDelegate?
    var mobileNoStr: String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUI(editModeForCell: Bool,dict: [String: Any]){
        
        editButton.setTitle("  \(WSUtility.getlocalizedString(key: "Edit my details", lang: WSUtility.getLanguage(), table: "Localizable")!)", for: .normal)
        
        var mobileNo = ""
        
        if let str = dict["phoneNumber"] as? String{
            mobileNo = str
        }
        else{
            if let tmpdict = dict["defaultAddress"] as? [String: Any]{
                if let str1 = tmpdict["phone"] as? String{
                    mobileNo = str1
                }
            }
        }
        if mobileNo != ""{
            if mobileNo == ""{
                mobileTextfield.text = mobileNoStr
            }
            else{
                mobileTextfield.text = (mobileNoStr == "") ? mobileNo: mobileNoStr
                UserDefaults.standard.set(mobileNo, forKey: "mobileNo")
            }
        }
        
        emailTextfield.text = "\(UserDefaults.standard.value(forKey: "LAST_AUTHENTICATED_USER_KEY")!)"
        
        self.setFirstNameLastName(responseDict: dict)
        
        if !editModeForCell {
            lastNameTopConstraint.constant = 8
            lastNameTextfield.isHidden = true
            firstNameTextfield.placeholder = "NAME"
            
            var nameStr = ""
            if let str = dict["name"] as? String{
                nameStr = str
            }
            else if let str1 = dict["fullName"] as? String{
                nameStr = str1
            }
            
            if nameStr != ""{
                if let checkName = UserDefaults.standard.value(forKey: "fullname") as? String, checkName != ""{
                    firstNameTextfield.text = "\(checkName)"
                }
                else{
                    firstNameTextfield.text = "\(nameStr)"
                    UserDefaults.standard.set(nameStr, forKey: "fullname")
                }
                
            }
            else{
                UserDefaults.standard.set("\(WSUtility.getValueFromUserDefault(key: "fname") + WSUtility.getValueFromUserDefault(key: "lname"))", forKey: "fullname")
            }
            
            firstNameTextfield.placeholder = WSUtility.getlocalizedString(key: "Name", lang: WSUtility.getLanguage(), table: "Localizable")?.uppercased()
            lastlineHConstraint.constant = 1
            updateTextfeilds(isBool: false)
        }
        else{

            lastNameTopConstraint.constant = 89
            lastNameTextfield.isHidden = false
            firstNameTextfield.text = WSUtility.getValueFromUserDefault(key: "fname")
            lastNameTextfield.text = WSUtility.getValueFromUserDefault(key: "lname")
            
            firstNameTextfield.placeholder = "FIRST NAME"
            lastNameTextfield.placeholder = "LAST NAME"
            firstNameTextfield.placeholder = WSUtility.getlocalizedString(key: "First Name", lang: WSUtility.getLanguage(), table: "Localizable")?.uppercased()
            lastNameTextfield.placeholder = WSUtility.getlocalizedString(key: "Surname", lang: WSUtility.getLanguage(), table: "Localizable")?.uppercased()
            
            lastlineHConstraint.constant = 0
            updateTextfeilds(isBool: true)
        }
        editButton.isHidden = editModeForCell
        emailTextfield.placeholder = WSUtility.getlocalizedString(key: "Email", lang: WSUtility.getLanguage(), table: "Localizable")?.uppercased()
        mobileTextfield.placeholder = WSUtility.getlocalizedString(key: "Mobile Number", lang: WSUtility.getLanguage(), table: "Localizable")?.uppercased()
        
        changeBackgroundColorAndBorder(textfiled: firstNameTextfield, textMode: firstNameTextfield.text == "" ? true: false,isEditMode:editModeForCell)
        changeBackgroundColorAndBorder(textfiled: lastNameTextfield,textMode: lastNameTextfield.text == "" ? true: false,isEditMode:editModeForCell)
        changeBackgroundColorAndBorder(textfiled: emailTextfield, textMode: emailTextfield.text == "" ? true: false,isEditMode:editModeForCell)
        changeBackgroundColorAndBorder(textfiled: mobileTextfield, textMode: mobileTextfield.text == "" ? true: false,isEditMode:editModeForCell)
    }
    func setFirstNameLastName(responseDict: [String: Any]){
        var firstName: String = ""
        var lastName: String = ""
        
        if let nameStr = UserDefaults.standard.value(forKey: "fname") as? String, nameStr != ""{
            firstName = nameStr
        }
        else{
            if let firstNameStr = responseDict["firstName"] as? String, firstNameStr != ""{
                firstName = firstNameStr
            }
            else{
                if let adminDict = UserDefaults.standard.object(forKey: "adminUserResponse") as? [String: Any]{
                    firstName = "\(adminDict["first_name"] as? String ?? "")"
                }
            }
        }
        
        if let nameStr = UserDefaults.standard.value(forKey: "lname") as? String, nameStr != ""{
            lastName = nameStr
        }
        else{
            if let lastNameStr = responseDict["lastName"] as? String, lastNameStr != ""{
                lastName = lastNameStr
            }
            else{
                if let adminDict = UserDefaults.standard.object(forKey: "adminUserResponse") as? [String: Any]{
                    lastName = "\(adminDict["last_name"] as? String  ?? "")"
                }
            }
        }
        
        UserDefaults.standard.set(firstName, forKey: "fname")
        UserDefaults.standard.set(lastName, forKey: "lname")
    }
    @IBAction func myDetailEditButton_click(sender: UIButton){
        delegate?.changeframeForCell(editMode: true)
        WSUtility.sendTrackingEvent(events: "Other", categories: "Onboarding",actions:"Start Onboarding")

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
    func updateTextfeilds(isBool: Bool){
        if isBool{
            firstNameTextfield.isUserInteractionEnabled = true
            lastNameTextfield.isUserInteractionEnabled = true
            mobileTextfield.isUserInteractionEnabled = true
        }
        else{
            firstNameTextfield.isUserInteractionEnabled = false
            lastNameTextfield.isUserInteractionEnabled = false
            mobileTextfield.isUserInteractionEnabled = false
        }
    }
    func UISetUpForPhoneTextFieldWithImage(textField:UITextField ,boolValue: Bool)  {
        
        if boolValue == true {
            
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 50))
            let checkedImage: UIImageView = UIImageView()
            checkedImage.frame = CGRect(x: 0, y: 17.5, width: 15, height: 15)
            checkedImage.contentMode = .scaleAspectFit
            
            if textField.text!.isPhoneNumber{
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
extension WSMyDetailsTableViewCell: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case firstNameTextfield:
            lastNameTextfield.becomeFirstResponder()
        case lastNameTextfield:
            mobileTextfield.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    @IBAction func textDidchange(_ textField: UITextField){
        switch textField {
        case firstNameTextfield:
            UserDefaults.standard.set(firstNameTextfield.text, forKey: "fname")
            WSUtility.UISetUpForTextFieldWithImage(textField: firstNameTextfield, boolValue: true)
        case lastNameTextfield:
            UserDefaults.standard.set(lastNameTextfield.text, forKey: "lname")
            WSUtility.UISetUpForTextFieldWithImage(textField: lastNameTextfield, boolValue: true)
        case mobileTextfield:
            mobileNoStr = mobileTextfield.text!
            UserDefaults.standard.set(mobileTextfield.text, forKey: "mobileNo")
            WSUtility.UISetUpForTextFieldWithImage(textField: mobileTextfield, boolValue: true)
        default:
            break
        }
        UserDefaults.standard.set(firstNameTextfield.text! + " " + lastNameTextfield.text!, forKey: "fullname")
    }
}
