//
//  WSChefRewardScreenViewController.swift
//  yB2CApp
//
//  Created by Lakshminarayana on 05/12/17.
//

import UIKit
import AVKit
import AVFoundation

class WSChefRewardScreenViewController: UIViewController {
  @IBOutlet weak var pointsBalanceLabel: UILabel!
  @IBOutlet weak var chefRewardTableView: UITableView!
    @IBOutlet weak var PlayPauseText: UILabel!
    
  var loyaltyProduct = [[String:Any]]()
    var isFirstOrderIncentiveEnable = false
    var enableLoyatlyPromotionBanner = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.registerTableView()
    self.UISetUP()
    
    // print(WSCacheSingleton.shared.cache.object(forKey: Cached_Loyalty_Product as NSString) as Any)
    
  }

    
  override func viewWillAppear(_ animated: Bool) {
    
    NotificationCenter.default.addObserver(self, selector:#selector(applicationWillEnterForeground), name:
      NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    
    let product = WSCacheSingleton.shared.cache.object(forKey: Cached_Loyalty_Product as NSString) as Any
    
    if let cachedProduct = product as? [String:Any]{
      parseProductData(product: cachedProduct)
    }else{
      getLoyaltyProductCatlog()
    }
    
    if WSUtility.isFeatureEnabled(feature: featureId.First_order_incentive.rawValue) {
        isFirstOrderIncentiveEnable = true
    }
    
    enableLoyatlyPromotionBanner = false
    if WSUtility.isFeatureEnabled(feature: featureId.Loyalty_Promotion_Banner.rawValue) {
      enableLoyatlyPromotionBanner = true
    }
   
    if WSUtility.isUserPlacedFirstOrder() == false{
        
        if WSUtility.isLoginWithTurkey(){
            getOrderHistoryListFromHybris()
        }
        else{
            getOrderHistoryList()
        }
    }else{
      let doubleLoyaltyProductCachedResponse = WSCacheSingleton.shared.cache.object(forKey: Cached_Double_Loyalty_Product_KEY as NSString) as Any
      if let productArray = doubleLoyaltyProductCachedResponse as? [[String:Any]]{
        
        if productArray.count == 0{
          getDoubleProductListFromSifu()
        }
        
      }else{
         getDoubleProductListFromSifu()
      }
    }
    
    chefRewardTableView.reloadData()
  }
    func getFirstOrderIncentive()  {
        let businesslayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businesslayer.getCartCoupon(successResponse: { (response) in
            
            if let dict = response["data"] as? [String: Any]{
                UserDefaults.standard.set(dict["minimum_order_amount"]!, forKey: "First_Order_Incentive_amount")
                UserDefaults.standard.set(dict, forKey: "First_Order_Incentive_Data")
                self.chefRewardTableView.reloadData()
            }
            
        }) { (errorMessage) in
            
        }
    }
  override func viewWillDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self)
    
    if let videoCell:WSChefRewardVideoTableViewCell = chefRewardTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? WSChefRewardVideoTableViewCell{
      
      videoCell.pauseVideo()
    }
    
  }

  func applicationWillEnterForeground()  {
    
    if WSUtility.isUserPlacedFirstOrder() == false{
        if WSUtility.isLoginWithTurkey(){
            getOrderHistoryListFromHybris()
        }
        else{
            getOrderHistoryList()
        }
    }
  }
  
  func UISetUP()  {
    // addSlideMenuButton()
    WSUtility.addNavigationBarBackButton(controller: self)
    WSUtility.setBottomShadowToNavigationBar(viewController: self)
    WSUtility.setLoyaltyPoint(label: pointsBalanceLabel)
  }
  
  func registerTableView(){
    chefRewardTableView.dataSource = self
    chefRewardTableView.delegate = self
    chefRewardTableView.register(UINib(nibName: "WSChefRewardState3TableViewCell", bundle: nil), forCellReuseIdentifier: "WSChefRewardState3TableViewCell")
    chefRewardTableView.register(UINib(nibName: "WSChefRewardScreenShopnowTableViewCell", bundle: nil), forCellReuseIdentifier: "WSChefRewardScreenShopnowTableViewCell")
    chefRewardTableView.register(UINib(nibName: "TRBlueLabelCustomCell", bundle: nil), forCellReuseIdentifier: "TRBlueLabelCustomCell")

    chefRewardTableView.register(UINib(nibName: "WSChefsRewardReachedGoalPopupTableViewCell", bundle: nil), forCellReuseIdentifier: "WSChefsRewardReachedGoalPopupTableViewCell")
    
    chefRewardTableView.register(UINib(nibName: "WSChefRewardScreenGoalTableViewCell", bundle: nil), forCellReuseIdentifier: "WSChefRewardScreenGoalTableViewCell")
    chefRewardTableView.register(UINib(nibName: "WSChefRewardPointsAwayTableViewCell", bundle: nil), forCellReuseIdentifier: "WSChefRewardPointsAwayTableViewCell")
  }
  
  func getOrderHistoryList() {
    //UFSProgressView.showWaitingDialog("")
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.makeOrderHistoryRequest(methodName: ORDER_HISTORY_API, successResponse: { (response) in
      print(response)
      
      if response.count > 0{
        UserDefaults.standard.set(true, forKey: IS_USER_HAS_PLACED_FIRST_ORDER)
        self.getDoubleProductListFromSifu()
      }else{
        UserDefaults.standard.set(false, forKey: IS_USER_HAS_PLACED_FIRST_ORDER)
        self.getFirstOrderIncentive()
      }
        
      self.chefRewardTableView.reloadData()
      
    }, faliureResponse: { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
      
    })
  }
    func getOrderHistoryListFromHybris() {
        
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.makeOrderHistoryRequestToHybris(methodName: ORDER_HISTORY_API, successResponse: { (response) in
            print(response)
            if response.count > 0{
                UserDefaults.standard.set(true, forKey: IS_USER_HAS_PLACED_FIRST_ORDER)
            }else{
                UserDefaults.standard.set(false, forKey: IS_USER_HAS_PLACED_FIRST_ORDER)
                self.getFirstOrderIncentive()
            }
        }, faliureResponse: { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        })
    }
    
  func getLoyaltyProductCatlog()  {
    
    UFSProgressView.showWaitingDialog("")
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.makeLoyaltyProductCatlogRequest(methodName: "", categoryName: "*", skip: "0", take: "5", successResponse: { (response) in
      let dictResponse = response as! [String:Any]
      
      self.parseProductData(product: dictResponse)
      UFSProgressView.stopWaitingDialog()
      
      
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
    }
  }
  
  func parseProductData(product:[String:Any])  {
    
    let dictResponse = product
    
    if let loyaltyProducts = dictResponse["hits"] as? [[String:Any]] {
      self.loyaltyProduct = loyaltyProducts
    }
    
    
    chefRewardTableView.reloadData()
    
  }
  
  /*
  func getDoubleProductListFromHybris()  {
    
    let queryString = ":relevance:doubleLoyalty:true"
    let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    businessLayer.getDoubleLoyaltyProductListFromHybris(queryWithID: queryString, pageNumber: "\(0)", successResponse: { (response) in
      
      if let array = response["products"] {
        
        WSCacheSingleton.shared.cache.setObject(array as AnyObject, forKey: (Cached_Double_Loyalty_Product_KEY as NSString))
        self.chefRewardTableView.reloadData()
        
      }
      
    }) { (errorMessage) in
    }
    
  }
  */
  
  
  func getDoubleProductListFromSifu()  {
    
    let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    businessLayer.getDoubleLoyaltyProductListFromSifu(successResponse: { (response) in
      
      if response.count > 0 {
        
        let valuesOfResponse:[[String: Any]] = Array(response.values) as! [[String: Any]]
        var isRemarkFound = false
        
        let sortedArray = valuesOfResponse.sorted {($0["id"] as! Int) < ($1["id"] as! Int) }
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
            let dict = sortedArray[0]
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
       self.chefRewardTableView.reloadData()
        
      }
      
    }) { (errorMessage) in
      
    }
    
  }
  
  @IBAction func backAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is AllProductsViewController{
      let productViewController = segue.destination as! AllProductsViewController
      productViewController.productListScreenOpenedBy = .DOUBLE_LOYALTY_PRODUCT
    }else if segue.destination is WSProductDetailViewController{
      
      let productVC = segue.destination as? WSProductDetailViewController
      productVC?.productCode = (sender as? String)!
    }
    else if segue.identifier == "ChefRewardDetailSegue" {
        let chefRewardDetailVc = segue.destination as! WSChefRewardDetailViewController
        chefRewardDetailVc.productDetail = sender as! [String:Any]
    }
  }
  
}

