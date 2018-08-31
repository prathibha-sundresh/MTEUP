 
//
//  WSWebServiceBusinessLayer.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 22/11/2017.
//

import UIKit
import Alamofire

class WSWebServiceBusinessLayer: NSObject {
  
  var  hybris_token_key = ""
  
  func makeLoyaltyPointsRequest(methodName:String , successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let header:HTTPHeaders? = ["Authorization": WSUtility.getSifuToken(),"Content-Type":"application/json"]
    
    var langCode = "\(WSUtility.getLanguageCode())-\(WSUtility.getCountryCode())"
    
    
    if WSUtility.getCountryCode() == "AT" {
      langCode = "de-AT"
    }
    
    let requestParameter = "\(Get_Loyalty_API_Method)?locale=\(langCode)"
    
    webServiceHandler.GETRequest(requestParameter: requestParameter, methodName: Get_Loyalty_API_Method, header: header, success: { (response) in
      successResponse(response)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
  }
  
  func makeFavouriteListRequest(methodName:String , successResponse:@escaping (_ response:[[String:Any]])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let requestParameter = "\(Favourites_List_API)?&countryCode=\(WSUtility.getCountryCode())&languageCode=\(WSUtility.getLanguageCode())"
    
    let header:HTTPHeaders? = ["Authorization": WSUtility.getSifuToken(),"Content-Type":"application/json"]
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: requestParameter, methodName: Favourites_List_API, header: header, success: { (response) in
      let dictResponse = response as! [[String:Any]]
      successResponse(dictResponse)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  func addFavouriteItemRequest(parameter:[String:Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let header:HTTPHeaders? = ["Authorization": WSUtility.getSifuToken(),"Content-Type":"application/json"]
    let requestUrl = "\(WSConfigurationFile().getSifuBaseUrl())\(ADD_Favourite_Item)"
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter: parameter, methodName: ADD_Favourite_Item, header: header, requestURL: requestUrl, success: { (response) in
      successResponse(response)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
  }
  func makeOrderHistoryRequest(methodName:String , successResponse:@escaping (_ response:[[String:Any]])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let requestParameter = "\(ORDER_HISTORY_API)"
    
    let header:HTTPHeaders? = ["Authorization": WSUtility.getSifuToken()]
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: requestParameter, methodName: ORDER_HISTORY_API, header: header, success: { (response) in
      let dictResponse = response as? [[String:Any]]
      successResponse(dictResponse!)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  func makeOrderHistoryRequestToHybris(methodName:String , successResponse:@escaping (_ response:[[String:Any]])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    let strEmail = UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY) as! String
    let requestParameter = String(format: ORDER_HISTORY_API_HYBRIS_FOR_TR,"\(strEmail)")
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.GETRequestWithJsonResponseForHybris(requestParameter: requestParameter, params: nil, methodName: ORDER_HISTORY_API_HYBRIS_FOR_TR, HttpMethod: "GET", header: header, success: { (response) in
      if let dictResponse = response as? [String:Any]{
        if let arrOrders = dictResponse["orders"] as? [[String:Any]]{
          successResponse(arrOrders)
        }
      }
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
  }
  
  func makeOrderDetailRequest(referenceID:String ,methodName:String , successResponse:@escaping (_ response:[String:Any])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let requestParameter = "\(ORDER_HISTORY_API)/\(referenceID)"
    
    let header:HTTPHeaders? = ["Authorization": WSUtility.getSifuToken()]
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: requestParameter, methodName: ORDER_HISTORY_API, header: header, success: { (response) in
      let dictResponse = response as? [String:Any]
      successResponse(dictResponse!)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  func makeOrderDetailRequestToHybris(referenceID:String ,methodName:String , successResponse:@escaping (_ response:[String:Any])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    let strEmail = UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY) as! String
    
    //        let requestParameter = "users/" + strEmail + ORDER_HISTORY_API_HYBRIS + "/" + referenceID + "?fields=DEFAULT" //"users/" + "garima.tiwari21%40mindtree.com/" + ORDER_HISTORY_API_HYBRIS + "/00042012?fields=DEFAULT"
    let requestParameter = String(format: ORDER_HISTORY_DETAIL_API_HYBRIS_FOR_TR,"\(strEmail)", referenceID)
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.GETRequestWithJsonResponseForHybris(requestParameter: requestParameter, params: nil, methodName: ORDER_HISTORY_DETAIL_API_HYBRIS_FOR_TR, HttpMethod: "GET", header: header,  success: { (response) in
      let dictResponse = response as? [String:Any]
      successResponse(dictResponse!)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  
  func makeRecipeListRequest(methodName:String , successResponse:@escaping (_ response:[[String:Any]])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    // recipes/AT/de/0/20
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    var langCode = WSUtility.getLanguageCode()
    var countryCode = WSUtility.getCountryCode()
    if WSUtility.getCountryCode() == "AT"{
      langCode = "de"
      countryCode = "AT"
    }
    
    let parameterString = String(format: Recipe_List_API, countryCode,langCode)
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: parameterString, methodName: Recipe_List_API, header: nil, success: { (response) in
      let dictResponse = response as! [[String:Any]]
      successResponse(dictResponse)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
  }
  
  func makeLoginRequest(parameter:[String:String],methodName:String , successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let user = parameter["EmailId"]
    let password = parameter["Password"]
    
    let credentialData = "\(user!):\(password!)".data(using: String.Encoding.utf8)!
    let base64Credentials = credentialData.base64EncodedString()
    
    let header:HTTPHeaders? = ["Authorization": "Basic \(base64Credentials)","Content-Type":"application/x-www-form-urlencoded"]
    
    let requestParameter = "\(Login_API_Method)?country=\(String(describing: UserDefaults.standard.value(forKey: "CountryCode")!))&site=\(String(describing: UserDefaults.standard.value(forKey: "Site")!))"
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    webServiceHandler.GETRequest(requestParameter: requestParameter, methodName: Login_API_Method, header: header, success: { (response) in
      successResponse(response)
      
    }) { (errorMessage) in
      
      var errorMessageToShow = errorMessage
      switch errorMessage {
      case "AUTH_PASSWORDS_INCORRECT":
        errorMessageToShow =  "Incorrect Password.Please try again."
        break
      case "AUTH_USER_NOT_FOUND":
        errorMessageToShow =  "Please use the registered email ID"
        break
        
      default:
        errorMessageToShow = errorMessage
      }
      
      print(errorMessage)
      
      faliureResponse(errorMessageToShow)
      
    }
  }
  
  func makeSignUpRequest(parameter:[String:Any] , successResponse:@escaping (_ response:NSDictionary)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let requestUrl = "\(WSUtility.getHybrisBaseUrlWithBaseSiteId())\(SIGN_UP)"
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter:parameter, methodName: SIGN_UP, header: header, requestURL: requestUrl, success: { (response) in
      
      successResponse(response as! NSDictionary)
      
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
    
  }
  
  
  
  func makeLoyaltyProductCatlogRequest(methodName:String,categoryName:String, skip:String, take:String , successResponse:@escaping (_ response:Any)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let langCode = WSUtility.getLanguageCode()
    let countryCode = WSUtility.getCountryCode()
    
    var APIName =  (WSUtility.getCountryCode() == "TR") ? LOYALTY_PRODUCT_BASE_URL().LOYALTY_PRODUCT_CATLOG_Turkey_API : LOYALTY_PRODUCT_BASE_URL().LOYALTY_PRODUCT_CATLOG_DACH_API
    
    var tempCategoryName = categoryName
    if (WSUtility.getCountryCode() == "TR") && categoryName == "*"{
      tempCategoryName = "oeduel-programi"
    }
    
    
    APIName = APIName.replacingOccurrences(of: "COUNTRY_CODE", with: countryCode)
    APIName = APIName.replacingOccurrences(of: "LANGUAGE_CODE", with: langCode)
    APIName = APIName.replacingOccurrences(of: "TAKE", with: take)
    APIName = APIName.replacingOccurrences(of: "SKIP", with: skip)
    APIName = APIName.replacingOccurrences(of: "CATEGORY_NAME", with: tempCategoryName)
    
    if let encoded = APIName.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
      let _ = URL(string: encoded) {
      
      let parameterString = encoded //String(format: APIName, countryCode,langCode,categoryName,skip,take)
      webServiceHandler.GETRequestWithJsonResponse(requestParameter: parameterString, methodName: APIName, header: nil, success: { (response) in
        WSCacheSingleton.shared.cache.setObject(response as AnyObject, forKey: (Cached_Loyalty_Product as NSString))
        successResponse(response)
      }) { (errorMessage) in
        faliureResponse(errorMessage)
      }
      
    }else{
      
      faliureResponse("errorMessage")
    }
    
    
    
  }
  
  func makeForgotPasswordRequest(emailID:String,methodName:String , successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    var requestUrl = "\(WSUtility.getHybrisBaseUrlWithBaseSiteId())\(Forgot_API)"
    requestUrl = requestUrl.replacingOccurrences(of: "email_id", with: "\(emailID)")
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter: ["email" : emailID,
                                                  "countryCode" : WSUtility.getCountryCode(),
                                                  "site" : WSUtility.getSiteCode(),
                                                  "languageCode" : WSUtility.getLanguageCode()], methodName: methodName, header: header, requestURL: requestUrl, success: { (response) in
                                                    successResponse(response as AnyObject)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
  }
  
  func getTradePartenersList(successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let requestHeader:HTTPHeaders? = ["Content-Type":"application/json"]
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: "", methodName:GET_TRADEPARTNERS, header: requestHeader, success: { (response) in
      successResponse(response as AnyObject)
      
    }) { (errorMessage) in
      
      faliureResponse(errorMessage)
      
    }
    
  }
  
  func gettradepartnersLocationListRequest(parentTPID:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let requestHeader:HTTPHeaders? = ["Content-Type":"application/json"]
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: parentTPID, methodName:GET_TRADEPARTNERS_LOCATIONS, header: requestHeader, success: { (response) in
      successResponse(response as AnyObject)
      
    }) { (errorMessage) in
      
      faliureResponse(errorMessage)
      
    }
  }
  func getUserTradepartnersList(parameter:[String:Any],methodName:String , successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let requestHeader:HTTPHeaders? = ["Authorization": WSUtility.getSifuToken()]
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: "", methodName:methodName, header: requestHeader, success: { (response) in
      successResponse(response as AnyObject)
      
    }) { (errorMessage) in
      
      faliureResponse(errorMessage)
      
    }
  }
  
  func addLoyaltyPointsRequest(parameter:[String:Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let header:HTTPHeaders? = ["Authorization": WSUtility.getSifuToken()]
    let requestUrl = "\(WSConfigurationFile().getSifuBaseUrl())\(Add_Loyalty_API_Method)"
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter: parameter, methodName: Add_Loyalty_API_Method, header: header, requestURL: requestUrl, success: { (response) in
      successResponse(response)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
  }
  
  //GBL_RL
  func makeLoyaltyRewardsRequest(methodName:String, skip:String, take:String , successResponse:@escaping (_ response:Any)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let header:HTTPHeaders? = ["Authorization": WSUtility.getSifuToken(),"Content-Type":"application/json"]
    
    let langCode = WSUtility.getLanguageCode()
    let countryCode = WSUtility.getCountryCode()
    
    let APIName =  (WSUtility.getCountryCode() == "TR") ? LOYALTY_REWARDS_BASE_URL().LOYALTY_REWARDS_OtherCountry_API : LOYALTY_REWARDS_BASE_URL().LOYALTY_REWARDS_DACH_API
    
    let parameterString = String(format: APIName, countryCode,langCode,skip,take)
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: parameterString, methodName: APIName, header: header, success: { (response) in
      WSCacheSingleton.shared.cache.setObject(response as AnyObject, forKey: (Cached_Loyalty_Product as NSString))
      successResponse(response)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  
  func getUserProfile(parameter:[String:Any],methodName:String , successResponse:@escaping (_ response:[String:Any])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let header:HTTPHeaders? = ["Authorization": WSUtility.getSifuToken(),"Content-Type":"application/json"]
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: "\(GET_PROFILE_API)", methodName: GET_PROFILE_API, header: header, success: { (response) in
      if let responseDict = response as? [String:Any]{
        successResponse(responseDict)
      }
    }, faliure: { (errorMessage) in
      faliureResponse(errorMessage)
    })
  }
  
  func getBasicUserProfile(parameter:[String:Any],methodName:String , successResponse:@escaping (_ response:[String:Any])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    
    let header:HTTPHeaders? = ["Authorization": WSUtility.getSifuToken(),"Content-Type":"application/json"]
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: "\(GET_BASIC_PROFILE_API)", methodName: GET_BASIC_PROFILE_API, header: header, success: { (response) in
      successResponse((response as? [String:Any])!)
    }, faliure: { (errorMessage) in
      faliureResponse(errorMessage)
    })
  }
  
    func getBasicUserProfileFromHybrisForTurkey(parameter:[String:Any],methodName:String , successResponse:@escaping (_ response:[String:Any])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {

        
        
        let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
        
        let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
        let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
        
        var requestUrl = String(format: GET_PROFILE_API_HYBRIS_TR,WSUtility.getLanguageCode())
        
        let email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
        requestUrl = requestUrl.replacingOccurrences(of: "email_id", with: "\(email_id)")
        
        webServiceHandler.GETRequestWithJsonResponseForHybris(requestParameter: requestUrl, params: [:], methodName: GET_PROFILE_API_HYBRIS_TR,HttpMethod: "GET", header: header, success: { (response) in
            
            successResponse((response as AnyObject) as! [String : Any])
            
        }) { (errorMessage) in
            faliureResponse(errorMessage)
        }

    }
    
    func updateUserProfileToHybrisForTurkey(parameter:[String:Any], successResponse:@escaping (_ response:String)-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
        
        let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
        
        let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
        let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
        var requestUrl = WSUtility.getHybrisBaseUrlWithBaseSiteId() + GET_PROFILE_API_HYBRIS_TR
        let email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
        requestUrl = requestUrl.replacingOccurrences(of: "email_id", with: "\(email_id)")
        
        webServiceHandler.POSTRequest(dictParameter: parameter, methodName: GET_PROFILE_API_HYBRIS_TR, header: header, requestURL: requestUrl, success: { (response) in
            print(response)
            successResponse(response as! String)

        }) { (errorMessage) in
            print(errorMessage)

            failureResponse(errorMessage)
        }
        
    }
    
  func UpdateUserProfileForSifu(parameter:[String:Any],methodName:String,responseDict:[String:Any] , successResponse:@escaping (_ response: [String:Any])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let siteCode = UserDefaults.standard.value(forKey: "Site")!
    let requestUrl = "\(WSConfigurationFile().getSifuBaseUrl())\(UPDATE_USER_DETAILS_TO_SIFU)"
    
    let requestHeader:HTTPHeaders? = ["Authorization": WSUtility.getSifuToken(),"Content-Type":"application/json"]
    
    let confirmedOptIn = UserDefaults.standard.bool(forKey: "confirmedOptIn")
    let newsletterOptIn = UserDefaults.standard.bool(forKey: "newsletterOptIn")
    //let oldNewsletterOptIn = UserDefaults.standard.bool(forKey: "oldNewsletterOptIn")
    let confirmedNewsletterOptIn = UserDefaults.standard.bool(forKey: "confirmedNewsletterOptIn")
    //let confirmUrl = "\(responseDict["confirmUrl"]!)" == "<null>" ? "null" : "\(responseDict["confirmUrl"]!)"
    let optINDate = "\(responseDict["optInDate"]!)" == "<null>" ? "null" : "\(responseDict["optInDate"]!)"
    let oldNewsletterOptIn = "\(responseDict["oldNewsletterOptIn"]!)" == "<null>" ? "false" : "\(responseDict["oldNewsletterOptIn"]!)"
    // let confirmedOptInDate = "\(responseDict["confirmedOptInDate"]!)" == "<null>" ? "null" : "\(responseDict["confirmedOptInDate"]!)"
    // let newsletterConfirmUrl = "\(responseDict["newsletterConfirmUrl"]!)" == "<null>" ? "null" : "\(responseDict["newsletterConfirmUrl"]!)"
    
    
    //"confirmedOptInDate": confirmedOptInDate,
    let requestDict = ["accountOptIn" : true,
                       "businessName": parameter["businessName"]!,
                       "city": parameter["city"]!,
                       "confirmedNewsletterOptIn":confirmedNewsletterOptIn,
                       "confirmedOptIn": confirmedOptIn,
                       "country":WSUtility.getCountryCode(),
                       "countryCode": WSUtility.getCountryCode(),
                       "email": parameter["email"]!,
                       "firstName": parameter["firstName"]!,
                       //"gender": "Profile_Gender_Male",
      "houseNumber": parameter["buildingNo"]!,
      //"houseNumberExtension": "",
      "id": 0,
      //"jobTitle": "",
      "languageCode": WSUtility.getLanguageCode(),
      "lastName": parameter["lastName"]!,
      "mobilePhone":parameter["mobileNo"]!,
      //"newsletterConfirmUrl": newsletterConfirmUrl,
      "newsletterOptIn": newsletterOptIn,
      "numberOfCovers": 0,
      "numberOfCoversPerDay": 0,
      "numberOfKitchenStaff": 0,
      "numberOfLocations": 0,
      //"oHubId": "",
      "oldNewsletterOptIn": oldNewsletterOptIn,
      "oldPrivateHousehold": false,
      "openOnFriday": false,
      "openOnMonday": false,
      "openOnSaturday": false,
      "openOnSunday": false,
      "openOnThursday": false,
      "openOnTuesday": false,
      "openOnWednesday": false,
      //"operatorRefId": "",
      "optInDate": optINDate,
      //"password": "",
      //"passwordMd5Hash": "",
      "phoneNumber": parameter["mobileNo"]!,
      "privateHousehold":false,
      "profileLoginType": "EMAIL",
      //"requestType": "register_profile",
      "site": siteCode,
      //"state": "",
      "street": parameter["street"]!,
      "taxNumber": "",
      //"title": "Mr",
      //"trackingId": "",
      "typeOfBusiness": parameter["businessType"]!,
      //"typeOfCuisine": "",
      "updateNewsletterSubscription":true,
      "userId": parameter["userId"]!,
      //"webUpdaterId": "",
      "zipCode": parameter["areaCode"]!] as [String: Any]
    
    //    let requestDict = ["accountOptIn" : true,
    //                       "businessName": parameter["businessName"]!,
    //                       "city": parameter["city"]!,
    //                       "confirmPassword":"",
    //                       "confirmUrl": confirmUrl,
    //                       "confirmedNewsletterOptIn":confirmedNewsletterOptIn,
    //                       "confirmedOptIn": confirmedOptIn,
    //                       "confirmedOptInDate": confirmedOptInDate,
    //                       "country":WSUtility.getCountryCode(),
    //                       "countryCode": WSUtility.getCountryCode(),
    //                       "distributor": "",
    //                       "distributorCustomerId": "",
    //                       "distributorEmail": "",
    //                       "email": parameter["email"]!,
    //                       "faxNumber": "",
    //                       "fbToken": "",
    //                       "fbUserId": "",
    //                       "firstName": parameter["firstName"]!,
    //                       "gender": "Profile_Gender_Male",
    //                       "houseNumber": parameter["buildingNo"]!,
    //                       "houseNumberExtension": "",
    //                       "id": 0,
    //                       "jobTitle": "",
    //                       "languageCode": WSUtility.getLanguageCode(),
    //                       "lastName": parameter["lastName"]!,
    //                       "mobilePhone":parameter["mobileNo"]!,
    //                       "newsletterConfirmUrl": newsletterConfirmUrl,
    //                       "newsletterOptIn": newsletterOptIn,
    //                       "numberOfCovers": 0,
    //                       "numberOfCoversPerDay": 0,
    //                       "numberOfKitchenStaff": 0,
    //                       "numberOfLocations": 0,
    //                       "oHubId": "",
    //                       "oldNewsletterOptIn": oldNewsletterOptIn,
    //                       "oldPrivateHousehold": false,
    //                       "openOnFriday": false,
    //                       "openOnMonday": false,
    //                       "openOnSaturday": false,
    //                       "openOnSunday": false,
    //                       "openOnThursday": false,
    //                       "openOnTuesday": false,
    //                       "openOnWednesday": false,
    //                       "operatorRefId": "",
    //                       "optInDate": optINDate,
    //                       "password": "",
    //                       "passwordMd5Hash": "",
    //                       "phoneNumber": parameter["mobileNo"]!,
    //                       "privateHousehold":false,
    //                       "profileLoginType": "EMAIL",
    //                       "requestType": "register_profile",
    //                       "site": siteCode,
    //                       "state": "",
    //                       "street": parameter["street"]!,
    //                       "taxNumber": parameter["taxNumber"]!,
    //                       "title": "Mr",
    //                       "trackingId": "",
    //                       "typeOfBusiness": parameter["businessType"]!,
    //                       "typeOfCuisine": "",
    //                       "updateNewsletterSubscription":true,
    //                       "userId": parameter["userId"]!,
    //                       "webUpdaterId": "",
    //                       "zipCode": parameter["areaCode"]!] as [String: Any]
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter: requestDict, methodName: UPDATE_USER_DETAILS_TO_SIFU, header: requestHeader, requestURL: requestUrl, success: { (response) in
      
      successResponse((response as? [String:Any])!)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
  }
  func changePasswordAPI(parms:[String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    var langCode = ""
    if WSUtility.getCountryCode() == "AT" {
      langCode = "de"
    }
    else {
      langCode = "tr"
    }
    
    let requestHeader:HTTPHeaders? = ["Authorization": WSUtility.getSifuToken(),"Content-Type":"application/json"]
    var paramsDict:[String: Any] = parms
    let siteCode = UserDefaults.standard.value(forKey: "Site")!
    paramsDict["languageCode"] = langCode
    paramsDict["site"] = siteCode
    paramsDict["countryCode"] = WSUtility.getCountryCode()
    
    let requestUrl = "\(WSConfigurationFile().getSifuBaseUrl())\(CHANGE_PASSWORD_API)?client_id=\(WSConfigurationFile().getClientID())&client_secret=\(WSConfigurationFile().getClientSecret())"
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter: paramsDict, methodName: CHANGE_PASSWORD_API, header: requestHeader, requestURL: requestUrl, success: { (response) in
      
      successResponse(response)
    }) { (errorMessage) in
      print(errorMessage)
      faliureResponse(errorMessage)
    }
  }
  func CreateEcomProfile(userID:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let langCode = "\(WSUtility.getLanguageCode().lowercased())-\(WSUtility.getCountryCode())"
    //    if WSUtility.getCountryCode() == "AT" {
    //      langCode = "de-AT"
    //    }
    //    else {
    //      langCode = "tr-TR"
    //    }
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    let siteCode = UserDefaults.standard.value(forKey: "Site")!
    let header:HTTPHeaders? = ["Authorization": "\(userID)"]
    let requestUrl = "\(WSConfigurationFile().getSifuBaseUrl() + CREATE_USER_FOR_ECOM)?locale=\(langCode)&emailAddress=\(emailID)&siteCode=\(siteCode)"
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter: [String:Any](), methodName: CREATE_USER_FOR_ECOM, header: header, requestURL: requestUrl, success: { (response) in
      UserDefaults.standard.set(true, forKey: "callFirstTime")
      successResponse(response)
    }) { (errorMessage) in
      print(errorMessage)
    }
  }
  
  func setGoalForProduct(productID:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let siteCode = UserDefaults.standard.value(forKey: "Site")!
    let requestUrl = "\(WSConfigurationFile().getSifuBaseUrl())\(UPDATE_PROFILE_API)?loyaltyGoalProductId=\(productID)&siteCode=\(siteCode)"
    let header:HTTPHeaders? = ["Authorization": WSUtility.getSifuToken()]
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter: [String:Any](), methodName: UPDATE_PROFILE_API, header: header, requestURL: requestUrl, success: { (response) in
      successResponse(response)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
  }
  
  func makeRecipeSearchRequest(searchString:String,skip:String, take:String, successResponse:@escaping (_ response:[String:Any])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    var langCode = WSUtility.getLanguageCode()
    var countryCode = WSUtility.getCountryCode()
    if WSUtility.getCountryCode() == "AT" {
      langCode = "de"
      countryCode = "AT"
    }
    let parameterString = String(format: Recipe_Search_API, countryCode,langCode,skip,take,searchString)
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: parameterString, methodName: Recipe_Search_API, header: nil, success: { (response) in
      let dictResponse = response as! [String:Any]
      // let searchResults = dictResponse["hits"] as! [[String:Any]]
      successResponse(dictResponse)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
  }
  
  func getRecommendedProductEANCodesRequest(successResponse:@escaping (_ response:[[String:Any]])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let requestHeader:HTTPHeaders? = ["Authorization": WSUtility.getSifuToken()]
    
    let parameterString = String(format: GET_RECOMMENDED_EANCODES)
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: parameterString, methodName: GET_RECOMMENDED_EANCODES, header: requestHeader, success: { (response) in
      
      if let results = response as? [[String:Any]]{
        var finalResults = [[String: Any]]()
        
        if results.count > 2{
          let tmpArray = results[..<2]
          let newArray = Array(tmpArray)
          finalResults = newArray
        }
        else{
          finalResults = results
        }
        successResponse(finalResults)
      }
      
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  func getRecommendedProductsFromEANCodesRequest(eanString: String, successResponse:@escaping (_ response:[[String:Any]])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let APIName =  (WSUtility.getCountryCode() == "TR") ? GET_RECOMMENDED_PRODUCT_FROM_EAN_CODES_BASE_URL().GET_RECOMMENDED_PRODUCT_FROM_EAN_CODES_OTHERCOUNTRY : GET_RECOMMENDED_PRODUCT_FROM_EAN_CODES_BASE_URL().GET_RECOMMENDED_PRODUCT_FROM_EAN_CODES_DACH
    
    let parameterString = String(format: APIName,WSUtility.getCountryCode(), WSUtility.getLanguageCode(),eanString)
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: parameterString, methodName: "RecommendedProductsfromEANCodes", header: nil, success: { (response) in
      
      if let results = response as? [[String:Any]]{
        successResponse(results)
      }
      
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  func makeRecommendedRecipeCatlogRequest(methodName:String, skip:String, take:String , successResponse:@escaping (_ response:[[String:Any]])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let langCode = WSUtility.getLanguageCode()
    let countryCode = WSUtility.getCountryCode()
    
    //    let APIName =  (WSUtility.getCountryCode() == "TR") ? GET_RECOMMENDED_RECIPE_BASE_URL().GET_RECOMMENDED_RECIPE_OtherCountry : GET_RECOMMENDED_RECIPE_BASE_URL().GET_RECOMMENDED_RECIPE_DACH
    let APIName = GET_RECOMMENDED_RECIPE_BASE_URL().GET_RECOMMENDED_RECIPES
    let parameterString = String(format: APIName, countryCode,langCode,skip,take)
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: parameterString, methodName: APIName, header: nil, success: { (response) in
      let dictResponse = response as! [String:Any]
      if dictResponse.count > 0{
        let loyaltyProduct = dictResponse["hits"] as! [[String:Any]]
        successResponse(loyaltyProduct)
      }else{
        successResponse([[String:Any]]())
      }
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  
  // ADMIN PANEL API REQUEST
  
  func getRecommnendedProductListFromAdmin(successResponse:@escaping (_ successMessage:[[String:Any]])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let finalUrl = WSConfigurationFile().getAdminBaseUrl() + "\(GET_RECOMMENDED_PRODUCT_ADMIN)"
    
    webServiceHandler.makeRequestToAdmin(dictParameter: [String:Any](), finalUrl: finalUrl , HttpMethod: "GET", apiMethodName: GET_RECOMMENDED_PRODUCT_ADMIN, success: { (response) in
      
      let dictRecommendedProdcut = response["data"] as! [[String : Any]]
      
      successResponse(dictRecommendedProdcut)
      
    }) { (errorMessage) in
      
      print(errorMessage)
      
      failureResponse(errorMessage)
      
    }
  }
  
  func getTradePartnerBanner(tradePartnerId:String, successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    var tempTradePartnerId = tradePartnerId
    if tempTradePartnerId.count == 0{
      tempTradePartnerId = "652"
    }
    
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    let finalUrl = WSConfigurationFile().getAdminBaseUrl() + "\(GET_TRADEPARTNER_BANNER_ADMIN)?" + "tradepartner_id=\(tempTradePartnerId)&" + "email_id=\(emailID)"
    
    webServiceHandler.makeRequestToAdmin(dictParameter: [String:Any](), finalUrl: finalUrl , HttpMethod: "GET", apiMethodName: GET_TRADEPARTNER_BANNER_ADMIN, success: { (response) in
      
      let dictRecommendedProdcut = response["data"] as! [String : Any]
      WSCacheSingleton.shared.cache.setObject(dictRecommendedProdcut as AnyObject, forKey: (Cached_TradePartner_Banner as NSString))
      successResponse(dictRecommendedProdcut)
      
    }) { (errorMessage) in
      
      print(errorMessage)
      
      failureResponse(errorMessage)
      
    }
  }
  
  func getCallSalesRepImage(successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void){
    
    var zipCode = WSUtility.getValueFromUserDefault(key: USER_ZIP_CODE)
    if  zipCode.count == 0 || zipCode == "<null>"  {
      zipCode = Default_ZIP_CODE
    }
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let finalUrl = WSConfigurationFile().getAdminBaseUrl() + "\(GET_SALES_REP_ADMIN)?" + "zip_code=\(zipCode)"
    
    webServiceHandler.makeRequestToAdmin(dictParameter: [String:Any](), finalUrl: finalUrl, HttpMethod: "GET", apiMethodName: GET_SALES_REP_ADMIN, success: {(response) in
      
      //let dictSalesRepImage = response["slrep_image"] as! [String : Any]
      successResponse(response)
      
    }) { (errorMessage) in
      
      print(errorMessage)
      
      failureResponse(errorMessage)
    }
  }
  
  func getRecipeToSwipe(successResponse:@escaping (_ successMessage:[WSRecipeModal])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let finalUrl = WSConfigurationFile().getAdminBaseUrl() + "\(RECIPE_SWIPE_API)?" + "email_id=\(emailID)"
    
    webServiceHandler.makeRequestToAdmin(dictParameter: [String:Any](), finalUrl: finalUrl , HttpMethod: "GET", apiMethodName: RECIPE_SWIPE_API, success: { (response) in
      
      let dictRecommendedProdcut = response["data"] as! [[String : Any]]
      let modal:[WSRecipeModal] =   WSRecipeModal.parseRecipesDetail(dictRecipes: dictRecommendedProdcut)
      successResponse(modal)
      
    }) { (errorMessage) in
      
      print(errorMessage)
      
      failureResponse(errorMessage)
      
    }
  }
  
  func getAllRecipe(forPage currentPage:String, successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let finalUrl = WSConfigurationFile().getAdminBaseUrl() + "\(GET_RECIPE_API)?" + "email_id=\(emailID)&page=\(currentPage)"
    
    webServiceHandler.makeRequestToAdmin(dictParameter: [String:Any](), finalUrl: finalUrl , HttpMethod: "GET", apiMethodName: GET_RECIPE_API, success: { (response) in
      
      
      let dictRecommendedProduct = response["data"] as! [String : Any]
      //let dict =  dictRecommendedProduct["data"]
      successResponse(dictRecommendedProduct)
      
    }) { (errorMessage) in
      
      print(errorMessage)
      
      failureResponse(errorMessage)
      
    }
  }
  
  func getMyRecipes(successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let finalUrl = WSConfigurationFile().getAdminBaseUrl() + "\(MY_RECIPES_API)?" + "email_id=\(emailID)"
    
    webServiceHandler.makeRequestToAdmin(dictParameter: [String:Any](), finalUrl: finalUrl , HttpMethod: "GET", apiMethodName: MY_RECIPES_API, success: { (response) in
      
      if let tempResp1 = response["data"] {
        if let myRecipeArray = tempResp1 as? Array<Any>, myRecipeArray.count == 0  {
          
          successResponse(["NoData":"True"])
        }
        else {
          let dictRecommendedProdcut = response["data"] as! [String : Any]
          successResponse(dictRecommendedProdcut)
        }
      }
      
    }) { (errorMessage) in
      
      print(errorMessage)
      
      failureResponse(errorMessage)
      
    }
  }
  
  func getRecommendedRecipeFromAdmin(successResponse:@escaping (_ successMessage:[[String:Any]])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let finalUrl = WSConfigurationFile().getAdminBaseUrl() + "\(GET_RECOMMENDE_RECIPE)"
    
    webServiceHandler.makeRequestToAdmin(dictParameter: [String:Any](), finalUrl: finalUrl , HttpMethod: "GET", apiMethodName: GET_RECOMMENDE_RECIPE, success: { (response) in
      
      let dictRecommendedProdcut = response["data"] as! [[String : Any]]
      successResponse(dictRecommendedProdcut)
      
    }) { (errorMessage) in
      
      print(errorMessage)
      
      failureResponse(errorMessage)
      
    }
  }
  
  func favouriteUnfavouriteFromAdmin(parameterDict: [String:Any],successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    var requestDict = [String :Any]()
    requestDict = parameterDict
    
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    let recipeCode = (parameterDict["recipe_code"]!)
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let APIName = ((requestDict["ISFavorite"] as? Bool) == true) ? Recipe_FAVORITE_API : Recipe_UNFAVORITE_API
    
    let finalUrl = WSConfigurationFile().getAdminBaseUrl() + "\(APIName)?" + "email_id=\(emailID)&recipe_code=\(recipeCode)"
    
    webServiceHandler.makeRequestToAdmin(dictParameter:[String:Any](), finalUrl: finalUrl , HttpMethod: "GET", apiMethodName: APIName, success: { (response) in
      
      successResponse(response as AnyObject)
      
    }) { (errorMessage) in
      
      print(errorMessage)
      
      faliureResponse(errorMessage)
      
    }
    
  }
  
  func getGoalProductDetail(prodcutEanCode:String, successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let langCode = WSUtility.getLanguageCode()
    let countryCode = WSUtility.getCountryCode()
    
    let APIName =  (WSUtility.getCountryCode() == "TR") ? GOAL_PRODUCT_DETAIL_BASE_URL().Goal_Product_Detail_OTHERCOUNTRY : GOAL_PRODUCT_DETAIL_BASE_URL().Goal_Product_Detail_DACH
    
    let parameterString = String(format: APIName, countryCode,langCode,prodcutEanCode)
    
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: parameterString, methodName: APIName, header: nil, success: { (response) in
      let dictResponse = response as! [String:Any]
      successResponse(dictResponse)
    }) { (errorMessage) in
      failureResponse(errorMessage)
    }
    
  }
  
  func setDeliveryMode(params:[String: Any],successResponse :@escaping (_ response: AnyObject)-> Void, faliureResponse :@escaping (_ errorMessage :String) -> Void)    {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    webServiceHandler.makePutRequest(dictParameter: params, methodName: "setDeliveryMode", success: { (response) in
      
      successResponse(response as AnyObject)
      
    }, faliure: { (errorMessage) in
      
      faliureResponse(errorMessage)
      
    })
    
  }
  
  //    func addPaymentDetails(successResponse:@escaping (_ successMessage:[[String:Any]])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void){
  //        let email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
  //        let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
  //        let finalUrl = BASE_URL_HYBRIS + String(ADD_PAYMENT_DETAILS,email_id,cart_id)
  //        let header:HTTPHeaders? = ["Authorization": UserDefaults().value(forKey: "SIFU_TOKEN_KEY") as! String]
  //
  //        webServiceHandler.POSTRequest(dictParameter: [String:Any](), methodName: "add_payment", header: header, requestURL: finalUrl, success: { (response) in
  //            successResponse(response)
  //        }) { (errorMessage) in
  //            failureResponse(errorMessage)
  //        }
  //    }
  
  func addAddressToCart(params:[String: Any],successResponse:@escaping (_ successMessage:[[String:Any]])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void){
    
    var requestURL = ""
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    let email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    requestURL = "\(WSUtility.getHybrisBaseUrlWithBaseSiteId() + ADD_ADDRESS_TO_CART)" + WSUtility.addVendorIDForTurkey().replacingOccurrences(of: "&", with: "?")
    requestURL = requestURL.replacingOccurrences(of: "email_id", with: "\(email_id)")
    
    Alamofire.request(requestURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header)
      .responseJSON { response in
        print(response.request as Any)  // original URL request
        print(response.response as Any) // URL response
        print(response.result.value as Any)   // result of response serialization
        
        if response.result.isSuccess {
          
          if let responseObject = response.result.value{
            let dictResponse = responseObject as! [String:Any]
            
            if dictResponse["error"] as! Bool == false{
              
              successResponse([dictResponse] )
              
            }else{
              failureResponse("No data found")
            }
          }
          
        }else{
          
          failureResponse(response.error!.localizedDescription)
        }
    }
    
  }
  
  func getCartId(successResponse :@escaping (_ response: AnyObject)-> Void, failureResponse :@escaping (_ errorMessage :String) -> String)
  {
    //hybris token---6943a547-9995-4996-a4d6-b669e7f0897e
    var requestURL = ""
    //        var header = [String: String]()
    //        header.updateValue("Bearer" + getHybrisToken(), forKey: "Authorization")
    //        header.updateValue("application/json", forKey: "Content-type")
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    let email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    requestURL = "\(WSUtility.getHybrisBaseUrlWithBaseSiteId() + GET_CART_ID)" + WSUtility.addVendorIDForTurkey()
    requestURL = requestURL.replacingOccurrences(of: "email_id", with: "\(email_id)")
    Alamofire.request(requestURL, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: header)
      .responseJSON { response in
        print(response.request as Any)  // original URL request
        print(response.response as Any) // URL response
        print(response.result.value as Any)   // result of response serialization
        
        
        if response.result.isSuccess {
          
          if let responseObject = response.result.value{
            let dictResponse = responseObject as! [String:Any]
            //                        return response.result.value
            if dictResponse["error"] as! Bool == false{
              
              successResponse(dictResponse as AnyObject )
              
            }else{
              failureResponse("No data found")
            }
            
          }
          
        }else{
          
          failureResponse(response.error!.localizedDescription)
        }
    }
  }
  
  
  func addToCart(product:String,cart_id:String,successResponse :@escaping (_ response: AnyObject)-> Void, failureResponse :@escaping (_ errorMessage :String) -> Void){
    
    var requestURL = ""
    let params = [
      "product":[
        "code":product
      ]
    ]
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    let email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    requestURL =  ADD_TO_CART
    requestURL = requestURL.replacingOccurrences(of: "email_id", with: "\(email_id)")
    requestURL = requestURL.replacingOccurrences(of: "cart_id", with: "\(cart_id)")
    requestURL = requestURL.replacingOccurrences(of: "SIFU_TOKEN_ID", with: WSUtility.getSifuToken())
    
    
    let requestUrl = "\(WSUtility.getHybrisBaseUrlWithBaseSiteId())\(requestURL)" + WSUtility.addVendorIDForTurkey()
    
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter: params, methodName: ADD_TO_CART, header: header, requestURL: requestUrl, success: { (response) in
      successResponse(response)
    }) { (errorMessage) in
      failureResponse(errorMessage)
    }
    
  }
  
  func reOrderToCart(product:String,cart_id:String,products:[String: Any],successResponse :@escaping (_ response: AnyObject)-> Void, failureResponse :@escaping (_ errorMessage :String) -> Void){
    
    var requestURL = ""
    //let params = ["":""]
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    let email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    requestURL =  REORDER_TO_CART
    requestURL = requestURL.replacingOccurrences(of: "email_id", with: "\(email_id)")
    requestURL = requestURL.replacingOccurrences(of: "cart_id", with: "\(cart_id)")
    //requestURL = requestURL.replacingOccurrences(of: "pid", with: "\(product_id)")
    requestURL = requestURL.replacingOccurrences(of: "SIFU_TOKEN_ID", with: WSUtility.getSifuToken())
    let requestUrl = "\(WSUtility.getHybrisBaseUrlWithBaseSiteId())\(requestURL)" + WSUtility.addVendorIDForTurkey()
    
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter: products, methodName: ADD_TO_CART, header: header, requestURL: requestUrl, success: { (response) in
      successResponse(response)
    }) { (errorMessage) in
      failureResponse(errorMessage)
    }
  }
  
  func addQtyProductToCart(product:String,cart_id:String,product_qty:String,successResponse :@escaping (_ response: AnyObject)-> Void, failureResponse :@escaping (_ errorMessage :String) -> Void){
    
    var requestURL = ""
    let params = [
      "product":[
        "code":product
      ],
      "quantity":product_qty
      ] as [String : Any]
 
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    let email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    requestURL =  ADD_PRODUCT_WITHQTY_TO_CART
    requestURL = requestURL.replacingOccurrences(of: "email_id", with: "\(email_id)")
    requestURL = requestURL.replacingOccurrences(of: "cart_id", with: "\(cart_id)")
    requestURL = requestURL.replacingOccurrences(of: "token", with: "\(WSUtility.getSifuToken())")
    
    let requestUrl = "\(WSUtility.getHybrisBaseUrlWithBaseSiteId())\(requestURL)" + WSUtility.addVendorIDForTurkey()
   
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter: params, methodName: ADD_TO_CART, header: header, requestURL: requestUrl, success: { (response) in
      successResponse(response)
    }) { (errorMessage) in
      failureResponse(errorMessage)
    }
  }
  

  func getProductsForSubCategory(queryWithID: String,pageNumber page:String,successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    let finalParameter = String(format:PRODUCTLIST_FOR_SUB_CATEGORY,"\(email_id)",queryWithID,page,WSUtility.getLanguageCode())

    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    webServiceHandler.GETRequestWithJsonResponseForHybris(requestParameter: finalParameter, params: nil, methodName: "ProductsListForCategory", HttpMethod: "GET", header: header, success: { (response) in
        print(response)
        
        successResponse(response as! [String: Any])
        
    }) { (errorMessage) in
        print(errorMessage)
        
        failureResponse(errorMessage)
    }

  }
  
  func getProductListFromHybris(queryWithID: String,pageNumber page:String,successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    let finalParameter = String(format:GET_PRODUCTLIST_HYBRIS,"\(email_id)",queryWithID,page,WSUtility.getLanguage())
    
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.GETRequestWithJsonResponseForHybris(requestParameter: finalParameter, params: nil, methodName: GET_PRODUCTLIST_HYBRIS   , HttpMethod: "GET", header: header, success: { (response) in
        print(response)
        
        successResponse(response as! [String: Any])
        
    }) { (errorMessage) in
        print(errorMessage)
        
        failureResponse(errorMessage)
    }
    

  }
  
  func getDoubleLoyaltyProductListFromHybris(queryWithID: String,pageNumber page:String,successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let finalParameter = String(format:GET_DOUBLE_PRODUCTLIST_HYBRIS,queryWithID)
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.GETRequestWithJsonResponseForHybris(requestParameter: finalParameter, params: nil, methodName: GET_PRODUCTLIST_HYBRIS, HttpMethod: "GET", header: nil, success: { (response) in
      print(response)
      
      successResponse(response as! [String: Any])
      
    }) { (errorMessage) in
      print(errorMessage)
      
      failureResponse(errorMessage)
    }
  }
  
  func getDoubleLoyaltyProductListFromSifu(successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let siteCode = WSUtility.getValueFromUserDefault(key: "Site")
    let requestParameter = String(format:Double_Loyalty_Product_Sifu,siteCode)
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: requestParameter, methodName: Double_Loyalty_Product_Sifu, header: nil, success: { (response) in
      
      successResponse(response as! [String:Any])
      
    }) { (errorMessage) in
      failureResponse(errorMessage)
    }
  }
  
  func getProductDetailFromSifu(productNumber:String,successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    // WSUtility.getLanguageCode()
    let APIName =  (WSUtility.getCountryCode() == "TR") ? Product_Detail_BY_Number_BASE_URL().Product_Detail_BY_Number_OtherCountry_API : Product_Detail_BY_Number_BASE_URL().Product_Detail_BY_Number_DACH_API
    let requestParameter = String(format:APIName,WSUtility.getCountryCode(),WSUtility.getLanguageCode(),productNumber)
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: requestParameter, methodName: APIName, header: nil, success: { (response) in
      
      successResponse(response as! [String:Any])
      
    }) { (errorMessage) in
      failureResponse(errorMessage)
    }
  }
  
  func addUserToAdminPanel(params:[String: Any],actionType:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    var parameterDict = [String: Any]()
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let osVersion = UIDevice.current.systemVersion
    let modelName = UIDevice.current.model
    let emailID = UserDefaults.standard.value(forKey: "UserEmailId") as! String
    
    let countryCode = WSUtility.getCountryCode()
    
    if actionType == "login" {
      
      parameterDict["email"] = emailID
      parameterDict["device_token"] = params["deviceToken"]
      parameterDict["fcm_token"] = params["fcm_token"]
      
      
      parameterDict["device_os_version"] = osVersion
      parameterDict["device_model"] = modelName
      parameterDict["device_os"] = "iOS"
      
      parameterDict["action"] = "login"
      parameterDict["country_code"] = countryCode
      parameterDict["pin_code"] = "1001"
      
    }
    else if actionType == "updateFcm" {
      
      parameterDict["email"] = emailID
      parameterDict["device_token"] = params["deviceToken"]
      parameterDict["fcm_token"] = params["fcm_token"]
      
      parameterDict["device_os_version"] = osVersion
      parameterDict["device_model"] = modelName
      parameterDict["device_os"] = "iOS"
      
      parameterDict["action"] = "login"
      parameterDict["country_code"] = countryCode
      parameterDict["pin_code"] = params["pin_code"]
    }
    else if actionType == "update" {
      
      parameterDict["email"] = emailID
      parameterDict["device_token"] = params["deviceToken"]
      
      parameterDict["device_os_version"] = osVersion
      parameterDict["device_model"] = modelName
      parameterDict["device_os"] = "iOS"
      
      parameterDict["action"] = "update"
      parameterDict["first_name"] = params["firstName"]
      parameterDict["last_name"] = params["lastName"]
      parameterDict["bt_id"] = params["bt_id"]
      parameterDict["business_code"] = params["bt_id"]
      parameterDict["business_name"] = params["business_name"]
      parameterDict["pin_code"] = params["pin_code"]
      parameterDict["country_code"] = countryCode
      let tradePartnerID = WSUtility.getValueFromUserDefault(key: TRADE_PARTNER_ID)
      parameterDict["tp_id"] = tradePartnerID
      if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
        parameterDict["is_dto_user"] = "1"
      }
      else{
        parameterDict["is_dto_user"] = "0"
      }
    }
    else{
      
      let firstName =  WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "FirstName"))
      let lastName =  WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "LastName"))
      
      // let BusinessType =  WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "BusinessType"))
      parameterDict["email"] = emailID
      parameterDict["device_token"] = params["deviceToken"]
      
      parameterDict["device_os_version"] = osVersion
      parameterDict["device_model"] = modelName
      parameterDict["device_os"] = "iOS"
      
      
      parameterDict["first_name"] = firstName
      parameterDict["last_name"] = lastName
      parameterDict["country_code"] = countryCode
      parameterDict["pin_code"] = "1001"
      //parameterDict["i_work_in"] = BusinessType
      parameterDict["action"] = "create"
      parameterDict["bt_id"] = params["businessCode"]
      parameterDict["business_code"] = params["businessCode"]
      parameterDict["business_name"] = params["business_name"]
        
      parameterDict["age_verification"] = params["age_verification"]
      parameterDict["news_letter_opt_in"] = params["news_letter_opt_in"]
      parameterDict["promotion_opt_in"] = params["promotion_opt_in"]
      parameterDict["event_opt_in"] = params["event_opt_in"]
      
      if let tradeID = UserDefaults.standard.value(forKey: "TradePartnerID"){
        parameterDict["tp_id"] = "\(String(describing: tradeID))"
      }
      else{
        parameterDict["tp_id"] = "651"
      }
    }
    
    let baseURL = WSConfigurationFile().getAdminBaseUrl() + UPDATE_USER_INFO
    
    webServiceHandler.makeRequestToAdmin(dictParameter: parameterDict, finalUrl: baseURL, HttpMethod: "POST",  apiMethodName: UPDATE_USER_INFO, success: { (dictResponse) in
      
      if let tempDictResponse = dictResponse["data"] as? [Any], tempDictResponse.count>0{
        
        let homeScreenWidgetContents = tempDictResponse[0] as! [String:Any]
        
        //            let first_name = homeScreenWidgetContents["first_name"] as! String
        //            let last_name = homeScreenWidgetContents["last_name"] as! String
        //
        ////            UserDefaults.standard.set(first_name, forKey: "FirstName")
        ////            UserDefaults.standard.set(last_name, forKey: "LastName")
        
        if let profileImageUrl = homeScreenWidgetContents["profile_image"]{
          UserDefaults.standard.set(profileImageUrl, forKey: USER_PROFILE_IMAGE_URL)
        }
      }
      successResponse(dictResponse as AnyObject)
    }) { (errorMessage) in
      
      print(errorMessage)
      
      faliureResponse(errorMessage)
      
    }
    
  }
  func removeUserPicFromAdminPanel(successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let emailID = UserDefaults.standard.value(forKey: "UserEmailId") as! String
    let parameterDict = ["email_id":emailID]
    
    let baseURL = WSConfigurationFile().getAdminBaseUrl() + REMOVE_USER_PIC
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.makeRequestToAdmin(dictParameter: parameterDict, finalUrl: baseURL, HttpMethod: "POST",  apiMethodName: REMOVE_USER_PIC, success: { (dictResponse) in
      
      successResponse(dictResponse as AnyObject)
    }) { (errorMessage) in
      
      print(errorMessage)
      
      faliureResponse(errorMessage)
      
    }
    
  }
  
  func updateUserLoggedInOrLogoutToAdminPanel(statusValue: Int,successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    guard let emailID = UserDefaults.standard.value(forKey: "UserEmailId") as? String else {
      return
    }
    let parameterDict = ["email_id":emailID, "status":statusValue] as [String : Any]
    
    let baseURL = WSConfigurationFile().getAdminBaseUrl() + UPDATELOGIN_OR_LOGGEDOUT_TO_ADMIN
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.makeRequestToAdmin(dictParameter: parameterDict, finalUrl: baseURL, HttpMethod: "POST",  apiMethodName: UPDATELOGIN_OR_LOGGEDOUT_TO_ADMIN, success: { (dictResponse) in
      
      successResponse(dictResponse as AnyObject)
    }) { (errorMessage) in
      
      print(errorMessage)
      
      faliureResponse(errorMessage)
      
    }
    
  }
  func getMainCategories(successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    //let email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.GETRequestWithJsonResponseForHybris(requestParameter: "", params: nil, methodName: MAIN_CATEGORIES_API, HttpMethod: "GET", header: nil, success: { (response) in
      print(response)
      successResponse(response as! [String : Any])
      
    }) { (errorMessage) in
      print(errorMessage)
      
      failureResponse(errorMessage)
    }
  }
  
  func getUserDetailsFromAdmin(successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let header:HTTPHeaders =  [WSConfigurationFile().getAdminHeaderSecretKey():WSConfigurationFile().getAdminHeaderSecretValue()]
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: "\(email_id)", methodName: GET_USER_INFO, header: header, success: { (response) in
      print(response)
      successResponse(response as! [String: Any])
    }) { (errorMessage) in
      print(errorMessage)
      failureResponse(errorMessage)
    }
  }
  
  func getBusinessTypesFromAdmin(successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let requestURL:String = "\(WSConfigurationFile().getAdminBaseUrl())\(GET_BUSINESS_TYPES)"
    webServiceHandler.makeRequestToAdmin(dictParameter: [String:Any](), finalUrl: requestURL, HttpMethod: "GET", apiMethodName: GET_BUSINESS_TYPES, success: { (response) in
      successResponse(response)
    }) { (errorMessage) in
      failureResponse(errorMessage)
    }
  }
  func getProductDetail(productID:String,successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    let email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let parameterString = String(format: HYB_PROUCT_DETAIL,"\(email_id)", productID, WSUtility.getLanguage())
    webServiceHandler.GETRequestWithJsonResponseForHybris(requestParameter: parameterString, params: nil, methodName: HYB_PROUCT_DETAIL, HttpMethod: "GET", header: header, success: { (response) in
      print(response)
      successResponse(response as! [String: Any])
      
    }) { (errorMessage) in
      print(errorMessage)
      
      failureResponse(errorMessage)
    }
    
  }
  
  func settradePartner(productID:String,successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let APIMethodName = "SetVendor"
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    webServiceHandler.GETRequestWithJsonResponseForHybris(requestParameter: productID, params: nil, methodName: APIMethodName, HttpMethod: "POST", header: header, success: { (response) in
      print(response)
      let responseParams = [
        "product": response
      ]
      successResponse(responseParams)
    }) { (errorMessage) in
      print(errorMessage)
      
      failureResponse(errorMessage)
    }
    
  }
  
  func setdeliveryAdd(productID:String,params:NSDictionary,successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let requestUrl = "\(WSUtility.getHybrisBaseUrlWithBaseSiteId())\(productID)"
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    
    let reqParams =   [
      "firstName":params["firstName"] as! NSString,
      "lastName":params["lastName"] as! NSString,
      "titleCode":"mr",
      "line1":params["line1"] as! NSString,
      "line2":params["line2"] as! NSString,
      "town":params["town"] as! NSString,
      "postalCode":params["postalCode"] as! NSString,
      "phone":params["phone"] as! NSString,
      "companyName":params["companyName"] as! NSString,
      "country":[
        "isocode": "AT"
      ],
      "region":[
        "isocode":"AT-1"
      ]
      ] as [String : Any]
    
    webServiceHandler.POSTRequest(dictParameter: reqParams, methodName: "", header: header, requestURL: requestUrl, success: { (response) in
      successResponse(response as! [String : Any])
    }) { (errorMessage) in
      failureResponse(errorMessage)
    }
    
  }
  
  func setdeliveryDetails(params:[String:Any],selectedVendorId:String,successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    let cartID = params["Cart_ID"] as! String
    let date = params["Date"] as! String
    let deliveryNotes = params["deliveryNotes"] as! String
    let requestParam = String(format: ADD_DELIVERY_DETAILS, emailID,cartID,deliveryNotes,date)
    let requestUrl = "\(WSUtility.getHybrisBaseUrlWithBaseSiteId())\(requestParam) + &vendorId=\(selectedVendorId)"
    
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    if let encodedUrl = requestUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
      let _ = URL(string: encodedUrl) {
      
      webServiceHandler.POSTRequest(dictParameter: [String:Any](), methodName: ADD_DELIVERY_DETAILS, header: header, requestURL: encodedUrl, success: { (response) in
        successResponse(response as! [String : Any])
      }) { (errorMessage) in
        failureResponse(errorMessage)
      }
      
    }
    
  }
  
  func putAddressToCart(productID:String,successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let APIMethodName = "deliverymode"
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    webServiceHandler.PUTRequestWithJsonResponseForHybris(requestParameter: productID, params: nil, methodName: APIMethodName, HttpMethod: "PUT", header: header, success: { (response) in
      print(response)
      successResponse(response as! [String: Any])
      
    }) { (errorMessage) in
      print(errorMessage)
      
      failureResponse(errorMessage)
    }
    
  }
  
  
  func postPaymentAndBilling(productID:String,params:NSDictionary,successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let requestUrl = "\(WSUtility.getHybrisBaseUrlWithBaseSiteId())\(productID)"
    //let parameterString = ""
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    
    let reqParams =   [
      "accountHolderName":"John Doe",
      "cardNumber":"4111111111111111",
      "cardType":[
        "code":"visa"
      ],
      "expiryMonth":"01",
      "expiryYear":"2017",
      "defaultPayment":true,
      "billingAddress":[
        
        "firstName":params["firstName"] as! NSString,
        "lastName":params["lastName"] as! NSString,
        "titleCode":"mr",
        "line1":params["line1"] as! NSString,
        "line2":params["line2"] as! NSString,
        "town":params["town"] as! NSString,
        "postalCode":params["postalCode"] as! NSString,
        "phone":params["phone"] as! NSString,
        "companyName":params["companyName"] as! NSString,
        "country":[
          "isocode": "AT"
        ],
        "region":[
          "isocode":"AT-1"
        ]
      ]
      ] as [String : Any]
    
    
    webServiceHandler.POSTRequest(dictParameter: reqParams, methodName: "", header: header, requestURL: requestUrl, success: { (response) in
      successResponse(response as! [String : Any])
    }) { (errorMessage) in
      failureResponse(errorMessage)
    }
    
  }
  
  
  func placePostOrder(productID:String,orderInfoDetail:[String:Any],successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let parameterString = PLACE_ORDER
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    let country_code = WSUtility.getCountryCode()
    let confirmedOptIn = UserDefaults.standard.bool(forKey: "confirmedOptIn")
    let newsletterOptIn = UserDefaults.standard.bool(forKey: "newsletterOptIn")
    let oldNewsletterOptIn = UserDefaults.standard.bool(forKey: "oldNewsletterOptIn")
    let confirmedNewsletterOptIn = UserDefaults.standard.bool(forKey: "confirmedNewsletterOptIn")
    
    var bodyparams: [String: Any] = ["confirmedOptIn":confirmedOptIn,
                                     "newsletterOptIn":newsletterOptIn,
                                     "oldNewsletterOptIn":oldNewsletterOptIn,
                                     "confirmedNewsletterOptIn":confirmedNewsletterOptIn,
                                     "securityCode":"123",
                                     "locale":"\(WSUtility.getLanguage() + country_code)",
      "site":"\(UserDefaults.standard.value(forKey: "Site")!)",
      "languageCode":WSUtility.getLanguage(),
      "countryCode":country_code,
      "sifuToken":"\(WSUtility.getSifuToken())"]
    
    if orderInfoDetail["PaymentMode"] as! String == "payu"{
      let payUDict = WSPayURequestModel().createRequestModelForPayU(orderInfo: orderInfoDetail)
      bodyparams["payUPaymentInfoWsDTO"] = payUDict
    }else if orderInfoDetail["PaymentMode"] as! String == "iban"{
      let IBANDict = WSIBANRequestModel().creatRequestModelForIBAN(IBANDictInfo: orderInfoDetail)
      bodyparams["ibanWsDTO"] = IBANDict
    }
    
    
   // let reqUrl = WSUtility.getHybrisBaseUrlWithBaseSiteId() + "\(productID)" + WSUtility.addVendorIDForTurkey()
     let reqUrl = WSUtility.getHybrisBaseUrlWithBaseSiteId() + "\(productID)" + "&vendorId=\(orderInfoDetail["VendorID"]!)"
    webServiceHandler.POSTRequest(dictParameter: bodyparams, methodName: parameterString, header: header, requestURL: reqUrl, success: { (response) in
      print(response)
      successResponse(response as! [String: Any])
      
    }) { (errorMessage) in
      print(errorMessage)
      
      failureResponse(errorMessage)
    }
  }
  
  func placeSampleOrder(postURL:String,params:[[String: Any]],successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let parameterString = CHECKOUT_SAMPLEORDER
    //  let header:HTTPHeaders? = ["Authorization": WSUtility.getSifuToken(),"Content-Type":"application/json","x-api-key": SIFU_PUBLIC_API_KEY]
    let reqUrl =  WSConfigurationFile().getSifuBaseUrl() + "order/sampleorder"  //postURL // productID+"&authToken=\(WSUtility.getSifuToken())"
    let priceDict = params[2]["price"] as! [NSString:AnyObject]
    let value = priceDict["value"] as! NSNumber
    
    var productNumber = ""
    if let id = (params[2]["number"] as? NSString) {
      productNumber = id as String
    }
    
    var sampleID = ""
    if let id = (params[3]["sampleId"] as? NSString) {
      sampleID = id as String
    }
    
    var imageUrl = ""
    if let tempImageArray = (params[2]["pictures"] as? [[String:Any]]){
      if tempImageArray.count > 0{
        if let otherImageUrl = tempImageArray[0]["imageUrl"] as? String{
          imageUrl = otherImageUrl
        }
      }
    }
    
    print(sampleID)
    
    let reqParams =   [
      "quantity":1,
      "productNumber":productNumber,
      "dataSourceId":productNumber,
      "url":imageUrl,
      "sampleId":sampleID,
      "orderContext":"Appshop",
      "productName":params[2]["name"] as! NSString,
      "productPrice":String(describing: value),
      "termsAndConditions":false,
      "activationSampleToken":"",
      "type":"SAMPLE",
      "languageCode":WSUtility.getLanguageCode(),
      "firstName":params[0]["firstName"] as! NSString,
      "lastName":params[0]["lastName"] as! NSString,
      "email":params[0]["email"] as! NSString,
      "site":WSUtility.getSiteCode(),
      "mobilePhone":params[0]["mobileNumber"] as! NSString,
      "phoneNumber":"",
      "gender":"",
      "countryCode":WSUtility.getCountryCode(),
      "businessName":params[1]["businessName"] as! NSString,
      "houseNumber":params[1]["buildingNo"] as! NSString,
      "street":params[1]["streetName"] as! NSString,
      "city":params[1]["city"] as! NSString,
      "zipCode":params[1]["postalCode"] as! NSString,
      "typeOfBusiness":"",
      "typeOfCuisine":"",
      "jobTitle":""
      ] as [String : Any]
    
    print(reqParams)
    
    let requestHeader:HTTPHeaders? = ["Authorization": WSUtility.getSifuToken(),"Content-Type":"application/json"]
    
    webServiceHandler.POSTRequest(dictParameter: reqParams, methodName: parameterString, header: requestHeader, requestURL: reqUrl, success: { (response) in
      print(response)
      let res = [String: Any]()
      successResponse(res)
      
    }) { (errorMessage) in
      print(errorMessage)
      
      failureResponse(errorMessage)
    }
    
  }
  
  
  func getRecipeDetailsRequest(recipeCode:String,methodName:String , successResponse:@escaping (_ response:([UFSRecipeDetailPreparation],[UFSRecipeDetailIngredients],[UFSRecipeDetailAllIngredients]))-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    
    let parameterString = "\(GET_RECIPE_DETAILS)"+"\(recipeCode)"
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: parameterString, methodName: GET_RECIPE_DETAILS, header: nil, success: { (response) in
      
      let combinedPreparationAndIngredientList = UFSParseRecipeDetailResponse.parseRecipeDetailResponse(responseDict: response as! [String : Any])
      
      successResponse(combinedPreparationAndIngredientList)
      
    }, faliure: { (errorMessage) in
      
      faliureResponse(errorMessage)
      
    })
    
  }
  
  func getRecipeCodeRequest(recipeNumber:String,methodName:String , successResponse:@escaping (_ recipeFullCode:[String:String])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    
    let countryCode =  WSUtility.getCountryCode()
    let languageCode = WSUtility.getLanguageCode()
    
    let parameterString = String(format: GET_RECIPE_CODE, countryCode,languageCode,recipeNumber)
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: parameterString, methodName: GET_RECIPE_CODE, header: nil, success: { (response) in
      
      let dictResponse = response as! [String:Any]
      let recipeCode = dictResponse["code"] as! String
      let recipeImageUrl = dictResponse["imageUrl"] as! String
      let title = dictResponse["name"] as! String
      
      let dictRecipeInfo = ["recipe_code":recipeCode, "banner_image":recipeImageUrl, "title":title]
      successResponse(dictRecipeInfo)
      
    }, faliure: { (errorMessage) in
      
      faliureResponse(errorMessage)
      
    })
    
  }
  
  func getFilterKeywordsForRecipes(successResponse:@escaping (_ response:[[String: Any]])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let countryCode =  WSUtility.getCountryCode()
    let languageCode = WSUtility.getLanguageCode()
    
    let parameterString = String(format: GET_FILTER_KEYWORDS_FOR_RECIPES, countryCode,languageCode)
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: parameterString, methodName: GET_FILTER_KEYWORDS_FOR_RECIPES, header: nil, success: { (response) in
      
      successResponse(response as! [[String : Any]])
      
    }, faliure: { (errorMessage) in
      
      faliureResponse(errorMessage)
      
    })
    
  }
  func getFilteredRecipeList(forPage currentPage:String ,recipeFilterStr:String,successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let finalUrl = WSConfigurationFile().getAdminBaseUrl() + "\(FILTER_RECIPES_LIST)?" + "email_id=\(emailID)" + "&sub_key=\(recipeFilterStr)" + "&page=\(currentPage)"
    
    webServiceHandler.makeRequestToAdmin(dictParameter: [String:Any](), finalUrl: finalUrl , HttpMethod: "GET", apiMethodName: FILTER_RECIPES_LIST, success: { (response) in
      
      let dictRecommendedProduct = response["data"] as! [String : Any]
      //let dict =  dictRecommendedProduct["data"]
      successResponse(dictRecommendedProduct)
      
    }) { (errorMessage) in
      
      print(errorMessage)
      
      failureResponse(errorMessage)
      
    }
  }
  
  func getTradePartnerLocation(parameter:[String:Any],methodName:String , successResponse:@escaping (_ response:[Any])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let header:HTTPHeaders? = ["Content-Type":"application/json"]
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.GETRequestWithJsonResponse(requestParameter:parameter["tradePartnerId"] as! String, methodName: methodName, header: header, success: { (response) in
      successResponse((response as! [Any]))
    }, faliure: { (errorMessage) in
      faliureResponse(errorMessage)
    })
  }
  
  
  func createOrUpdateOrMakeDefalutTradePartner(parameter:[String:Any],methodName:String , successResponse:@escaping (_ response: String)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let siteCode = UserDefaults.standard.value(forKey: "Site")!
    
    let requestUrl = "\(WSConfigurationFile().getSifuBaseUrl())\(CREATE_UPDATE_MAKE_DEFALUT_TRADEPARTNER_API)?setDefault=\(parameter["makeDefalut"]!)&parentTradePartnerId=\(parameter["parentTpId"]!)&tradePartnerId=\(parameter["tplocationID"]!)&clientNumber=\(parameter["accountNumber"]!)&ecomUserTradePartnerId=\(parameter["ecomUserTPId"]!)&siteCode=\(siteCode)"
    
    let requestHeader:HTTPHeaders? = ["Authorization": WSUtility.getSifuToken(),"Content-Type":"application/json"]
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter: [String:Any](), methodName: CREATE_UPDATE_MAKE_DEFALUT_TRADEPARTNER_API, header: requestHeader, requestURL: requestUrl, success: { (response) in
      
      successResponse(response as! String)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
  }
  
  func checkUserHasConfirmedVerificationMail(emailID:String, successResponse:@escaping (_ response: [String:Any])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let siteCode = UserDefaults.standard.value(forKey: "Site")!
    let parameterDict = ["username":emailID,"site":siteCode]
    let requestUrl = "\(WSConfigurationFile().getSifuBaseUrl())\(Check_User_Email_Verification)"
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter: parameterDict, methodName: Check_User_Email_Verification, header: nil, requestURL: requestUrl, success: { (response) in
      print("forgotpassword")
      successResponse(response as! [String:Any])
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  
  func resendEmailConfirmationMail(parameterDict:[String:Any], successResponse:@escaping (_ response: [String:Any])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let requestUrl = "\(WSConfigurationFile().getSifuBaseUrl())\(RESEND_VERIFICATION_MAIL)"
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter: parameterDict, methodName: RESEND_VERIFICATION_MAIL, header: nil, requestURL: requestUrl, success: { (response) in
      successResponse(response as! [String:Any])
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  
  func getSampleOrderProductList(successResponse:@escaping (_ response: [[String:Any]])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    //http://sifu.unileversolutions.com/adobecampaign/products/samples?country=AT
    
    let parameterString = String(format: GET_SAMPLE_ORDER,WSUtility.getCountryCode())
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: parameterString, methodName: GET_SAMPLE_ORDER, header: nil, success: { (response) in
      let dictResponse = response as? [[String:Any]]
      successResponse(dictResponse!)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  
  
  
  func getNotificaionListFromAdmin(requestURL:String,successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    var finalUrl:String = ""
    if requestURL == ""{
      finalUrl = "\(WSConfigurationFile().getAdminBaseUrl())\(GET_NOTIFICATION_LIST)?email_id=\(emailID)"
    }else{
      finalUrl = "\(requestURL)"
    }
    webServiceHandler.makeRequestToAdmin(dictParameter: [String:Any](), finalUrl: finalUrl , HttpMethod: "GET", apiMethodName: GET_NOTIFICATION_LIST, success: { (response) in
      successResponse(response)
    }) { (errorMessage) in
      failureResponse(errorMessage)
    }
  }
  
  func getNotificaionReadUnreadCount(successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    let finalUrl:String = "\(WSConfigurationFile().getAdminBaseUrl())\(GET_NOTIFICATION_LIST)?email_id=\(emailID)&read_unread=unread_count"
    
    webServiceHandler.makeRequestToAdmin(dictParameter: [String:Any](), finalUrl: finalUrl , HttpMethod: "GET", apiMethodName: GET_NOTIFICATION_LIST, success: { (response) in
      successResponse(response)
    }) { (errorMessage) in
      failureResponse(errorMessage)
    }
  }
  func sendNotificationStatus(notificationID:Int,notificationTray:Int, successResponse:@escaping (_ response: [String:Any])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let requestUrl = "\(WSConfigurationFile().getAdminBaseUrl())\(SEND_NOTIFICATION_STATUS)"
    
    let parmsDict = ["nid":notificationID,"opened_on_notification_tray":notificationTray]
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    webServiceHandler.makeRequestToAdmin(dictParameter: parmsDict, finalUrl: requestUrl, HttpMethod: "POST",  apiMethodName: SEND_NOTIFICATION_STATUS, success: { (response) in
      successResponse(response)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  
  func sendLastVisitedRecipeStatus(recipe_code:String, successResponse:@escaping (_ response: [String:Any])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    let requestUrl = "\(WSConfigurationFile().getAdminBaseUrl())\(SEND_LAST_VISITED_RECIPE_STATUS)"
    let parmsDict = ["email_id":emailID,"recipe_code":recipe_code]
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    webServiceHandler.makeRequestToAdmin(dictParameter: parmsDict, finalUrl: requestUrl, HttpMethod: "POST",  apiMethodName: SEND_LAST_VISITED_RECIPE_STATUS, success: { (response) in
      successResponse(response)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  
  func triggerAppInstalledPushNotification(action:String) {
    let osVersion = UIDevice.current.systemVersion
    let modelName = UIDevice.current.model
    let requestUrl = "\(WSConfigurationFile().getAdminBaseUrl())\(TRIGGER_PUSH_NOTIFICATION)"
    let header:HTTPHeaders =  [WSConfigurationFile().getAdminHeaderSecretKey():WSConfigurationFile().getAdminHeaderSecretValue()]
    
    let deviceTokenValue = WSUtility.getValueFromUserDefault(key: "DeviceToken")
    
    let parameterDict = ["action":action,"device_token":deviceTokenValue,"device_os":"IOS","device_os_version":osVersion,"device_model":modelName]
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter: parameterDict, methodName: TRIGGER_PUSH_NOTIFICATION, header: header, requestURL: requestUrl, success: { (response) in
        if !UserDefaults.standard.bool(forKey: "PushNotificationSentForFirstInstallation"){
            UserDefaults.standard.set(true, forKey: "PushNotificationSentForFirstInstallation")
        }
    }) { (errorMessage) in
      
    }
  }
  
  func triggerRegistrationPushNotification(action:String, email:String = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY), successResponse:@escaping (_ response: Any)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
    let osVersion = UIDevice.current.systemVersion
    let modelName = UIDevice.current.model
    let requestUrl = "\(WSConfigurationFile().getAdminBaseUrl())\(TRIGGER_PUSH_NOTIFICATION)"
    let header:HTTPHeaders =  [WSConfigurationFile().getAdminHeaderSecretKey():WSConfigurationFile().getAdminHeaderSecretValue()]
    let firstName =  WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "FirstName"))
    
    let deviceTokenValue = WSUtility.getValueFromUserDefault(key: "DeviceToken")
    
    let parameterDict = ["email_id":email,"first_name":firstName,"action":action,"device_token":deviceTokenValue,"device_os":"IOS","device_os_version":osVersion,"device_model":modelName]
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter: parameterDict, methodName: TRIGGER_PUSH_NOTIFICATION, header: header, requestURL: requestUrl, success: { (response) in
      successResponse(response)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
  }
  func triggerOrderPlacedPushNotification(action:String,order_id:String, email:String = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)) {
    
    let requestUrl = "\(WSConfigurationFile().getAdminBaseUrl())\(TRIGGER_PUSH_NOTIFICATION)"
    let header:HTTPHeaders =  [WSConfigurationFile().getAdminHeaderSecretKey():WSConfigurationFile().getAdminHeaderSecretValue()]
    let parameterDict = ["email_id":email,"action":action,"order_id":order_id]
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter: parameterDict, methodName: TRIGGER_PUSH_NOTIFICATION, header: header, requestURL: requestUrl, success: { (response) in
      
    }) { (errorMessage) in
      
    }
  }
  
  func triggerLeavingAppWithoutBuyingNotification(action:String,email:String = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY) ,productNames:String,productCodes:String){
    
    let requestUrl = "\(WSConfigurationFile().getAdminBaseUrl())\(TRIGGER_PUSH_NOTIFICATION)"
    let header:HTTPHeaders =  [WSConfigurationFile().getAdminHeaderSecretKey():WSConfigurationFile().getAdminHeaderSecretValue()]
    let parameterDict = ["email_id":email,"action":action,"product_codes":productCodes,"product_names":productNames] as [String : Any]
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter: parameterDict, methodName: TRIGGER_PUSH_NOTIFICATION, header: header, requestURL: requestUrl, success: { (response) in
      
    }) { (errorMessage) in
      
    }
  }
  
  
  func trackingEvent(event:String,category:String,action:String = "",label:String = "", successResponse:@escaping (_ response: [String:Any])-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    
    let requestUrl = "\(WSConfigurationFile().getAdminBaseUrl())\(SEND_TRACKING_EVENT_API)"
    let parmsDict = ["email":emailID,"country_code":WSUtility.getCountryCode(),"event":event,"category":category, "action":action,"label":label]
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.makeRequestToAdmin(dictParameter: parmsDict, finalUrl: requestUrl, HttpMethod: "POST",  apiMethodName: SEND_TRACKING_EVENT_API, success: { (response) in
      successResponse(response)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  func trackingScreens(screenName:String) {
    if let emailID = UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY) {
      
      let requestUrl = "\(WSConfigurationFile().getAdminBaseUrl())\(TRACK_SAVE_INFO)"
      
      let parmsDict = ["email":emailID,"country_code":WSUtility.getCountryCode(),"screen":screenName,"hit_count":1]
      
      let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
      webServiceHandler.makeRequestToAdmin(dictParameter: parmsDict, finalUrl: requestUrl, HttpMethod: "POST",  apiMethodName: TRACK_SAVE_INFO, success: { (dictResponse) in
        
      }) { (errorMessage) in
        
      }
      
    }
    
  }
  func deleteFavoriteProductFromSifu(productNumber:String,
                                     successResponse:@escaping (_ response: Any)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let header:HTTPHeaders? = ["Authorization":WSUtility.getSifuToken()]
    let requestUrl = "\(WSConfigurationFile().getSifuBaseUrl())\(Delete_Favourite_Item)"
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let dictParameter = ["countryCode":WSUtility.getCountryCode(),"languageCode":"de","productNumber":productNumber]
    
    webServiceHandler.DELETERequest(dictParameter: dictParameter, methodName: Delete_Favourite_Item, header: header, requestURL: requestUrl, success: { (response) in
      successResponse(response)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
  }
  
  func getScanProductDetail(productEanCode:String,successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let parameterString = String(format: HYB_SCAN_PROUCT_DETAIL,"\(email_id)", productEanCode)
    webServiceHandler.GETRequestWithJsonResponseForHybris(requestParameter: parameterString, params: nil, methodName: HYB_SCAN_PROUCT_DETAIL, HttpMethod: "GET", header: header, success: { (response) in
      print(response)
      successResponse(response as! [String: Any])
      
    }) { (errorMessage) in
      print(errorMessage)
      
      failureResponse(errorMessage)
    }
    
  }
  
  func getCartCoupon(successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let requestUrl = "\(WSConfigurationFile().getAdminBaseUrl())\(GET_INCENTIVE_PRODUCTS)"
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    webServiceHandler.makeRequestToAdmin(dictParameter: [String: Any](), finalUrl: requestUrl, HttpMethod: "GET",  apiMethodName: GET_GIFT, success: { (dictResponse) in
      
      successResponse(dictResponse as AnyObject)
    }) { (errorMessage) in
      
      faliureResponse(errorMessage)
      
    }
    
  }
  
  func validatePromoCodeRequest(promoCode:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    var isFirstOrder:String = "0"
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    if  WSUtility.isUserPlacedFirstOrder() == true {
      isFirstOrder = "0"
    }else{
      isFirstOrder = "1"
    }
    
    let requestUrl = "\(WSConfigurationFile().getAdminBaseUrl())\(VALIDATE_PROMOCODE)?email_id=\(emailID)&promocode=\(promoCode)&is_first_order=\(isFirstOrder)"
    
    if let encodedUrl = requestUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
      let _ = URL(string: encodedUrl) {
      
      let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
      let header:HTTPHeaders =  [WSConfigurationFile().getAdminHeaderSecretKey():WSConfigurationFile().getAdminHeaderSecretValue()]
      webServiceHandler.GETRequestWithJsonResponse(requestParameter: encodedUrl, methodName: VALIDATE_PROMOCODE, header: header, success: { (response) in
        print(response)
        successResponse(response as AnyObject)
      }) { (errorMessage) in
        print(errorMessage)
        faliureResponse(errorMessage)
      }
      
    }
    
  }
  
  func afterOrderPlacedToStoreTheSifuOrderIdAndLoyaltyPointsForPromoCodeInAdminRequest(parmsDict:[String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let baseURL = WSConfigurationFile().getAdminBaseUrl() + AFTER_PROMOCODE_ORDER_PLACED_SUCCESSFULLY
    
    webServiceHandler.makeRequestToAdmin(dictParameter: parmsDict, finalUrl: baseURL, HttpMethod: "POST",  apiMethodName: AFTER_PROMOCODE_ORDER_PLACED_SUCCESSFULLY, success: { (dictResponse) in
      
      successResponse(dictResponse as AnyObject)
    }) { (errorMessage) in
      
      faliureResponse(errorMessage)
      
    }
    
  }
  func updateLoyaltyPointsForPromoCodeInAdminRequest(parmsDict:[String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let baseURL = WSConfigurationFile().getAdminBaseUrl() + UPDATE_LOYALTYPOINTS_TO_ADMIN
    
    webServiceHandler.makeRequestToAdmin(dictParameter: parmsDict, finalUrl: baseURL, HttpMethod: "POST",  apiMethodName: UPDATE_LOYALTYPOINTS_TO_ADMIN, success: { (dictResponse) in
      
      successResponse(dictResponse as AnyObject)
    }) { (errorMessage) in
      
      faliureResponse(errorMessage)
      
    }
    
  }
  
  func getPendingLoyaltyPointsRequest(successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    
    let requestUrl = "\(WSConfigurationFile().getAdminBaseUrl())\(GET_PENDING_LOYALTYPOINTS_FROM_ADMIN)?email_id=\(emailID)"
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    webServiceHandler.makeRequestToAdmin(dictParameter: [String:Any](), finalUrl: requestUrl, HttpMethod: "GET", apiMethodName: GET_PENDING_LOYALTYPOINTS_FROM_ADMIN, success: {(response) in
      successResponse(response as AnyObject)
    }, failure: {(errorMessage) in
      faliureResponse(errorMessage)
    })
  }
  
  func updateAdminFlagStatusAfterSifuSuccessRequest( successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    var parmsDict: [String: Any] = [:]
    parmsDict["email_id"] = "\(emailID)"
    parmsDict["SIFU_response_status"] = "1"
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let baseURL = WSConfigurationFile().getAdminBaseUrl() + UPDATE_ADMIN_FLAG_STATUS_AFTER_SIFU
    
    webServiceHandler.makeRequestToAdmin(dictParameter: parmsDict, finalUrl: baseURL, HttpMethod: "POST",  apiMethodName: UPDATE_ADMIN_FLAG_STATUS_AFTER_SIFU, success: { (dictResponse) in
      
      successResponse(dictResponse as AnyObject)
    }) { (errorMessage) in
      
      faliureResponse(errorMessage)
      
    }
    
  }
  
  func getAppliedPromoCodeWhileOrderIsNotPlaced( successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    
    let requestUrl = "\(WSConfigurationFile().getAdminBaseUrl())\(GET_APPLIED_PROMOCODE_BEFORE_ORDERPLACED)?email_id=\(emailID)"
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let header:HTTPHeaders =  [WSConfigurationFile().getAdminHeaderSecretKey():WSConfigurationFile().getAdminHeaderSecretValue()]
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: requestUrl, methodName: GET_APPLIED_PROMOCODE_BEFORE_ORDERPLACED, header: header, success: { (response) in
      print(response)
      successResponse(response as AnyObject)
    }) { (errorMessage) in
      print(errorMessage)
      faliureResponse(errorMessage)
    }
  }
  
  func setAppliedPromoCodeBeforeOrderPlaced(promoCode:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    var parmsDict: [String: Any] = [:]
    parmsDict["email_id"] = "\(emailID)"
    parmsDict["promo_code"] = "\(promoCode)"
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let baseURL = WSConfigurationFile().getAdminBaseUrl() + SET_APPLIED_PROMOCODE_BEFORE_ORDERPLACED
    
    webServiceHandler.makeRequestToAdmin(dictParameter: parmsDict, finalUrl: baseURL, HttpMethod: "POST",  apiMethodName: SET_APPLIED_PROMOCODE_BEFORE_ORDERPLACED, success: { (dictResponse) in
      
      successResponse(dictResponse as AnyObject)
    }) { (errorMessage) in
      
      faliureResponse(errorMessage)
      
    }
    
  }
  
  func unSetAppliedPromoCodeBeforeOrderPlaced(promoCode:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    var parmsDict: [String: Any] = [:]
    parmsDict["email_id"] = "\(emailID)"
    parmsDict["promo_code"] = "\(promoCode)"
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let baseURL = WSConfigurationFile().getAdminBaseUrl() + UNSET_APPLIED_PROMOCODE_BEFORE_ORDERPLACED
    
    webServiceHandler.makeRequestToAdmin(dictParameter: parmsDict, finalUrl: baseURL, HttpMethod: "POST",  apiMethodName: SET_APPLIED_PROMOCODE_BEFORE_ORDERPLACED, success: { (dictResponse) in
      
      successResponse(dictResponse as AnyObject)
    }) { (errorMessage) in
      
      faliureResponse(errorMessage)
      
    }
    
  }
  func updateDTOProfileTOHybrisRequest(parameter:[String:String],methodName:String , successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    var requestUrl = "\(WSUtility.getHybrisBaseUrlWithBaseSiteId() + HYB_DTO_UPDATE_PROFILE)?" + "sifuToken=\(WSUtility.getSifuToken())"
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    requestUrl = requestUrl.replacingOccurrences(of: "%@", with: "\(emailID)")
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter: [:], methodName: HYB_DTO_UPDATE_PROFILE, header: header, requestURL: requestUrl, success: { (response) in
      print("Dto udpated")
    }) { (errorMessage) in
      
    }
    
  }
  func startChat(email_Id:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    var parmsDict: [String: Any] = [:]
    
    parmsDict["email_id"] = "\(email_Id)"
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let baseURL = "\(WSConfigurationFile().getAdminBaseUrl() + START_CHAT)?email_id=\(email_Id)"
    
    webServiceHandler.makeRequestToAdmin(dictParameter: parmsDict, finalUrl: baseURL, HttpMethod: "GET",  apiMethodName: "Start_Chat", success: { (dictResponse) in
      
      successResponse(dictResponse as AnyObject)
      
      
    }) { (errorMessage) in
      
      faliureResponse(errorMessage)
      
    }
    
  }
  
  
  func sendMsg(slrep_id:String,email_Id:String,reply_Msg:String,seg_id:String,groupChatOrNot:Bool, successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    var parmsDict: [String: Any] = [:]
    
    parmsDict["slrep_id"] = "\(slrep_id)"
    parmsDict["email_id"] = "\(email_Id)"
    parmsDict["reply"] = "\(reply_Msg)"
    
    if groupChatOrNot {
      parmsDict["seg_id"] = "\(seg_id)"
    }
    
    let repliedString = reply_Msg.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    //ufsapp_global
    let baseURL = "\(WSConfigurationFile().getAdminBaseUrl() + SEND_MESSAGE)?email_id=\(email_Id)&slrep_id=\(slrep_id)&reply=\(repliedString ?? "")"
    
    webServiceHandler.makeRequestToAdmin(dictParameter: parmsDict, finalUrl: baseURL, HttpMethod: "POST",  apiMethodName: "Send_msg", success: { (dictResponse) in
      
      successResponse(dictResponse as AnyObject)
    }) { (errorMessage) in
      
      faliureResponse(errorMessage)
      
    }
    
  }
  
  func chatHistory(email_Id:String,successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    var parmsDict: [String: Any] = [:]
    parmsDict["email_id"] = "\(email_Id)"
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let baseURL = "\(WSConfigurationFile().getAdminBaseUrl() + CHAT_HISTORY)?email_id=\(email_Id)"
    
    
    webServiceHandler.makeRequestToAdmin(dictParameter: parmsDict, finalUrl: baseURL, HttpMethod: "GET",  apiMethodName: "Chat_History", success: { (dictResponse) in
      
      successResponse(dictResponse as AnyObject)
      
    }) { (errorMessage) in
      
      faliureResponse(errorMessage)
      
    }
    
  }
  
  func makeGuestTrustedClientAndExecute(successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    var parmsDict: [String: Any] = [:]
    parmsDict["client_id"] = "android"
    parmsDict["client_secret"] = "android123"
    parmsDict["grant_type"] = "client_credentials"
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let baseURL = "\(WSConfigurationFile().getHybrisTokenBaseURL())"
    
    webServiceHandler.POSTRequest(dictParameter: parmsDict, methodName: HYBRIS_TOKEN, header: nil, requestURL: baseURL, success: { (response) in
      successResponse(response as! [String : Any] as AnyObject)
      let res = response as! [String : Any] as AnyObject
      UFSHybrisUtility.hybrisToken = res["access_token"] as! String
      UserDefaults.standard.set(UFSHybrisUtility.hybrisToken, forKey: "HYBRIS_TOKEN_KEY")
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  
  func retrieveLoginTokenForUsername(username:String, password:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    var parmsDict: [String: Any] = [:]
    parmsDict["countryCode"] = WSUtility.getCountryCode()
    parmsDict["siteCode"] = UserDefaults.standard.value(forKey: "Site")!
    parmsDict["password"] = "\(password)"
    parmsDict["userId"] = "\(username)"
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let baseURL = "\(WSUtility.getHybrisBaseUrlWithBaseSiteId())\(LoginUser_API)"
    
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    webServiceHandler.POSTRequest(dictParameter: parmsDict, methodName: "Login", header: header, requestURL: baseURL, success: { (response) in
      successResponse(response as! [String : Any] as AnyObject)
      //
      // need to save cart locally
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  
  func createCartForUserId(userId:String, params:[String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    var parmsDict: [String: Any] = [:]
    parmsDict["fields"] = "FULL"
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    var baseURL = WSUtility.getHybrisBaseUrlWithBaseSiteId() + CREATE_CART + WSUtility.addVendorIDForTurkey()
    baseURL = baseURL.replacingOccurrences(of: "email_id", with: "\(emailID)")
    baseURL = baseURL.replacingOccurrences(of: "SIFU_TOKEN_ID", with: WSUtility.getSifuToken())
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    webServiceHandler.POSTRequest(dictParameter: parmsDict, methodName: "", header: header, requestURL: baseURL, success: { (response) in
      let dict: [String : Any] = response as! [String : Any]
      if let cartDetail = dict["code"] as? String{
        UFSHybrisUtility.uniqueCartId = cartDetail
      }
      successResponse(response)
      // need to save cart locally
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  
  func getCartsForUserId(userId:String, params:[String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    var parmsDict: [String: Any] = [:]
    parmsDict["fields"] = "FULL"
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    var baseURL = GET_CART_URL
    baseURL = baseURL.replacingOccurrences(of: "email_id", with: "\(emailID)")
    baseURL = baseURL.replacingOccurrences(of: "SIFU_TOKEN_ID", with: WSUtility.getSifuToken())
    baseURL = baseURL.replacingOccurrences(of: "language_Code", with: WSUtility.getLanguage())
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    
    webServiceHandler.GETRequestWithJsonResponseForHybris(requestParameter: baseURL, params: parmsDict, methodName: GET_CART, HttpMethod: "GET", header: header, success: { (response) in
      
      let dict: [String : Any] = response as! [String : Any]
      
      if let cartId = dict["code"] as? String {
        UFSHybrisUtility.uniqueCartId = cartId
        UFSHybrisUtility.cartData = dict as NSDictionary
        UserDefaults.standard.set(dict as NSDictionary, forKey: Cart_Detail_Key)
        
      }
      
      if let entries = dict["entries"] as? NSArray{
        print(entries)
      }
      successResponse(response as AnyObject)
      // need to save cart locally
      
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
    
    /*
     webServiceHandler.GETRequest(requestParameter: baseURL, methodName: GET_CART, header: header, success: { (response) in
     
     let dict: [String : Any] = response as! [String : Any]
     UFSHybrisUtility.uniqueCartId = dict["code"] as! String
     UFSHybrisUtility.cartData = dict as NSDictionary
     if let entries = dict["entries"] as? NSArray{
     print(entries)
     }
     successResponse(response)
     // need to save cart locally
     }) { (errorMessage) in
     faliureResponse(errorMessage)
     }
     */
    
    
  }
  
  func replaceCartEntryForUserId(cartId:NSString, entryNumber:NSString, cartQuantity:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    var parmsDict = [String:String]()
    parmsDict["qty"] = cartQuantity
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    var baseURL =  WSUtility.getHybrisBaseUrlWithBaseSiteId() + REPLACE_CART_ENTRY + WSUtility.addVendorIDForTurkey()
    //baseURL = baseURL.replacingOccurrences(of: "cart_id", with: "\(UFSHybrisUtility.uniqueCartId)")
    baseURL = baseURL.replacingOccurrences(of: "cart_id", with: "\(cartId)")
    baseURL = baseURL.replacingOccurrences(of: "email_id", with: "\(emailID)")
    baseURL = baseURL.replacingOccurrences(of: "entry_no", with: "\(entryNumber)")
    baseURL = baseURL.replacingOccurrences(of: "REP_QTY", with: "\(cartQuantity)")
    baseURL = baseURL.replacingOccurrences(of: "SIFU_TOKEN_ID", with: WSUtility.getSifuToken())
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"text/html"]
    
    if(entryNumber == "0"){
      webServiceHandler.DELETERequest(dictParameter: parmsDict, methodName: "delete_cart_item", header: header, requestURL: baseURL, success: { (response) in
        successResponse(response)
      }) { (errorMessage) in
        faliureResponse(errorMessage)
      }
    }else{
      parmsDict["fields"] = "FULL"
      
      webServiceHandler.POSTRequest(dictParameter: parmsDict, methodName: "REPLACE_CART_ENTRY", header: header, requestURL: baseURL, success: { (response) in
        print(response)
        successResponse(response as! [String: Any] as AnyObject)
        
      }) { (errorMessage) in
        print(errorMessage)
        faliureResponse(errorMessage)
        
        
        
      }
      
    }
    
  }
  
  
  func deleteCartEntryForUserId(userId:String, cartId:NSString, entryNumber:NSString, params:[String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    var parmsDict: [String: Any] = [:]
    parmsDict["qty"] = "0"
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    var baseURL = WSUtility.getHybrisBaseUrlWithBaseSiteId() + DELETE_CART_ENTRY + WSUtility.addVendorIDForTurkey()
    //baseURL = baseURL.replacingOccurrences(of: "cart_id", with: "\(UFSHybrisUtility.uniqueCartId)")
    baseURL = baseURL.replacingOccurrences(of: "cart_id", with: "\(cartId)")
    baseURL = baseURL.replacingOccurrences(of: "email_id", with: "\(emailID)")
    baseURL = baseURL.replacingOccurrences(of: "entry_no", with: "\(entryNumber)")
    baseURL = baseURL.replacingOccurrences(of: "SIFU_TOKEN_ID", with: WSUtility.getSifuToken())
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    webServiceHandler.DELETERequest(dictParameter: parmsDict, methodName: "delete_cart_item", header: header, requestURL: baseURL, success: { (response) in
      successResponse(response)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  
  
  func getProductsByQuery(currentSearchQuery:String, currentPage:Int, successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    var parmsDict: [String: Any] = [:]
    parmsDict["currentPage"] = currentPage
    parmsDict["pageSize"] = 10
    parmsDict["query"] = currentSearchQuery
    parmsDict["fields"] = "FULL"
    parmsDict["lang"] = WSUtility.getLanguage()
    
    let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    var baseURL = WSUtility.getHybrisBaseUrlWithBaseSiteId() + Products_Search_API + WSUtility.addVendorIDForTurkey().replacingOccurrences(of: "&", with: "?")
    baseURL = baseURL.replacingOccurrences(of: "Email_Id", with: "\(emailID)")
    //https://52.31.80.240:8002/rest/v2/ufs/products/search
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    webServiceHandler.GETRequestWithJsonResponseForHybris(requestParameter: baseURL, params: parmsDict, methodName: GET_PRODUCT_QUERY,HttpMethod: "GET", header: header, success: { (response) in
      //let dict: [String : Any] = response as! [String : Any]
      successResponse(response as AnyObject)
      // need to save cart locally
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  
  func updateExcludedProductsFromUserProfile()  {
    
    self.getUserProfile(parameter: [String:Any](), methodName: GET_PROFILE_API, successResponse: { (response) in
      
      if let tpDict = response["parentTradePartner"] as? [String: Any]{
        
        if let excludedProductsStr = tpDict["excludedProducts"]as? String{
          let array = excludedProductsStr.components(separatedBy: ",")
          UserDefaults.standard.set(array, forKey: "ExcludedProducts")
        }
      }
      
    }) { (errorMessage) in
      
    }
  }
  func featureEnableDisableForcountries(success:@escaping(_ response:[String:Any])->Void, failure:@escaping(_ errorMessage:String)->Void) {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let requestURL: String = "\(WSConfigurationFile().getAdminBaseUrl())\(GET_FEATURE_ENABLE_DISABLE)"
    webServiceHandler.makeRequestToAdmin(dictParameter: [String: Any](), finalUrl: requestURL, HttpMethod: "GET",  apiMethodName: GET_FEATURE_ENABLE_DISABLE, success: { (dictResponse) in
      
      let temp = dictResponse["data"] as! [String:Any]
      let appReleaseFeature = temp["app_release_feature"] as! [[String:Any]]
      //let baseUrlDic = temp["app_release"] as! [String:Any]
      var baseUrlDic = [String: Any]()
      
      if UserDefaults.standard.bool(forKey: "isManualSettings"){
        baseUrlDic = WSUtility.getBaseURLsDictForStageAndLive(isLive: UserDefaults.standard.bool(forKey: "isForLiveOrStage"))
        UserDefaults.standard.setValue(baseUrlDic, forKey: "baseURlFeature")
      }
      else{
        baseUrlDic = temp["app_release"] as! [String:Any]
      }
      
      if appReleaseFeature.count != 0 {
        UserDefaults.standard.setValue(appReleaseFeature, forKey: "enableDisbleFeature")
        UserDefaults.standard.setValue(baseUrlDic, forKey: "baseURlFeature")
      }
      
      success(dictResponse)
    }) { (errorMessage) in
      failure(errorMessage)
    }
  }
  
  func triggerPushNotificationAfterOrderPlacedForPromoCode(promoCode:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    var parmsDict: [String: Any] = [:]
    parmsDict["promo_code"] = "\(promoCode)"
    parmsDict["action"] = "mgm_notification"
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let baseURL = WSConfigurationFile().getAdminBaseUrl() + SEND_PUSH_NOTIFICATION_AFTER_ORDER_PLACED
    
    webServiceHandler.makeRequestToAdmin(dictParameter: parmsDict, finalUrl: baseURL, HttpMethod: "POST",  apiMethodName: SEND_PUSH_NOTIFICATION_AFTER_ORDER_PLACED, success: { (dictResponse) in
      
      successResponse(dictResponse as AnyObject)
    }) { (errorMessage) in
      
      faliureResponse(errorMessage)
      
    }
    
  }
  func getCountryAndLanguage(success:@escaping(_ response:[String:Any])->Void, failure:@escaping(_ errorMessage:String)->Void) {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let header:HTTPHeaders =  [WSConfigurationFile().getAdminHeaderSecretKey():WSConfigurationFile().getAdminHeaderSecretValue(),ADMIN_HEADER_APP_NAME : ADMIN_HEADER_APP_NAME_VALUE]
    
    webServiceHandler.GETRequestWithJsonResponse(requestParameter:"" , methodName: GET_COUNTRY_LANGUAGE, header: header, success: { (response) in
      success(response as! [String : Any])
    }) { (errorMessage) in
      failure(errorMessage )
    }
  }
  
  //GET : Admin method to get available delivary dates to update calender
  func getAvailableDeliveryDatesToUpdateCalender(successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    let finalUrl = WSConfigurationFile().getAdminBaseUrl() + "\(GET_CALENDER_INFO_TO_ENABLE_AVAILABLE_DATES)"
    
    webServiceHandler.makeRequestToAdmin(dictParameter: [String:Any](), finalUrl: finalUrl , HttpMethod: "GET", apiMethodName: GET_CALENDER_INFO_TO_ENABLE_AVAILABLE_DATES, success: { (response) in
      
      successResponse(response)
      
    }) { (errorMessage) in
      
      print(errorMessage)
      
      failureResponse(errorMessage)
      
    }
    
  }
  func getCountryLoyaltyPoints(success:@escaping(_ response:[String:Any])->Void, failure:@escaping(_ errorMessage:String)->Void) {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let requestURL: String = "\(WSConfigurationFile().getAdminBaseUrl())\(GET_COUNTRY_LOYALTY_POINTS)"
    webServiceHandler.makeRequestToAdmin(dictParameter: [String: Any](), finalUrl: requestURL, HttpMethod: "GET",  apiMethodName: GET_COUNTRY_LOYALTY_POINTS, success: { (dictResponse) in
      success(dictResponse)
    }) { (errorMessage) in
      failure(errorMessage)
    }
  }
  
  
  func getBusinessTypesFromHybris(successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    let requestUrl = String(format: GET_BUSINESS_TYPES_FROM_HYBRIS,WSUtility.getLanguageCode())
    webServiceHandler.GETRequestWithJsonResponseForHybris(requestParameter: requestUrl, params: [:], methodName: GET_BUSINESS_TYPES_FROM_HYBRIS,HttpMethod: "GET", header: header, success: { (response) in
      
      successResponse(response as AnyObject)
      
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
  }
  
  func getVendorsList(successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    webServiceHandler.GETRequestWithJsonResponseForHybris(requestParameter: GET_VENDORSLIST_FOR_TR, params: nil, methodName: GET_VENDORSLIST_FOR_TR, HttpMethod: "GET", header: header, success: { (response) in
      print(response)
      
      successResponse(response as! [String: Any])
      
    }) { (errorMessage) in
      print(errorMessage)
      
      failureResponse(errorMessage)
    }
  }
  func makeTermsAndCondtionsRequest(parameter:[String:Any] , successResponse:@escaping (_ response:NSDictionary)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let requestUrl = "\(WSUtility.getHybrisBaseUrlWithBaseSiteId())\(String(format: HYB_TermsAndCondtions, WSUtility.getLanguageCode()))"
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter:["uid": "termsandconditions", "channel":"mobile"], methodName: SIGN_UP, header: header, requestURL: requestUrl, success: { (response) in
      
      successResponse(response as! NSDictionary)
      
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
  }
  
  func postVendorDetailsFor_TR_Payment(params:NSDictionary,selectedVendorId:String,successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void){
    
    UFSProgressView.showWaitingDialog("")
    
    let email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    
    let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
    let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
    let url = "\(WSUtility.getHybrisBaseUrlWithBaseSiteId())vendors/\(email_id)/details?fields=DEFAULT&vendorId=\(selectedVendorId))"
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.POSTRequest(dictParameter: params as! [String : Any], methodName: "", header: header, requestURL: url, success: { (response) in
      successResponse(response as! [String : Any])
      UFSProgressView.stopWaitingDialog()
    }) { (errorMessage) in
      failureResponse(errorMessage)
      print("error")
      UFSProgressView.stopWaitingDialog()
    }
  }

    /* Add,get,update user vendor details for turkey (Hybris Apis)
        1. creating vendor for user
        2. get UserProfileVendors
        3. update UserProfileVendor
     */
    func addVendorToUser(params:[String: Any],successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void){
        
        var email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
        
        if email_id == ""{
            email_id = "\(params["email"] ?? "")"
        }
        
        let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
        let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
        
        let requestUrl = String(format: WSUtility.getHybrisBaseUrlWithBaseSiteId() + CREATE_VENDOR  ,email_id,email_id,"\(params["parentTpId"]!)","\(params["tplocationID"]!)","\(params["accountNumber"]!)","\(params["makeDefalut"]!)")
        
        let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
        webServiceHandler.POSTRequest(dictParameter: params, methodName: CREATE_VENDOR, header: header, requestURL: requestUrl, success: { (response) in
            successResponse(response as! [String : Any])
            }) { (errorMessage) in
                failureResponse(errorMessage)
            }
    }

    func getUserProfileVendorsList( successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
        
        let email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
        
        let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
        let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
        let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
        
        let requestUrl = String(format: GET_USER_PROFILE_VENDORS_LIST,email_id)
        webServiceHandler.GETRequestWithJsonResponseForHybris(requestParameter: requestUrl, params: [String : Any](), methodName: GET_USER_PROFILE_VENDORS_LIST, HttpMethod: "GET", header: header, success: { (response) in
            successResponse(response as AnyObject)
        }) { (errorMessage) in
            faliureResponse(errorMessage)
        }
    }
   
    func updateUserProfileVendorToUser(params:[String: Any],successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void){
        
        let email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
        
        let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
        let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
        
        let requestUrl = String(format: WSUtility.getHybrisBaseUrlWithBaseSiteId() + UPDATE_USER_VENDOR_PROFILE  ,email_id,"\(params["myProfileVendorCode"]!)","\(params["accountNumber"]!)","\(params["makeDefalut"]!)")
        
        let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
        webServiceHandler.POSTRequest(dictParameter: params, methodName: UPDATE_USER_VENDOR_PROFILE, header: header, requestURL: requestUrl, success: { (response) in
            successResponse(response as! [String : Any])
        }) { (errorMessage) in
            failureResponse(errorMessage)
        }
    }
    
    func getSavedPaymentCardsDetails(isSaved:Bool,selectedVendorId:String,successResponse:@escaping (_ successMessage:[String:Any])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void){
        
        UFSProgressView.showWaitingDialog("")
        let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
        let email_id = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
        let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
        let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
        let requestStr = String(format: GET_SAVED_PAYMENT_CARDS_FOR_TR, email_id,"\(isSaved)",selectedVendorId)
        webServiceHandler.GETRequestWithJsonResponseForHybris(requestParameter: requestStr, params: nil, methodName: GET_SAVED_PAYMENT_CARDS_FOR_TR, HttpMethod: "GET", header: header, success: { (response) in
            print(response)
            UFSProgressView.stopWaitingDialog()
            
            successResponse(response as! [String: Any])
            
        }) { (errorMessage) in
            print(errorMessage)
            UFSProgressView.stopWaitingDialog()
            failureResponse(errorMessage)
        }
    }
    
    func deleteSavedPaymentCardsDetails( paymentDetailsId:NSString , successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
        
        UFSProgressView.showWaitingDialog("")
 
        let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
        let hybrisToken = WSUtility.getValueFromUserDefault(key: "HYBRIS_TOKEN_KEY")
        let header:HTTPHeaders? = ["Authorization": "Bearer " + hybrisToken,"Content-Type":"application/json"]
        let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
        let requestStr = String(format: DELETE_SAVED_PAYMENT_CARDS_FOR_TR, emailID,paymentDetailsId)
        let baseURL = WSUtility.getHybrisBaseUrlWithBaseSiteId() + requestStr //+ WSUtility.addVendorIDForTurkey()
 
        webServiceHandler.DELETERequest(dictParameter : [:], methodName: "delete_card_item", header: header, requestURL: baseURL, success: { (response) in
            UFSProgressView.stopWaitingDialog()

            successResponse(response)
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()

            faliureResponse(errorMessage)
        }
    }
}

