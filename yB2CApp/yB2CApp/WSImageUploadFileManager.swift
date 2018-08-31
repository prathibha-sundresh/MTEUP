//
//  WSImageUploadFileManager.swift
//  yB2CApp
//
//  Created by Ramakrishna on 12/2/17.
//

import UIKit
import Alamofire

class WSImageUploadFileManager: NSObject {
    class func uploadImages(imageData:[Data], apiMethodName methodName:String,imageName:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void) {
        
        let email_id = UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)!
        
        let header:HTTPHeaders =  [WSConfigurationFile().getAdminHeaderSecretKey():WSConfigurationFile().getAdminHeaderSecretValue()]
        
        let url = try! URLRequest(url: URL(string:"\(WSConfigurationFile().getAdminBaseUrl())\(methodName)?email_id=\(email_id)&profile_image=\(imageName)")!, method: .post, headers: header)
        
        Alamofire.upload(
            
            multipartFormData: { multipartFormData in
                
                for data in imageData{
                    //let imageData = (UIImagePNGRepresentation(images) as Data?)!
                    multipartFormData.append(data, withName: imageName, fileName: "UploadIcon.png", mimeType: "image/png")
                }
                
                // multipartFormData.append(imageData2, withName: "menu_card[]", fileName: "UploadIcon.png", mimeType: "image/png")
                
                
        },
            with: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if((response.result.value) != nil) {
                            print(response.result.value!)
                            let dictResponse = response.result.value as! [String:Any]
                            
                            if dictResponse["error"] as! Bool == false{
                                
                                successResponse(dictResponse as AnyObject )
                                
                            }else{
//                                faliureResponse(WSUtility.getValueFromDict(dict: dictResponse, key: "data"))
                            }
                            
                            
                        } else {
//                            faliureResponse(UFSUtility.getlocalizedString(key:UNKNOWN_ERROR_MESSAGE, lang:UFSUtility.getLanguage(), table: "Localizable")!)
                        }
                    }
                case .failure( _):
//                    faliureResponse(WSUtility.getlocalizedString(key:UNKNOWN_ERROR_MESSAGE, lang:UFSUtility.getLanguage(), table: "Localizable")!)
                    break
                }
        }
        )
        
    }
}
