//
//  WSloginView.swift
//  yB2CApp
//
//  Created by Ramakrishna on 10/5/17.
//

import UIKit

@objc class WSloginView: UIView {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    var activeField:UITextField = UITextField()
    @IBOutlet weak var scrollView: UIScrollView!
    class func loadnib() ->WSloginView{
        return UINib(nibName: "WSloginView", bundle: nil).instantiate(withOwner: nil , options: nil)[0] as! WSloginView
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  @IBAction func tapOnLoginView(_ sender: UITapGestureRecognizer) {
    activeField.resignFirstResponder()
  }
    func setUI() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
  
    func keyboardWillShow(aNotification:Notification) {
        let info = aNotification.userInfo! as NSDictionary
        let kbSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, (kbSize?.height)!, 0.0)
        
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.frame
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
    
}
extension WSloginView:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
