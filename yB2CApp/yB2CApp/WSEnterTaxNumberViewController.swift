//
//  EnterTaxNumberViewController.swift
//  UFS
//
//  Created by Guddu Gaurav on 17/05/2018.
//

import UIKit

class WSEnterTaxNumberViewController: UIViewController {
  @IBOutlet weak var vwBase: UIView!
  @IBOutlet weak var lblHdr: UILabel!
  @IBOutlet weak var btnClose: UIButton!
  @IBOutlet weak var tfBusTaxNum: FloatLabelTextField!
  @IBOutlet weak var btnLater: UIButton!
  @IBOutlet weak var saveBtn: UIButton!
  @IBOutlet weak var tfTradePartner: UITextField!
  @IBOutlet weak var tradePartnerViewH: NSLayoutConstraint!
  @IBOutlet weak var mainViewVerticalY: NSLayoutConstraint!
  
  var pickerTradeData: [String] = [String]()
  var selectedTradePartne = ""
  var callBack: (() -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    /*
    if let vendorDict = UserDefaults.standard.value(forKey: "vendor") as? [String : Any]{
      
//      if vendorDict.count > 0{
//        if let code = vendorDict["code"], "\(code)" != ""{
//          tradePartnerViewH.constant = 0
//        }
//        else{
//          tradePartnerViewH.constant = 48
//          getUserTradePartnerProfile()
//        }
//      }
        tradePartnerViewH.constant = 0
    }
    */
    
     tradePartnerViewH.constant = 0
    
    addBorderColor(textfiled: tfBusTaxNum)
    tfBusTaxNum.layer.borderWidth = 1.0
    tfBusTaxNum.layer.cornerRadius = 5
    
    addBorderColor(textfiled: tfTradePartner)
    tfTradePartner.layer.borderWidth = 1.0
    tfTradePartner.layer.cornerRadius = 5
    
    btnLater.layer.borderWidth = 1.0
    btnLater.layer.borderColor = unselectedTextFieldBorderColor
    btnLater.layer.cornerRadius = 5
    
    
    tfTradePartner.text = selectedTradePartne
    lblHdr.text = WSUtility.getlocalizedString(key: "Complete your details to get your prices", lang: WSUtility.getLanguage())
    self.textDidchange(tfBusTaxNum)
  }
  
  func addBorderColor(textfiled: UITextField){
    textfiled.setLeftPaddingPoints(10)
    WSUtility.UISetUpForTextField(textField: textfiled, withBorderColor: unselectedTextFieldBorderColor)
  }
  
