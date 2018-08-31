//
//  UFSNetworkReachablityHandler.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 23/08/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit
import Alamofire

protocol NetworkStatusDelegate : class{
    func ReachableNetwork()
    func NonReachableNetwork()
}

class UFSNetworkReachablityHandler: NSObject {
    var delegate:NetworkStatusDelegate?
    static let shared = UFSNetworkReachablityHandler()

    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    func startNetworkReachabilityObserver() {
        // start listening
        if (UIApplication.shared.applicationState == .inactive) {
            return
        }
        
        reachabilityManager?.listener = { status in
          
            switch status {
            case .notReachable:
                self.delegate?.NonReachableNetwork()
                break
            case .unknown : break
            case .reachable(.ethernetOrWiFi):
                self.delegate?.ReachableNetwork()
                break
            case .reachable(.wwan):
                self.delegate?.ReachableNetwork()
                break
            }
        }

        reachabilityManager?.startListening()
    }

}
