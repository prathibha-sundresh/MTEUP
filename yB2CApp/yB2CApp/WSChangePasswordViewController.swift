//
//  WSChangePasswordViewController.swift
//  yB2CApp
//
//  Created by Anandita on 11/30/17.
//

import UIKit

class WSChangePasswordViewController: UIViewController {
    var isFromMenu = false

    @IBOutlet weak var savePasswordBtn: UIButton!
    @IBOutlet weak var changePasswordTextLabel: UILabel!
    @IBOutlet weak var newPasswordTxtField: UITextField!
    @IBOutlet weak var confirmPasswordTxtField: UITextField!
    @IBOutlet weak var passwordConfirmErrorImg: UIImageView!
    @IBOutlet weak var passwordErrorLbl: UILabel!
    @IBOutlet weak var passwordErrorImg: UIImageView!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var passwordNewErrorImg: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var passwordBtn: UIButton!
    @IBOutlet weak var newPasswordBtn: UIButton!
    @IBOutlet weak var confirmPasswordBtn: UIButton!
    var activeField:UITextField = UITextField()
    
    override func viewWillAppear(_ animated: Bool) {
        if !isFromMenu {
            self.navigationController?.popToRootViewController(animated: true)
        }
        else{
            isFromMenu = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appVersion = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }

            UFSGATracker.trackEvent(withCategory: "Changing password", action: "", label: "", value: nil)
        
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.trackingScreens(screenName: "Change Password Screen")
        UFSGATracker.trackScreenViews(withScreenName: "Change Password Screen")
        FireBaseTracker.ScreenNaming(screenName: "Change Password Screen", ScreenClass: String(describing: self))
        FBSDKAppEvents.logEvent("Change Password Screen")
        UISetUP()
//        confirmPasswordTxtField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
//        passwordTxtField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
//        newPasswordTxtField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        passwordTextFieldDidChange(textField)
    }
    
    func passwordTextFieldDidChange(_ textField: UITextField) {
        let texts = textField.text
        if textField == passwordTxtField{
            if textField.text == ""{
                passwordErrorImg.isHidden = false
                passwordErrorImg.image = UIImage(named:"error_icon")
                passwordTxtField.layer.borderColor = UIColor(red: 197.0/255.0, green:0.0/255.0, blue: 26.0/255.0, alpha: 1.0).cgColor
            }
            else{
                passwordErrorImg.isHidden = false
                passwordErrorImg.image = UIImage(named:"right_icon")
                passwordTxtField.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
            }
        }
        if(isPasswordValid(texts!)){
            if(textField.tag == 20){
                passwordErrorLbl.textColor = UIColor.black
                passwordConfirmErrorImg.isHidden = false
                passwordConfirmErrorImg.image = UIImage(named:"right_icon")
                confirmPasswordTxtField.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
            }
            else if(textField.tag == 30){
                passwordErrorLbl.textColor = UIColor.black
                passwordNewErrorImg.isHidden = false
                passwordNewErrorImg.image = UIImage(named:"right_icon")
                newPasswordTxtField.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
            }
        }else{
            if(textField.tag == 20){
                passwordErrorLbl.textColor = UIColor(red: 197.0/255.0, green:0.0/255.0, blue: 26.0/255.0, alpha: 1.0)
                passwordConfirmErrorImg.isHidden = false
                passwordConfirmErrorImg.image = UIImage(named:"error_icon")
                confirmPasswordTxtField.layer.borderColor = UIColor(red: 197.0/255.0, green: 0.0/255.0, blue: 26.0/255.0, alpha: 1.0).cgColor
            }
            if(textField.tag == 30){
                passwordErrorLbl.textColor = UIColor(red: 197.0/255.0, green:0.0/255.0, blue: 26.0/255.0, alpha: 1.0)
                passwordNewErrorImg.isHidden = false
                passwordNewErrorImg.image = UIImage(named:"error_icon")
                newPasswordTxtField.layer.borderColor = UIColor(red: 197.0/255.0, green: 0.0/255.0, blue: 26.0/255.0, alpha: 1.0).cgColor
            }
        }
    }
    
