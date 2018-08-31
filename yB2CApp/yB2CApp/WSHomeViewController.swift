
//
//  WSHomeViewController.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 14/11/2017.
//

import UIKit
import AVKit

class WSHomeViewController: BaseViewController,NoInternetDelegate,NetworkStatusDelegate {
  
  var SALES_REP = 0
  let CHEF_REWARD_CELL = 1
  let TR_BLUE_NOTE = 2
  let PROMOTION_CELL = 3
  let FAVORITE_CELL = 4
  let PRODUCT_CELL = 5
  let RECIPE_CELL = 6
  var salesRepoHeight : CGFloat = 0.0
  
  var isExpanding = false
  //var isSalesRepoChatEnabled = false
  var enableLoyaltyBanner = false
  var enableTradePartner = false // For enable Disable Feature
  var enableRecommendedProduct = false
  var enablePersonalizedPricing = false
  var enableFirstOrderIncentive = false
  var recipeLists = [[String:Any]]()
  var favouriteLists = [[String:Any]]()
  var loyaltyProdcutCatlog = [[String:Any]]()
  var recommendedProduct = [[String:Any]]()
  var tradePartnerBannerUrl = ""
  var callSalesRepUrl:[[String: Any]] = []
  var bannerDict = [String:Any]()
  var noInternetView:UFSNoInternetView?
  
  let dispatchGroup = DispatchGroup()
  let networkStatus = UFSNetworkReachablityHandler.shared
  let taxNumberFooterView = WSTaxNumberFooterView.loadnib()
  
  @IBOutlet weak var homeTableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    addSlideMenuButton()
    
   
    UFSGATracker.trackScreenViews(withScreenName: "Home Screen")
    FireBaseTracker.ScreenNaming(screenName: "Home Screen", ScreenClass: String(describing: self))
    FBSDKAppEvents.logEvent("Home Screen")
    
    homeTableView.estimatedRowHeight = 220
    homeTableView.register(UINib(nibName: "WSSalesRepTableViewCell", bundle: nil), forCellReuseIdentifier: "WSSalesRepTableViewCell")
    homeTableView.register(UINib(nibName: "TRBlueLabelCustomCell", bundle: nil), forCellReuseIdentifier: "TRBlueLabelCustomCell")
    
    homeTableView.register(UINib(nibName: "WSFavouriteWithOneProductTableViewCell", bundle: nil), forCellReuseIdentifier: "WSFavouriteWithOneProductTableViewCell")
    
    homeTableView.register(UINib(nibName: "WSFavouriteWithThreeProductTableViewCell", bundle: nil), forCellReuseIdentifier: "WSFavouriteWithThreeProductTableViewCell")
    
    homeTableView.register(UINib(nibName: "WSChefRewardState2TableViewCell", bundle: nil), forCellReuseIdentifier: "WSChefRewardState2TableViewCell")
    
    
    homeTableView.register(UINib(nibName: "WSChefRewardState3TableViewCell", bundle: nil), forCellReuseIdentifier: "WSChefRewardState3TableViewCell")
    
    UserDefaults.standard.set("", forKey: LOYALTY_BALANCE_KEY)
    
    WSUtility.setBottomShadowToNavigationBar(viewController: self)
    //homeTableView.isHidden = true
    
