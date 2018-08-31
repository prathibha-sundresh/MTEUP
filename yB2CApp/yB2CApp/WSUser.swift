//
//  WSUser.swift
//  UFSDev
//
//  Created by Guddu Gaurav on 06/07/2018.
//

import UIKit

class WSUser: NSObject {
  var emailId = ""
  var firstName = ""
  var lastName = ""
  var userGroup = ""
  var tradePartner = ""
  var tradePartnerId = ""
  var mobileNumber = ""
  var postalCode = ""
  var UserId = ""
  var businessCode = ""
  var businessname = ""
  var taxNumber = ""
  var tradePartnerCity = ""
  var defaultAddress: [String: Any] = [:]
  var isPaymentByCreditCard = false
  
  struct UserGroupType {
    let DTBO = "dtbogroup"
    let DTT = "dttgroup"
    let DTI = "dtigroup"
  }
  
  func getUserProfile() -> WSUser {
    
    let user = WSUser()
    user.emailId = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    user.firstName = WSUtility.getValueFromUserDefault(key: "FirstName")
    user.lastName = WSUtility.getValueFromUserDefault(key: "LastName")
    user.userGroup = WSUtility.getValueFromUserDefault(key: USER_GROUP)
    user.mobileNumber = WSUtility.getValueFromUserDefault(key: "mobileNo")
    user.postalCode = WSUtility.getValueFromUserDefault(key: USER_ZIP_CODE)
    user.UserId = WSUtility.getValueFromUserDefault(key: "UFS_USER_Id")
    user.taxNumber = WSUtility.getValueFromUserDefault(key: TAX_NUMBER_KEY)
    if let dict = UserDefaults.standard.object(forKey: "businessType") as? [String: Any]{
        user.businessCode = "\(dict["businessCode"] ?? "")"
        user.businessname = "\(dict["businessName"] ?? "")"
    }
    if let dict = UserDefaults.standard.object(forKey: "defaultAddress") as? [String: Any]{
        user.defaultAddress = dict
    }
    
//    if let objVendor = UserDefaults.standard.object(forKey: "vendor") as? [String: Any]{
//        let tradePartnerName = objVendor["name"] as? String
//        let tradePartnerID = "\(objVendor["code"] ?? "")"
//        UserDefaults.standard.setValue(tradePartnerName, forKey: TRADE_PARTNER_NAME)
//        UserDefaults.standard.setValue(tradePartnerID, forKey: TRADE_PARTNER_ID)
//
//    }
    
    if let array = UserDefaults.standard.object(forKey: "myProfileVendorsList") as? [[String: Any]], array.count > 0{
        let tpPredicate = NSPredicate(format: "isDefault = true")
        let filterArray = array.filter { tpPredicate.evaluate(with: $0) }
        if filterArray.count > 0{
            let dict = filterArray[0]
            if let objVendor = dict["assignedVendor"] as? [String: Any]{
                let tradePartnerName = objVendor["name"] as? String
                let tradePartnerID = "\(objVendor["code"] ?? "")"
                UserDefaults.standard.setValue(tradePartnerName, forKey: TRADE_PARTNER_NAME)
                UserDefaults.standard.setValue(tradePartnerID, forKey: TRADE_PARTNER_ID)
            }
            if let locationDict = dict["assignedVendorAddress"] as? [String: Any]{
                user.tradePartnerCity = "\(locationDict["town"] ?? "")"
            }
        }
    }
    else{
        if let objVendor = UserDefaults.standard.object(forKey: "vendor") as? [String: Any]{
            
            let tradePartnerName = objVendor["name"] as? String
            let tradePartnerID = "\(objVendor["code"] ?? "")"
            UserDefaults.standard.setValue(tradePartnerName, forKey: TRADE_PARTNER_NAME)
            UserDefaults.standard.setValue(tradePartnerID, forKey: TRADE_PARTNER_ID)
            
            if let array = objVendor["vendorAddress"] as? [[String: Any]], array.count > 0{
                let locationDict = array[0]
                user.tradePartnerCity = "\(locationDict["town"] ?? "")"
            }
        }
    }
    user.tradePartner = WSUtility.getValueFromUserDefault(key: TRADE_PARTNER_NAME)
    user.tradePartnerId = WSUtility.getValueFromUserDefault(key: TRADE_PARTNER_ID)
    
    if let value = UserDefaults.standard.value(forKey: ISPAYMENT_BY_CREDITCARD_KEY) as? Bool{
      user.isPaymentByCreditCard = value
    }
    
    return user
  }
    
    func removeObjectsFromUserDefaults(){
        UserDefaults.standard.removeObject(forKey: "vendor")
        UserDefaults.standard.removeObject(forKey: "defaultAddress")
        UserDefaults.standard.removeObject(forKey: "businessType")
        UserDefaults.standard.removeObject(forKey: "myProfileVendorsList")
        UserDefaults.standard.removeObject(forKey: USER_GROUP)
        UserDefaults.standard.removeObject(forKey: TAX_NUMBER_KEY)
        UserDefaults.standard.removeObject(forKey: USER_ZIP_CODE)
        UserDefaults.standard.removeObject(forKey: USER_GROUP)
        UserDefaults.standard.removeObject(forKey: ISMOQREQUIRED_KEY)
        UserDefaults.standard.removeObject(forKey: ISPAYMENT_BY_CREDITCARD_KEY)
        
    }
}