    @IBAction func showHidePassword(sender: UIButton){
        switch sender.tag {
            
        case 1000:
            if !passwordBtn.isSelected {
                passwordBtn.isSelected = true
                passwordTxtField.isSecureTextEntry = false
            }
            else{
                passwordBtn.isSelected = false
                passwordTxtField.isSecureTextEntry = true
            }
        case 1001:
            if !newPasswordBtn.isSelected {
                newPasswordBtn.isSelected = true
                newPasswordTxtField.isSecureTextEntry = false
            }
            else{
                newPasswordBtn.isSelected = false
                newPasswordTxtField.isSecureTextEntry = true
            }
        default:
            if !confirmPasswordBtn.isSelected {
                confirmPasswordBtn.isSelected = true
                confirmPasswordTxtField.isSecureTextEntry = false
            }
            else{
                confirmPasswordBtn.isSelected = false
                confirmPasswordTxtField.isSecureTextEntry = true
            }
        }
        
    }
    
    func isPasswordValid(_ password : String) -> Bool {
      
     
     // let passwordTest = NSPredicate(format:"SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#^()+-._])[A-Za-zäöüÄÖÜß\\d$@$!%*?&#^()+-._]{8,}")
      
      let passwordTest = NSPredicate(format:"SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[#%!$@^*()_.])[A-Za-z\\d#%!$@^*()_.]{8,}")
      
        return passwordTest.evaluate(with: password)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // @IBAction func savePasswordTapped(_ sender: Any) {
    
    //    if passwordTxtField.text == "" {
    //      WSUtility.showAlertWith(message: "Please choose a password.", title: "", forController: self)
    //    }
    //    else if newPasswordTxtField.text == ""{
    //      WSUtility.showAlertWith(message: "Please choose a password.", title: "", forController: self)
    //    }
    //    else if confirmPasswordTxtField.text == ""{
    //      WSUtility.showAlertWith(message: "Please confirm your password.", title: "", forController: self)
    //    }
    //<<<<<<< HEAD
    //    else if newPasswordTxtField.text != confirmPasswordTxtField.text{
    //      WSUtility.showAlertWith(message: "The passwords you entered do not match, please try again.", title: "", forController: self)
    //=======
  
    @IBAction func savePasswordTapped(_ sender: Any) {
        
        if passwordTxtField.text == "" {
            WSUtility.showAlertWith(message: WSUtility.getTranslatedString(forString: "Please enter a correct password"), title: "", forController: self)
        }
        else if newPasswordTxtField.text == ""{
            WSUtility.showAlertWith(message: WSUtility.getTranslatedString(forString: "Please enter a correct password"), title: "", forController: self)
        }
        else if confirmPasswordTxtField.text == ""{
            WSUtility.showAlertWith(message: WSUtility.getTranslatedString(forString: "Please confirm your password"), title: "", forController: self)
        }
        else if newPasswordTxtField.text != confirmPasswordTxtField.text{
            WSUtility.showAlertWith(message: "The passwords you entered do not match, please try again.", title: "", forController: self)
        }else if( newPasswordTxtField.text == confirmPasswordTxtField.text){
            self.confirmPasswordTxtField.resignFirstResponder()
            
            //save operation
            if(isPasswordValid(newPasswordTxtField.text!) && isPasswordValid(confirmPasswordTxtField.text!)){
                
                var requestDict: [String: Any] = [:]
                requestDict["currentPassword"] = passwordTxtField.text
                requestDict["newPassword"] = newPasswordTxtField.text
                requestDict["confirmPassword"] = confirmPasswordTxtField.text
                let firstName =  WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "FirstName"))
                let lastName =  WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "LastName"))
                requestDict["username"] = firstName + " " + lastName
                UFSProgressView.showWaitingDialog("")
                let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
                businessLayer.changePasswordAPI(parms: requestDict, successResponse: { (response) in
                    UFSProgressView.stopWaitingDialog()
                    
                    WSUtility.sendTrackingEvent(events: "Other", categories: "Changing password",actions:"")
                    FireBaseTracker .fireBaseTrackerWith(Events: "Other", Category: "Changing password")
                    var msg: String = ""
                    if let isSuccessFull = response["successful"] as? Bool{
                        if isSuccessFull{
                            msg = WSUtility.getlocalizedString(key:"Password Changed Successfully.", lang:WSUtility.getLanguage(), table: "Localizable")!
                        }
                        else{
                            msg = WSUtility.getlocalizedString(key:"Unfortunately, your password could not be changed, please try again later.", lang:WSUtility.getLanguage(), table: "Localizable")!
                        }
                    }
                    else{
                        msg = WSUtility.getlocalizedString(key:"Unfortunately, your password could not be changed, please try again later.", lang:WSUtility.getLanguage(), table: "Localizable")!
                    }
                    let alert  = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: WSUtility.getlocalizedString(key:"Ok", lang:WSUtility.getLanguage(), table: "Localizable")!, style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: true)
                        self.confirmPasswordTxtField.resignFirstResponder()
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }) { (errorMessage) in
                    UFSProgressView.stopWaitingDialog()
                    WSUtility.showAlertWith(message: WSUtility.getlocalizedString(key:"Unfortunately, your password could not be changed, please try again later.", lang:WSUtility.getLanguage(), table: "Localizable")!, title: "", forController: self)
                }
                
            }
            
        }
    }
    
    func keyboardWillShow(aNotification:Notification) {
        let info = aNotification.userInfo! as NSDictionary
        let kbSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, (kbSize?.height)!, 0.0)
        
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = view.frame
        aRect.size.height -= (kbSize?.height)!;
        if (!aRect.contains((activeField.frame.origin)) ) {
            self.scrollView.scrollRectToVisible((activeField.frame), animated: true)
        }
    }
    
    func keyboardWillBeHidden(aNotification:Notification)  {
        let  contentInsets = UIEdgeInsets.zero;
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
    }
    func UISetUP()  {
        WSUtility.addNavigationBarBackButton(controller: self)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        changePasswordTextLabel.text = WSUtility.getTranslatedString(forString: "Change Password")
        // passwordErrorLbl.text = WSUtility.getTranslatedString(forString: "Your password needs to be minimum 8 characters long and contain at least one of each: Upper Case, Lower Case, Number, Special character (e.g. !,%,+)")
        
        
        passwordTxtField.placeholder = WSUtility.getTranslatedString(forString: "Current password")
        newPasswordTxtField.placeholder = WSUtility.getTranslatedString(forString: "New password")
        confirmPasswordTxtField.placeholder = WSUtility.getTranslatedString(forString: "Confirm new password")
        addBorderColor(textfiled: passwordTxtField)
        addBorderColor(textfiled: newPasswordTxtField)
        addBorderColor(textfiled: confirmPasswordTxtField)
        
        savePasswordBtn.setTitle(WSUtility.getTranslatedString(forString: "Save new password"), for: .normal)
        
        setAttributedText(originalText: WSUtility.getTranslatedString(forString: "Your password needs to be minimum 8 characters long and contain at least one of each: Upper Case, Lower Case, Number, Special character (e.g. !,%,+)"))
    }
    func addBorderColor(textfiled: UITextField){
        textfiled.setLeftPaddingPoints(10)
        WSUtility.UISetUpForTextField(textField: textfiled, withBorderColor: unselectedTextFieldBorderColor)
    }
  
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setAttributedText(originalText:String) {
        
        let attributedString = NSMutableAttributedString(string: WSUtility.getTranslatedString(forString: "Your password needs to be minimum 8 characters long and contain at least one of each: Upper Case, Lower Case, Number, Special character (e.g. !,%,+)"), attributes: [
            NSFontAttributeName: UIFont(name: "DINPro-Regular", size: 12.0)!,
            NSForegroundColorAttributeName: UIColor(white: 51.0 / 255.0, alpha: 1.0)
            ])
        
        let text1 = WSUtility.getTranslatedString(forString: "minimum 8 characters")
        
        let range = attributedString.mutableString.range(of: text1, options: .caseInsensitive)
        if range.location != NSNotFound {
            
            attributedString.addAttributes([NSFontAttributeName: UIFont(name: "DINPro-Medium", size: 12.0)!], range: range)
        }
        
        let text2 = WSUtility.getTranslatedString(forString: "Upper Case, Lower Case, Number, Special character (e.g. !,%,+)")
        
        let range2 = attributedString.mutableString.range(of: text2, options: .caseInsensitive)
        if range2.location != NSNotFound {
            
            attributedString.addAttributes([NSFontAttributeName: UIFont(name: "DINPro-Medium", size: 12.0)!], range: range2)
        }
        
        passwordErrorLbl.attributedText = attributedString
      
    }
    
}
extension WSChangePasswordViewController:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case passwordTxtField:
            newPasswordTxtField.becomeFirstResponder()
        case newPasswordTxtField:
            confirmPasswordTxtField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

