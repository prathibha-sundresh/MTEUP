//
//  OrderSuccessViewController.swift
//  yB2CApp
//
//  Created by Ajay on 29/11/17.
//

import UIKit

class OrderSuccessViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  @IBOutlet weak var orderTableView: UITableView!
  @IBOutlet weak var orderSuccessfulLabel: UILabel!
  @IBOutlet weak var earnedPoints: UILabel!
  @IBOutlet weak var pointBalance: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var rewardLbl: UILabel!
  @IBOutlet weak var continueShoppingButton: WSDesignableButton!
  @IBOutlet weak var sentToTradepartnerLabel: UILabel!
  @IBOutlet weak var pointsBalanceLabel: UILabel!
  @IBOutlet weak var EarnedLabel: UILabel!
  @IBOutlet weak var orderNumberLbl: UILabel!
  @IBOutlet weak var pointsLabel: UILabel!
  
  var promoCode = ""
  var orderStatusDictionary = [String: Any]()
  var updateDictToAdmin = [String: Any]()
  let reuseIdentifier = "summarycell" // also enter this string as the cell identifier in the storyboard
  var items = ["200", "700", "900", "120", "140"]
  var pointEarned = ""
  var earnedLoyaltyPoints = ""
  var loyaltyProdcutCatlog = [[String:Any]]()
  
  let Order_Success_CELL = 0
  let CHEF_REWARD_CELL = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    UserDefaults.standard.set(false, forKey: "isFromSummary")
    UserDefaults.standard.set(nil, forKey: "userDeliveryDetails")
    UserDefaults.standard.removeObject(forKey: Cart_Detail_Key)
    WSWebServiceBusinessLayer().trackingScreens(screenName: "Order Success Screen")
    UFSGATracker.trackScreenViews(withScreenName: "Home Screen")// added this one to match android apps flow in campaign tracking
    UFSGATracker.trackScreenViews(withScreenName: "Order Success Screen")
    FireBaseTracker.ScreenNaming(screenName: "Order Success Screen", ScreenClass: String(describing: self))
    
    FBSDKAppEvents.logEvent("Order Success Screen")
    //FBSDKAppEvents.logPurchase("item purchased")
    //sifuOrderId - key to get sifu order id
    let businessLayer = WSWebServiceBusinessLayer()
    
    var orderNumber: String = ""
    if let code = orderStatusDictionary["sifuOrderId"]{
      orderNumber = "\(code)"
    }else if let code = orderStatusDictionary["code"] {
      orderNumber = "\(code)"
    }
    businessLayer.triggerOrderPlacedPushNotification(action: "order_completed", order_id: orderNumber)
    
    WSUtility.sendTrackingEvent(events: "Orders", categories: "Product order",actions:"\(orderNumber)")
    
    UFSGATracker.trackEvent(withCategory: "Product order", action: "Order Number - \(orderNumber)", label: "Product Order Success", value: nil)
    
    if  WSUtility.isUserPlacedFirstOrder() == true {
      getLoyaltyPoint()
    }else{
      if self.promoCode != ""{
        var dict:[String: Any] = [:]
        dict["promocode"] = self.promoCode
        if let orderNumber = orderStatusDictionary["sifuOrderId"]{
          dict["order_id"] = "\(orderNumber)"
        }else if let code = orderStatusDictionary["code"] {
          dict["order_id"] = "\(code)"
        }
        
        let emailID = UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)!
        dict["email_id"] = "\(emailID)"
        WSWebServiceBusinessLayer().afterOrderPlacedToStoreTheSifuOrderIdAndLoyaltyPointsForPromoCodeInAdminRequest(parmsDict: dict, successResponse: { (response) in
          
          self.updateDictToAdmin = response as! [String : Any]
          
          self.addLoyaltyPoints()
          
        }, faliureResponse: { (errorMessage) in
          
        })
        self.sendPushNotificationForPromoCode()
      }
      else{
        self.addLoyaltyPoints()
      }
      
    }
    
    // Do any additional setup after loading the view.
    UserDefaults.standard.set(true, forKey: IS_USER_HAS_PLACED_FIRST_ORDER)
    
    
    orderTableView.register(UINib(nibName: "WSOrderChefRewardState2TableViewCell", bundle: nil), forCellReuseIdentifier: "WSOrderChefRewardState2TableViewCell")
    
    
    orderTableView.register(UINib(nibName: "WSOrderChefRewardState3TableViewCell", bundle: nil), forCellReuseIdentifier: "WSOrderChefRewardState3TableViewCell")
    
    
    self.getLoyaltyProductCatlog()
    
  }
  
  func sendPushNotificationForPromoCode(){
    WSWebServiceBusinessLayer().triggerPushNotificationAfterOrderPlacedForPromoCode(promoCode: self.promoCode, successResponse: { (response) in
      
    }, faliureResponse: { (errorMessage) in
      
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    goBack()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    createCart()
  }
  
  func goBack()    {
    WSUtility.addNavigationBarBackButton(controller: self)
  }
  
  @IBAction func backAction(_ sender: UIButton) {
    //createCart()
    self.navigationController!.popToRootViewController(animated: false)
    
  }
  
  func addLoyaltyPoints() {
    
    var loyaltyDict:[String:Any] = [:]
    var adminPoints: Int = 0
    if let dict = UserDefaults.standard.value(forKey: "First_Order_Incentive_Data") as? [String: Any]{
      if let value = dict["loyalty_points"] as? String{
        adminPoints = Int(value)!
      }
      else if let value = dict["loyalty_points"] as? Int{
        adminPoints = value
      }
    }
    if updateDictToAdmin.keys.count > 0{
      
      var pendingPoints: Int = 0
      if let value = updateDictToAdmin["points"] as? String{
        pendingPoints = Int(value)! + adminPoints
      }
      else if let value = updateDictToAdmin["points"] as? Int{
        pendingPoints = value + adminPoints
      }
      
      loyaltyDict = ["points":"\(pendingPoints)", "description":"Initiated"]
    }
    else{
      
      loyaltyDict = ["points":adminPoints, "description":"Initiated"]
    }
    
    let bussinessLayer:WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    
    bussinessLayer.addLoyaltyPointsRequest(parameter: loyaltyDict,successResponse: { (success) in
      print("loyalty points added successfully")
      self.updateLoyaltyPointsToAdmin()
      self.getLoyaltyPoint()
      
    }) { (error) in
      print("error response")
      self.getLoyaltyPoint()
      UFSProgressView.stopWaitingDialog()
      
    }
  }
  
  func getLoyaltyPoint()  {
    
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.makeLoyaltyPointsRequest(methodName: Get_Loyalty_API_Method, successResponse: { (response) in
      //self.homeTableView.reloadData()
      UFSProgressView.stopWaitingDialog()
      self.orderTableView.reloadData()
      
    }) { (errorMessage) in
      if errorMessage == "Session_Token_Expire" {
        print("session token expired in homescreen")
        self.getSifuAccessToken()
        
      }else{
        UFSProgressView.stopWaitingDialog()
      }
    }
  }
  
  
  func getSifuAccessToken()  {
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    let emailID = UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)!
    let password =  UserDefaults.standard.value(forKey: USER_PASSWORD_KEY)!
    let dictParameter = ["EmailId":emailID, "Password":password]
    
    serviceBussinessLayer.makeLoginRequest(parameter: dictParameter as! [String : String], methodName: Login_API_Method, successResponse: { (response) in
      self.getLoyaltyPoint()
    }) { (errorMessage) in
      
    }
  }
  
  func updateLoyaltyPointsToAdmin(){
    
    if self.promoCode != "" && updateDictToAdmin.keys.count > 0{
      var dict:[String: Any] = [:]
      dict["loyalty_history_id"] = "\(updateDictToAdmin["loyalty_history_id"]!)"
      dict["user_id"] = "\(updateDictToAdmin["user_id"]!)"
      dict["order_id"] = "\(updateDictToAdmin["order_id"]!)"
      dict["SIFU_response_status"] = "1"
      
      let serviceBussinessLayer =  WSWebServiceBusinessLayer()
      
      serviceBussinessLayer.updateLoyaltyPointsForPromoCodeInAdminRequest(parmsDict: dict, successResponse: { (response) in
        
      }) { (errorMessage) in
        
      }
    }
    
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    
    if segue.identifier == "ChefRewardDetailSegue" {
      let chefRewardDetailVc = segue.destination as! WSChefRewardDetailViewController
      chefRewardDetailVc.productDetail = sender as! [String:Any]
    }
  }
  
  func getLoyaltyProductCatlog()  {
    UFSProgressView.showWaitingDialog("")
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.makeLoyaltyProductCatlogRequest(methodName: "", categoryName: "*", skip: "0", take: "5", successResponse: { (response) in
      let dictResponse = response as! [String:Any]
      
      if let loyaltyProduct = dictResponse["hits"] as? [[String:Any]]{
        print(loyaltyProduct)
        self.loyaltyProdcutCatlog = loyaltyProduct
      }
      UFSProgressView.stopWaitingDialog()
      self.orderTableView.reloadData()
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
    }
  }
  
  @IBAction func continueShopingClicked(_ sender: Any) {
    createCart()
  }
  
  // MARK: - UICollectionViewDataSource protocol
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    // get a reference to our storyboard cell
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! SummaryCollectionViewCell
    // Use the outlet in our custom class to get a reference to the UILabel in the cell
    cell.pNameLabel.text = WSUtility.getlocalizedString(key: "points", lang: WSUtility.getLanguage(), table: "Localizable")
    cell.priceLabel.text = self.items[indexPath.item]
    
    return cell
  }
  
  // MARK: - UICollectionViewDelegate protocol
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // handle tap events
    print("You selected cell #\(indexPath.item)!")
  }
  
  func createCart(){
    
    let addToCartBussinessLogic = WSAddToCartBussinessLogic()
    addToCartBussinessLogic.createCartForUSer(forController: self)
    
    
    //        let backendService:HYBB2CService = (UIApplication.shared.delegate as! HYBAppDelegate).backEndService
    //        backendService.createCart(forUser: backendService.userId, andExecute: {(_ response, _ error) in
    //            if response == nil {
    //                //self.showNotifyMessage((error)?.localizedDescription)
    //            }else{
    //                //print(response!)
    //                //let arr = response! as! [Any]
    //                //let cart: HYBCart? = arr[0] as? HYBCart
    //                let cart: HYBCart? = response!
    //                backendService.saveCart(inCacheNotifyObservers: cart)
    //            }
    //          //self.tabBarController?.selectedIndex = 2
    //          //self.navigationController!.popToRootViewController(animated: false)
    //        })
  }
  
}

