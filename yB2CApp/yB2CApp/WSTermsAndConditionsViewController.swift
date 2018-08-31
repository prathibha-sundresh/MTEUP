//
//  WSTermsAndConditionsViewController.swift
//  yB2CApp
//
//  Created by Lakshminarayana on 12/12/17.
//

import UIKit

class WSTermsAndConditionsViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var blnLoadFromServer : Bool = false
    var UrlData  : String = ""
    
    var isFromNewsLetter: Bool = false
  var loadOnlineContractDocx = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //didOpen()
        webView.dataDetectorTypes = UIDataDetectorTypes.phoneNumber
        if loadOnlineContractDocx{
            self.webView.scalesPageToFit = true
            self.webView.contentMode = UIViewContentMode.scaleAspectFit
            
            let strPath = Bundle.main.path(forResource: "onlineContract.docx", ofType: nil)
            let url = URL.init(fileURLWithPath: strPath!)
            do {
                let data = try Data(contentsOf: url)
                webView.dataDetectorTypes .remove(UIDataDetectorTypes.phoneNumber)
                webView.load(data, mimeType: "application/vnd.openxmlformats-officedocument.wordprocessingml.document", textEncodingName: "UTF-8", baseURL: url)
            } catch {
                print("Unable to load data: \(error)")
            }
        }
        else{
            getTCDetails()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getTCDetails(){
        
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.makeTermsAndCondtionsRequest(parameter: [:], successResponse: { (response) in
            if let dict = response["MessageType"] as? [String: Any]{
                if let content = dict["content"] as? String{
                    self.webView?.loadHTMLString(content, baseURL: nil)
                }
            }
            
        }) { (errorMessage) in
            
        }
    }
    func didOpen() {
        let error: Error? = nil
        
        var htmlText = ""
        
        var fileName: String = ""
        if isFromNewsLetter{
            fileName = "news_subscriptions_at"
        }
        else{
            fileName = "tc_at"
        }
        let TermsOfUseData =  Bundle.main.url(forResource: fileName, withExtension: "html")
    
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: (TermsOfUseData?.path)!) {
            htmlText = try! String(contentsOfFile: (TermsOfUseData?.path)!, encoding: String.Encoding.utf8)
            let htmlString: String = "<font face='DINPro-Medium' size='2'>\(htmlText)"
            webView?.loadHTMLString(htmlString, baseURL: TermsOfUseData!)
        }
        
        if error != nil {
            //        NSLog(@"%@", [error localizedDescription]);
        }
        
   
        
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension WSTermsAndConditionsViewController: UIWebViewDelegate{
    func webView(_ inWeb: UIWebView, shouldStartLoadWith inRequest: URLRequest, navigationType inType: UIWebViewNavigationType) -> Bool {
        if inType == .linkClicked && !((inRequest.url?.absoluteString as NSString?)?.substring(to: 4) == "file") {
            UIApplication.shared.openURL(inRequest.url!)
            return false
        }
        return true
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        UFSProgressView.showWaitingDialog("")
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UFSProgressView.stopWaitingDialog()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UFSProgressView.stopWaitingDialog()
    }
}
