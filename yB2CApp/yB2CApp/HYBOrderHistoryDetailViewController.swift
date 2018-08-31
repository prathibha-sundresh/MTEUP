//
//  HYBOrderHistoryDetailViewController.swift
//  yB2CApp
//
//  Created by Sahana Rao on 06/12/17.
//

import UIKit

class HYBOrderHistoryDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, WSTotalOrderItemsTableViewCellDelegate {
    var dicOrderHistory = [
        
        "id":"",
        "createdDateTime":"",
        "orderLineItemCount":0,
        "totalLoyaltyPoints":0,
        "totalLoyaltyRewardPoints":"",
        "status":""] as [String : Any]
    
    var dicMydetails = [String : Any]()

    var dicBillingAddress = [String : Any]()

  /*
    var dicOrderDetails = [
        "productName":"",
        "totalLoyaltyPoints":0,
        "packagingDescription":"",
        "quantity":0,
        "totalPrice": 0.0,
        "productImageUrl":""] as [String : Any]
 */
  var dicOrderDetails = [[String : Any]]()
  

  

    @IBOutlet weak var bottomConstraintConstant: NSLayoutConstraint!
    var isFromOrderHistory = false
    @IBOutlet weak var orderDetailsTableView: UITableView!
    var orderDetail:[String:Any] = [:]
    var orderDetailHistory:[String:Any] = [:]
    var orderLineItemsArray = [[String:Any]]()
    
