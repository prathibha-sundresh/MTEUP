//
//  WSLiveChatSDKManager.swift
//  UFS
//
//  Created by Guddu Gaurav on 08/05/2018.
//

import UIKit
import LiveChat

struct LiveChatGroups {
  let AT_OperaterApp = "11"
  let TR_OperatorApp = "12"
}

let Licence_ID = "8746516"

class WSLiveChatSDKManager: NSObject {

  func liveChatSDKSetUp()  {
    LiveChat.licenseId = Licence_ID
    LiveChat.groupId = ""
    
    LiveChat.name = "Test"
    LiveChat.email = "Test@test.com"
  }

}