    var appVersion = ""
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      appVersion = version
    }
    if let myInteger = Double(appVersion) {
      _ = NSNumber(value:myInteger)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    getCartDetail()
    WSUtility.setCartBadgeCount(ViewController: self)
    
    // APIs Call
    enableDisableFeature()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.trackingScreens(screenName: "Home Screen")
    if !WSUtility.isTaxNumberAvailable(VCview: self.view){
      WSUtility.addTaxNumberView(viewController: self)
    }
    
  }
  
  func btnTaxTapped(sender:UIButton)  {
    let storyBoard: UIStoryboard = UIStoryboard(name: "EnterTaxNumberStoryboard", bundle: nil)
    let vc:WSEnterTaxNumberViewController = storyBoard.instantiateViewController(withIdentifier: "WSEnterTaxNumberViewController") as! WSEnterTaxNumberViewController
    vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    vc.callBack = {
      if let view = self.view.viewWithTag(9006){
        view.removeFromSuperview()
      }
      self.makeAPICall()
    }
    present(vc, animated: true, completion: nil)
    
  }
  
  func getPendingPointsFromAdmin(){
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.getPendingLoyaltyPointsRequest(successResponse: { (response) in
      print(response)
      let responseSuccuess: Bool = response["error"] as! Bool
      let forceUpdateDic = response["force_update_status"] as! [String:Any]
      let forceUpdateValue  = forceUpdateDic["force_update"] as! Int
      
      
      if let value = response["points"] as? String{
        let pendingPoints: Int = Int(value)!
        if !responseSuccuess && pendingPoints > 0{
          self.addLoyaltyPoints(pointsVal: pendingPoints)
        }
      }
      else if let pendingPoints = response["points"] as? Int{
        
        if !responseSuccuess && pendingPoints > 0{
          self.addLoyaltyPoints(pointsVal: pendingPoints)
        }
        
        if forceUpdateValue == 1 {
          let alertController = UIAlertController(title: "", message: WSUtility.getlocalizedString(key: "We have done some critical enhancements to the app. Please update now.", lang: WSUtility.getLanguage()), preferredStyle: UIAlertControllerStyle.alert)
          alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            //call update
            
            if let url = URL(string: "https://itunes.apple.com/us/app/ufs/id1298425491?ls=1&mt=8"),
              UIApplication.shared.canOpenURL(url){
              if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
              } else {
                UIApplication.shared.openURL(url)
              }
            }
            
            
          }))
          self.present(alertController, animated: true, completion: nil)
          
        }
      }
      
    }) { (errorMessage) in
      
    }
  }
  func addLoyaltyPoints(pointsVal: Int) {
    
    let loyaltyDict:[String:Any] = ["points":"\(pointsVal)", "description":"Pending points"]
    
    let bussinessLayer:WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    
    bussinessLayer.addLoyaltyPointsRequest(parameter: loyaltyDict,successResponse: { (success) in
      print("loyalty points added successfully")
      self.updateFlagStatusToAdmin()
      
    }) { (error) in
      print("error response")
      
    }
  }
  
  func networkCheckAndApiCall()  {
    if (UFSNetworkReachablityHandler().reachabilityManager?.isReachable)!{
      ReachableNetwork()
    }else{
      NonReachableNetwork()
    }
  }
  
  func reloadView() {
    networkCheckAndApiCall()
  }
  
  func ReachableNetwork() {
    if self.homeTableView != nil{
      self.homeTableView.reloadData()
    }
    
    WSUtility.removeNoNetworkView(internetView: &noInternetView)
  }
  
  func NonReachableNetwork() {
    if noInternetView == nil {
      WSUtility.loadNoInternetView(internetView: &noInternetView, controllerView: self)
    }
  }
  
  func updateFlagStatusToAdmin(){
    let bussinessLayer:WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    bussinessLayer.updateAdminFlagStatusAfterSifuSuccessRequest(successResponse: { (response) in
      self.getLoyaltyPoint()
    }) { (error) in
      print("error response")
    }
  }
  override func viewWillDisappear(_ animated: Bool) {
    UserDefaults.standard.set(false, forKey: "isFromLoginForDTO")
    WSUtility.removeNoNetworkView(internetView: &noInternetView)
    NotificationCenter.default.removeObserver(self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func applicationWillEnterForeground()  {
    getPendingPointsFromAdmin()
    
    enableDisableFeature()
    
  }
  func applicationDidEnterBackground()  {
    UserDefaults.standard.set(false, forKey: "isFromLoginForDTO")
  }
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    
    if segue.identifier == "ChefRewardDetailSegue" {
      let chefRewardDetailVc = segue.destination as! WSChefRewardDetailViewController
      chefRewardDetailVc.productDetail = sender as! [String:Any]
    }else if segue.destination is WSProductDetailViewController{
      
      let productVC = segue.destination as? WSProductDetailViewController
      if let number = (sender as? String){
        productVC?.productCode = number
      }
    }else if segue.destination is UFSRecipeDetailViewController{
      
      let recipeDetailVC = segue.destination as? UFSRecipeDetailViewController
      if let dict = sender as? [String:Any]{
        
        // recipeDetailVC?.recipeNumber = (sender as? String)!
        if let recipeNumberStr = dict["recipe_code"] as? String{
          recipeDetailVC?.recipeNumber = recipeNumberStr
        }
        else if let recipeNumberStr = dict["number"] as? String{
          recipeDetailVC?.recipeNumber = recipeNumberStr
        }
        //recipeDetailVC?.recipeNumber = "\(dict["recipe_code"]!)"
        //recipeDetailVC?.recipePersonalized = "\(dict["recipe_id"]!)"
        recipeDetailVC?.recipeLikeStatus = ""
      }else{
        recipeDetailVC?.recipeNumber = ""
        recipeDetailVC?.recipePersonalized = ""
        recipeDetailVC?.recipeLikeStatus = ""
      }
      
    }else if segue.destination  is AllProductsViewController {
      let productViewController = segue.destination as! AllProductsViewController
      productViewController.productListScreenOpenedBy = .DOUBLE_LOYALTY_PRODUCT
    }
    
  }
  
  // MARK: - API Call
  
  func makeAPICall()  {
    
    downLoadChefRewardVideo()
    networkStatus.delegate = self
    networkCheckAndApiCall()
    
    NotificationCenter.default.addObserver(self, selector:#selector(applicationWillEnterForeground), name:
      NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    
    enableTradePartner = false
    if WSUtility.isFeatureEnabled(feature: featureId.Trade_partner_promotion_banners.rawValue) {
      enableTradePartner = true
      getTradePartnerBanner()
    }
    
    enableFirstOrderIncentive = false
    if WSUtility.isFeatureEnabled(feature: featureId.First_order_incentive.rawValue) {
      enableFirstOrderIncentive = true
    }
    
    enableLoyaltyBanner = false
    if WSUtility.isFeatureEnabled(feature: featureId.Loyalty_Promotion_Banner.rawValue) {
      enableLoyaltyBanner = true
    }
    
    enableRecommendedProduct = false
    if WSUtility.isFeatureEnabled(feature: featureId.Recommended_Product.rawValue) {
      enableRecommendedProduct = true
    }
    
    enablePersonalizedPricing = false
    if WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
      enablePersonalizedPricing = true
    }
    
    getLoyaltyPoint()
    getFavouriteList()
    getPendingPointsFromAdmin()
    
   
    if WSUtility.isLoginWithTurkey(){
      self.getUserProfileFromHybrisFor_TR()
    }
    else{
      self.getUserBasicProfile()
    }
    
    if WSUtility.isUserPlacedFirstOrder() == false{
      if WSUtility.isLoginWithTurkey(){
        getOrderHistoryListFromHybris()
      }
      else{
        getOrderHistoryList()
      }
    }
    
    let doubleLoyaltyProductCachedResponse = WSCacheSingleton.shared.cache.object(forKey: Cached_Double_Loyalty_Product_KEY as NSString) as Any
    if let productArray = doubleLoyaltyProductCachedResponse as? [[String:Any]]{
      
      if productArray.count == 0{
        getDoubleProductListFromSifu()
      }
      
    }else{
      getDoubleProductListFromSifu()
    }
    
   
    getLoyaltyProductCatlog()
  
    getRecommendedProductCatlogFromSIFU()
    getRecommendedRecipeCatlog()
    
    dispatchGroup.notify(queue: .main) {
      print("All functions complete ")
      UFSProgressView.stopWaitingDialog()
      self.homeTableView.reloadData()
      
      // self.homeTableView.isHidden = false
    }
  }
  
  func downLoadChefRewardVideo()  {
    let downloadService = WSDownloadFilesManager()
    downloadService.downloadVideo(urlString: ChefRewards_Vedio, PathName: chefRewards_Path_Name,success: {(response) in
      
    }, failure: {(error) in
      
    })
  }
  
  func getUserProfile()  {
    
    dispatchGroup.enter()
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.getUserProfile(parameter: [String:Any](), methodName: GET_PROFILE_API, successResponse: { (response) in
      
      self.dispatchGroup.leave()
      
      let goalProductID = response["loyaltyRewardGoalProductId"] as? String
      
      
      if WSUtility.isLoginWithTurkey(){
        // For Turkey DTO feature is not aviliable, not need to keep this information
        self.getUserGoalID(goalProductID: goalProductID)
        return
      }
      
      // for DACH country
      
      if let parentTradePartner = response["parentTradePartner"] as? NSDictionary{
        let tradePartnerName = parentTradePartner["name"] as? String
        let tradePartnerID = "\(parentTradePartner["id"]!)"
        UserDefaults.standard.setValue(tradePartnerName, forKey: TRADE_PARTNER_NAME)
        UserDefaults.standard.setValue(tradePartnerID, forKey: TRADE_PARTNER_ID)
      }
      
      
      if let dtoFlag = response["directOperator"] as? Bool{
        serviceBussinessLayer.updateDTOProfileTOHybrisRequest(parameter: [:], methodName: "UpdateDTOProfileHybrisAPI", successResponse: { (response) in
          
        }, faliureResponse: { (errorMessage) in
          
        })
        
        UserDefaults.standard.set(dtoFlag, forKey: DTO_OPERATOR)
        if !dtoFlag{
          UserDefaults.standard.set(false, forKey: "Is_First_Time_DTO_OPERATOR")
        }
        else{
          if UserDefaults.standard.bool(forKey: "isFromLoginForDTO"){
            if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
              UserDefaults.standard.set(true, forKey: "Is_First_Time_DTO_OPERATOR")
            }
          }
        }
      }
      self.updateDTOUserInfoToAdmin()
      
      if let tpDict = response["parentTradePartner"] as? [String: Any]{
        
        if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
          print(tpDict["minOrderValue"]!)
          UserDefaults.standard.set(tpDict["minOrderValue"]!, forKey: "minOrderValue")
        }
        
        if let name = tpDict["name"]as? String{
          UserDefaults.standard.set(name, forKey: "DTO_TP_Name")
        }
        if let excludedProductsStr = tpDict["excludedProducts"]as? String{
          let array = excludedProductsStr.components(separatedBy: ",")
          UserDefaults.standard.set(array, forKey: "ExcludedProducts")
        }
      }
      
      /*
       // for release version DTO making By default False
       //Start
       UserDefaults.standard.set(false, forKey: DTO_OPERATOR)
       UserDefaults.standard.set(true, forKey: "Is_First_Time_DTO_OPERATOR")
       UserDefaults.standard.set(false, forKey: "isFromLoginForDTO")
       //End
       */
      
      if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
        if !UserDefaults.standard.bool(forKey: "isFromLoginForDTO"){
          if !UserDefaults.standard.bool(forKey: "Is_First_Time_DTO_OPERATOR"){
            
            WSUtility.showAlertWith(message: (WSUtility.getlocalizedString(key: "Hi %@, we have upgraded you to our direct delivery service.", lang: WSUtility.getLanguage(), table: "Localizable")?.replacingOccurrences(of: "%@", with: String(format: "%@ %@",WSUtility.getValueFromUserDefault(key: "FirstName"),WSUtility.getValueFromUserDefault(key: "LastName"))))!, title: "", forController: self)
            UserDefaults.standard.set(true, forKey: "Is_First_Time_DTO_OPERATOR")
            UserDefaults.standard.set(false, forKey: "isFromLoginForDTO")
            
          }
        }
      }
      
      self.getCartDetail()
      self.getUserGoalID(goalProductID: goalProductID)
      self.getTradePartnerBanner()
      
    }) { (errorMessage) in
      self.dispatchGroup.leave()
    }
  }
  
  func getUserGoalID(goalProductID:String?)  {
    UserDefaults.standard.setValue(goalProductID, forKey: USER_LOYALTY_GOAL_ID_KEY)
    self.dispatchGroup.enter()
    if (goalProductID?.count == 0) ||  (goalProductID == nil) {
      
      self.dispatchGroup.leave()
    }else{
      if WSUtility.isLoginWithTurkey(){
        self.dispatchGroup.leave()
        self.getGoalProductDetailForTurkey(productCode: goalProductID!)
      }else{
        self.dispatchGroup.leave()
        self.getGoalProductDetail(productID: goalProductID!)
      }
      
    }
  }
  
  
  func getUserBasicProfile()  {
    
    // UFSProgressView.showWaitingDialog("")
    dispatchGroup.enter()
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    
    serviceBussinessLayer.getBasicUserProfile(parameter: [String:Any](), methodName: GET_PROFILE_API, successResponse: { (response) in
      
       self.dispatchGroup.leave()
      if !WSUtility.isLoginWithTurkey(){
        
        self.setFirstNameLastName(responseDict: response)
        
        LiveChat.email =  (UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)! as! String)
        LiveChat.name = WSUtility.getValueFromUserDefault(key: "FirstName")
        
        if let mobileNo = response["phoneNumber"] as? String{
          UserDefaults.standard.set(mobileNo, forKey: "mobileNo")
        }
        if let confirmedOptIn = response["confirmedOptIn"] as? Bool {
          UserDefaults.standard.set(confirmedOptIn, forKey: "confirmedOptIn")
        }
        if let newsletterOptIn = response["newsletterOptIn"] as? Bool{
          UserDefaults.standard.set(newsletterOptIn, forKey: "newsletterOptIn")
        }
        if let oldNewsletterOptIn = response["oldNewsletterOptIn"] as? Bool{
          UserDefaults.standard.set(oldNewsletterOptIn, forKey: "oldNewsletterOptIn")
        }
        if let confirmedNewsletterOptIn = response["confirmedNewsletterOptIn"] as? Bool{
          UserDefaults.standard.set(confirmedNewsletterOptIn, forKey: "confirmedNewsletterOptIn")
        }
        
        
        if let zipCode = response["zipCode"] as? String{
          UserDefaults.standard.set("\(zipCode)", forKey: USER_ZIP_CODE)
        }
        
      }
      
      
      self.getCallSalesRepDetails()
      
      // print("getUserProfile")
      self.createUserForEcom(userID: "\(response["userId"]!)")
      let userID = "\(response["userId"]!)"
      UserDefaults.standard.set(userID, forKey: "UFS_USER_Id")
      
    }) { (errorMessage) in
      self.dispatchGroup.leave()
    }
    
    getUserProfile()
    
  }
  
    func setFirstNameLastName(responseDict: [String: Any]){
        var firstName: String = ""
        var lastName: String = ""
        
        if let firstNameStr = responseDict["firstName"] as? String, firstNameStr != ""{
            firstName = firstNameStr
        }
        else{
            if let adminDict = UserDefaults.standard.object(forKey: "adminUserResponse") as? [String: Any]{
                firstName = "\(adminDict["first_name"] as? String ?? "")"
            }
        }
        if let lastNameStr = responseDict["lastName"] as? String, lastNameStr != ""{
            lastName = lastNameStr
        }
        else{
            if let adminDict = UserDefaults.standard.object(forKey: "adminUserResponse") as? [String: Any]{
                lastName = "\(adminDict["last_name"] as? String  ?? "")"
            }
        }
        UserDefaults.standard.setValue(lastName, forKey:"LastName")
        UserDefaults.standard.setValue(firstName, forKey:"FirstName")
    }
    
  //TURKEY : Get customer profile
  func getUserProfileFromHybrisFor_TR()  {
    dispatchGroup.enter()

    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    
    serviceBussinessLayer.getBasicUserProfileFromHybrisForTurkey(parameter: [String:Any](), methodName: GET_PROFILE_API_HYBRIS_TR, successResponse: { (response) in
      
      self.dispatchGroup.leave()
      
      self.setFirstNameLastName(responseDict: response)
      
      if let businessType = response["businessType"] as? [String : Any]{
        UserDefaults.standard.set(businessType, forKey: "businessType")
      }
      
        if WSUtility.isLoginWithTurkey(){
            if WSUser().getUserProfile().businessname == "Toptancı"{
                if !UserDefaults.standard.bool(forKey: "IsbusinessPopUpShown_TR"){
                    WSUtility.showAlertWith(message: "Toptancı uygulamalarını görüntüleyebilmeniz için kaydınızı tamamlamamız gerekiyor. Lütfen bu numara ile “05497481346” iletişime geçiniz.", title: "", forController: self)
                    UserDefaults.standard.set(true, forKey: "IsbusinessPopUpShown_TR")
                }
            }
            else{
                UserDefaults.standard.set(false, forKey: "IsbusinessPopUpShown_TR")
            }
        }
        
        if let array = response["myProfileVendorsList"] as? [[String : Any]]{
            UserDefaults.standard.set(array, forKey: "myProfileVendorsList")
        }
        if let dict = response["vendorMOQ"] as? [String : Any]{
            UserDefaults.standard.set(dict, forKey: "vendorMOQ")
            UserDefaults.standard.set("\(dict["minOrderValue"] ?? "")", forKey: "minOrderValue")
         
          
            if let boolValue = dict["isPayByCreditCard"] as? Bool{
                UserDefaults.standard.set(boolValue, forKey: ISPAYMENT_BY_CREDITCARD_KEY)
            }else{
              // by default Payment option should be CC/IBAN
              UserDefaults.standard.set(true, forKey: ISPAYMENT_BY_CREDITCARD_KEY)
          }
            if let boolValue = dict["isMOQRequired"] as? Bool{
               UserDefaults.standard.set(boolValue, forKey: ISMOQREQUIRED_KEY)
            }else{
              UserDefaults.standard.set(false, forKey: ISMOQREQUIRED_KEY)
          }
          
        }else{
          // Reset MOQ value
          
           UserDefaults.standard.set(false, forKey: ISMOQREQUIRED_KEY)
           // by default Payment option should be CC/IBAN
          UserDefaults.standard.set(true, forKey: ISPAYMENT_BY_CREDITCARD_KEY)
          UserDefaults.standard.set("", forKey: "minOrderValue")
          UserDefaults.standard.set([String:Any](), forKey: "vendorMOQ")
          
      }
        
      
      if let defaultAddress = response["defaultAddress"] as? [String : Any]{
        var tmpDict: [String: Any] = defaultAddress
        tmpDict["operatorBusinessName"] = "\(response["operatorBusinessName"] as? String ?? "")"
        UserDefaults.standard.set(tmpDict, forKey: "defaultAddress")
        
        if let mobileNo = tmpDict["phone"] as? String{
            UserDefaults.standard.set(mobileNo, forKey: "mobileNo")
        }
      }
      if let taxNo = response["taxNumber"]{
        UserDefaults.standard.setValue("\(taxNo)", forKey: TAX_NUMBER_KEY)
      }
      if !WSUtility.isTaxNumberAvailable(VCview: self.view){
        WSUtility.addTaxNumberView(viewController: self)
        self.homeTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 75))
      }else{
        if let view = self.view.viewWithTag(9006){
          view.removeFromSuperview()
        }
        self.homeTableView.tableFooterView = UIView(frame: CGRect.zero)
      }
      if let vendorList = response["vendor"] as? [[String : Any]]{
        if vendorList.count > 0{
          UserDefaults.standard.set(vendorList[0], forKey: "vendor")
          let objVendor = vendorList[0]
          let tradePartnerName = objVendor["name"] as? String
          let tradePartnerID = "\(objVendor["code"] ?? "")"
          UserDefaults.standard.setValue(tradePartnerName, forKey: TRADE_PARTNER_NAME)
          UserDefaults.standard.setValue(tradePartnerID, forKey: TRADE_PARTNER_ID)
        }
      }
      LiveChat.email =  (UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)! as! String)
      LiveChat.name = WSUtility.getValueFromUserDefault(key: "FirstName");
      
      if let mobileNo = response["phone"] as? String{
        UserDefaults.standard.set(mobileNo, forKey: "mobileNo")
      }
      
      if let zipCode = response["postalCode"] as? String{
        UserDefaults.standard.set("\(zipCode)", forKey: USER_ZIP_CODE)
      }
   
     
      self.getUserBasicProfile()

      
      if let userGroup = response["userGroup"] as? String{
        UserDefaults.standard.set(userGroup, forKey: USER_GROUP)
      }
      
      self.getCartDetail()
      self.updateDTOUserInfoToAdmin()
      self.getTradePartnerBanner()
      
      
    }) { (errorMessage) in
      self.dispatchGroup.leave()
      
    }
    
  }
  
  func getLoyaltyPoint() {
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.makeLoyaltyPointsRequest(methodName: Get_Loyalty_API_Method, successResponse: { (response) in
      
      self.homeTableView.reloadData()
      
    }) { (errorMessage) in
      if errorMessage == "Session_Token_Expire" {
        print("session token expired in homescreen")
        self.getSifuAccessToken()
        
      }
    }
  }
  
  func updateDTOUserInfoToAdmin(){
    
    if let adminDict = UserDefaults.standard.object(forKey: "adminUserResponse") as? [String: Any]{
      
      if adminDict.count == 0{
        return
      }
      var requestDict = [String: Any]()
      requestDict["firstName"] = "\(adminDict["first_name"]!)"
      requestDict["lastName"] = "\(adminDict["last_name"]!)"
      requestDict["bt_id"] = "\(adminDict["business_code"] ?? "")"
      requestDict["pin_code"] = "\(adminDict["pin_code"]!)"
      requestDict["deviceToken"] = UserDefaults.standard.value(forKey: "DeviceToken")!
      requestDict["business_name"] = "\(adminDict["business_name"] ?? "")"
      let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
      businessLayer.addUserToAdminPanel(params: requestDict, actionType: "update", successResponse: { (response) in
        
        if let tempDictResponse = response["data"] as? [Any], tempDictResponse.count>0{
          if let adminDict = tempDictResponse[0] as? [String:Any]{
            UserDefaults.standard.set(adminDict, forKey: "adminUserResponse")
          }
        }
        // self.getCallSalesRepDetails()
      }, faliureResponse: { (errorMessage) in
        
      })
    }
  }
  
  func getRecipeList()  {
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.makeRecipeListRequest(methodName: Recipe_List_API, successResponse: { (success) in
      self.recipeLists = success
      
      self.homeTableView.reloadData()
    }) { (errorMessage) in
      
    }
  }
  
  func getSifuAccessToken()  {
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    let emailID = UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)!
    let password =  UserDefaults.standard.value(forKey: USER_PASSWORD_KEY)!
    let dictParameter = ["EmailId":emailID, "Password":password]
    
    serviceBussinessLayer.makeLoginRequest(parameter: dictParameter as! [String : String], methodName: Login_API_Method, successResponse: { (response) in
      self.getLoyaltyPoint()
      self.getFavouriteList()
      if WSUtility.isLoginWithTurkey(){
        self.getUserProfileFromHybrisFor_TR()
      }
      else{
        self.getUserBasicProfile()
      }
      if WSUtility.isLoginWithTurkey(){
        self.getOrderHistoryListFromHybris()
      }
      else{
        self.getOrderHistoryList()
      }
    }) { (errorMessage) in
      
    }
  }
  
  func createUserForEcom(userID: String){
    if UserDefaults.standard.bool(forKey: "callFirstTime") == false {
      let businesslayer =  WSWebServiceBusinessLayer()
      businesslayer.CreateEcomProfile(userID: userID, successResponse: { (response) in
        UserDefaults.standard.set(true, forKey: "callFirstTime")
      }) { (errorMessage) in
        
      }
    }
  }
  
  func getFavouriteList() {
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.makeFavouriteListRequest(methodName: Favourites_List_API, successResponse: { (response) in
      WSUtility.removeProductCode()
      
      self.favouriteLists = response
      
      for items in self.favouriteLists {
        var dict = items
        
        let productDict = dict ["product"] as! [String: Any]
        let add = dict ["automaticallyAdded"] as! Bool
        if !add{//Don't convert ordered products into favourites
          let productNumber =  productDict["productNumber"] as! String
          WSUtility.setProductCode(productNumber: productNumber)
        }
      }
      
      self.homeTableView.reloadData()
    }) { (errorMessage) in
      
    }
  }
  
  func getLoyaltyProductCatlog()  {
   
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.makeLoyaltyProductCatlogRequest(methodName: "", categoryName: "*", skip: "0", take: "5", successResponse: { (response) in
      let dictResponse = response as! [String:Any]
      if let loyaltyProduct = dictResponse["hits"] as? [[String:Any]]{
        self.loyaltyProdcutCatlog = loyaltyProduct
      }
      
     
    }) { (errorMessage) in
      
    }
  }
  
  func getRecommendedProductCatlogFromSIFU()  {
    
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.getRecommendedProductEANCodesRequest(successResponse: { (response) in
      
      if response.count > 0{
        let recommendedEanCodes = response.map({$0["recommendation"] as! String})
        let recommededEanStr = recommendedEanCodes.joined(separator: ",")
        serviceBussinessLayer.getRecommendedProductsFromEANCodesRequest(eanString: recommededEanStr, successResponse: { (response) in
          
          self.recommendedProduct = response
          self.homeTableView.reloadData()
        }, faliureResponse: { (errorMessage) in
          
        })
      }
      else{
        self.getRecommendedProductListFromAdmin()
      }
    }) { (errorMessage) in
      self.getRecommendedProductListFromAdmin()
    }
  }
  
  func getGoalProductDetailForTurkey(productCode:String)  {
    
    self.dispatchGroup.enter()
    
    let getProductDetail:WSGetProductsFromCode = WSGetProductsFromCode()
    getProductDetail.getProductDetail(codes: productCode, successResponse: { (successResponse) in
      
      self.dispatchGroup.leave()
      if successResponse.count > 0{
        let response = successResponse[0]
        
        var goalDict = [String:Any]()
        if let prodName = response["productName"]{
          goalDict["ProductName"] = prodName
        }else if let prodName = response["name"]{
          goalDict["ProductName"] = prodName
        }
        
        goalDict["ImageUrl"] = response["packshotUrl"]
        goalDict["LoyaltyPoint"] = response["cuLoyaltyPoints"]
        goalDict["ProductId"] = response["productID"]
        
        
        UserDefaults.standard.setValue(goalDict, forKey: USER_GOAL_DETAIL_KEY)
      }
        
    
     // self.homeTableView.reloadData()
    }) { (errorMessage) in
      print("error in getting recommended product detail")
      UserDefaults.standard.setValue([String:Any](), forKey: USER_GOAL_DETAIL_KEY)
      UserDefaults.standard.setValue("", forKey: USER_LOYALTY_GOAL_ID_KEY)
      self.homeTableView.reloadData()
      self.dispatchGroup.leave()
    }
  }
  
  func getRecommendedProductDetailForTurkey(productCode:String)  {
    let getProductDetail:WSGetProductsFromCode = WSGetProductsFromCode()
    getProductDetail.getProductDetail(codes: productCode, successResponse: { (response) in
      self.recommendedProduct = response
      self.homeTableView.reloadData()
    }) { (errorMessage) in
      print("error in getting recommended product detail")
    }
  }
  
  func getRecommendedProductListFromAdmin(){
    
    let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    businessLayer.getRecommnendedProductListFromAdmin(successResponse: { (response) in
      if response.count > 0{
        if WSUtility.isLoginWithTurkey(){
          let recommendedProductCodes = response.map({$0["product_code"] as! String})
          let recommededProductCodeStr = recommendedProductCodes.joined(separator: ",")
          self.getRecommendedProductDetailForTurkey(productCode: recommededProductCodeStr)
          
        }else {
          let recommendedEanCodes = response.map({$0["product_cu_ean_code"] as! String})
          let recommededEanStr = recommendedEanCodes.joined(separator: ",")
          businessLayer.getRecommendedProductsFromEANCodesRequest(eanString: recommededEanStr, successResponse: { (response) in
            
            self.recommendedProduct = response
            self.homeTableView.reloadData()
          }, faliureResponse: { (errorMessage) in
            self.homeTableView.reloadData()
          })
        }
        
      }
    }) { (error) in
      
      self.homeTableView.reloadData()
    }
  }
  
  func getTradePartnerBanner()  {
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    var tradePartnerID = WSUtility.getValueFromUserDefault(key: TRADE_PARTNER_ID)
    
    if tradePartnerID.count == 0{
      tradePartnerID = "652"
    }
    
    serviceBussinessLayer.getTradePartnerBanner(tradePartnerId: tradePartnerID, successResponse: { (response) in
      
      self.bannerDict = response
      self.homeTableView.reloadData()
    }) { (errorMessage) in
      
    }
  }
  
  func getRecommendedRecipeCatlog()  {
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.makeRecommendedRecipeCatlogRequest(methodName: "", skip: "0", take: "5", successResponse: { (response) in
      /*
       if response.count == 0{
       self.getRecommendedRecipeFromAdmin()
       }else{
       self.recipeLists = response
       
       }
       */
      self.getRecommendedRecipeFromAdmin()
    }) { (errorMessage) in
      self.getRecommendedRecipeFromAdmin()
    }
  }
  
  func getRecommendedRecipeFromAdmin()  {
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.getRecommendedRecipeFromAdmin(successResponse: { (response) in
      self.recipeLists = response
      
      self.homeTableView.reloadData()
    }) { (errorMessage) in
      
    }
  }
  
  func getGoalProductDetail(productID:String)  {
    self.dispatchGroup.enter()
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.getGoalProductDetail(prodcutEanCode: productID, successResponse: { (response) in
      
       self.dispatchGroup.leave()
      var goalDict = [String:Any]()
      
      if let prodName = response["productName"]{
        goalDict["ProductName"] = prodName
      }else if let prodName = response["name"]{
        goalDict["ProductName"] = prodName
      }
      
      goalDict["ImageUrl"] = response["packshotUrl"]
      goalDict["LoyaltyPoint"] = response["cuLoyaltyPoints"]
      goalDict["ProductId"] = response["productID"]
      
      
      UserDefaults.standard.setValue(goalDict, forKey: USER_GOAL_DETAIL_KEY)
      
      //let indexPath = IndexPath(row: 1, section: 0)
      // self.homeTableView.reloadRows(at: [indexPath], with: .automatic)
     
      
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
      self.dispatchGroup.leave()
    }
  }
  
  func getOrderHistoryList() {
    //UFSProgressView.showWaitingDialog("")
    dispatchGroup.enter()
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.makeOrderHistoryRequest(methodName: ORDER_HISTORY_API, successResponse: { (response) in
      print(response)
      
      if response.count > 0{
        UserDefaults.standard.set(true, forKey: IS_USER_HAS_PLACED_FIRST_ORDER)
      }else{
        UserDefaults.standard.set(false, forKey: IS_USER_HAS_PLACED_FIRST_ORDER)
        self.getFirstOrderIncentive()
      }
      
      self.dispatchGroup.leave()
      // let indexPath = IndexPath(row: 1, section: 0)
      // self.homeTableView.reloadRows(at: [indexPath], with: .automatic)
      
      
    }, faliureResponse: { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
      self.dispatchGroup.leave()
      
    })
  }
  
  func getOrderHistoryListFromHybris() {
    dispatchGroup.enter()
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.makeOrderHistoryRequestToHybris(methodName: ORDER_HISTORY_API, successResponse: { (response) in
      print(response)
      if response.count > 0{
        UserDefaults.standard.set(true, forKey: IS_USER_HAS_PLACED_FIRST_ORDER)
      }else{
        UserDefaults.standard.set(false, forKey: IS_USER_HAS_PLACED_FIRST_ORDER)
        self.getFirstOrderIncentive()
      }
      
      self.dispatchGroup.leave()
      // let indexPath = IndexPath(row: 1, section: 0)
      // self.homeTableView.reloadRows(at: [indexPath], with: .automatic)
      
      
      
    }, faliureResponse: { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
      self.dispatchGroup.leave()
      
    })
  }
  func getDoubleProductListFromSifu()  {
    
    let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    businessLayer.getDoubleLoyaltyProductListFromSifu(successResponse: { (response) in
      
      if response.count > 0 {
        
        let valuesOfResponse:[[String: Any]] = Array(response.values) as! [[String: Any]]
        
        let sortedArray = valuesOfResponse.sorted {($0["id"] as! Int) < ($1["id"] as! Int) }
        var isRemarkFound = false
        
        for dict in sortedArray{
          //
          if let prodcutType = dict["productLoyaltyRemark"] as? String{
            
            if prodcutType.range(of:"3x") != nil || prodcutType.range(of:"2x") != nil || prodcutType.range(of:"3 fach") != nil || prodcutType.range(of:"2 fach") != nil{
              print("exists")
              isRemarkFound = true
              self.getProductDetailFromNumber(productNumber: "\(dict["articleNumber"] ?? "")", productRemark: prodcutType)
              break
            }
            
          }
        }
        
        if isRemarkFound == false{
          if sortedArray.count > 0{
            let randomNum:UInt32 = arc4random_uniform(UInt32(sortedArray.count))
            let indexOfProduct:Int = Int(randomNum)
            let dict = sortedArray[indexOfProduct]
            self.getProductDetailFromNumber(productNumber: "\(dict["articleNumber"] ?? "")", productRemark: "prodcutType")
          }
          
        }
      }
      
    }) { (errorMessage) in
      
    }
    
  }
  
  func getProductDetailFromNumber(productNumber:String, productRemark:String) {
    
    let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    businessLayer.getProductDetailFromSifu(productNumber: productNumber, successResponse: { (response) in
      
      if  response.count > 0 {
        var finalDict = response
        finalDict["productLoyaltyRemark"] = productRemark
        WSCacheSingleton.shared.cache.setObject(finalDict as AnyObject, forKey: (Cached_Double_Loyalty_Product_KEY as NSString))
        self.homeTableView.reloadData()
        
      }
      
    }) { (errorMessage) in
      
    }
    
  }
  
  func getCartDetail()  {
    
    let addToCartBussinessLogic = WSAddToCartBussinessLogic()
    addToCartBussinessLogic.getCartDetail(forController: self)
 
  }
  
  func getFirstOrderIncentive()  {
    let businesslayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    businesslayer.getCartCoupon(successResponse: { (response) in
      
      if let dict = response["data"] as? [String: Any]{
        UserDefaults.standard.set(dict["minimum_order_amount"]!, forKey: "First_Order_Incentive_amount")
        UserDefaults.standard.set(dict, forKey: "First_Order_Incentive_Data")
        self.homeTableView.reloadData()
      }
      
    }) { (errorMessage) in
      
    }
  }
  
  @objc func shopNowButton_click(sender: UIButton){
    
    if WSUtility.isLoginWithTurkey(){
        //as per UFSAPP-3772
        return
    }
    var appVersion = ""
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      appVersion = version
    }
    
    UFSGATracker.trackEvent(withCategory: "Banner click", action: "Homescreen", label: "", value: nil)
    if bannerDict.count > 0{
      let productCode = bannerDict["article_number"]
      self.performSegue(withIdentifier: "ProductDetailSegue", sender: productCode)
    }
  }
  
  func isSalesRepSectionHidden() -> Bool {
    if  WSUtility.isFeatureEnabled(feature: featureId.Live_Chat_Chef.rawValue) == false && WSUtility.isFeatureEnabled(feature: featureId.Sales_rep_chat_feature.rawValue) == false && WSUtility.isFeatureEnabled(feature: featureId.Sales_Rep_Call.rawValue) == false{
      return true
      
    }
    return false
  }
}

