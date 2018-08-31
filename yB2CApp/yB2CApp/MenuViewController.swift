//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
  func slideMenuItemSelectedAtIndex(_ index : Int32)
}

let ProfileCell = 0
let MenuCell = 1
let CallSalesRepCell = 7
var name = ""

var isExpanding = false
class MenuViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
  
  /**
   *  Array to display menu options
   */
  @IBOutlet var tblMenuOptions : UITableView!
  
  /**
   *  Transparent button to hide menu
   */
  @IBOutlet var btnCloseMenuOverlay : UIButton!
  
  /**
   *  Array containing menu options
   */
  var arrayMenuOptions = [Dictionary<String,String>]()
  /**
   * Array Containing select menu options
   */
  var arrayMenuSelectOptions = [Dictionary<String,String>]()
  /**
   *  Menu button which was tapped to display the menu
   */
  var btnMenu : UIButton!
  
  /**
   *  Delegate of the MenuVC
   */
  
  var delegate : SlideMenuDelegate?
  
  
  var selectedIndexPaths = Set<NSIndexPath>()
  
  var callSalesRepUrl:[[String: Any]] = []
  
  let wsWebServiceBusinessLayer = WSWebServiceBusinessLayer()
  var notificationCount:String = ""
  var isSalesRepoChatEnable = false
  override func viewDidLoad() {
    super.viewDidLoad()
    tblMenuOptions.tableFooterView = UIView()
    tblMenuOptions.estimatedRowHeight = 50
    tblMenuOptions.register(UINib(nibName: "WSSalesRepTableViewCell", bundle: nil), forCellReuseIdentifier: "WSSalesRepTableViewCell")
    if #available(iOS 11.0, *) {
      tblMenuOptions.contentInsetAdjustmentBehavior = .never
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateArrayMenuOptions()
    updateArrayMenuSelectOptions()
    
    getNotificationCount()
    getCallSalesRepImage()
    
    //        if WSUtility.isFeatureEnabled(feature: featureId.Sales_rep_chat_feature.rawValue) {
    //            isSalesRepoChatEnable = true
    //        }
  }
  
  func updateArrayMenuOptions(){
    
    arrayMenuOptions.append(["title":WSUtility.getlocalizedString(key: "My UFS", lang: WSUtility.getLanguage(), table: "Localizable")!, "icon":"TabBar-Home-Selected"])
    arrayMenuOptions.append(["title":WSUtility.getlocalizedString(key: "Chef Rewards", lang: WSUtility.getLanguage(), table: "Localizable")!, "icon":"MenuBar-chef_rewards"])
    arrayMenuOptions.append(["title":WSUtility.getlocalizedString(key: "Scan", lang: WSUtility.getLanguage(), table: "Localizable")!, "icon":"MenuBar-Scan"])
    arrayMenuOptions.append(["title":WSUtility.getlocalizedString(key: "Notifications", lang: WSUtility.getLanguage(), table: "Localizable")!, "icon":"MenuBar-Notifications"])
    arrayMenuOptions.append(["title":WSUtility.getlocalizedString(key: "Order History", lang: WSUtility.getLanguage(), table: "Localizable")!, "icon":"MenuBar-Order_history"])
    arrayMenuOptions.append(["title":WSUtility.getlocalizedString(key: "App Settings", lang: WSUtility.getLanguage(), table: "Localizable")!, "icon":"menubar-App_settings"])
    
    
    tblMenuOptions.reloadData()
  }
  func updateArrayMenuSelectOptions(){
    
    arrayMenuSelectOptions.append(["title":WSUtility.getlocalizedString(key: "My UFS", lang: WSUtility.getLanguage(), table: "Localizable")!, "icon":"TabBar-Home-Selected"])
    arrayMenuSelectOptions.append(["title":WSUtility.getlocalizedString(key: "Chef Rewards", lang: WSUtility.getLanguage(), table: "Localizable")!, "icon":"menuBar-Chef_rewards_select"])
    arrayMenuSelectOptions.append(["title":WSUtility.getlocalizedString(key: "Scan", lang: WSUtility.getLanguage(), table: "Localizable")!, "icon":"menuBar-Scan_deselect"])
    arrayMenuSelectOptions.append(["title":WSUtility.getlocalizedString(key: "Notifications", lang: WSUtility.getLanguage(), table: "Localizable")!, "icon":"menuBar-notifications_select"])
    arrayMenuSelectOptions.append(["title":WSUtility.getlocalizedString(key: "Order History", lang: WSUtility.getLanguage(), table: "Localizable")!, "icon":"menuBar-order_history_select"])
    arrayMenuSelectOptions.append(["title":WSUtility.getlocalizedString(key: "App Settings", lang: WSUtility.getLanguage(), table: "Localizable")!, "icon":"menubar-App_settings_select"])
    
    tblMenuOptions.reloadData()
  }
  
  func getNotificationCount(){
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    
    serviceBussinessLayer.getNotificaionReadUnreadCount(successResponse: { (response) in
      print(response)
      if let data = response["data"] as? Int{
        self.notificationCount = "\(data)"
      }
      self.tblMenuOptions.reloadData()
      
    }) { (errorMessage) in
      
    }
  }
  @IBAction func onCloseMenuClick(_ button:UIButton!){
    
    btnMenu.tag = 0
    
    if (self.delegate != nil) {
      var index = Int32(button.tag)
      if(button == self.btnCloseMenuOverlay){
        index = -1
      }
      delegate?.slideMenuItemSelectedAtIndex(index)
    }
    
    UIView.animate(withDuration: 0.3, animations: { () -> Void in
      self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
      self.view.layoutIfNeeded()
      self.view.backgroundColor = UIColor.clear
    }, completion: { (finished) -> Void in
      self.view.removeFromSuperview()
      self.removeFromParentViewController()
    })
  }
  
  func isSalesRepSectionHidden() -> Bool {
    if  WSUtility.isFeatureEnabled(feature: featureId.Live_Chat_Chef.rawValue) == false && WSUtility.isFeatureEnabled(feature: featureId.Sales_rep_chat_feature.rawValue) == false && WSUtility.isFeatureEnabled(feature: featureId.Sales_Rep_Call.rawValue) == false{
      return true
      
    }
    return false
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    if indexPath.row == ProfileCell {
      let profileCell:WSSlideMenuProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WSSlideMenuProfileTableViewCell") as! WSSlideMenuProfileTableViewCell
      profileCell.setUI()
      return profileCell
    }
    else if (indexPath.row >= MenuCell && indexPath.row<=6)
    {
      let menuCell:WSSlideMenuCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WSSlideMenuCellTableViewCell") as! WSSlideMenuCellTableViewCell
      //  menuCell.itemImageView.image = UIImage(named:"home_select")
      menuCell.itemImageView.image = UIImage(named: arrayMenuOptions[indexPath.row-1]["icon"]!)
      menuCell.notificationCountLabel.isHidden = true
      menuCell.itemNameLabel.text = WSUtility.getlocalizedString(key: arrayMenuOptions[indexPath.row-1]["title"]!, lang: WSUtility.getLanguage(), table: "Localizable")
      if menuCell.itemNameLabel.text == WSUtility.getlocalizedString(key: "Notifications", lang: WSUtility.getLanguage(), table: "Localizable")!{
        if notificationCount == ""{
          menuCell.notificationCountLabel.isHidden = true
          
        }else{
          menuCell.notificationCountLabel.isHidden = false
        }
        
      }
      menuCell.notificationCountLabel.setTitle(notificationCount, for: UIControlState.normal)
      
      if let cell = tableView.dequeueReusableCell( withIdentifier: "WSSlideMenuCellTableViewCell") as? WSSlideMenuCellTableViewCell {
        
        if self.selectedIndexPaths.contains( indexPath as NSIndexPath ) {
          // Change color of the cell just dequeued/created
          menuCell.itemNameLabel.font = UIFont.init(name: "DINPro-Regular", size: 16)
          menuCell.itemNameLabel.textColor = UIColor.gray
        }
        // cell = menuCell
      }
      return menuCell
    }
    else {
      
      
      let callSalesRepCell:WSSalesRepTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WSSalesRepTableViewCell") as! WSSalesRepTableViewCell
      
      
      callSalesRepCell.delegate =  self as SalesRepoDelegate
      callSalesRepCell.backgroundColor = UIColor(red: 247.0 / 255.0, green: 245.0 / 255.0, blue: 243.0 / 255.0, alpha: 0.6)
      callSalesRepCell.updateCellContent(isNeedToHideAllViews: isSalesRepSectionHidden(), salesRepDetails: callSalesRepUrl, cellExpandingStatus: isExpanding)
      
      /*
      if WSUtility.isFeatureEnabled(feature: featureId.Live_Chat_Chef.rawValue) {
        callSalesRepCell.callSalesRepImage.image = #imageLiteral(resourceName: "bubbleIcon")
        callSalesRepCell.setSaleRepName(name: "", message: WSUtility.getlocalizedString(key: "Need help? Chat with our chef.", lang: WSUtility.getLanguage())!)
        callSalesRepCell.callButton.isHidden = true
        callSalesRepCell.chatBtn.isHidden = !isExpanding
      }else{
        
        callSalesRepCell.chatBtn.isHidden = true
        callSalesRepCell.callButton.isHidden = !isExpanding
        
        if self.callSalesRepUrl.count > 0 {
          
          let dict = self.callSalesRepUrl.first!
          
          if let imageurl = dict["slrep_image"] {
            
            callSalesRepCell.callSalesRepImage.layer.masksToBounds = true;
            callSalesRepCell.callSalesRepImage.layer.cornerRadius = 25.0
            callSalesRepCell.callSalesRepImage.sd_setImage(with: URL(string:imageurl as! String))
          }
          
          if let firstName = dict["slrep_name"] as? String{
            let salePersonFistName = firstName.components(separatedBy: " ")
            if salePersonFistName.count > 0 {
              
              //let buttonTitle = String(format:WSUtility.getTranslatedString(forString: "Call your sales representative"),dict["slrep_name"] as! String)
              
              let buttonTitle = String(format:WSUtility.getTranslatedString(forString: "Call your sales representative"),salePersonFistName[0])
              callSalesRepCell.callButton.setTitle(buttonTitle, for: .normal)
              
              let chatbuttonTitle = String(format:WSUtility.getTranslatedString(forString: "Chat with your sales representative"),salePersonFistName[0])
              callSalesRepCell.chatBtn.setTitle(chatbuttonTitle, for: .normal)
              
              callSalesRepCell.chatBtn.addTarget(self, action: #selector(chatButton_click), for: .touchUpInside)
              callSalesRepCell.chatBtn.isHidden = false
              if isSalesRepoChatEnable == false {
                callSalesRepCell.chatBtn.isHidden = true
              }
              
              
              callSalesRepCell.setSaleRepName(name: salePersonFistName[0], message: "Need Help, Call your sales rep")
            }
            
          }
          
          //  callSalesRepCell.setSaleRepName(name: dict["slrep_name"] as! String)
          
        }
        
      }
      
       callSalesRepCell.chatBtn.addTarget(self, action: #selector(chatButton_click), for: .touchUpInside)
      //callSalesRepCell.callButton.isHidden = !isExpanding
      callSalesRepCell.callButtonHeightConstraint.constant = callSalesRepCell.callButton.isHidden ? 0 : 35
      callSalesRepCell.callButtonTopConstraint.constant = callSalesRepCell.callButton.isHidden ? 0 : 10
      
      /*
      callSalesRepCell.chatBtn.isHidden = !isExpanding
      if isSalesRepoChatEnable == false {
        callSalesRepCell.chatBtn.isHidden = true
      }
 */
      callSalesRepCell.chatBtnHightConstraint.constant = callSalesRepCell.chatBtn.isHidden ? 0 : 35
      callSalesRepCell.chatBtnTopConstraint.constant = callSalesRepCell.chatBtn.isHidden ? 0 : 10
      
      */
      
      return callSalesRepCell
    }
  }
  
  @IBAction func chatButton_click(_ sender: Any) {

    LiveChat.presentChat()
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let btn = UIButton(type: UIButtonType.custom)
    btn.tag = indexPath.row
    
    if (indexPath.row == CallSalesRepCell) {
      reloadSaleRepoSection(isExpandedCell: isExpanding)
      
    }else{
      
      if(indexPath.row == 6)
      {
        performSegue(withIdentifier: "AppSettingsSegue", sender: self)
      }
      if (indexPath.row == 5) {
        let checkoutStoryboard = UIStoryboard.init(name: "MyOrderHistory", bundle: nil)
        let orderHistoryViewController = checkoutStoryboard.instantiateViewController(withIdentifier: "MyOrderHistoryViewControllerID") as! MyOrderHistoryViewController
        self.navigationController?.pushViewController(orderHistoryViewController, animated: false)
      }
      
      
      self.onCloseMenuClick(btn)
      self.selectedIndexPaths.insert( indexPath as NSIndexPath )
      
      if let menuCell = tableView.cellForRow( at: indexPath ) as? WSSlideMenuCellTableViewCell {
        // Change color of the existing cell
        menuCell.itemNameLabel.font = UIFont.init(name: "DINPro-Medium", size: 16)
        menuCell.itemNameLabel.textColor = UIColor.black
        menuCell.itemImageView.image = UIImage(named: arrayMenuSelectOptions[indexPath.row-1]["icon"]!)
        
        
      }
    }
    
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrayMenuOptions.count+2
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1;
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
  {
    if indexPath.row == 0{
      //            if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
      //                return 180.0
      //            }
      //            else{
      //                return 220.0
      //            }
      return 220.0
    }
    if indexPath.row == CallSalesRepCell {
      if isSalesRepSectionHidden(){
        return 0
      }
      return UITableViewAutomaticDimension
    }
    return 50
  }
  
  
  func getCallSalesRepImage(){
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.getCallSalesRepImage(successResponse: { (response) in
        
        self.callSalesRepUrl.removeAll()
        if WSUtility.isLoginWithTurkey(){
            if let dict = response["ChefInfo"] as? [String: Any]{
                self.callSalesRepUrl.append(dict)
            }
        }
        else{
            if let list = response["data"] as? [[String: Any]], list.count > 0{
                self.callSalesRepUrl.append(list[0])
            }
        }
        
      if self.callSalesRepUrl.count > 0 {
        
        let indexPath = IndexPath(row: CallSalesRepCell, section: 0)
        self.tblMenuOptions.reloadRows(at: [indexPath], with: .automatic)
      }
      
    }) { (errorMessage) in
      
    }
  }
  @IBAction func editMyaccount_Click(sender: UIButton){
    
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "MyAccountVC"{
      self.onCloseMenuClick(self.btnCloseMenuOverlay)
    }
    if segue.identifier == "AppSettingsSegue"{
      let appSettingsVC = segue.destination as! AppSettingsViewController
      appSettingsVC.isFromMenu = true
    }
  }
}
extension MenuViewController : SalesRepoDelegate{
  func reloadSaleRepoSection(isExpandedCell: Bool) {
    isExpanding = !isExpanding
    let indexPath = IndexPath(row: 7, section: 0)
    if isExpanding {
      tblMenuOptions.reloadRows(at: [indexPath], with: .bottom)
    }else{
      tblMenuOptions.reloadRows(at: [indexPath], with: .top)
    }
  }
  
}

