//
//  UFSWebServiceHandler.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 03/11/17.
//

import UIKit
import Alamofire


@objc class UFSWebServiceHandler: NSObject {
  
    private static var manager: Alamofire.SessionManager = {
        
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "https://stage-api.ufs.com": .disableEvaluation,"https://52.19.87.124:9002": .disableEvaluation,
            "https://52.31.80.240:51002":.disableEvaluation
        ]
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManagerForDevelop()
        )
        
        return manager
    }()
    
    private class ServerTrustPolicyManagerForDevelop: ServerTrustPolicyManager {
        
        init() {
            super.init(policies: [:])
        }
        
        override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
            return .disableEvaluation
        }
    }
    
    func forgotPasswordRequest(email:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
        
        
    }
    
    func POSTRequest(dictParameter:[String:Any], methodName:String, header:HTTPHeaders?, requestURL:String,success:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: dictParameter, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:Any] {
                
                var requestHeader = header
                if header == nil {
                    requestHeader = ["x-api-key": WSConfigurationFile().getSIFUPublicAPIKey()]
                }
                else{
                    if(methodName != "UpdateDTOProfileHybrisAPI"){
                        requestHeader!["x-api-key"] = WSConfigurationFile().getSIFUPublicAPIKey()
                    }
                }
                
                UFSWebServiceHandler.manager.request("\(requestURL)", method: .post, parameters: dictFromJSON, encoding: JSONEncoding.default, headers: requestHeader)
                    .responseJSON { response in
                        print(response.request as Any)  // original URL request
                        //print(response.response as Any) // URL response
                        print(response.result.value as Any)   // result of response serialization
                        
                        if (response.response?.statusCode == 400) && (methodName == CREATE_VENDOR){
                            
                            if let errorMessage = response.result.value as? [String:Any]{
                                let message = errorMessage["errors"] as! [[String:Any]]
                                if message.count > 0{
                                    if let actualErrorMessage = message[0]["message"] {
                                        faliure(actualErrorMessage as! String)
                                        return
                                    }
                                    else{
                                        faliure("NullPointerError")
                                        return
                                    }
                                }
                            }
                            
                        }
                        else if (methodName == CREATE_UPDATE_MAKE_DEFALUT_TRADEPARTNER_API ){
                            success("Success" as AnyObject)
                            return
                        }else if methodName == PLACE_ORDER && response.response?.statusCode == 409 {
                           // faliure("Please enter a valid card detail.")
                          
                          if let errorDictResponse  = response.result.value as? [String:Any], let errorDict = errorDictResponse["error"] as? [String:Any], let errorMsg = errorDict["errorMessage"] as? String  {
                            faliure (errorMsg)
                            return
                          }
                          
                          return faliure (WSUtility.getlocalizedString(key: "Error while placing order", lang: WSUtility.getLanguage())!)
                        }
                        else if methodName == SIGN_UP   {
                            var dictResponse = [String:Any]()
                            if response.response?.statusCode == 201{
                                dictResponse["StatusCode"] = 201
                                dictResponse["MessageType"] = "Registration Successful"
                                
                            }else{
                                if let statusCode = response.response?.statusCode{
                                    dictResponse["StatusCode"] = statusCode
                                    if let _  = response.result.value {
                                        dictResponse["MessageType"] = response.result.value
                                    }
                                    
                                }
                            }
                            success(dictResponse as AnyObject)
                        }else if (response.response?.statusCode == 200 || response.response?.statusCode == 201 || response.response?.statusCode == 202) {
                            // status code = 202 for forgot password
                            if let _  = response.result.value {
                                success((response.result.value)! as AnyObject)
                                return
                            }else if methodName == GET_PROFILE_API_HYBRIS_TR{
                                success("success" as AnyObject)
                                return
                            }
                            else{
                                faliure(WSUtility.getlocalizedString(key: "No data found", lang: WSUtility.getLanguage())!)
                                return
                            }
                            
                        }else if (response.response?.statusCode == 400) && (methodName == ADD_TO_CART){
                            if let errorMessage = response.result.value as? [String:Any]{
                                let message = errorMessage["errors"] as! [[String:Any]]
                                if message.count > 0{
                                    if let actualErrorMessage = message[0]["message"] {
                                        faliure(actualErrorMessage as! String)
                                        return
                                    }else{
                                        faliure(message[0]["type"] as! String)
                                        return
                                    }
                                    
                                }
                            }
                        }
                        else if (response.response?.statusCode != 200) && (methodName == CHANGE_PASSWORD_API){
                            if let errorMessage = response.result.value as? [String:Any]{
                                faliure(errorMessage["message"] as! String)
                                return
                            }
                        }else if (response.response?.statusCode != 200) && ((methodName == Forgot_API) || (methodName == GET_PROFILE_API_HYBRIS_TR)) {
                            faliure(self.getHybrisErrorMessage(response: response.result.value as? [String : Any]))
                        }
                        else{
                            faliure(WSUtility.getlocalizedString(key: "server error", lang: WSUtility.getLanguage())!)
                            return
                        }
                        
                        
                }
                
            }
        } catch {
            print(error.localizedDescription)
            faliure(error as! String)
        }
        
    }
  
  func getHybrisErrorMessage(response:[String:Any]?) -> String {
    if let errorMessageDict = response, let errorDict = errorMessageDict["errors"] as? [[String:Any]],errorDict.count > 0,let errorMessage = errorDict[0]["message"] as? String {
      return errorMessage
    }else{
      return WSUtility.getlocalizedString(key: "server error", lang: WSUtility.getLanguage())!
    }
  }
    
    func GETRequest(requestParameter:String,methodName:String,  header:HTTPHeaders?, success:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessageCode:String) -> Void)   {
        
        var requestHeader = header
        if header == nil {
            requestHeader = ["x-api-key": WSConfigurationFile().getSIFUPublicAPIKey()]
        }else{
            requestHeader!["x-api-key"] = WSConfigurationFile().getSIFUPublicAPIKey()
        }
        
        var requestURL:String?
        
        if methodName == "" {
            
        }else{
            //requestURL = "\(WSConfigurationFile().getSifuBaseUrl())\(requestParameter)"
        }
        
        if(methodName == GET_GIFT || methodName == GET_CART){
            requestURL = requestParameter
        }else{
            requestURL = "\(WSConfigurationFile().getSifuBaseUrl())\(requestParameter)"
        }
        
        UFSWebServiceHandler.manager.request(requestURL!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: requestHeader)
            .responseString { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
                
                if  response.response?.statusCode == 200{
                    
                    //print(response.result.value!)   // result of response serialization
                    
                    
                    if methodName == Login_API_Method {
                        // UserDefaults().set(response.result.value!, forKey: "SIFU_TOKEN_KEY")
                        UserDefaults.standard.set(response.result.value!, forKey: "SIFU_TOKEN_KEY")
                        
                        /*
                         let userKey:String = UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY) as! String
                         var dictUserInfo = UserDefaults.standard.value(forKey: userKey) as! [String:Any]
                         dictUserInfo["sifuToken"] = response.result.value!
                         UserDefaults.standard.set(dictUserInfo.description, forKey: LAST_AUTHENTICATED_USER_KEY)
                         */
                        success( response.result.value! as AnyObject)
                        return
                    }
                    /*****
                     *** PARSE RESPONSE OF GET LOYALTY POINTS API
                     ******/
                    
                    if methodName == Get_Loyalty_API_Method {
                        guard let responeString : String = response.result.value else {
                            return
                        }
                        guard let dictResponse = WSUtility.convertToDictionary(text: responeString) else{
                            return
                        }
                        if let points = dictResponse["currentLoyaltyBalance"] {
                            UserDefaults().set("\(points)", forKey: LOYALTY_BALANCE_KEY)
                        }
                        else{
                            UserDefaults().set("0", forKey: LOYALTY_BALANCE_KEY)
                        }
                    }
                    
                    guard let responeString : String = response.result.value else {
                        faliure("error")
                        return
                    }
                    
                    
                    guard let dictResponse = WSUtility.convertToDictionary(text: responeString) else{
                        faliure("error")
                        return
                    }
                    
                    success( dictResponse as AnyObject)
                }else{
                    
                    if methodName == Get_Loyalty_API_Method {
                        if  response.response?.statusCode == 401{
                            // token expire, login again to get the new token
                            faliure("Session_Token_Expire")
                        }
                    }
                    
                    guard let responseValue = response.result.value else{
                        faliure((response.error?.localizedDescription)!)
                        return
                    }
                    
                    guard let dictResponse = WSUtility.convertToDictionary(text: responseValue) else{
                        faliure("error")
                        return
                    }
                    
                    
                    if let responseMessage = dictResponse["code"]{
                        print(responseMessage)
                        faliure(responseMessage as! String)
                    }else{
                        faliure("error")
                    }
                    
                    
                }
                
        }
        
    }
    
    func GETRequestWithJsonResponse(requestParameter:String,methodName:String,header:HTTPHeaders?, success:@escaping (_ response:Any)-> Void, faliure:@escaping (_ errorMessageCode:String) -> Void)   {
        
        var requestHeader = header
        if header == nil {
            requestHeader = ["x-api-key": WSConfigurationFile().getSIFUPublicAPIKey()]
        }else{
            requestHeader!["x-api-key"] = WSConfigurationFile().getSIFUPublicAPIKey()
        }
        var requestURL:String = ""
        
        if methodName == GET_USER_INFO{
            requestURL = "\(WSConfigurationFile().getAdminBaseUrl())\(GET_USER_INFO)?email_id=\(requestParameter)"
        }
        else if methodName == GET_USER_TRADEPARTNERS{
            
            requestURL = "\(WSConfigurationFile().getSifuBaseUrl())\(GET_USER_TRADEPARTNERS)"
        }
        else if methodName == GET_TRADEPARTNERS{
            let siteCode = UserDefaults.standard.value(forKey: "Site")!
            requestURL = "\(WSConfigurationFile().getSifuBaseUrl() + GET_TRADEPARTNERS)?siteCode=\(siteCode)"
        }
        else if methodName == GET_TRADEPARTNERS_LOCATIONS{
            let siteCode = UserDefaults.standard.value(forKey: "Site")!
            requestURL = "\(WSConfigurationFile().getSifuBaseUrl() + GET_TRADEPARTNERS_LOCATIONS)?siteCode=\(siteCode)"
            requestURL = requestURL.replacingOccurrences(of: "%@", with: requestParameter)
        }
        else if methodName == GET_NOTIFICATION_LIST{
            requestURL = "\(WSConfigurationFile().getAdminBaseUrl())\(GET_NOTIFICATION_LIST)?email_id=\(requestParameter)"
            
        }
        else if methodName == VALIDATE_PROMOCODE{
            requestURL = requestParameter
        }
        else if methodName == GET_PENDING_LOYALTYPOINTS_FROM_ADMIN{
            requestURL = requestParameter
        }
        else if methodName == GET_APPLIED_PROMOCODE_BEFORE_ORDERPLACED{
            requestURL = requestParameter
        }
            //     else if methodName == GET_FEATURE_ENABLE_DISABLE{
            //        requestURL = "\(WSConfigurationFile().getAdminBaseUrl())\(GET_FEATURE_ENABLE_DISABLE)"
            //     }
        else if methodName == GET_COUNTRY_LANGUAGE{
            requestURL = "\(WSConfigurationFile().getAdminBaseUrl())\(GET_COUNTRY_LANGUAGE)"
        }
        else{
            requestURL = "\(WSConfigurationFile().getSifuBaseUrl())\(requestParameter)"
        }
        
        UFSWebServiceHandler.manager.request(requestURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: requestHeader)
            .responseJSON { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
                
                if  response.response?.statusCode == 200{
                    if let dict  = response.result.value{
                        // let dictResponse = dict as! [[String:Any]]
                        success( dict)
                      return
                    }else{
                        faliure("No data found")
                      return
                    }
                    
                }else{
                    
                    if methodName == Favourites_List_API {
                        if  response.response?.statusCode == 401{
                            // token expire, login again to get the new token
                            faliure("Session_Token_Expire")
                        }
                    }
                    
                    guard response.result.value != nil else{
                        faliure((response.error?.localizedDescription)!)
                        return
                    }
                    
                    faliure("No data found")
                    
                }
        }
        
    }
    
    func GETRequestWithJsonResponseForHybris(requestParameter:String,params:[String:Any]?,methodName:String,HttpMethod:String,header:HTTPHeaders?, success:@escaping (_ response:Any)-> Void, faliure:@escaping (_ errorMessageCode:String) -> Void)   {
        
        
        var requestURL = ""
        
        if methodName == MAIN_CATEGORIES_API {
            let categoryName = String(format:MAIN_CATEGORIES_API, WSUtility.getCountryCode(),WSUtility.getLanguageCode())
            requestURL = WSUtility.getHybrisBaseUrlWithBaseSiteId() + "\(categoryName)" + WSUtility.addVendorIDForTurkey()
            
        }else if methodName == "ProductsListForCategory"{
            //requestURL = BASE_URL_HYBRIS + "\(PRODUCTLIST_FOR_SUB_CATEGORY)"
            requestURL = WSUtility.getHybrisBaseUrlWithBaseSiteId() + "\(requestParameter)" + WSUtility.addVendorIDForTurkey()
            //requestURL = requestURL.replacingOccurrences(of: "%@", with: "\(requestParameter)")
        }else if(methodName == CHECKOUT_SAMPLEORDER || methodName == GET_PRODUCT_QUERY){
            requestURL = requestParameter
        }
        else if (methodName == GET_VENDORSLIST_FOR_TR || methodName == GET_PROFILE_API_HYBRIS_TR || methodName == GET_BUSINESS_TYPES_FROM_HYBRIS || methodName == "SetVendor" || methodName == GET_SAVED_PAYMENT_CARDS_FOR_TR) {
            requestURL = WSUtility.getHybrisBaseUrlWithBaseSiteId() + "\(requestParameter)"
        }
        else{
            requestURL = WSUtility.getHybrisBaseUrlWithBaseSiteId() + "\(requestParameter)" + WSUtility.addVendorIDForTurkey()
        }
        
        UFSWebServiceHandler.manager.request(requestURL, method: (HttpMethod == "POST" ? .post : .get), parameters: params, encoding: URLEncoding.default, headers: header)
            .responseJSON { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
                
                if  (response.response?.statusCode == 200 || response.response?.statusCode == 201){
                  
                    if let dict  = response.result.value{
                        success( dict)
                    }else{
                        faliure("No data found")
                    }
                    
                    return
                }else if (methodName == GET_CART && response.response?.statusCode == 400){
                   faliure(self.getHybrisErrorMessage(response: response.result.value as? [String : Any]))
                  return
                }
                else{
                    
                    guard response.result.value != nil else{
                        faliure((response.error?.localizedDescription)!)
                        return
                    }
                    
                    faliure("No data found")
                    
                }
        }
        
    }
    
    func PUTRequestWithJsonResponseForHybris(requestParameter:String,params:[String:Any]?,methodName:String,HttpMethod:String,header:HTTPHeaders?, success:@escaping (_ response:Any)-> Void, faliure:@escaping (_ errorMessageCode:String) -> Void)   {
        
        var requestURL = ""
        if(methodName == "REPLACE_CART_ENTRY"){
            requestURL = requestParameter
        }else if (methodName == "deliverymode"){
          requestURL = WSUtility.getHybrisBaseUrlWithBaseSiteId() + "\(requestParameter)"
        }
      else{
            requestURL = WSUtility.getHybrisBaseUrlWithBaseSiteId() + "\(methodName)" + "\(requestParameter)" + WSUtility.addVendorIDForTurkey()
        }
        
        
        UFSWebServiceHandler.manager.request(requestURL, method: (HttpMethod == "PUT" ? .put : .get), parameters: params, encoding: URLEncoding.default, headers: header)
            .responseJSON { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
                
                if  response.response?.statusCode == 200{
                    if let dict  = response.result.value{
                        success( dict)
                    }else{
                        success([String: Any]())
                    }
                    
                }else{
                    
                    guard response.result.value != nil else{
                        faliure((response.error?.localizedDescription)!)
                        return
                  }
                  
                    faliure(self.getHybrisErrorMessage(response: response.result.value as? [String : Any]))
                    return
                  }
                    
                  
                    
                }
        }
        
  
    func makeRequestToAdmin(dictParameter:[String:Any], finalUrl:String, HttpMethod:String, apiMethodName:String, success:@escaping (_ response:[String:Any])-> Void, failure:@escaping (_ errorMessage:String) -> Void) {
        
        let header:HTTPHeaders =  [WSConfigurationFile().getAdminHeaderSecretKey() : WSConfigurationFile().getAdminHeaderSecretValue(),
                                   ADMIN_HEADER_COUNTRY_CODE : WSUtility.getCountryCode(),
                                   ADMIN_HEADER_LANGUAGE_CODE : WSUtility.getLanguageCode(),
                                   ADMIN_HEADER_APP_NAME : ADMIN_HEADER_APP_NAME_VALUE,
                                   ADMIN_HEADER_APP_PLATFORM : ADMIN_HEADER_APP_PLATFORM_VALUE,
                                   ADMIN_HEADER_APP_VERSION : WSUtility.getAppVersion()]
        
        Alamofire.request(finalUrl, method: (HttpMethod == "POST" ? .post : .get), parameters: (HttpMethod == "POST" ? dictParameter : nil), encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
                
                
                if response.result.isSuccess {
                    
                    if let responseObject = response.result.value{
                        let dictResponse = responseObject as! [String:Any]
                        
                        if dictResponse["error"] as! Bool == false{
                            
                            success(dictResponse )
                            
                        }else{
                            failure("No data found")
                        }
                        
                    }
                    
                }else{
                    
                    failure(response.error!.localizedDescription)
                }
        }
        
    }
    
    func makePutRequest(dictParameter:[String:Any],methodName:String,success:@escaping (_ response:AnyObject)-> Void, faliure :@escaping (_ errorMessage :String) -> Void) {
        
        
        do {
            
            var requestURL = ""
            let header:HTTPHeaders? = nil
            
            let jsonData = try JSONSerialization.data(withJSONObject: dictParameter, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:Any] {
                
                if methodName == "setDeliveryMode" {
                    requestURL = "\(WSUtility.getHybrisBaseUrlWithBaseSiteId() + SET_DELIVERY_MODE)" + WSUtility.addVendorIDForTurkey()
                    requestURL = requestURL.replacingOccurrences(of: "email_id", with: "\(dictParameter["email_id"]!)")
                    requestURL = requestURL.replacingOccurrences(of: "cart_id", with: "\(dictParameter["cart_id"]!)")
                    requestURL = requestURL.replacingOccurrences(of: "delivery_Mode", with: "\(dictParameter["delivery_Mode"]!)")
                    
                }
                Alamofire.request("\(requestURL)", method: .put, parameters: dictFromJSON, encoding: URLEncoding.default, headers: header)
                    .responseJSON { response in
                        print(response.request as Any)  // original URL request
                        //print(response.response as Any) // URL response
                        print(response.result.value as Any)   // result of response serialization
                        
                        if response.result.isSuccess{
                            success(response.result.value  as AnyObject)
                            
                        }else{
                            faliure(response.error!.localizedDescription)
                        }
                        
                }
                
                
            }
        } catch {
            print(error.localizedDescription)
            faliure(error as! String)
        }
        
    }
    
    func DELETERequest(dictParameter:[String:Any], methodName:String, header:HTTPHeaders?, requestURL:String,success:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: dictParameter, options: .prettyPrinted)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            if let dictFromJSON = decoded as? [String:Any] {
                
                var requestHeader = header
                if header == nil {
                    requestHeader = ["x-api-key": WSConfigurationFile().getSIFUPublicAPIKey()]
                }else{
                    requestHeader!["x-api-key"] = WSConfigurationFile().getSIFUPublicAPIKey()
                }
                
                UFSWebServiceHandler.manager.request("\(requestURL)", method: .delete, parameters: dictFromJSON, encoding: JSONEncoding.default, headers: requestHeader)
                    .responseJSON { response in
                        print(response.request as Any)  // original URL request
                        print(response.result.value as Any)   // result of response serialization
                        
                        
                        if (response.response?.statusCode == 200) {
                            
                            if let _  = response.result.value{
                                success((response.result.value)! as AnyObject)
                            }
                            else{
                                if(methodName == "delete_cart_item"){
                                    success("" as AnyObject)
                                }else if (methodName == "delete_card_item"){
                                  success("" as AnyObject)
                              }
                                faliure("No data found")
                            }
                            return
                            
                        }else if (methodName == "delete_cart_item" && response.response?.statusCode == 400){
                          faliure(self.getHybrisErrorMessage(response: response.result.value as? [String : Any]))
                          return
                        }
                        else{
                            faliure(WSUtility.getlocalizedString(key: "server error", lang: WSUtility.getLanguage())!)
                        }
                        
                }
                
            }
        } catch {
            print(error.localizedDescription)
            faliure(error as! String)
        }
        
    }
    
    
}
