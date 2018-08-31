//
//  WSIBANRequestModel.swift
//  UFSDev
//
//  Created by Guddu Gaurav on 06/07/2018.
//

import UIKit

class WSIBANRequestModel: NSObject {
  
  func creatRequestModelForIBAN(IBANDictInfo:[String:Any]) -> [String:Any] {
    
    let IBANDict = IBANDictInfo["PaymentDetail"] as? [String:Any]
    
    var activeVal = true
    if let tempActive = IBANDict!["active"] {
      if "\(tempActive)" == "0"{
        activeVal = false
      }
    }
   
    let ibanRequestDict:[String:Any] = [

      "accountNumber": "\(IBANDict?["accountNumber"] ?? "")",
        "active": activeVal,
        "bankIdentifier": "\(IBANDict?["bankIdentifier"] ?? "")",
        "bban": "bban",
        "ibanCheckDigits": "\(IBANDict?["ibanCheckDigits"] ?? "")",
        "isoCountryCode": "\(IBANDict?["isoCountryCode"] ?? "")",
        "name": "\(IBANDict?["name"] ?? "")",
        "reservedField": "\(IBANDict?["reservedField"] ?? "")",
        "sepaMember": "\(IBANDict?["sepaMember"] ?? "")"
     
    ]
    

  return ibanRequestDict


}

}
