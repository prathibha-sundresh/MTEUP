//
//  WSSoftLoginHandler.swift
//  UFS
//
//  Created by Guddu Gaurav on 09/08/2018.
//

import UIKit

class WSSoftLoginHandler: NSObject {

  func doSoftLogin(success:@escaping ()-> Void, failure:@escaping(_ failureMessage:String)-> Void )  {
    
  let email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
  let password = WSUtility.getValueFromUserDefault(key: USER_PASSWORD_KEY)
    
    let bussinessLayer = WSWebServiceBusinessLayer()
    bussinessLayer.retrieveLoginTokenForUsername(username: email_id, password: password, successResponse: { (response) in
      
      if let responseDict = response as? [String:Any], let sifuToken = responseDict["sifuToken"] as? String{
        UserDefaults.standard.set(sifuToken, forKey: SIFU_TOKEN_KEY)
      }
      
      self.getCartDetail(success: {
        success()
      }, failure: { (errorMessage) in
         failure("get cart")
      })
      
      
    }) { (errorMessage) in
      failure("login error")
    }
    
  }
  
  
  func getCartDetail(success:@escaping ()-> Void, failure:@escaping(_ failureMessage:String)-> Void )  {
    
    let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    businessLayer.getCartsForUserId(userId: "", params: ["":""], successResponse:{ (response) in
  
      success()
    }) { (errorMessage) in
      
      self.createCartForUSer(success: {
        success()
      }, failure: { (errorMessage) in
        failure("error in create cart")
      })
  
    }
    
  }
  
  func createCartForUSer(success:@escaping ()-> Void, failure:@escaping(_ failureMessage:String)-> Void )  {
    
    let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    businessLayer.createCartForUserId(userId: "", params: ["":""], successResponse:{ (response) in
      success()
      
    }) { (errorMessage) in
      failure("error in create cart")
    }
    
  }
  
  
}
