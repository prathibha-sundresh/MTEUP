//
//  WSGetProductsFromCode.swift
//  UFS
//
//  Created by Guddu Gaurav on 10/07/2018.
//

import UIKit

class WSGetProductsFromCode: NSObject {

 func getProductDetail(codes:String,successResponse:@escaping (_ successMessage:[[String:Any]])-> Void, failureResponse:@escaping (_ errorMessage:String) -> Void) {
  
    let requestParameter = String(format:GET_PRODUCT_BY_CODE_TR,codes)
    
    let webServiceHandler:UFSWebServiceHandler = UFSWebServiceHandler()
    webServiceHandler.GETRequestWithJsonResponse(requestParameter: requestParameter, methodName: GET_PRODUCT_BY_CODE_TR, header: nil, success: { (response) in
      
      successResponse(response as! [[String:Any]])
      
    }) { (errorMessage) in
      failureResponse(errorMessage)
    }
    
}

}
