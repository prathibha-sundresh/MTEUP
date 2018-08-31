//
//  UFSGATracker.swift
//  yB2CApp
//
//  Created by Lakshminarayana on 08/01/18.
//

import UIKit

class UFSGATracker: NSObject {
    class func gaIntializer() {
        guard let gai = GAI.sharedInstance() else {
            //assert(false, "Google Analytics not configured correctly")
            return
        }
        
        var DevTrackingId = ""
        var ProTrackingId = ""
        
        if WSUtility.getCountryCode() == "DE" {
            DevTrackingId = "UA-119882344-1"
            ProTrackingId = "UA-120136171-2"
        } else if WSUtility.getCountryCode() == "AT" {
            DevTrackingId = "UA-112079493-1"
            ProTrackingId = "UA-120136171-1"
        } else if WSUtility.getCountryCode() == "CH" {
            DevTrackingId = "UA-119865651-1"
            ProTrackingId = "UA-46456303-18"
        } else if WSUtility.getCountryCode() == "TR" {
            DevTrackingId = "UA-119896739-1"
            ProTrackingId = "UA-61669244-3"
        }
        
        if WSConfigurationFile().getAppState() == "DEV" {//Development
            gai.tracker(withTrackingId: DevTrackingId)
        }
        else if WSConfigurationFile().getAppState() == "LIVE"{//Production
            gai.tracker(withTrackingId: ProTrackingId)
        }
        else{
            print("error")
        }
        
        //Production
        //gai.tracker(withTrackingId: "UA-112505322-1")
        
        
        gai.trackUncaughtExceptions = true // Optional : Automatically reports uncaught exception.
        
        //gai.logger.logLevel = .verbose; // Remove : Before app release
    }
    
    
    class func trackScreenViews(withScreenName:String!) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: withScreenName)
        
        guard UserDefaults.standard.value(forKey: "UFS_USER_Id") != nil else {
            return
        }
        
//        let email = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
        let userID = WSUtility.getValueFromUserDefault(key: "UFS_USER_Id")
        tracker.set(GAIFields.customDimension(for: 85), value: userID)
        
//        tracker.set(GAIFields.customDimension(for: 43), value: convertStringToMD5Hash(strValue:email))
        
        
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    class func trackProduct(withScreenName:String!, customDimensions:[String:String]) {
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        
        guard UserDefaults.standard.value(forKey: "UFS_USER_Id") != nil else {
            return
        }
        
        guard let builder = GAIDictionaryBuilder.createItem(withTransactionId: UserDefaults.standard.value(forKey: "UFS_USER_Id") as! String, name:customDimensions["Product_Name"], sku: customDimensions["Product_ID"], category: "App Product Views", price: 10, quantity: 2, currencyCode: "Euro") else {
            return
        }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    class func trackEvent(withCategory: String, action: String, label: String, value: NSNumber?) {
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
    
        guard UserDefaults.standard.value(forKey: "UFS_USER_Id") != nil else {
            return
        }
        tracker.set(kGAIUserId, value:UserDefaults.standard.value(forKey: "UFS_USER_Id") as! String)
        
        let email = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
        let userID = WSUtility.getValueFromUserDefault(key: "UFS_USER_Id")
        let hashEmailID = convertStringToMD5Hash(strValue: email)
        tracker.set(GAIFields.customDimension(for: 85), value: userID)
        tracker.set(GAIFields.customDimension(for: 43), value: hashEmailID)
        
        guard let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: withCategory, action: action, label: label, value: value).build() else { return }
        print("create event \(trackDictionary)")
        tracker.send(trackDictionary as! [AnyHashable:Any])
    }
    class func MD5(string: String) -> Data {
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData
    }
    class func convertStringToMD5Hash(strValue: String) -> String{
        let md5Data = MD5(string:strValue)
        
        let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
        print("md5Hex: \(md5Hex)")
        
        return md5Hex
        
        // if want md5Data to base64
        //        let md5Base64 = md5Data.base64EncodedString()
        //        print("md5Base64: \(md5Base64)")
    }
}


