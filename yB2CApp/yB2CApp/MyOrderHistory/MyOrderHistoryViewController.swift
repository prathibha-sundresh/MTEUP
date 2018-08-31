//
//  MyOrderHistoryViewController.swift
//  yB2CApp
//
//  Created by Ramakrishna on 12/7/17.
//

import UIKit

class MyOrderHistoryViewController: UIViewController {
    
    @IBOutlet weak var myOrderHistoryTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var noRecordsFoundLabel: UILabel!
    var historyArray:[[String:Any]] = []
    var productCodeWithQuantity = ""
    var totalNumberOfTimeRetry = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  addSlideMenuButton()
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.trackingScreens(screenName: "Order Listing Screen")
        UFSGATracker.trackScreenViews(withScreenName: "Order Listing Screen")
        FireBaseTracker.ScreenNaming(screenName: "Order Listing Screen", ScreenClass: String(describing: self))
        FBSDKAppEvents.logEvent("Order Listing Screen")
        
        self.noRecordsFoundLabel.isHidden = true
        WSUtility.addNavigationBarBackButton(controller: self)
        WSUtility.addNavigationRightBarButton(toViewController: self)
        
        if WSUtility.isLoginWithTurkey() {
            getOrderHistoryListFromHybris()
        }
        else{
            getOrderHistoryList()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        WSUtility.setCartBadgeCount(ViewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rightBarButtonPressed(_ sender: UIButton)  {
        WSUtility.cartButtonPressed(viewController: self)
        
    }
    
    func getOrderHistoryList() {
        UFSProgressView.showWaitingDialog("")
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.makeOrderHistoryRequest(methodName: ORDER_HISTORY_API, successResponse: { (response) in
            
            self.historyArray = response
            if self.historyArray.count != 0 {
                self.myOrderHistoryTableView.tableHeaderView = self.headerView
                self.myOrderHistoryTableView.tableFooterView = UIView(frame: CGRect.zero)
                self.myOrderHistoryTableView.reloadData()
            }
            else {
                self.noRecordsFound()
            }
            UFSProgressView.stopWaitingDialog()
            
        }, faliureResponse: { (errorMessage) in
            self.noRecordsFound()
            UFSProgressView.stopWaitingDialog()
        })
    }
    
    func getOrderHistoryListFromHybris() {
        UFSProgressView.showWaitingDialog("")
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.makeOrderHistoryRequestToHybris(methodName: ORDER_HISTORY_API, successResponse: { (response) in
            
            self.historyArray = response
            if self.historyArray.count != 0 {
                self.myOrderHistoryTableView.tableHeaderView = self.headerView
                self.myOrderHistoryTableView.tableFooterView = UIView(frame: CGRect.zero)
                self.myOrderHistoryTableView.reloadData()
            }
            else {
                self.noRecordsFound()
            }
            UFSProgressView.stopWaitingDialog()
            
        }, faliureResponse: { (errorMessage) in
            self.noRecordsFound()
            UFSProgressView.stopWaitingDialog()
        })
    }
  
  /*
  func retreiveDataFromHybris(dic:[String:Any]){
    if let str = dic["code"] as? String{
      dicOrderHistory["id"] = str
    }
    if let str = dic["created"] as? String{
      var myStringArr = str.components(separatedBy: " ")
      
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      
      let date = dateFormatter.date(from: myStringArr[0])
      dateFormatter.dateFormat = "MM/dd/yy"
      
      
      dicOrderHistory["createdDateTime"] = "\(dateFormatter.string(from: date!))"
    }
    if let items = dic["totalItems"] as? Int{
      dicOrderHistory["orderLineItemCount"] = items
    }
    dicOrderHistory["status"] = "\(dic["statusDisplay"] ?? "")"
    
    if let dicVendorData = dic["vendorData"] as? [String:Any]{
      dicOrderHistory["parentTradePartner"] = dicVendorData
    }
    
    if let arrEntries = dic["entries"] as? [[String:Any]]{
      if let objEntry = arrEntries[0] as? [String:Any]
      {
        if let dicProduct = objEntry["product"] as? [String:Any]{
          if let arrBaseOptions = dicProduct["baseOptions"] as? [[String:Any]]
          {
            if let objBaseOptions = arrBaseOptions[0] as? [String:Any]
            {
              if let dicSelected = objBaseOptions["selected"] as? [String:Any]{
                if let points = dicSelected["loyalty"] as? Int{
                  dicOrderHistory["totalLoyaltyPoints"] = points
                }
                dicOrderDetails["productImageUrl"] =  "\(dicSelected["thumbnailUrl"] ?? "")"
              }
            }
          }
          dicOrderDetails["productName"] =  "\(dicProduct["name"] ?? "")"
          dicOrderDetails["packagingDescription"] =  "\(dicProduct["packaging"] ?? "")"
        }
      }
    }
    
    var dicUserDetails = [String:Any]()
    if let dicUser = dic["user"] as? [String:Any]{
      if let str = dicUser["name"] as? String{
        dicUserDetails["fullName"] = str
      }
      if let str = dicUser["uid"] as? String{
        dicUserDetails["email"] = str
      }
    }
    dicMydetails["orderInfo"] = dicUserDetails
    
    var dicDtls = [String:Any]()
    var dicBilling = [String:Any]()
    if let dicDeliveryAddress = dic["deliveryAddress"] as? [String:Any]{
      if let str = dicDeliveryAddress["companyName"] as? String{
        dicBilling["businessName"] = str
      }
      if let str = dicDeliveryAddress["line1"] as? String{
        dicBilling["houseNumber"] = str
      }
      if let str = dicDeliveryAddress["line2"] as? String{
        dicBilling["street"] = str
      }
      if let str = dicDeliveryAddress["postalCode"] as? String{
        dicBilling["zipCode"] = str
      }
      if let str = dicDeliveryAddress["town"] as? String{
        dicBilling["city"] = str
      }
      dicDtls["billingAddress"] = dicBilling
      dicBillingAddress["orderInfo"] = dicDtls
    }
    
    
    if let dicTotalPrice = dic["totalPrice"] as? [String:Any]{
      if let price = dicTotalPrice["value"] as? Double{
        dicOrderDetails["totalPrice"] = price
      }
    }
    dicOrderDetails["totalLoyaltyPoints"] = dicOrderHistory["totalLoyaltyPoints"]
    dicOrderDetails["quantity"] =  dicOrderHistory["orderLineItemCount"]
  }
 */
 
 
  func getOrderDetailFromHybris(index:Int){
    
    let orderDetail = historyArray[index]
    if let referenceid = orderDetail["code"]{
    let  referenceID = referenceid as! String
      
      
      UFSProgressView.showWaitingDialog("")
      
      let businessLayer = WSWebServiceBusinessLayer()
      businessLayer.makeOrderDetailRequestToHybris(referenceID: referenceID, methodName: ORDER_HISTORY_DETAIL_API_HYBRIS_FOR_TR, successResponse: { (response) in
        
        //self.retreiveDataFromHybris(dic: response)
        
        if let Items = response as? [String:Any] {
          
            if let entries = Items["deliveryOrderGroups"] as? [[String:Any]]{
              if let orderLineItems = entries[0] as? [String:Any]{
                if let Items = orderLineItems["entries"] as? [[String:Any]]{
                 
                  self.reOrderToCart(productsArray: Items)
                }
              }
            }
          
        }
        
        UFSProgressView.stopWaitingDialog()
        
      }) { (error) in
        UFSProgressView.stopWaitingDialog()
        
      }
      
      
      
    }
    
    
  }
  
  
    func noRecordsFound() {
        self.myOrderHistoryTableView.isHidden = true
        self.noRecordsFoundLabel.isHidden = false
        self.noRecordsFoundLabel.text = WSUtility.getlocalizedString(key: "No data found", lang: WSUtility.getLanguage(), table: "Localizable")
    }
    
    func getOrderDetail(forIndex index:Int){
        let orderDetail = historyArray[index]
        
        if let referenceID = orderDetail["orderReferenceId"] as? String {
            
            UFSProgressView.showWaitingDialog("")
            
            let businessLayer = WSWebServiceBusinessLayer()
            businessLayer.makeOrderDetailRequest(referenceID: referenceID, methodName: ORDER_HISTORY_API, successResponse: { (response) in
                if let Items = response as? [String:Any] {
                    if let orderLineItems = Items["orderLineItems"] as? [[String:Any]]{
                        
                        self.reOrderToCart(productsArray: orderLineItems)
                        
                    }
                }
                
                UFSProgressView.stopWaitingDialog()
                
            }) { (error) in
                UFSProgressView.stopWaitingDialog()
                
            }
            
        }
        
    }
    
    
    func reOrderToCart(productsArray:[[String:Any]]) {
        
        var productListArray = [[String: Any]]()
        
        //var products = ""
        for index in 1...productsArray.count {
            let reOrderArr = productsArray[index-1]
          
          if let productType = reOrderArr["productType"] as? String {
            
            if (productType  == "PROMOTION_REWARD" || productType == "LOYALTY_REWARD") {
              continue
            }
          }
          
          // for turkey
          if let productPriceValue = reOrderArr["totalPrice"] as? [String:Any],productPriceValue["value"] as? Int == 0{
            continue
          }
          
          
            var productDict = [String: Any]()
            var billingAddressDictionary = [String: Any]()
            billingAddressDictionary = reOrderArr
            //print(billingAddressDictionary)
          
         if  let product = billingAddressDictionary["product"] as? [String:Any]{
            productDict["code"] =  product["code"]
          }else if let productCode = billingAddressDictionary["eanCode"] as? String{
              productDict["code"] = productCode
          }
         
            let qty = billingAddressDictionary["quantity"]
            
          
            productDict["qty"] = qty
            productListArray.append(productDict)
          
            print(productDict)
        }
        let dict = ["productList": productListArray]
        let productRequestDict = ["cartId":UFSHybrisUtility.uniqueCartId,"entries":dict] as [String : Any]
       // print(productRequestDict)
        
        reOrderAPICall(requestDict: productRequestDict)
        
    }
    
    func reOrderAPICall(requestDict:[String : Any])  {
        
        let cartId = UFSHybrisUtility.uniqueCartId

        let webServiceBusinessLayer = WSWebServiceBusinessLayer()
        UFSProgressView.showWaitingDialog("")
        webServiceBusinessLayer.reOrderToCart(product: "", cart_id: cartId, products: requestDict, successResponse: {(response) in
            print(response)
            self.retriveCurrentCart()
        }) {(errorMessage) in
            UFSProgressView.stopWaitingDialog()
//            WSUtility.showAlertWith(message: errorMessage, title: "", forController: self)
        }

    
    }
    
    func retriveCurrentCart(){
        let addToCartBussinessLogic = WSAddToCartBussinessLogic()
        addToCartBussinessLogic.getCartDetail(forController: self)
    }
}
extension MyOrderHistoryViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let orderHistoryTableViewCell: MyOrderHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyOrderHistoryTableViewCell", for: indexPath) as! MyOrderHistoryTableViewCell
        
        orderHistoryTableViewCell.delegate = self
        orderHistoryTableViewCell.reOrderAllButton.layer.borderColor = UIColor(red:1.00, green:0.35, blue:0.01, alpha:1.0).cgColor
        orderHistoryTableViewCell.reOrderAllButton.layer.borderWidth = 1.0
        orderHistoryTableViewCell.reOrderAllButton.clipsToBounds = true
        orderHistoryTableViewCell.reOrderAllButton.tag = indexPath.row
        let dict = historyArray[indexPath.row]
    let temp = dict["parentTradePartner"] as? [String:Any]
        orderHistoryTableViewCell.setUI(dict: dict)
        if WSUtility.isLoginWithTurkey(){
            orderHistoryTableViewCell.reOrderAllButton.isEnabled = true
            orderHistoryTableViewCell.reOrderAllButton.alpha = 1
        }
        else {
    if (temp == nil) {
        orderHistoryTableViewCell.reOrderAllButton.isEnabled = false
        orderHistoryTableViewCell.reOrderAllButton.alpha = 0.25
    } else {
        orderHistoryTableViewCell.reOrderAllButton.isEnabled = true
        orderHistoryTableViewCell.reOrderAllButton.alpha = 1
    }
    }
        cell = orderHistoryTableViewCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderDetail = historyArray[indexPath.row]
        performSegue(withIdentifier: "orderHistoryDetails", sender: orderDetail)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    /*
     func reOrderToCart(from cell: WSSearchProductViewCell, selectedIndex: Int) {
     
     getOrderDetail(forIndex: selectedIndex)
     }
     */
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HYBOrderHistoryDetailViewController{
            let chefRewardDetailVc = segue.destination as! HYBOrderHistoryDetailViewController
            chefRewardDetailVc.orderDetail = sender as! [String:Any]
            chefRewardDetailVc.isFromOrderHistory = true
            
        }
    }
}

extension MyOrderHistoryViewController:MyOrderHistoryCellDelegate{
    func reOrderButtonAction(selectedIndex: Int) {
      if WSUtility.getCountryCode() == "TR"{
        getOrderDetailFromHybris(index: selectedIndex)
      }else{
        getOrderDetail(forIndex: selectedIndex)
      }
      
    }
}

