//
//  WSLoginVIewController.swift
//  yB2CApp
//
//  Created by Anandita on 11/9/17.
//

import UIKit
import Foundation

class WSLoginVIewController: UIViewController {
    
    @IBOutlet weak var passwordField: FloatLabelTextField!
    @IBOutlet weak var emailField: FloatLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        aplyDefaultStyle()
    }
    
    func aplyDefaultStyle(){
      
        passwordField.layer.cornerRadius = 5
        passwordField.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        passwordField.layer.borderWidth = 1
     
        emailField.layer.cornerRadius = 5
        emailField.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        emailField.layer.borderWidth = 1
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func loginBtnClicked(_ sender: Any) {
    }
    
    
}