  @IBAction func btnTradePartnerTapped(_ sender: Any) {
    self.view.endEditing(true)
    //        if pickerTradeData.count > 0{
    performSegue(withIdentifier: "showTradePartnerSegue", sender: sender)
    //        }
  }
  @IBAction func btnSaveTapped(_ sender: Any) {
    
        if tfBusTaxNum.text != ""{
            UFSProgressView.showWaitingDialog("")
        
            let user:WSUser = WSUser().getUserProfile()
            let addressDict:[String : Any] = user.defaultAddress
            
            var operatorBusinessNameStr: String = ""
            
            if let businessName = addressDict["operatorBusinessName"] as? String, businessName != ""{
                operatorBusinessNameStr =  businessName
            }
            else{
                operatorBusinessNameStr =  user.businessname
            }
            let bodyparams:[String: Any] = ["firstName": user.firstName,
                                            "lastName": user.lastName,
                                            "name": "\(user.firstName) \(user.lastName)",
                                            "uid": user.emailId,
                                            "businessType": ["businessCode": user.businessCode],
                                            "defaultAddress":user.defaultAddress,
                                            "operatorBusinessName": operatorBusinessNameStr,
                                            "titleCode": "ms",
                                            "taxNumber":self.tfBusTaxNum.text!]
            WSWebServiceBusinessLayer().updateUserProfileToHybrisForTurkey(parameter: bodyparams, successResponse: { (response) in
                UFSProgressView.stopWaitingDialog()
                self.getUserProfileFromHybrisFor_TR()
                
            }) { (errorMessage) in
                UFSProgressView.stopWaitingDialog()
                WSUtility.showAlertWith(message: errorMessage, title: WSUtility.getlocalizedString(key: "Error", lang: WSUtility.getLanguage())!, forController: self)
            }
        }
    }
    func getUserProfileFromHybrisFor_TR()  {
        
        UFSProgressView.showWaitingDialog("")
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        
        serviceBussinessLayer.getBasicUserProfileFromHybrisForTurkey(parameter: [String:Any](), methodName: GET_PROFILE_API_HYBRIS_TR, successResponse: { (response) in
            
            UFSProgressView.stopWaitingDialog()
            if let businessType = response["businessType"] as? [String : Any]{
                UserDefaults.standard.set(businessType, forKey: "businessType")
            }
            
            if let array = response["myProfileVendorsList"] as? [[String : Any]]{
                UserDefaults.standard.set(array, forKey: "myProfileVendorsList")
            }
            
            if let taxNo = response["taxNumber"]{
                UserDefaults.standard.setValue("\(taxNo)", forKey: TAX_NUMBER_KEY)
            }
            
            if let vendorList = response["vendor"] as? [[String : Any]]{
                if vendorList.count > 0{
                    UserDefaults.standard.set(vendorList[0], forKey: "vendor")
                    
                    let objVendor = vendorList[0]
                    let tradePartnerName = objVendor["name"] as? String
                    let tradePartnerID = "\(objVendor["code"] ?? "")"
                    UserDefaults.standard.setValue(tradePartnerName, forKey: TRADE_PARTNER_NAME)
                    UserDefaults.standard.setValue(tradePartnerID, forKey: TRADE_PARTNER_ID)
                }
            }
            
            if let defaultAddress = response["defaultAddress"] as? [String : Any]{
                
                var tmpDict: [String: Any] = defaultAddress
                tmpDict["operatorBusinessName"] = "\(response["operatorBusinessName"] as? String ?? "")"
                UserDefaults.standard.set(tmpDict, forKey: "defaultAddress")
                
                if let mobileNo = response["phone"] as? String{
                    UserDefaults.standard.set(mobileNo, forKey: "mobileNo")
                }
                
                if let zipCode = response["postalCode"] as? String{
                    UserDefaults.standard.set("\(zipCode)", forKey: USER_ZIP_CODE)
                }
            }

            let userID = "\(response["customerId"]!)"
            UserDefaults.standard.set(userID, forKey: "UFS_USER_Id")
            
            if let userGroup = response["userGroup"] as? String{
                UserDefaults.standard.set(userGroup, forKey: USER_GROUP)
            }
            if let arrVendors = response["vendor"] as? [[String:Any]], arrVendors.count > 0{
                
                let objVendor = arrVendors[0]
                let tradePartnerName = objVendor["name"] as? String
                let tradePartnerID = "\(objVendor["code"] ?? "")"
                UserDefaults.standard.setValue(tradePartnerName, forKey: TRADE_PARTNER_NAME)
                UserDefaults.standard.setValue(tradePartnerID, forKey: TRADE_PARTNER_ID)
                
            }
            
            if let callBackBlock = self.callBack {
                callBackBlock()
            }
            
            self.dismiss(animated: false, completion: nil)
        }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
      self.dismiss(animated: false, completion: nil)
    }
    
  }
  @IBAction func btnCloseTapped(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  func trade_request() {
    
    UFSProgressView.showWaitingDialog("")
    let myTradePartnerId = WSUtility.getValueFromUserDefault(key: TRADE_PARTNER_ID)
    let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    businessLayer.getTradePartenersList(successResponse: { (response) in
      if let trades = response as? [[String: Any]]{
        self.pickerTradeData.removeAll()
        //                var isTradePartnerIdMatched = false
        //                var myTradePartnerName = ""
        for tDict in trades {
          // print(tDict)
          let tName = tDict["name"] as? String
          let tId = tDict["id"]
          self.pickerTradeData.append(tName!)
          
          //                    if Int(myTradePartnerId) == (tId as! Int) {
          //                        isTradePartnerIdMatched = true
          //                        myTradePartnerName = tName!
          //                    }
        }
      }
      
      UFSProgressView.stopWaitingDialog()
      
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
    }
    
  }
  
  func getUserTradePartnerProfile()  {
    
    UFSProgressView.showWaitingDialog("")
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.getUserProfile(parameter: [String:Any](), methodName: GET_PROFILE_API, successResponse: { (response) in
      self.trade_request()
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
      self.trade_request()
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is UFSPopUpViewController {
      let popUpVC = segue.destination as! UFSPopUpViewController
      popUpVC.titleString = "Select tradepartner"
      popUpVC.isSearchBarHidden = true //(sender as! UITextField) == workInTextField ? true : false
      
      popUpVC.arrayItems = pickerTradeData
      popUpVC.selectedItem = selectedTradePartne
      
      popUpVC.callBack = { selectedItemValue in
        
        self.tfTradePartner.text = selectedItemValue
        
      }
      
    }
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    tfBusTaxNum.resignFirstResponder()
    mainViewVerticalY.constant = 0
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

extension WSEnterTaxNumberViewController: UITextFieldDelegate{
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if self.view.frame.width == 320{
      mainViewVerticalY.constant = -70
    }
  }
  
  @IBAction func textDidchange(_ textField: UITextField){
    if tfBusTaxNum.text == ""{
      saveBtn.isEnabled = false
      saveBtn.alpha = 0.5
    }
    else{
      saveBtn.isEnabled = true
      saveBtn.alpha = 1.0
    }
  }
}
