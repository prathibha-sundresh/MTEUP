//
//  WSCacheSingleton.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 18/12/2017.
//

import UIKit

class WSCacheSingleton: NSObject {
static let shared = WSCacheSingleton()
  
  let cache = NSCache<NSString, AnyObject>()
}
