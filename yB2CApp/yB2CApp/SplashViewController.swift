//
//  SplashViewController.swift
//  yB2CApp
//
//  Created by Ajay on 27/11/17.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var imgProgressIndicator:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let Lang = NSLocale.preferredLanguages as Array
        let currentLanguage = (Lang.first?.components(separatedBy: "-").first)!
        UserDefaults.standard.set(currentLanguage, forKey: "DeviceLanguage")
        
        // Do any additional setup after loading the view.
    //    UFSProgressView.showWaitingDialog("")
        var rotationAnimation: CABasicAnimation?
        rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation?.toValue = Int(.pi * 2.0 * 2 * 0.6)
        rotationAnimation?.duration = 1
        rotationAnimation?.isCumulative = true
        rotationAnimation?.repeatCount = Float.infinity
        imgProgressIndicator?.layer.add(rotationAnimation!, forKey: "rotationAnimation")
        self.perform(#selector(removeSplash), with: nil, afterDelay: 2.0)
  
       // sleep(12)
//imgProgressIndicator.removeFromSuperview()
        // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RemoveSplashScreen"), object: nil)
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeSplash()
    {
        UFSProgressView.stopWaitingDialog()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RemoveSplashScreen"), object: nil)
    }


}
