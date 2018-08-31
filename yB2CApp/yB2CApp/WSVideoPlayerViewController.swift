//
//  WSVideoPlayerViewController.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 24/12/2017.
//

import UIKit

class WSVideoPlayerViewController: UIViewController {
  @IBOutlet weak var videoWebView: UIWebView!
  var videoUrl = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      let url = URL (string: videoUrl)
      let requestObj = URLRequest(url: url!)
      videoWebView.delegate = self
      videoWebView.loadRequest(requestObj)
      
       WSUtility.addNavigationBarBackButton(controller: self)
    }

  @IBAction func backAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension WSVideoPlayerViewController:UIWebViewDelegate{
  
  func webViewDidStartLoad(_ webView: UIWebView){
    UFSProgressView.showWaitingDialog("")
  }
  func webViewDidFinishLoad(_ webView: UIWebView){
    UFSProgressView.stopWaitingDialog()
  }
  
  func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    UFSProgressView.stopWaitingDialog()
  }
  
}
