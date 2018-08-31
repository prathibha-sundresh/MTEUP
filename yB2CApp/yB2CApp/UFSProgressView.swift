//
//  UFSProgressView.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 03/07/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit

@objc class UFSProgressView: UIView {
  @IBOutlet weak var imgProgressIndicator: UIImageView!

  static let sharedProgressView:UFSProgressView = UINib(nibName: "UFSProgressView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UFSProgressView
  

  
  class func showWaitingDialog(_ text: String) {
    let progressView: UFSProgressView? = self.sharedProgressView
    let window: UIWindow? = UIApplication.shared.keyWindow
    progressView?.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat((window?.bounds.width)!), height: CGFloat((window?.bounds.height)!))
    window?.addSubview(progressView!)
    var rotationAnimation: CABasicAnimation?
    rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotationAnimation?.toValue = Int(.pi * 2.0 * 2 * 0.6)
    rotationAnimation?.duration = 1
    rotationAnimation?.isCumulative = true
    rotationAnimation?.repeatCount = MAXFLOAT
    progressView?.imgProgressIndicator?.layer.add(rotationAnimation!, forKey: "rotationAnimation")
  }
  
  class func stopWaitingDialog() {
    let progressView: UFSProgressView? = sharedProgressView
    UIView.animate(withDuration: 0.5, animations: {() -> Void in
      progressView?.alpha = 0
    }, completion: {(_ finished: Bool) -> Void in
      progressView?.removeFromSuperview()
      progressView?.alpha = 1
    })
  }
  
  
  class func showWaitingDialogOnView(_ text: String, viewController:UIViewController) {
    let progressView: UFSProgressView? = self.sharedProgressView
    let view: UIView? = viewController.view
    progressView?.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat((view?.bounds.width)!), height: CGFloat((view?.bounds.height)!))
    view?.addSubview(progressView!)
    var rotationAnimation: CABasicAnimation?
    rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotationAnimation?.toValue = Int(.pi * 2.0 * 2 * 0.6)
    rotationAnimation?.duration = 1
    rotationAnimation?.isCumulative = true
    rotationAnimation?.repeatCount = MAXFLOAT
    progressView?.imgProgressIndicator?.layer.add(rotationAnimation!, forKey: "rotationAnimation")
  }
 
  
}
