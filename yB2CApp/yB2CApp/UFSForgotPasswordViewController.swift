//
//  UFSForgotPasswordViewController.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 23/06/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit


@objc class UFSForgotPasswordViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var topSpaceContinueButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightImageTextField: UIImageView!
    @IBOutlet weak var forgotYourPasswordLabel: UILabel!{
        didSet{
            forgotYourPasswordLabel.numberOfLines = 0
            forgotYourPasswordLabel.sizeToFit()
        }
    }
    @IBOutlet weak var noWorriesLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var indicatesRequiredLabel: UILabel!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sentEmailLabel: UILabel!
    @IBOutlet weak var errorMessageEmailLabel: UILabel!
    @IBOutlet weak var containigResetPasswordLabel: UILabel!
    @IBOutlet weak var forgotPasswordEmailTextField: UITextField!
    @IBOutlet weak var sentEmailView: UIView!
    @IBOutlet weak var boxEmailLabel: UILabel!
    
    @IBOutlet weak var sentEmailViewY: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    var IsUserNotThereInSifu: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
      
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
        forgotPasswordEmailTextField.setLeftPaddingPoints(10)
        sentEmailView.isHidden = true
        errorMessageEmailLabel.isHidden = true
        forgotPasswordEmailTextField.layer.cornerRadius = 5
        forgotPasswordEmailTextField.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        forgotPasswordEmailTextField.layer.borderWidth = 1
        if forgotPasswordEmailTextField.text == "" {
            resetPasswordButton.alpha = 0.5
        }
      
      WSUtility.addNavigationBarBackButton(controller: self)
    }
    @objc func keyboardWillShow(aNotification:Notification) {
        let info = aNotification.userInfo! as NSDictionary
        let kbSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, (kbSize?.height)!, 0.0)
        
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = view.frame
        aRect.size.height -= (kbSize?.height)!;
        
    }
    
    @objc func keyboardWillBeHidden(aNotification:Notification)  {
        let  contentInsets = UIEdgeInsets.zero;
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
    }
    override func viewWillAppear(_ animated: Bool) {
       
        forgotYourPasswordLabel.text = WSUtility.getlocalizedString(key: "Oops, you forgot your password?", lang: WSUtility.getLanguage(), table: "Localizable")
        emailLabel.text = WSUtility.getlocalizedString(key:"Enter your email", lang: WSUtility.getLanguage(), table: "Localizable")
        sentEmailLabel.text = WSUtility.getlocalizedString(key: "We have sent an email to", lang: WSUtility.getLanguage(), table: "Localizable")
        containigResetPasswordLabel.text = WSUtility.getlocalizedString(key: "Please follow the instructions in the email to verify your address", lang: WSUtility.getLanguage(), table: "Localizable")
        errorMessageEmailLabel.text = WSUtility.getlocalizedString(key: "Please enter a correct email address", lang: WSUtility.getLanguage(), table: "Localizable")
        backButton.setTitle(WSUtility.getlocalizedString(key:"Back", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        continueButton.setTitle(WSUtility.getlocalizedString(key:"Continue", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
     resetPasswordButton.setTitle(WSUtility.getlocalizedString(key:"Continue", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
      resetPasswordButton.setTitle(WSUtility.getlocalizedString(key:"Continue", lang: WSUtility.getLanguage(), table: "Localizable"), for: .disabled)
     

       forgotPasswordEmailTextField.placeholder = WSUtility.getlocalizedString(key:"Email", lang: WSUtility.getLanguage(), table: "Localizable")
       continueButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
       // token_request()
    }
  
  @IBAction func backAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        forgotPasswordEmailTextField.resignFirstResponder()
    }
    
    @IBAction func textDidChage(textField: UITextField){
        errorMessageEmailLabel.isHidden = true
        if forgotPasswordEmailTextField.text != "" {
            resetPasswordButton.alpha = 1.0
            if !isValidEmail(testStr : forgotPasswordEmailTextField.text!) || IsUserNotThereInSifu {
                rightImageTextField.isHidden = false
                rightImageTextField.image = UIImage(named: "error_cross.png")!
                
                forgotPasswordEmailTextField.layer.cornerRadius = 5
                forgotPasswordEmailTextField.layer.borderColor = UIColor(red: 197.0/255.0, green: 0.0/255.0, blue: 26.0/255.0, alpha: 1.0).cgColor
                forgotPasswordEmailTextField.layer.borderWidth = 1
                errorMessageEmailLabel.isHidden = false
               // topSpaceContinueButtonConstraint.constant = 170
                resetPasswordButton.isEnabled = false
            }
            else{
                rightImageTextField.image = UIImage(named: "checked_Icon.png")!
                 forgotPasswordEmailTextField.layer.borderColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
                resetPasswordButton.isEnabled = true
                rightImageTextField.isHidden = false
            }
        }
        if forgotPasswordEmailTextField.text == "" {
            resetPasswordButton.alpha = 0.5
             forgotPasswordEmailTextField.layer.borderColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
            rightImageTextField.isHidden = true
            resetPasswordButton.isEnabled = false
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
 
    

    @IBAction func resetPassword(_ sender: Any) {
        guard let emailString = forgotPasswordEmailTextField.text,forgotPasswordEmailTextField.text != "" else {
            errorMessageEmailLabel.isHidden = false
            return
        }
        if isValidEmail(testStr : emailString) {
            boxEmailLabel.text = emailString
        }
        else{
            self.textDidChage(textField: forgotPasswordEmailTextField)
            return
        }
        IsUserNotThereInSifu = false
        UFSProgressView.showWaitingDialog("")
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.makeForgotPasswordRequest(emailID: emailString, methodName: Forgot_API, successResponse: { (response) in
            UFSProgressView.stopWaitingDialog()
          /*
            let alert = UIAlertController(title: "", message: WSUtility.getlocalizedString(key: "Email not registered!", lang: WSUtility.getLanguage(), table: "Localizable"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .`default`, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
 */
            //print("Problems during the forgot password: \(error!.localizedDescription)")
          
          self.sentEmailView.isHidden = false
          self.containerView.isHidden = true
          //self.topSpaceContinueButtonConstraint.constant = 285
          self.continueButton.isHidden = false
          self.resetPasswordButton.isHidden = true
          
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
            self.IsUserNotThereInSifu = true
            self.textDidChage(textField: self.forgotPasswordEmailTextField)
            self.resetPasswordButton.isEnabled = true
            self.IsUserNotThereInSifu = false
          //WSUtility.showAlertWith(message: errorMessage, title: "", forController: self)
          
          
        }
        
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
       // self.dismiss(animated: true, completion: nil)
       self.navigationController?.popViewController(animated: true)
    }
}

extension UFSForgotPasswordViewController: URLSessionDelegate{
  
  func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
  }
}

extension UFSForgotPasswordViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
extension UFSForgotPasswordViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardView))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboardView() {
        self.view.endEditing(true)
    }
}
