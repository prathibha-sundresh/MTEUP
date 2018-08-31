//
//  ChatHistoryViewController.swift
//  
//
//  Created by Abbut John on 4/13/18.
//

import UIKit

class ChatHistoryViewController: UIViewController {
    
    var chatHistoryArray : [[[String : Any]]] = []
    var segId = String ()
    var callSalesRepUrl:[[String: Any]] = []

    @IBOutlet weak var tableV: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupUI()
        self.getCallSalesRepImage()
        self.getTheChatHistory()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Actions
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI()  {
        
        self.title = "Chat"
        WSUtility.addNavigationBarBackButton(controller: self)
    }
    
    func getTheChatHistory()  {
        
        UFSProgressView.showWaitingDialog("")
        
        let webServiceBusinessLayer = WSWebServiceBusinessLayer()
        webServiceBusinessLayer.chatHistory(email_Id:UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)! as! String, successResponse: { (responce) in
            
            var parmsDict: [String: Any] = [:]
            parmsDict = responce as! [String : Any]
            
            if parmsDict["error"] as! Bool == false{

                var dataDict: [String: Any] = [:]
                dataDict = parmsDict ["data"] as! [String : Any]

                let chatAray = dataDict ["operatorChatHistory"] as! [[String : Any]]
              
                self.chatHistoryArray = self.createSeprateHistory(chatArray: chatAray)
                
                print("=========\(self.chatHistoryArray)=========")
                
                self.tableV.reloadData()
               
                UFSProgressView.stopWaitingDialog()
            
                 if !self.segId.isEmpty {
                    
                    let chatStoryboard = UIStoryboard.init(name: "Chat", bundle: nil)
                    let cahtViewController = chatStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                    cahtViewController.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController( cahtViewController,animated: false)
                }

                
            }}) { (errorMessage) in
                
                UFSProgressView.stopWaitingDialog()
                
                let chatStoryboard = UIStoryboard.init(name: "Chat", bundle: nil)
                let cahtViewController = chatStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                cahtViewController.hidesBottomBarWhenPushed = true
                cahtViewController.segId = "0"
                self.navigationController?.pushViewController( cahtViewController,animated: false)
        }
        
        
    }
    
    func getCallSalesRepImage(){
        
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.getCallSalesRepImage(successResponse: { (response) in
            
            self.callSalesRepUrl = response["data"] as! [[String: Any]]
            
            if self.callSalesRepUrl.count > 0 {
                
                self.tableV.reloadData()
            }
            
        }) { (errorMessage) in
            
        }
    }
    
    
    func createSeprateHistory (chatArray : [[String : Any]]) -> [[[String : Any]]]{
        
        //create a seg ment array
        var segMentArray:[String] = []
        var gruopArray : [[[String : Any]]] = []
        
        for Msg in chatArray {
            
            segMentArray.append(Msg["seg_id"] as! String)
            
        }
        //remove duplicates
        segMentArray.removeDuplicates()
        //create an history array
        for Group in segMentArray{
            
            let filteredVisitors = chatArray.filter({
                ($0["seg_id"] as! String) == Group //access the value to filter
            })
            gruopArray.append(filteredVisitors)
            
        }
        return gruopArray
        
    }

}
extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}
extension ChatHistoryViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return chatHistoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatGropTableViewCell", for: indexPath) as! ChatGropTableViewCell
        let firstMsg = chatHistoryArray[indexPath.row][0] as [String : Any]
        if (firstMsg["seg_name"] as? String == ""){
            
            cell.chatNameLb.text = firstMsg["slrep_name"] as? String
            if self.callSalesRepUrl.count > 0 {
                
                let dict = self.callSalesRepUrl.first!
                
                if let imageurl = dict["slrep_image"] {
                    
                    cell.chatHeadImgV.layer.masksToBounds = true;
                    cell.chatHeadImgV.layer.cornerRadius = 25.0
                    cell.chatHeadImgV.sd_setImage(with: URL(string:imageurl as! String))
                }
            }
    
        }else{
             cell.chatNameLb.text = firstMsg["seg_name"] as? String
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatStoryboard = UIStoryboard.init(name: "Chat", bundle: nil)
        let cahtViewController = chatStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        cahtViewController.hidesBottomBarWhenPushed = true
        let firstMsg = chatHistoryArray[indexPath.row][0] as [String : Any]
        cahtViewController.segId = (firstMsg["seg_id"] as? String)!
        self.navigationController?.pushViewController( cahtViewController,animated: false)
       
    }
}



