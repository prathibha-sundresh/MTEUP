//
//  ChatViewController.swift
//  UFSDev
//
//  Created by Abbut John on 3/14/18.
//
/*
import UIKit
import Firebase

class ChatViewController: JSQMessagesViewController {

    var emailId : String = ""
    var salesRepoId : String = ""
    var segId : String = ""
    var messages = [JSQMessage]()
    var callSalesRepUrl:[[String: Any]] = []
    var isHidden:Bool = false
    var chatAray:[[String: Any]] = []
    
    static let kdateFormatWithtime      = "yyyy-MM-dd HH:mm:ss"
    static let kdateFormate             = "yyyy-MM-dd"
    static let kTimeFormate             = "HH:mm:ss"
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        setUpUI()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadColV(notfication:)), name:.msgcame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadTheDataFromServer), name:NSNotification.Name.UIApplicationWillEnterForeground , object: nil)
        loadTheDataFromServer()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Actions
    
    @IBAction func backAction(_ sender: UIButton) {
        
        if(chatAray.count==0){
             self.navigationController?.popToRootViewController(animated: true)
        }else{
             self.navigationController?.popViewController(animated: true)
        }
        
       
    }
    
    // UI Methods
    
    func setUpUI()  {
        

        self.senderId = "Reciver_ID"
        self.senderDisplayName = "Me"
        self.title = "Chat"
        
        isHidden = !isHidden
        WSUtility.addNavigationBarBackButton(controller: self)
        self.inputToolbar.contentView.leftBarButtonItem = nil;
        self.inputToolbar.contentView.textView.delegate = self

        self.automaticallyScrollsToMostRecentMessage = true
        
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        
        
    }
    
    // Network
    
    func loadTheDataFromServer()  {
        
        messages.removeAll()
        collectionView.reloadData()
        self.getTheSalesRepId()
        self.getTheChatHistory()
        
    }
    
  
    
    func getTheSalesRepId()  {
        
        UFSProgressView.showWaitingDialog("")
        let webServiceBusinessLayer = WSWebServiceBusinessLayer()
        webServiceBusinessLayer.startChat(email_Id:UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)! as! String, successResponse: { (responce) in
            
            var parmsDict: [String: Any] = [:]
            parmsDict = responce as! [String : Any]
            
            if parmsDict["error"] as! Bool == false{
                
                var dataDict: [String: Any] = [:]
                dataDict = parmsDict ["data"] as! [String : Any]
                self.salesRepoId = dataDict ["slrep_id"]  as! String
                
                if(dataDict ["sales_rep_online"] as! Int == 0){
                    
                    self.inputToolbar.contentView.textView.isEditable = false
                    self.inputToolbar.contentView.isHidden = true
                    
                    self.showAlert(textMsg: "Sales Representative is not available")
                    
                }

            }else{
                
                print("failed")
                
                self.inputToolbar.contentView.textView.isEditable = false
                self.inputToolbar.contentView.isHidden = true
                
                self.showAlert(textMsg: "Sales Representative is not available")
            }
            
        }) { (errorMessage) in
            
            print("failed")
            
            self.inputToolbar.contentView.textView.isEditable = false
            self.inputToolbar.contentView.isHidden = true
            
            self.showAlert(textMsg: "Sales Representative is not available")
            
        }
    }
    
    func showAlert(textMsg: String) {
        
        let alert = UIAlertController(title: "Alert", message: textMsg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func sendTheMsg (textMsg: String)  {
        
        var groupChat = Bool()
        groupChat = false
        
        if(self.segId == ""){
            
             groupChat = false
            
        }else{
            
            groupChat = true
        }
        
     
        
        let webServiceBusinessLayer = WSWebServiceBusinessLayer()
        
        webServiceBusinessLayer.sendMsg(slrep_id: self.salesRepoId, email_Id: UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)! as! String , reply_Msg: textMsg, seg_id: groupChat ? self.segId : "", groupChatOrNot: groupChat, successResponse: { (responce) in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = ChatViewController.kdateFormatWithtime
            let currentDateTime = Date()
            let myString = dateFormatter.string(from: currentDateTime)
            let date = dateFormatter.date(from: myString)
            self.addMessage(withId:self.senderId, name: self.senderDisplayName, date: date!, text: textMsg)
            self.collectionView.reloadData()
            self.scrollToBottom(animated: true)
            
        }) { (errorMessage) in
            
            print("failed to send Msg")
        }
    }
    
    
    func getTheChatHistory()  {
        
        let webServiceBusinessLayer = WSWebServiceBusinessLayer()
        webServiceBusinessLayer.chatHistory(email_Id:UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)! as! String, successResponse: { (responce) in
            
            var parmsDict: [String: Any] = [:]
            parmsDict = responce as! [String : Any]
            
            if parmsDict["error"] as! Bool == false{
                
                
                
                var dataDict: [String: Any] = [:]
                dataDict = parmsDict ["data"] as! [String : Any]
                self.senderId = dataDict ["chat_history_of_userid"] as! String
                self.chatAray = []
                self.chatAray = dataDict ["operatorChatHistory"] as! [[String : Any]]
                print (self.chatAray)
                
                
                let filteredMsg = self.chatAray.filter({
                    ($0["seg_id"] as! String) == self.segId //access the value to filter
                })
                
                self.messages = [JSQMessage]()
                //putting data in to db
                for msg in filteredMsg {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = ChatViewController.kdateFormatWithtime
                    let date = dateFormatter.date(from: (String(format: "%@", msg["created_at"] as! String!)))!
                    self.addMessage(withId: msg["sender_id"] as! String, name: msg["sender"] as! String, date: date, text:  msg["message"] as! String)
                   
                    
                }
                
          
                self.collectionView .reloadData()
                self.scrollToBottom(animated: true)
                UFSProgressView.stopWaitingDialog()
                
            }}) { (errorMessage) in
                
                UFSProgressView.stopWaitingDialog()
        }
        
        
    }
    
    // Reload Collection View
    
    @objc func reloadColV(notfication: NSNotification)  {
        
        self.messages = [JSQMessage]()
        
        
        let webServiceBusinessLayer = WSWebServiceBusinessLayer()
        webServiceBusinessLayer.chatHistory(email_Id:UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)! as! String, successResponse: { (responce) in
            
            var parmsDict: [String: Any] = [:]
            parmsDict = responce as! [String : Any]
            
            if parmsDict["error"] as! Bool == false{
                
                
                var dataDict: [String: Any] = [:]
                dataDict = parmsDict ["data"] as! [String : Any]
                self.senderId = dataDict ["chat_history_of_userid"] as! String
                self.chatAray = []
                self.chatAray = dataDict ["operatorChatHistory"] as! [[String : Any]]
                print (self.chatAray)
                
                let filteredMsg = self.chatAray.filter({
                    ($0["seg_id"] as! String) == self.segId //access the value to filter
                })
                
                self.messages = [JSQMessage]()
                //putting data in to db
                for msg in filteredMsg {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = ChatViewController.kdateFormatWithtime
                    let date = dateFormatter.date(from: (String(format: "%@", msg["created_at"] as! String!)))!
                    self.addMessage(withId: msg["sender_id"] as! String, name: msg["sender"] as! String, date: date, text:  msg["message"] as! String)
                    
                    
                }
                
         
                self.collectionView .reloadData()
                self.scrollToBottom(animated: true)
                
                
            }}) { (errorMessage) in
                
                
        }
    }
    

    
    private func addMessage(withId id: String, name: String, date: Date, text: String) {
        
        if let message = JSQMessage(senderId: id, senderDisplayName: name, date : date, text: text) {
            
            
            messages.append(message)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    override var prefersStatusBarHidden: Bool{
        return isHidden
    }
    override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 50
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        
        return 0.0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return 17.0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            return nil
        } else {
            
            guard let senderDisplayName = message.senderDisplayName else {
                assertionFailure()
                return NSAttributedString(string: "Sender")
            }
            
            if (senderDisplayName == ""){
                return NSAttributedString(string:"Sender")
            }else{
                return NSAttributedString(string: senderDisplayName)
            }
            
        }
        
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        let message = messages[indexPath.item] // 1
        
        
        if message.senderId == senderId {
            return nil
        } else {
            guard let senderDisplayName = message.senderDisplayName else {
                assertionFailure()
                return nil
            }
            return NSAttributedString(string: senderDisplayName)
            
        }
        
    }
    
    
    func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        return NSAttributedString(string: "ok")
    }
    func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 50
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        
        if(messages.count > indexPath.row){
            
            return messages[indexPath.item]
            
        }else{
            
            return JSQMessage(senderId: "", displayName: "", text: "")
        }
    }
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: "?", backgroundColor: UIColor.darkGray, textColor: UIColor.green, font: UIFont.systemFont(ofSize: 14), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        let msg =  messages[indexPath.item]
        var preMsg : JSQMessage? = nil
        
        if indexPath.item > 0{
            
            preMsg = self.messages[indexPath.item - 1]
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let MsgDateString = formatter.string(from:  msg.date)
            let PreMsgDateString = formatter.string(from:  (preMsg?.date)!)
            
            if (indexPath.item - 1 > 0 && MsgDateString != PreMsgDateString){
                
                let formatter = DateFormatter()
                // initially set the format based on your datepicker date
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateString = formatter.string(from:  msg.date)
                
                return (NSAttributedString.init(string: dateString, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 9), NSForegroundColorAttributeName:UIColor.black]))
                
                
            }else if(indexPath.item - 1 > 0 && PreMsgDateString == MsgDateString){
                
                let formatter = DateFormatter()
                // initially set the format based on your datepicker date
                formatter.dateFormat = "HH:mm:ss"
                let dateString = formatter.string(from:  msg.date)
                
                return (NSAttributedString.init(string: dateString, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 9), NSForegroundColorAttributeName:UIColor.black]))
                
            }else{
                
                return nil
                
            }
            
        }else if indexPath.item == 0{
            
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = formatter.string(from:  msg.date)
            
            return (NSAttributedString.init(string: dateString, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 9), NSForegroundColorAttributeName:UIColor.black]))
            
        }else{
            
            return nil
            
        }
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        self.inputToolbar.contentView.textView.text = ""
        sendTheMsg(textMsg: text)
        
    }
}
extension Notification.Name {
    
    static let msgcame = Notification.Name("msgcame")
}


*/
