//
//  WSTermsViewController.swift
//  yB2CApp
//
//  Created by Anandita on 11/30/17.
//

import UIKit

class WSTermsViewController: UIViewController {
    
    
    @IBOutlet weak var termsConditionLabel: UILabel!
    var showTerms: Bool!
    var url: NSURL!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func closePressed(_ sender: Any) {
       
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 0.7)
        UFSProgressView.showWaitingDialog("")
        
            termsConditionLabel.text = WSUtility.getlocalizedString(key:"Terms and Conditions", lang:WSUtility.getLanguage(), table: "Localizable")
            switch UserDefaults.standard.value(forKey: "SelectedLocation")  as! String{
            case "Austria" :
                url = Bundle.main.url(forResource: "tc_at", withExtension: "html")! as NSURL
            case "Turkey":
                url = Bundle.main.url(forResource: "tc_tk", withExtension: "html")! as NSURL
            default:
                self.url = NSURL (string:"https://www.unileverfoodsolutions.us/")
            }
      
    }
    
    @IBOutlet weak var contentView: UIView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
func openPrivacyWebView() -> String {
    
    switch UserDefaults.standard.value(forKey: "SelectedLocation")  as! String{
    case "Austria" :
        return "http://www.unileverprivacypolicy.com/de_at/Policy.aspx"
    case "Turkey":
        return "http://www.unileverprivacypolicy.com/turkish/policy.aspx"
    default:
        return "https://www.unileverfoodsolutions.us/"
    }


}



extension WSTermsViewController:UIWebViewDelegate{
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UFSProgressView.stopWaitingDialog()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UFSProgressView.stopWaitingDialog()
    }
}
