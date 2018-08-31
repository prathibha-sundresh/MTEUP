//
//  MyNotificationViewController.swift
//  yB2CApp
//
//  Created by Lakshminarayana on 26/12/17.
//

import UIKit

class MyNotificationViewController: UIViewController,MyNotificationLoadMoreTableViewCellDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var myNotificationLabel: UILabel!{
    didSet{
      myNotificationLabel.text = WSUtility.getlocalizedString(key: "My Notifications", lang: WSUtility.getLanguage(), table: "Localizable")
    }
  }
  var loadMoreCellHeight = 0
  var notificationData: [[String: Any]] = []
  var nextPageUrl:String = ""
  var notificationTrayStatus:Int = 0
  var notificationID:Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    UFSGATracker.trackScreenViews(withScreenName: "Notification Screen")
    FireBaseTracker.ScreenNaming(screenName: "Notification Screen", ScreenClass: String(describing: self))
    FBSDKAppEvents.logEvent("Notification Screen")

    // Do any additional setup after loading the view.
    self.registerTableView()
    WSUtility.addNavigationBarBackButton(controller: self)
    self.getNotificationList()
  }
  
  func registerTableView(){
    tableView.delegate = self
    tableView.dataSource = self
  }
    override func viewDidAppear(_ animated: Bool) {
//        nextPageUrl = ""
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.trackingScreens(screenName: "Notification Screen")

    }
  @IBAction func backAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func getNotificationList(){
    UFSProgressView.showWaitingDialog("")
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.getNotificaionListFromAdmin(requestURL: nextPageUrl,successResponse: { (response) in
      print(response)
      if let responseData = response["data"] as? [String : Any]{
        if let dictRecommendedProdcut = responseData["data"] as? [[String : Any]]{
          for index in dictRecommendedProdcut{
            self.notificationData.append(index)
          }
        }
        if let next_page_url = responseData["next_page_url"] as? String{
          self.nextPageUrl = next_page_url
        }
      }
      
      self.tableView.reloadData()
      UFSProgressView.stopWaitingDialog()
      
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
    }
    
  }
  
  
  func loadMoreButtonAction(loadMoreCell:MyNotificationLoadMoreTableViewCell)
  {
    getNotificationList()
  }
    func redirectToscreen(notificationData: [String: Any]){
        let appDelegate = UIApplication.shared.delegate as! HYBAppDelegate
        switch notificationData["NotificationType"] as! String {
        case "home_screen":
            self.tabBarController?.selectedIndex = 0
            self.navigationController?.popViewController(animated: true)
            break
        case "shopping_list_screen":
            self.tabBarController?.selectedIndex = 1
            self.navigationController?.popViewController(animated: true)
            break
        case "product_category_screen":
            self.tabBarController?.selectedIndex = 2
            self.navigationController?.popViewController(animated: true)
            break
        case "search_screen":
            self.tabBarController?.selectedIndex = 4
            self.navigationController?.popViewController(animated: true)
            break
        case "search_recipe_screen":
            self.tabBarController?.selectedIndex = 3
            self.navigationController?.popViewController(animated: true)
            break
        case "product_listing_screen":
            appDelegate.navigateToAllProductScreen()
            break
        case "product_detail_screen":
            appDelegate.navigate(toProductDetailScreen: notificationData["code"] as! String)
            break
        case "recipe_listing_screen":
            appDelegate.navigateToRecipeListScreen()
            break
        case "recipe_detail_screen":
            appDelegate.navigate(toRecipeDetailScreen:notificationData["code"] as! String)
            break
        case "recipe_favorites_screen":
            appDelegate.navigateToMyRecipeListScreen()
            break
        case "my_accounts_screen":
            appDelegate.navigateToMyAccountScreen()
            break
        case "chef_rewards_screen":
            appDelegate.navigateToChefRewardScreen()
            break
        case "loyalty_listing_screen":
            appDelegate.navigateToChefRewardLoyaltyListScreen()
            break
        case "notifications_screen":
            appDelegate.navigateToNotificationScreen()
            break
        case "order_listing_screen":
            appDelegate.navigateToOrderHistoryScreen()
            break
        case "order_detail_screen":
            appDelegate.navigateToOrderHistoryScreen()
            break
        case "app_settings_screen":
            appDelegate.navigateToAppSettingScreen()
            break
        case "my_cart_screen":
            appDelegate.navigateToCartScreen()
            break
        default:
            self.tabBarController?.selectedIndex = 0
            self.navigationController?.popViewController(animated: true)
            
        }
    }
  func sendNotificationStatus(ID:Int, notificationStatus:Int,tmpDict: [String: Any]){
    
    let modifiedResults : [[String :Any]] = notificationData.map { dictionary in
        var dict = dictionary
        if let tmpNid = (dict["nid"] as AnyObject).integerValue, tmpNid == ID  {
            dict["flag"] = "Read"
        }
        return dict
    }
    notificationData = modifiedResults
    self.tableView.reloadData()
    
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.sendNotificationStatus(notificationID: ID, notificationTray: notificationStatus, successResponse: { (Response) in
        
    }) { (errorMessage) in
    
    }

  }
  
  func tappedOnNotificationTypeButton(sender:UIButton) {
    
    let dict = notificationData[sender.tag]

    if let flag = dict["flag"] as? String{
        if flag != "Read"{
            if let nid = dict["nid"] as? String{
                notificationID = Int(nid)!
            }
            sendNotificationStatus(ID: notificationID, notificationStatus: notificationTrayStatus, tmpDict: [:])
        }
    }
    self.redirectToscreen(notificationData: dict)
  }
  
}

extension MyNotificationViewController:UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notificationData.count + 1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == notificationData.count{
      let loadMoreCell:MyNotificationLoadMoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyNotificationLoadMoreCell") as! MyNotificationLoadMoreTableViewCell
      loadMoreCell.setUI()
      loadMoreCell.delegate = self
      return loadMoreCell
    }else{
      let cell = tableView.dequeueReusableCell(withIdentifier: "MyNotificationCell") as! MyNotificationTableViewCell
      let dictionary = notificationData[indexPath.row]
      cell.notificationTypeButton.tag = indexPath.row
      cell.notificationTypeButton.addTarget(self, action: #selector(tappedOnNotificationTypeButton), for: .touchUpInside)

      cell.setUI(dict: dictionary)
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let dict = notificationData[indexPath.row]
    if let flag = dict["flag"] as? String{
      if flag != "Read"{
        if let nid = dict["nid"]{
            notificationID = (nid as AnyObject).integerValue
        }
        sendNotificationStatus(ID: notificationID, notificationStatus: notificationTrayStatus, tmpDict: [:])
      }
    }
    self.redirectToscreen(notificationData: dict)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == notificationData.count{
      if nextPageUrl == ""{
        return 0
      }else{
        return 60
      }
    }
    else{
      return UITableViewAutomaticDimension
    }
    
  }
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
}
