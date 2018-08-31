//
//  WSConfigurationFile.swift
//  UFS
//
//  Created by Guddu Gaurav on 22/06/2018.
//

import UIKit

class WSConfigurationFile: NSObject {
  
  
  func getHybrisBaseURL() -> String {
    let dict = WSUtility.getBaseUrlDictFromUserDefault()
    
    let hybris_base_url = dict["hybris_base_url"]
    let hybris_base_url_path = dict["hybris_base_url_path"]
   
    let BASE_URL_HYBRIS = "\(hybris_base_url ?? "")\(hybris_base_url_path ?? "")BASE_SITE_ID/"
    
    return BASE_URL_HYBRIS
  }
  
  func getHybrisTokenBaseURL() -> String {
    let dict = WSUtility.getBaseUrlDictFromUserDefault()
    
    let hybris_base_url = (dict["hybris_base_url"])
    let hybris_token_path = dict["hybris_token_path"]
    let GET_HYBRIS_TOKEN_URL = "\(hybris_base_url ?? "")\(hybris_token_path ?? "")"
    
    return GET_HYBRIS_TOKEN_URL
  }
  
  func getHybrisForgotPasswordBaseURL() -> String {
    let dict = WSUtility.getBaseUrlDictFromUserDefault()
    
    let hybris_base_url = dict["hybris_base_url"]
    let hybris_forgot_password = dict["hybris_forgot_password"]
    let FORGOT_PASSWORD_API = "\(hybris_base_url ?? "")\(hybris_forgot_password ?? "")"
    
    return FORGOT_PASSWORD_API
  }
  func getAdminBaseUrl() -> String {
    
    let dict = WSUtility.getBaseUrlDictFromUserDefault()
    let ADMIN_DEV_BASE_URL = dict["app_admin_panel_url"]  as! String
    if ADMIN_DEV_BASE_URL.count == 0{
      return "https://techstage.nl/ufsapp_global/api/v2/"
    }
    return ADMIN_DEV_BASE_URL
  }
  
  func getSifuBaseUrl() -> String {
     let dict = WSUtility.getBaseUrlDictFromUserDefault()
     let API_BASE_URL = dict["app_sifu_url"] as! String // SIFU BASE URL
    return API_BASE_URL
  }
  
  func getSIFUPublicAPIKey() -> String {
    var dict = WSUtility.getBaseUrlDictFromUserDefault() //UserDefaults.standard.dictionary(forKey: "baseURlFeature")
    
    if "\(dict["app_is_live"] ?? "0")" == "1" { //Production
    
      return "a23h6lsLjXZOoljihm0t3i8xen0uhF4aMQdh6Aog"
    }else{
      return "a23h6lsLjXZOoljihm0t3i8xen0uhF4aMQdh6Aog"
    }
  }
  
  func getAdminHeaderSecretKey() -> String {
    var dict = WSUtility.getBaseUrlDictFromUserDefault()//UserDefaults.standard.dictionary(forKey: "baseURlFeature")
    
    if "\(dict["app_is_live"] ?? "0")" == "1" { //Production
      
      return "Secretkey"
    }else{
      return "Secretkey"
    }
  }
  
  func getAdminHeaderSecretValue() -> String {
    var dict = WSUtility.getBaseUrlDictFromUserDefault()//UserDefaults.standard.dictionary(forKey: "baseURlFeature")
    
    if "\(dict["app_is_live"] ?? "0")" == "1" { //Production
      
      return "bu+3=m+4epHathAcuswE"
    }else{
      return "taW5FyM3kS8Q!qjq"
    }
  }
  
  func getClientID() -> String {
    var dict = WSUtility.getBaseUrlDictFromUserDefault()//UserDefaults.standard.dictionary(forKey: "baseURlFeature")
    
    if "\(dict["app_is_live"] ?? "0")" == "1" { //Production
      
      return "471929289"
    }else{
      return "471929289"
    }
  }
  
  func getClientSecret() -> String {
    var dict = WSUtility.getBaseUrlDictFromUserDefault()//UserDefaults.standard.dictionary(forKey: "baseURlFeature")
    
    if "\(dict["app_is_live"] ?? "0")" == "1" { //Production
      
      return "8928A89B-F15E-4236-BA31-4240C8CD42B1"
    }else{
      return "8928A89B-F15E-4236-BA31-4240C8CD42B1"
    }
    
   
  }
  
  func getReedemGiftUrl(countryCode:String) -> String {
    
    var dict = WSUtility.getBaseUrlDictFromUserDefault()//UserDefaults.standard.dictionary(forKey: "baseURlFeature")
    var reedemBaseUrl = ""
    
    switch countryCode {
    case "AT":
      if "\(dict["app_is_live"] ?? "0")" == "1" {
         reedemBaseUrl = "http://unileverfoodsolutions.at/treueprogramm.html"
      }else{
         reedemBaseUrl = "http://stage.unileverfoodsolutions.at/treueprogramm.html"
      }
      break
    case "DE":
      if "\(dict["app_is_live"] ?? "0")" == "1" {
      reedemBaseUrl = "http://unileverfoodsolutions.de/treueprogramm.html"
      }else{
        reedemBaseUrl = "http://stage.unileverfoodsolutions.de/treueprogramm.html"
      }
      break
    case "CH":
      if "\(dict["app_is_live"] ?? "0")" == "1" {
      reedemBaseUrl = "http://unileverfoodsolutions.ch/de/treueprogramm.html"
        }else{
           reedemBaseUrl = "http://stage.unileverfoodsolutions.ch/de/treueprogramm.html"
        }
      break
    case "TR":
      if "\(dict["app_is_live"] ?? "0")" == "1" {
          reedemBaseUrl = "http://unileverfoodsolutions.com.tr/odul-programi.html"
        }else{
          reedemBaseUrl = "http://stage.unileverfoodsolutions.com.tr/odul-programi.html"
        }
      
      break
    default:
      break
    }
    
    return reedemBaseUrl
    }
    
  func getAppState() -> String {
    var dict = WSUtility.getBaseUrlDictFromUserDefault()//UserDefaults.standard.dictionary(forKey: "baseURlFeature")
    if "\(dict["app_is_live"] ?? "0")" == "1"{
      return "LIVE"
    }else{
       return "DEV"
    }
    
    
  }
  
  
  
  
  
}