extension OrderSuccessViewController:UITableViewDelegate,UITableViewDataSource{
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == CHEF_REWARD_CELL {
      let selectedGoalID = WSUtility.getGoalId()
      if selectedGoalID.count == 0 {
        return 377
      }else{
        return 330
      }
    }
    return UITableViewAutomaticDimension
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    var tableViewCell = UITableViewCell()
    
    if indexPath.row == Order_Success_CELL {
      let orderCell =  tableView.dequeueReusableCell(withIdentifier: "OrderSummaryTableViewCell") as! OrderSummaryTableViewCell
      orderCell.orderSuccessTextLabel.text = WSUtility.getTranslatedString(forString: "Order Successful")
      
      orderCell.loyaltyPointEarnedLabel.text = String(format:WSUtility.getTranslatedString(forString: "You have earned 1500 points"),earnedLoyaltyPoints)
      
      WSUtility.setLoyaltyPoint(label: orderCell.myLoyaltyPointLabel)
      orderCell.tradePartnerLabel.text = WSUtility.getTranslatedString(forString: "Your order has been sent to your trade partner")
      /*
       if let orderNumber = orderStatusDictionary["sifuOrderId"] {
       let orderNumberString = "\(WSUtility.getTranslatedString(forString: "Your order number is")) \n" + "\(orderNumber)"
       orderCell.orderNumberLabel.text = orderNumberString
       }
       */
      
      if let orderNumber = orderStatusDictionary["sifuOrderId"] {
        let orderNumberString = "\(WSUtility.getTranslatedString(forString: "Your order number is")) \n" + "\(orderNumber)"
        orderCell.orderNumberLabel.text = orderNumberString
      }else if let code = orderStatusDictionary["code"] {
        let orderNumberString = "\(WSUtility.getTranslatedString(forString: "Your order number is")) \n" + "\(code)"
        orderCell.orderNumberLabel.text = orderNumberString
      }else{
        orderCell.orderNumberLabel.text = ""
      }
      
      tableViewCell = orderCell
      
    }else if indexPath.row == CHEF_REWARD_CELL {
      
      let selectedGoalID = WSUtility.getGoalId() //UserDefaults.standard.value(forKey: USER_LOYALTY_GOAL_ID_KEY) as? String
      if selectedGoalID.count == 0 {
        
        let chefRewardsCell =  tableView.dequeueReusableCell(withIdentifier: "WSOrderChefRewardState2TableViewCell") as! WSOrderChefRewardState2TableViewCell
        chefRewardsCell.chefRewardCollectionView.register(UINib(nibName: "ChefRewardCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "ChefRewardCollectionViewCell")
        
        chefRewardsCell.upadateCellContent(with: loyaltyProdcutCatlog)
        chefRewardsCell.delegate = self
        //chefRewardsCell.setUI()
        tableViewCell = chefRewardsCell
      }else{
        let chefRewardsCell =  tableView.dequeueReusableCell(withIdentifier: "WSOrderChefRewardState3TableViewCell") as! WSOrderChefRewardState3TableViewCell
        chefRewardsCell.updateCellContent()
        chefRewardsCell.delegate = self
        tableViewCell = chefRewardsCell
      }
      
    }
    
    return tableViewCell;
  }
}

extension OrderSuccessViewController : WSOrderChefRewardState2Delegate{
  func didSelectOnChefRewardState2Prodcut(productDetail: [String : Any]) {
    self.performSegue(withIdentifier: "ChefRewardDetailSegue", sender: productDetail)
  }
  
  func learnMoreAboutChefRewardState2Action() {
    self.performSegue(withIdentifier: "ShowCategoryRewardSegue", sender: self)
  }
}

extension OrderSuccessViewController : OrderChefRewardState3Delegate{
  func reloadTableViewAfterReedemGift() {
    orderTableView.reloadData()
  }
}



