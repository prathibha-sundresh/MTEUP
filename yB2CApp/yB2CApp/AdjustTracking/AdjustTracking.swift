//
//  AdjustTracking.swift
//  UFS
//
//  Created by Prathibha Sundresh on 06/08/18.
//

import Foundation
import Adjust


class AdjustTracking : NSObject {
    static var deviceToken : Data?
    class func EventTracking(token:String) {
        let event = ADJEvent.init(eventToken: token)
        Adjust.trackEvent(event)
    }
    class func configureAdjustForTurkey(){
        
        if WSUtility.getCountryCode() == "TR" {
            let appDelegate = UIApplication.shared.delegate as! HYBAppDelegate
            if appDelegate.adjustConfig == nil {
                appDelegate.adjustTrackingSetup()
            }
        }
    }
    
    class func setTokenToAdjust(){
        // For adjust push token only for turkey & first installation
        if UserDefaults.standard.bool(forKey: "FirstInstallation"){
            if let token = deviceToken {
                Adjust.setDeviceToken(token)
                UserDefaults.standard.set(false, forKey: "FirstInstallation")
            }
        }
    }
}