extension WSHomeViewController:UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 7
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == TR_BLUE_NOTE {
      let user:WSUser = WSUser().getUserProfile()
      if WSUtility.isLoginWithTurkey() && (user.userGroup == WSUser.UserGroupType().DTBO || user.userGroup == WSUser.UserGroupType().DTT){
        return 70 //TR Blue note
      }
      return 0
    }
    
    if indexPath.row == SALES_REP {
      if isSalesRepSectionHidden(){
        return 0
      }
      return UITableViewAutomaticDimension
      
    }else if indexPath.row == CHEF_REWARD_CELL {
      var height = 0.0
      let selectedGoalID = WSUtility.getGoalId()
      if selectedGoalID.count == 0 {
        height = WSUtility.isUserPlacedFirstOrder() ? (enableLoyaltyBanner ? 762 : 552) : (enableFirstOrderIncentive ? 817 : 598)
        return CGFloat(height)
      } else {
        //                let loyaltyHeight = enableLoyaltyBanner ? 666 : 456
        return 666
      }
      //624-state3 //720-state2
    }else if indexPath.row == PRODUCT_CELL{
      
      if enablePersonalizedPricing {
        return (enableRecommendedProduct && recommendedProduct.count > 0) ? 350 : 0
      }
      else{
        return (enableRecommendedProduct && recommendedProduct.count > 0) ? 416 : 0
      }
      
      //          return (recommendedProduct.count > 0) ? 416 : 0
    }else if indexPath.row == RECIPE_CELL{
      if self.recipeLists.count > 0{
        return 360
      }
      else{
        return 0
      }
    }else if indexPath.row == PROMOTION_CELL {
      if UserDefaults.standard.bool(forKey: DTO_OPERATOR) || enableTradePartner == false{
        return 0
      }
      else{
        return 260
      }
    }
    else if indexPath.row == FAVORITE_CELL {
      let height = favouriteLists.count == 0 ? 150 : 196
      return  CGFloat(height)
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var tableViewCell = UITableViewCell()
    
    if indexPath.row == SALES_REP {
      
      let salesRepo = tableView.dequeueReusableCell(withIdentifier: "WSSalesRepTableViewCell") as! WSSalesRepTableViewCell
      salesRepo.delegate =  self
      salesRepo.updateCellContent(isNeedToHideAllViews: isSalesRepSectionHidden(), salesRepDetails: callSalesRepUrl, cellExpandingStatus: isExpanding)
      
      tableViewCell = salesRepo
      
    }
    else if indexPath.row == TR_BLUE_NOTE {
      let user:WSUser = WSUser().getUserProfile()
      
      if WSUtility.isLoginWithTurkey() && (user.userGroup == WSUser.UserGroupType().DTBO || user.userGroup == WSUser.UserGroupType().DTT){
        let blueCell = tableView.dequeueReusableCell(withIdentifier: "TRBlueLabelCustomCell") as! TRBlueLabelCustomCell
        blueCell.vwHide(hide: false)
        tableViewCell = blueCell
      }
      
    }else if indexPath.row == CHEF_REWARD_CELL {
      
      let selectedGoalID = WSUtility.getGoalId() 
      if selectedGoalID.count == 0 {
        
        if WSUtility.isUserPlacedFirstOrder(){
          let chefRewardsCell =  tableView.dequeueReusableCell(withIdentifier: "WSChefRewardState2TableViewCell") as! WSChefRewardState2TableViewCell
          chefRewardsCell.chefRewardCollectionView.register(UINib(nibName: "ChefRewardCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "ChefRewardCollectionViewCell")
          
          chefRewardsCell.upadateCellContent(with: loyaltyProdcutCatlog)
          chefRewardsCell.delegate = self
          chefRewardsCell.toHideShowNowContainer(hide: false)
          if enableLoyaltyBanner == false {
            chefRewardsCell.toHideShowNowContainer(hide: true)
          }
          chefRewardsCell.shopNowcontainerView.delegate = self
          //chefRewardsCell.setUI()
          tableViewCell = chefRewardsCell
        }else{
          // if user has not place his first Order
          let chefRewardsCell =  tableView.dequeueReusableCell(withIdentifier: "WSChefRewardsTableViewCell") as! WSChefRewardsTableViewCell
          chefRewardsCell.setUI()
          chefRewardsCell.shopNowContainerView.delegate = self
          chefRewardsCell.shopNowContainerView.isFromHomeOrChefRewards = "Home"
          chefRewardsCell.chefRewardCollectionView.register(UINib(nibName: "ChefRewardCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "ChefRewardCollectionViewCell")
          chefRewardsCell.setUI()
          chefRewardsCell.chefRewardCollectionView.register(UINib(nibName: "WSChefRewardsCollectionViewAllProducts",bundle: nil), forCellWithReuseIdentifier: "WSChefRewardsCollectionViewAllProducts")
          
          
          chefRewardsCell.updateCellContent(with: loyaltyProdcutCatlog)
          chefRewardsCell.delegate = self
          chefRewardsCell.setUI()
          chefRewardsCell.shopNowContainerView.isHidden = false
          chefRewardsCell.toHideShowNowContainer(hide: false)
          if enableFirstOrderIncentive == false {
            chefRewardsCell.toHideShowNowContainer(hide: true)
          }
          tableViewCell = chefRewardsCell
        }
      }else{
        let chefRewardsCell =  tableView.dequeueReusableCell(withIdentifier: "WSChefRewardState3TableViewCell") as! WSChefRewardState3TableViewCell
        chefRewardsCell.updateCellContent()
        chefRewardsCell.shopNowContainerView.delegate = self
        chefRewardsCell.delegate = self
        chefRewardsCell.shopNowContainerView.isHidden = false
        chefRewardsCell.shopNowContainerView.setAttributedText()
        chefRewardsCell.toHideShowNowContainer(hide: false)
        tableViewCell = chefRewardsCell
      }
      
    } else if indexPath.row == PROMOTION_CELL{
      let promotionCell = tableView.dequeueReusableCell(withIdentifier: "WSPromotionTableViewCell") as! WSPromotionTableViewCell
      promotionCell.updateCellContent(dict: bannerDict)
      promotionCell.shopNowButton.addTarget(self, action: #selector(shopNowButton_click), for: .touchUpInside)
      tableViewCell = promotionCell
    }else if indexPath.row == FAVORITE_CELL{
      
      if favouriteLists.count == 0{
        let favouriteCell =  tableView.dequeueReusableCell(withIdentifier: "WSFavouriteTableViewCell") as! WSFavouriteTableViewCell
        favouriteCell.setUI()
        tableViewCell = favouriteCell
      }else if favouriteLists.count == 1 {
        let favouriteCell =  tableView.dequeueReusableCell(withIdentifier: "WSFavouriteWithOneProductTableViewCell") as! WSFavouriteWithOneProductTableViewCell
        
        let productDict = (favouriteLists[0]["product"] as![String:Any])
        let imageUrl = productDict["packshotUrl"]
        favouriteCell.productImageView.sd_setImage(with: URL(string: imageUrl as! String), placeholderImage: UIImage(named: "placeholder.png"), options: .allowInvalidSSLCertificates)
        favouriteCell.updateCellContent()
        tableViewCell = favouriteCell
      }else{
        
        let favouriteCell =  tableView.dequeueReusableCell(withIdentifier: "WSFavouriteWithThreeProductTableViewCell") as! WSFavouriteWithThreeProductTableViewCell
        
        favouriteCell.setUI()
        favouriteCell.productImageView1.sd_setImage(with: URL(string: getImageUrlForIndex(index: 0) ), placeholderImage: UIImage(named: "placeholder.png"), options: .allowInvalidSSLCertificates)
        
        favouriteCell.productImageView2.sd_setImage(with: URL(string: getImageUrlForIndex(index: 1) ), placeholderImage: UIImage(named: "placeholder.png"), options: .allowInvalidSSLCertificates)
        
        favouriteCell.productImageView3.isHidden = true
        
        if favouriteLists.count >= 3{
          favouriteCell.productImageView3.sd_setImage(with: URL(string: getImageUrlForIndex(index: 2) ), placeholderImage: UIImage(named: "placeholder.png"), options: .allowInvalidSSLCertificates)
          favouriteCell.productImageView3.isHidden = false
        }
        
        tableViewCell = favouriteCell
      }
      
    }else if indexPath.row == PRODUCT_CELL {
      let productCell = tableView.dequeueReusableCell(withIdentifier: "WSProductTableViewCell") as! WSProductTableViewCell
      //productCell.setUI()
      productCell.productCollectionView.register(UINib(nibName: "WSProductCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "WSProductCollectionViewCell")
      
      productCell.recommended_Prod = recommendedProduct
      productCell.setUI()
      productCell.delegate = self
      tableViewCell = productCell
    }else{
      let recipeCell = tableView.dequeueReusableCell(withIdentifier: "WSRecipeTableViewCell") as! WSRecipeTableViewCell
      recipeCell.setUI()
      recipeCell.recipeCollectionView.register(UINib(nibName: "WSRecipeCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "WSRecipeCollectionViewCell")
      recipeCell.reloadCollectionViewWithRecipes(recipes: recipeLists)
      recipeCell.delegate = self
      recipeCell.setUI()
      tableViewCell = recipeCell
    }
    
    return tableViewCell
    
  }
  
  @IBAction func chatButton_click(_ sender: Any) {
    /*
     let chatStoryboard = UIStoryboard.init(name: "Chat", bundle: nil)
     let cahtViewController = chatStoryboard.instantiateViewController(withIdentifier: "ChatHistoryViewController") as! ChatHistoryViewController
     cahtViewController.hidesBottomBarWhenPushed = true
     self.navigationController?.pushViewController(cahtViewController , animated: false)
     */
    LiveChat.presentChat()
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == SALES_REP{
      reloadSaleRepoSection(isExpandedCell: isExpanding)
    }else if indexPath.row == RECIPE_CELL{
      // self.performSegue(withIdentifier: "RecipeDeatilSeugeID", sender: recipeLists)
    }else if indexPath.row == PROMOTION_CELL {
      
    }
  }
  
  func getImageUrlForIndex(index:Int) -> String {
    let productDict = (favouriteLists[index]["product"] as![String:Any])
    let imageUrl = productDict["packshotUrl"]
    return imageUrl as! String
  }
  
    func getCallSalesRepDetails(){
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
                
                // let indexPath = IndexPath(row: 0, section: 0)
                //self.homeTableView.reloadRows(at: [indexPath], with: .automatic)
                self.homeTableView.reloadData()
            }
            
        }) { (errorMessage) in
            
        }
    }
  
  func enableDisableFeature() {
    
    UFSProgressView.showWaitingDialog("")
    let webservice = WSWebServiceBusinessLayer()
    webservice.featureEnableDisableForcountries(success: { (response) in
      self.makeAPICall()
      
      
    }) { (error) in
      //Error
      UFSProgressView.stopWaitingDialog()
    }
  }
  
}

extension WSHomeViewController : SalesRepoDelegate {
  func reloadSaleRepoSection(isExpandedCell: Bool) {
    isExpanding = !isExpanding
    let indexPath = IndexPath(row: 0, section: 0)
    if isExpanding {
      homeTableView.reloadRows(at: [indexPath], with: .bottom)
    }else{
      let cell:WSSalesRepTableViewCell = homeTableView.cellForRow(at: indexPath) as! WSSalesRepTableViewCell
      cell.callButton.isHidden = true
      cell.chatBtn.isHidden = true
      homeTableView.reloadRows(at: [indexPath], with: .top)
    }
  }
  
}

extension WSHomeViewController : ChefRewardDelegate {
  func didSelectOnChefRewardProdcut(productDetail: [String : Any]) {
    self.performSegue(withIdentifier: "ChefRewardDetailSegue", sender: productDetail)
  }
  
  func learnMoreAboutChefRewardAction() {
    
    self.performSegue(withIdentifier: "ChefRewardLandingSegue", sender: self)
  }
  
  func showAllRewardAction() {
    self.performSegue(withIdentifier: "ChefRewardCategorySegue", sender: self)
  }
}

extension WSHomeViewController : RecommendedProductDelegate{
  func didSelectOnRecommendedProdcut(productDetail: [String : Any]) {
    
    var productcodeStr: String = ""
    if let productCode = productDetail["productNumber"]{
      productcodeStr = "\(productCode)"
    }
    else if let productCode = productDetail["product_code"]{
      productcodeStr = "\(productCode)"
    }
    
    self.performSegue(withIdentifier: "ProductDetailSegue", sender: productcodeStr)
  }
}

extension WSHomeViewController : RecommendedRecipeCellDelegate {
  func didSelectOnRecipeCell(recipeDetail: [String : Any]) {
    self.performSegue(withIdentifier: "RecipeDeatilSeugeID", sender: recipeDetail)
  }
}

extension WSHomeViewController : WSChefRewardState2Delegate{
  func didSelectOnChefRewardState2Prodcut(productDetail: [String : Any]) {
    self.performSegue(withIdentifier: "ChefRewardDetailSegue", sender: productDetail)
  }
  
  func learnMoreAboutChefRewardState2Action() {
    self.performSegue(withIdentifier: "ChefRewardLandingSegue", sender: self)
  }
}

extension WSHomeViewController : ChefRewardState3Delegate{
  func reloadTableViewAfterReedemGift() {
    homeTableView.reloadData()
  }
  
  func didSelectOnDoubleLoyaltyProduct(productCode: String) {
    self.performSegue(withIdentifier: "ProductDetailSegue", sender: productCode)
    
  }
}

extension WSHomeViewController:WSChefRewardShopNowDelegate{
  func shopNowActionOnProduct(productCode: String) {
    if WSUtility.isUserPlacedFirstOrder(){
      //self.performSegue(withIdentifier: "ShowDoubleLoyaltyProductSegue", sender: self)
      self.performSegue(withIdentifier: "ProductDetailSegue", sender: productCode)
    }else{
      tabBarController?.selectedIndex = 2
    }
    
    
  }
  
}