    var referenceID:String = ""
    var productCodeWithQuantity = ""
    var totalNumberOfTimeRetry = 3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
        WSWebServiceBusinessLayer().updateExcludedProductsFromUserProfile()
    }
        if isFromOrderHistory{
            bottomConstraintConstant.constant = 0
        }
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.trackingScreens(screenName: "Order Detail Screen")
        UFSGATracker.trackScreenViews(withScreenName: "Order detail screen")
        FireBaseTracker.ScreenNaming(screenName: "Order Detail Screen", ScreenClass: String(describing: self))
        FBSDKAppEvents.logEvent("Order Detail Screen")
        
        WSUtility.addNavigationBarBackButton(controller: self)
        // Do any additional setup after loading the view.
        
        WSUtility.addNavigationRightBarButton(toViewController: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        if WSUtility.isLoginWithTurkey() {
            getOrderDetailFromHybris()
        }
        else{
            getOrderDetail()
        }
        WSUtility.setCartBadgeCount(ViewController: self)
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func rightBarButtonPressed(_ sender: UIButton)  {
        WSUtility.cartButtonPressed(viewController: self)
        
    }
    
    func getOrderDetail(){
        if let referenceid = orderDetail["orderReferenceId"]{
            referenceID = referenceid as! String
        }
        orderDetailHistory.removeAll()
        UFSProgressView.showWaitingDialog("")
        
        let businessLayer = WSWebServiceBusinessLayer()
        businessLayer.makeOrderDetailRequest(referenceID: referenceID, methodName: ORDER_HISTORY_API, successResponse: { (response) in
            self.orderDetailHistory = response
            if let Items = response as? [String:Any] {
                if let orderLineItems = Items["orderLineItems"] as? [[String:Any]]{
                    self.orderLineItemsArray = orderLineItems
                }
            }
            self.orderDetailsTableView.reloadData()
            UFSProgressView.stopWaitingDialog()
            
        }) { (error) in
            UFSProgressView.stopWaitingDialog()
            
        }
    }
    
    func retreiveDataFromHybris(dic:[String:Any]){
        if let str = dic["code"] as? String{
            dicOrderHistory["id"] = str
        }
        if let valueStr = dic["tpAccountNumber"] as? String{
            dicOrderHistory["clientNumber"] = valueStr
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
        if let items = dic["deliveryItemsQuantity"] as? Int{
            dicOrderHistory["orderLineItemCount"] = items
        }
        dicOrderHistory["status"] = "\(dic["statusDisplay"] ?? "")"
        
        if let dicVendorData = dic["vendorData"] as? [String:Any]{
            dicOrderHistory["parentTradePartner"] = dicVendorData
        }
      if let totalLoyaltyPoints = dic["totalLoyaltyPointsForOrder"] as? Int{
        dicOrderHistory["totalLoyaltyPoints"] = totalLoyaltyPoints
      }
      
      if let dicTotalPrice = dic["totalPrice"] as? [String:Any]{
        if let price = dicTotalPrice["formattedValue"] as? String{
          dicOrderHistory["totalPrice"] = price
        }
      }
        
        if let arrEntries = dic["entries"] as? [[String:Any]]{
          
          for objEntry in arrEntries{
            
            var dict = [String:Any]()
            
              if let dicProduct = objEntry["product"] as? [String:Any]{
                if let arrBaseOptions = dicProduct["baseOptions"] as? [[String:Any]]{
                  
                  if  arrBaseOptions.count > 0 {
                    let objBaseOptions = arrBaseOptions[0]
                    if let dicSelected = objBaseOptions["selected"] as? [String:Any]{
 
                      dict["totalLoyaltyPoints"] = dicSelected["loyalty"]
                      dict["productImageUrl"] =  "\(dicSelected["thumbnailUrl"] ?? "")"
                      
                      if let totalprice = dicSelected["priceData"] as? [String:Any],let price = totalprice["formattedValue"] as? String{
                        
                        dict["totalPrice"] = price
                      }
                    }
                    
                    
                  }
                  
                  
                }
                dict["productName"] =  "\(dicProduct["name"] ?? "")"
                dict["packagingDescription"] =  "\(dicProduct["packaging"] ?? "")"
                
      
              }
            
            //dict["totalLoyaltyPoints"] = objEntry["loyaltyPointsForProduct"]
            dict["quantity"] =  objEntry["quantity"]
            
            dicOrderDetails.append(dict)
            
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
        
      
            }
  
    func getOrderDetailFromHybris(){
            if let referenceid = orderDetail["code"]{
                referenceID = referenceid as! String
            }
        
        orderDetailHistory.removeAll()
        UFSProgressView.showWaitingDialog("")
        
        let businessLayer = WSWebServiceBusinessLayer()
        businessLayer.makeOrderDetailRequestToHybris(referenceID: referenceID, methodName: ORDER_HISTORY_DETAIL_API_HYBRIS_FOR_TR, successResponse: { (response) in
            self.orderDetailHistory = response
            self.retreiveDataFromHybris(dic: response)

            if let Items = response as? [String:Any] {
                if WSUtility.getCountryCode() == "TR"
                {
                    self.orderLineItemsArray.removeAll()
                    if let entries = Items["deliveryOrderGroups"] as? [[String:Any]]{
                        if let orderLineItems = entries[0] as? [String:Any]{
                            if let Items = orderLineItems["entries"] as? [[String:Any]]{
                                for objEntry in Items{
                                    var tmpDict: [String: Any] = objEntry
                                    if let totalprice = objEntry["totalPrice"] as? [String:Any]{
                                        if let value = totalprice["value"] as? Double, value == 0{
                                            tmpDict["productType"] = "PROMOTION_REWARD"
                                        }
                                        else{
                                            tmpDict["productType"] = ""
                                        }
                                    }
                                    self.orderLineItemsArray.append(tmpDict)
                                }
                                
                            }
                        }
                    }
                }
                else{
                    if let orderLineItems = Items["orderLineItems"] as? [[String:Any]]{
                        self.orderLineItemsArray = orderLineItems
                    }
                }
            }
            
            self.orderDetailsTableView.reloadData()
            UFSProgressView.stopWaitingDialog()
            
        }) { (error) in
            UFSProgressView.stopWaitingDialog()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 3
        }
        else if section == 2 {
            return 1
        }
        else if section == 3 {
            return orderLineItemsArray.count
        }
        else if section == 4 {
            return 1
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 55
        }
        else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView : UIView = UIView()
        if section == 1 {
            headerView = UIView(frame: CGRect(x: 0, y: 0, width:self.orderDetailsTableView.frame.size.width , height: 43))
            headerView.backgroundColor = UIColor.white
            let label = UILabel(frame: CGRect(x: 15, y: 13, width: self.orderDetailsTableView.frame.size.width, height: 30))
            label.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1)
            label.text = WSUtility.getlocalizedString(key: "Summary", lang: WSUtility.getLanguage(), table: "Localizable")
            label.font = UIFont (name: "DINPro-Medium", size: 20)
            headerView.addSubview(label)
        }
        return headerView
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellReuseIdentifier : String
        var cell : UITableViewCell = UITableViewCell()
        
        if indexPath.section == 0 {
            cellReuseIdentifier = "orderHistoryTableViewCell"
            let orderHistoryCell : OrderHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! OrderHistoryTableViewCell
            
            orderHistoryCell.translateUI()
            if WSUtility.getCountryCode() == "TR"{
                orderHistoryCell.setUI(dict: dicOrderHistory)
            }
            else{
                orderHistoryCell.setUI(dict: orderDetailHistory)
            }
            cell = orderHistoryCell
            
        }
        else if indexPath.section == 1 {
            cellReuseIdentifier = "orderSummaryTableViewCell"
            let orderSummaryCell : WSOrderSummaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! WSOrderSummaryTableViewCell
            orderSummaryCell.translateUI()
            if indexPath.row == 0{
                if WSUtility.getCountryCode() == "TR"{
                    orderSummaryCell.setMydetailsUI(dict: dicMydetails)
                }
                else{
                    orderSummaryCell.setMydetailsUI(dict: orderDetailHistory)
                }

            }else if indexPath.row == 1{
                if WSUtility.getCountryCode() == "TR"{
                orderSummaryCell.setTradePartnerUI(dict: dicOrderHistory)
                }
                else{
                orderSummaryCell.setTradePartnerUI(dict: orderDetailHistory)
                }
            }else if indexPath.row == 2{
                if WSUtility.getCountryCode() == "TR"{
                    orderSummaryCell.setBillingUI(dict: dicBillingAddress)
                }
                else{
                    orderSummaryCell.setBillingUI(dict: orderDetailHistory)
                }
            }
            cell = orderSummaryCell
            
        }
        else if indexPath.section == 2 {
            cellReuseIdentifier = "totalItemsTableviewCell"
            let totalOrderCell : WSTotalOrderItemsTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! WSTotalOrderItemsTableViewCell
            totalOrderCell.translateUI()
            totalOrderCell.delegate = self
            if indexPath.row == 0{
                if WSUtility.getCountryCode() == "TR"{
                    totalOrderCell.setUI(dict: dicOrderHistory)
                }
                else{
                    totalOrderCell.setUI(dict: orderDetailHistory)
                }
            }
            cell = totalOrderCell
            
        }
        else if indexPath.section == 3 {
            cellReuseIdentifier = "orderDetailsTableViewCell"
            let orderDetailsCell : WSOrderDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! WSOrderDetailsTableViewCell
            orderDetailsCell.delegate = self
            orderDetailsCell.translateUI()
            let orderItems = orderLineItemsArray[indexPath.row]
            if WSUtility.getCountryCode() == "TR"{
                orderDetailsCell.setUI(dict: dicOrderDetails[indexPath.row])
            }
            else{
                orderDetailsCell.setUI(dict: orderItems)
            }
            if orderItems.count > 0{
                if (orderItems["productType"] as! String)  == "PROMOTION_REWARD"{
                    orderDetailsCell.addToCartButton.isEnabled = true
                    orderDetailsCell.addToCartButton.alpha = 1
                    orderDetailsCell.addToCartButton.isHidden = true
                    orderDetailsCell.orderCostLabel.isHidden = true
                } else if (orderItems["productType"] as! String == "LOYALTY_REWARD") {
                    orderDetailsCell.addToCartButton.isEnabled = false
                    orderDetailsCell.addToCartButton.alpha = 0.25
                } else{
                    orderDetailsCell.addToCartButton.isEnabled = true
                    orderDetailsCell.addToCartButton.alpha = 1
                    orderDetailsCell.addToCartButton.isHidden = false
                    orderDetailsCell.orderCostLabel.isHidden = false
                }
            }
            orderDetailsCell.addToCartButton.tag = indexPath.row
            cell = orderDetailsCell
            
        }
        else if indexPath.section == 4 {
            cellReuseIdentifier = "totalItemsTableviewCell"
            let totalOrderCell : WSTotalOrderItemsTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! WSTotalOrderItemsTableViewCell
            totalOrderCell.translateUI()
            
            cell = totalOrderCell
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
        
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight : CGFloat = 0.0
        if indexPath.section == 0 {
            cellHeight = 572.0
        }
        else if indexPath.section == 1 {
            cellHeight = 126.0
            
        }
        else if indexPath.section == 2 {
            cellHeight = 169.0
            
        }
        else if indexPath.section == 3 {
            cellHeight = 230
            
        }
        else if indexPath.section == 4 {
            cellHeight = 169.0
            
        }
        return cellHeight
    }
    
    func didSelectItem(){
        reOrderToCart()
    }
    
    func reOrderToCart() {
        
        //var products = ""
        var productListArray = [[String: Any]]()
        for index in 1...self.orderLineItemsArray.count {
            let reOrderArr = self.orderLineItemsArray[index-1]
          
          if let productType = reOrderArr["productType"] as? String {
            
            if (productType  == "PROMOTION_REWARD" || productType == "LOYALTY_REWARD") {
              continue
            }
          }
          
       /*
      if (reOrderArr["productType"] as! String)  == "PROMOTION_REWARD" || reOrderArr["productType"] as! String == "LOYALTY_REWARD" {
                continue
            }
          */
          
            var productDict = [String: Any]()
            
            var billingAddressDictionary = [String: Any]()
            billingAddressDictionary = reOrderArr
          //  print(billingAddressDictionary)
          
          if  let product = billingAddressDictionary["product"] as? [String:Any]{
            productDict["code"] =  product["code"]
          }else if let productCode = billingAddressDictionary["eanCode"] as? String{
            productDict["code"] = productCode
          }
          
           // let productId = billingAddressDictionary["eanCode"] as! String
            let qty = billingAddressDictionary["quantity"]
            
            //productDict["code"] = productId
            productDict["qty"] = qty
            productListArray.append(productDict)
            print(productDict)
            
//            let pkgType = billingAddressDictionary["packagingType"]
//            products = products + "\(productId)-\(String(describing: pkgType!)):\(String(describing: qty!)):"
//            
//            productCodeWithQuantity = products
//            print(products)
        }
        let dict = ["productList": productListArray]
        let productRequestDict = ["cartId":UFSHybrisUtility.uniqueCartId,"entries":dict] as [String : Any]
        print(productRequestDict)
        reOrderAPICall(requestDict: productRequestDict)
        
   
    }
    
    func reOrderAPICall(requestDict:[String : Any])  {
        
        let webServiceBusinessLayer = WSWebServiceBusinessLayer()
        UFSProgressView.showWaitingDialog("")
        let cartId = UFSHybrisUtility.uniqueCartId
        webServiceBusinessLayer.reOrderToCart(product: "", cart_id: cartId, products: requestDict, successResponse: {(response) in
            if let dict1 = response as? [String:Any]{
                
                if let items = dict1["cartModifications"] as? [[String:Any]]{
                    if items.count <= 0  {
                        UFSProgressView.stopWaitingDialog()
                        return
                    }
                    var statusMessageBool = true
                    for value in items {
                        if let statusMessage = value["statusMessage"] {
                            if (statusMessage as! String).range(of: "excluded product for the customer Id") != nil {
                                statusMessageBool = false
                            } else {
                                statusMessageBool = true
                                return
                            }
                        } else {
                            statusMessageBool = true
                        }
                    }
                    let tmpDict = items[0]
                    if statusMessageBool == false {
                        if let statusCode = tmpDict["statusCode"] as? String, statusCode == "406"{
                            WSUtility.showAlertWith(message: WSUtility.getlocalizedString(key: "The product is currently not available.", lang: WSUtility.getLanguage(), table: "Localizable")!, title: "", forController: self)
                            UFSProgressView.stopWaitingDialog()
                        }
                    } else {
                        UFSProgressView.stopWaitingDialog()
                    }
                    self.retriveCurrentCart()
                }
            }
        }) {(errorMessage) in
            UFSProgressView.stopWaitingDialog()
            //            WSUtility.showAlertWith(message: WSUtility.getlocalizedString(key: "The product is currently not available.", lang: WSUtility.getLanguage(), table: "Localizable")!, title: "", forController: self)
        }
    }
    
    func retriveCurrentCart(){
        let addToCartBussinessLogic = WSAddToCartBussinessLogic()
        addToCartBussinessLogic.getCartDetail(forController: self)
    }
    
 
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func checkExcludedProductsFoundOrNotForDTO(productDict: [String: Any])->Bool{
        // For DTO User
        if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
            let excludedProducts:[String] = UserDefaults.standard.value(forKey: "ExcludedProducts") as! [String]
            //print(excludedProducts)
            if let value = productDict["productNumber"] as? String{
                let foundExcludedProducts = excludedProducts.filter() { $0 == value }
                //print(foundExcludedProducts)
                if foundExcludedProducts.count > 0{
//                    self.showNotifyMessage(WSUtility.getlocalizedString(key: "The product is currently not available.", lang: WSUtility.getLanguage(), table: "Localizable"))
                    return true
                }
                return false
            }
        }
        return false
    }
  
  
  func addToCartAction(eanCode:String,orderDetailDict:[String:Any])  {
    
      //let packingType =  (orderDetailDict["packagingType"] as? String)  == "CU" ? "cu":"du"
      let qty = orderDetailDict["quantity"]
      
      let productDict = ["code": eanCode, "qty": qty!] as [String : Any]
      var productListArray = [[String: Any]]()
      productListArray.append(productDict)
      let dict = ["productList": productListArray]
      let productRequestDict = ["cartId":UFSHybrisUtility.uniqueCartId,"entries":dict] as [String : Any]
      print(productRequestDict)
      
      //let finalProductString = "\(productEanCode)-\(packingType):\(qty!)"
      
      reOrderAPICall(requestDict: productRequestDict)
  }
  
}

extension HYBOrderHistoryDetailViewController:WSOrderDetailsTableViewCellDelegate {
    func addToCartButtonTapped(index: Int) {
        
        let orderDetailDict = orderLineItemsArray[index]
        
    if self.checkExcludedProductsFoundOrNotForDTO(productDict: orderDetailDict){
        WSUtility.showAlertWith(message: WSUtility.getlocalizedString(key: "The product is currently not available.", lang: WSUtility.getLanguage(), table: "Localizable")!, title: "", forController: self)
        return
    }
      
      
      if  let product = orderDetailDict["product"] as? [String:Any]{
        addToCartAction(eanCode: product["code"] as! String, orderDetailDict: orderDetailDict)
      }else if let productCode = orderDetailDict["eanCode"] as? String{
       addToCartAction(eanCode: productCode, orderDetailDict: orderDetailDict)
      }
      
    
    }
}

