//
//  TestViewController.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 16/10/17.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
      
      print("viewDidLoad")
      /*
      let btn = UIButton(type: .custom)
      //btn.frame = CGRect(x: 0, y: 0, width: 38, height: 35)
      btn.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
      btn.setImage(#imageLiteral(resourceName: "Cancel"), for: .normal)
      btn.imageView?.clipsToBounds = true
      btn.addTarget(self, action: #selector(leftBarButtonAction(sender:)), for: .touchUpInside)
      let emailButton = UIBarButtonItem(customView: btn)
      navigationItem.leftBarButtonItem = emailButton
      */
      
    }
  
  override func viewWillAppear(_ animated: Bool) {
    print("viewWillAppear")
  }
  override func viewDidAppear(_ animated: Bool) {
    print("viewDidAppear")
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  func leftBarButtonAction(sender:UIButton)  {
    self.dismiss(animated: true, completion: nil)
  }
  @IBAction func bacbuttonAction(_ sender: UIButton) {
     self.dismiss(animated: true, completion: nil)
  }
  /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
