//
//  WSPayURequestModel.swift
//  UFS
//
//  Created by Guddu Gaurav on 03/07/2018.
//

import UIKit

class WSPayURequestModel: NSObject {

  func createRequestModelForPayU(orderInfo:[String:Any]) -> [String:Any]{
    
  let emailID = WSUtility.getValueFromUserDefault(key: LAST_AUTHENTICATED_USER_KEY)
    

    let cardDetail = orderInfo["PaymentDetail"] as? [String:Any]
    let payUDict:[String:Any] =
    [
      "amount": orderInfo["amount"]!,
      "billToCity": orderInfo["town"] ?? "",
      "billToCountry": orderInfo["town"] ?? "",
      "billToCustomerId": "\(emailID)",
      "billToEmail": "\(emailID)",
      "billToFirstName": orderInfo["firstName"] ?? "",
      "billToLastName": orderInfo["lastName"] ?? "",
      "billToPhoneNumber": orderInfo["phone"] ?? "",
      "billToPostalCode": orderInfo["postalCode"] ?? "",
      "billToState": orderInfo["town"] ?? "",
      "billToStreet1": orderInfo["line1"] ?? "",
      "billToStreet2": orderInfo["line2"] ?? "",
      "cardNumber": cardDetail!["CardNumber"] ?? "",
      "cardType": "visa",
      "comments": "comments",
      "currency": "TRY",
      "cvNumber": cardDetail!["CVV"] ?? "",
      "expirationMonth": cardDetail!["Expiration_Month"] ?? "",
      "expirationYear": cardDetail!["Expiration_Year"] ?? "",
      "installmentCount": 0,
      "isMobile": true,
      "issueNumber": "000",
      "nameOncard": cardDetail!["NameOnCard"] ?? "",
      "orderCode": "string",
      "parameters":[],
      "paymentProvider": "payu",
      "saveCardSelected": false,
      "saveInAccount": false,
      "savePaymentInfo": cardDetail! ["isNeedToSave"] ?? false,
      "shipToCity": orderInfo["town"] ?? "",
      "shipToCountry": orderInfo["town"] ?? "",
      "shipToCustomerId": "\(emailID)",
      "shipToEmail": "\(emailID)",
      "shipToFirstName": orderInfo["firstName"] ?? "",
      "shipToLastName": orderInfo["lastName"] ?? "",
      "shipToPhoneNumber": orderInfo["phone"] ?? "",
      "shipToPostalCode": orderInfo["postalCode"] ?? "",
      "shipToState": orderInfo["town"] ?? "",
      "shipToStreet1": orderInfo["line1"] ?? "",
      "shipToStreet2": orderInfo["line2"] ?? "",
      "startMonth": "",
      "startYear": "",
      "taxAmount": "",
      "tdsSelected": false,
      "useDeliveryAddress": true,
      "selectedCardId": cardDetail!["savedCardID"] ?? "" ]
    
    print(payUDict)
    
    return payUDict
  }
  
  
}
