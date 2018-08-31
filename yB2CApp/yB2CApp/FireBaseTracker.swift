//
//  FireBaseTracker.swift
//  yB2CApp
//
//  Created by Prathibha Sundresh on 2/23/18.
//

import Foundation
import FirebaseCore


class FireBaseTracker:NSObject {
    
    class func firebaseTrackerConfig() {
        var firebasePlistFileName = ""
        
      var dict = WSUtility.getBaseUrlDictFromUserDefault()
      
      if "\(dict["app_is_live"] ?? "0")" == "1" { //Production
        firebasePlistFileName = Bundle.main.path(forResource: "GoogleService-Info-UFSProd", ofType: "plist")!
      }else{
        firebasePlistFileName = Bundle.main.path(forResource: "GoogleService-Info-UFSdev", ofType: "plist")!
      }
        
        
        //print("Firebase plist path : \(String(describing: firebasePlistFileName))")
        guard let firOptions = FIROptions(contentsOfFile: firebasePlistFileName) else {
            assert(false, "Failed to load Firebase config file")
            return
        }

        FIRApp.configure(with: firOptions)
        
    }
    
    class func fireBaseTrackerWith(Events:String, Category:String, Action:String, Label:String) {
        let countryName = WSUtility.getCountryName()
        FIRAnalytics.logEvent(withName: ANALYTICS_DATA, parameters: [EVENTS:Events,CATEGORIES:Category,ACTION:Action, LABEL:Label])
        FIRAnalytics.setUserPropertyString(countryName, forName: FIREBASE_USERID)
    }
    
    class func fireBaseTrackerWith(Events:String, Category:String) {
        let countryName = WSUtility.getCountryName()
        FIRAnalytics.logEvent(withName: ANALYTICS_DATA, parameters: [EVENTS:Events,CATEGORIES:Category])
        FIRAnalytics.setUserPropertyString(countryName, forName: FIREBASE_USERID)
    }
    
    class func fireBaseTrackerWith(Events:String, Category:String, Action:String) {
        let countryName = WSUtility.getCountryName()
        FIRAnalytics.logEvent(withName: ANALYTICS_DATA, parameters:[EVENTS:Events,CATEGORIES:Category,ACTION:Action])
        FIRAnalytics.setUserPropertyString(countryName, forName: FIREBASE_USERID)
    }

    class func fireBaseTrackingWith(Events:String, params:[String:Any]) {
        let countryName = WSUtility.getCountryName()
        FIRAnalytics.logEvent(withName: Events, parameters:params)
        FIRAnalytics.setUserPropertyString(countryName, forName: FIREBASE_USERID)
    }
    
    class func ScreenNaming(screenName:String, ScreenClass:String) {
        let countryName = WSUtility.getCountryName()
        FIRAnalytics.setScreenName(screenName, screenClass: ScreenClass)
        FIRAnalytics.setUserPropertyString(countryName, forName: FIREBASE_USERID)
    }
}