extension WSChefRewardScreenViewController:UITableViewDelegate, UITableViewDataSource{
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if WSUtility.isLoginWithTurkey(){
        // for time being purpose
        return 5
    }
    return 6
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var tableViewCell = UITableViewCell()
    
    if indexPath.row == 0 {
      let cell = chefRewardTableView.dequeueReusableCell(withIdentifier: "WSChefRewardScreenShopnowTableViewCell") as! WSChefRewardScreenShopnowTableViewCell
      cell.shopViewContainerView.delegate = self
      cell.shopViewContainerView.isFromHomeOrChefRewards = "Chef Rewards"
      cell.shopViewContainerView.isHidden = false
      cell.shopViewContainerView.setAttributedText()
      if WSUtility.isUserPlacedFirstOrder(){
        if enableLoyatlyPromotionBanner == false {
          cell.shopViewContainerView.isHidden = true
        }
      }else{
        
        if isFirstOrderIncentiveEnable == false{
          cell.shopViewContainerView.isHidden = true
        }
      }
     
        
      cell.setUI()
      tableViewCell = cell
    }
    else if indexPath.row == 1{
      
      let selectedGoalID = WSUtility.getGoalId()
      if selectedGoalID.count == 0 {
        //chefs reward entry 1
        
        let cell = chefRewardTableView.dequeueReusableCell(withIdentifier: "WSChefRewardScreenGoalTableViewCell") as! WSChefRewardScreenGoalTableViewCell
        cell.earnPointsCollectionView.register(UINib(nibName: "ChefRewardCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "ChefRewardCollectionViewCell")
        cell.upadateCellContent(ProductDetail: loyaltyProduct)
        cell.setUI()
        cell.delegate = self
        tableViewCell = cell
      }else{
        //chefs reward entry 2
        
        let cell = chefRewardTableView.dequeueReusableCell(withIdentifier: "WSChefRewardPointsAwayTableViewCell") as! WSChefRewardPointsAwayTableViewCell
        cell.updateCellContent()
        cell.delegate = self
        tableViewCell = cell
      }
      
      
    }
    else if indexPath.row == 2 {
        let user:WSUser = WSUser().getUserProfile()
        
        if WSUtility.isLoginWithTurkey() && (user.userGroup == WSUser.UserGroupType().DTBO || user.userGroup == WSUser.UserGroupType().DTT){

        let blueCell = tableView.dequeueReusableCell(withIdentifier: "TRBlueLabelCustomCell") as! TRBlueLabelCustomCell
        blueCell.vwHide(hide: false)
        tableViewCell = blueCell
        }
    }else if indexPath.row == 3{
      let cell = chefRewardTableView.dequeueReusableCell(withIdentifier: "WSChefRewardVideoTableViewCell") as! WSChefRewardVideoTableViewCell
      // cell.playVideo()
        cell.activityIndicator.startAnimating()
      
      tableViewCell = cell
      
    }else if indexPath.row == 4{
      let cell = chefRewardTableView.dequeueReusableCell(withIdentifier: "WSChefRewardCatalogueTableViewCell") as! WSChefRewardCatalogueTableViewCell
      cell.updateUI()
      cell.chefRewardCollectionView.register(UINib(nibName: "ChefRewardCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "ChefRewardCollectionViewCell")
      cell.updateUI()
      cell.upadateCellContent(ProductDetail: loyaltyProduct)
      cell.delegate = self
      tableViewCell = cell
    }else{
      let cell = chefRewardTableView.dequeueReusableCell(withIdentifier: "WSChefRewardFaqTableViewCell") as! WSChefRewardFaqTableViewCell
      cell.setUI()
      tableViewCell = cell
    }
    
    return tableViewCell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 2 {
        let user:WSUser = WSUser().getUserProfile()
        if WSUtility.isLoginWithTurkey() && (user.userGroup == WSUser.UserGroupType().DTBO || user.userGroup == WSUser.UserGroupType().DTT){
            return 70 //TR Blue note
        }
        return 0
    }

    if indexPath.row == 0{
      
      if WSUtility.isUserPlacedFirstOrder(){
        if enableLoyatlyPromotionBanner == false {
          return 0
        }
      }else{
        if isFirstOrderIncentiveEnable == false{
          return 0
        }
      }
      
      return 210
    }else if indexPath.row == 1{
      let selectedGoalID = WSUtility.getGoalId() 
      if selectedGoalID.count == 0 {
        return 613
      }else{
        return 380
      }
      
    }else if indexPath.row == 3{
      // Video url is only available for AT now
      return WSUtility.getCountryCode() == "AT" ? 334 : 0
      
       /* not needed as cellforeRow at indexpath has no check for getgoalID
         let selectedGoalID = WSUtility.getGoalId()
        if selectedGoalID.count == 0 {
            return 334
        }
        else{
            return 0
        }*/
      
    }else if indexPath.row == 4{
      return 360
    }else{
        
        if WSUtility.isLoginWithTurkey(){
            // for time being purpose
            return 0
        }
      return 140
    }
  }
  //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  //        let cell = chefRewardTableView.dequeueReusableCell(withIdentifier: "WSChefRewardVideoTableViewCell") as! WSChefRewardVideoTableViewCell
  //        cell.pauseVideo()
  //    }
}

extension WSChefRewardScreenViewController : WSChefRewardScreenGoalTableViewCellDelegate{
  func openChefRewardCategory() {
    self.performSegue(withIdentifier: "ChefRewardCategorySegue", sender: self)
  }
    func didSelectOnChefRewardProdcut(productDetail: [String : Any]) {
        self.performSegue(withIdentifier: "ChefRewardDetailSegue", sender: productDetail)
    }
}

extension WSChefRewardScreenViewController : ChefRewardCatalogueCellDelegate{
  func showAllChefRewardCategory() {
    self.performSegue(withIdentifier: "ChefRewardCategorySegue", sender: self)
  }
  func didSelectOnChefRewardCatalogueProduct(productDetail: [String : Any]) {
    self.performSegue(withIdentifier: "ChefRewardDetailSegue", sender: productDetail)
  }
}

extension WSChefRewardScreenViewController : ChefRewardPointsAwayTableViewCellDelegate{
  func changeMyGoalAction() {
    self.performSegue(withIdentifier: "ChefRewardCategorySegue", sender: self)
  }
  func reloadTableViewAfterReedemGift() {
    chefRewardTableView.reloadData()
  }
}

extension WSChefRewardScreenViewController : WSChefRewardShopNowDelegate{
  func shopNowActionOnProduct(productCode: String) {
    
    if WSUtility.isUserPlacedFirstOrder(){
      self.performSegue(withIdentifier: "ProductDetailSegue", sender: productCode)
    }else{
      tabBarController?.selectedIndex = 2
      self.navigationController?.popViewController(animated: false)
    }
  }
}
