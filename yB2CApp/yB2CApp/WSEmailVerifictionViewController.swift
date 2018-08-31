//
//  WSEmailVerifictionViewController.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 22/12/2017.
//

import UIKit

class WSEmailVerifictionViewController: UIViewController {
  
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var instructionLbl: UILabel!
    @IBOutlet weak var emailConfirmationLabel: UILabel!
    @IBOutlet weak var resendBtn: UIButton!
    
  var emailId = ""
  var password = ""
  var userID = ""
  var confirmUrl = ""
  var isComeFromSignUpScreen = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    WSUtility.addNavigationBarBackButton(controller: self)
    UISetUp()
    getSifuAccessToken()
    
    if isComeFromSignUpScreen == true {
      triggerPushNotificationAfterRegistration()
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func backAction(_ sender: UIButton) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  func UISetUp()  {
    
    self.titleLbl.text = WSUtility.getlocalizedString(key: "Please verify your email", lang: WSUtility.getLanguage(), table: "Localizable")
    self.instructionLbl.text = WSUtility.getlocalizedString(key: "Please follow the instructions in the email to verify your address", lang: WSUtility.getLanguage(), table: "Localizable")
    let originalTextString = WSUtility.getlocalizedString(key: "An email has been sent to", lang: WSUtility.getLanguage(), table: "Localizable")! + " \n \(emailId)"
    resendBtn.setTitle(WSUtility.getlocalizedString(key: "Resend verification email", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    
    WSUtility.setAttributedLabel(originalText: originalTextString, attributedText: emailId, forLabel: emailConfirmationLabel, withFont: UIFont(name: "DINPro-Medium", size: 16.0)!, withColor: UIColor.black)
  }
  
  func triggerPushNotificationAfterRegistration()  {
//    let serviceBusinesslayer = WSWebServiceBusinessLayer()
//    serviceBusinesslayer.triggerAppInstalledPushNotification(action: "registration_completed")
  }
  
  func getSifuAccessToken()  {
    UFSProgressView.showWaitingDialog("")
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    // let emailID = UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)!
    //let password =  UserDefaults.standard.value(forKey: USER_PASSWORD_KEY)!
    let dictParameter = ["EmailId":emailId, "Password":password]
    
    serviceBussinessLayer.makeLoginRequest(parameter: dictParameter , methodName: Login_API_Method, successResponse: { (response) in
        
        UserDefaults.standard.setValue(self.emailId, forKey: LAST_AUTHENTICATED_USER_KEY)
      if self.isComeFromSignUpScreen  == true{
        self.getPendingLoyaltyPoints()
      }else{
        UFSProgressView.stopWaitingDialog()
      }
     
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
    }
  }
    
    func getPendingLoyaltyPoints() {
        let bussinessLayer:WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        bussinessLayer.getPendingLoyaltyPointsRequest(successResponse: {(response) in
            let loyaltyPointsDic = response["country_loyalty_points"] as! [String:Any]
            let loyaltyPoints = loyaltyPointsDic["points"] as! Int
            self.addLoyaltyPoints(Points: loyaltyPoints)
        }, faliureResponse: {(error) in
            
        })
    }
  
    func addLoyaltyPoints(Points: Int) {
    
    let loyaltyDict:[String:Any] = ["points":Points, "description":"Initiated"]
    
    let bussinessLayer:WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    
    bussinessLayer.addLoyaltyPointsRequest(parameter: loyaltyDict,successResponse: { (success) in
      print("loyalty points added successfully")
      UFSProgressView.stopWaitingDialog()
    }) { (error) in
      print("error response")
      UFSProgressView.stopWaitingDialog()
    }
  }
  
  @IBAction func resendVerificationMailAction(_ sender: UIButton) {
    if userID.isEmpty {
      getUserProfile()
    }else{
     resendVerificationAPICall(forUserID: userID)
    }
    
  }
  
  func getUserProfile()  {
    
    UFSProgressView.showWaitingDialog("")
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    
    serviceBussinessLayer.getBasicUserProfile(parameter: [String:Any](), methodName: GET_BASIC_PROFILE_API, successResponse: { (response) in
      
      if let userid = response["userId"] as? String{
        self.userID = userid
        self.resendVerificationAPICall(forUserID: userid)
      }else{
        UFSProgressView.stopWaitingDialog()
      }
      
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
    }
    
  }
  
  func resendVerificationAPICall(forUserID userID:String) {
    
    let languageCode = WSUtility.getLanguageCode()
    let countryCode = WSUtility.getCountryCode()
    
    let dict = ["confirmUrl":confirmUrl,"countryCode":countryCode,"id":userID,"languageCode":languageCode]
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.resendEmailConfirmationMail(parameterDict: dict, successResponse: { (response) in
      UFSProgressView.stopWaitingDialog()
      if let message = response["message"] as? String{
        /*
        if(message == "Confirmation mail successfully sent."){
            WSUtility.showAlertWith(message:WSUtility.getlocalizedString(key: "Confirmation mail successfully sent.", lang: WSUtility.getLanguage(), table: "Localizable")!, title: "", forController: self)
        }
 */
         WSUtility.showAlertWith(message:WSUtility.getlocalizedString(key: message, lang: WSUtility.getLanguage(), table: "Localizable")!, title: "", forController: self)
      }
     
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
    }
    
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
