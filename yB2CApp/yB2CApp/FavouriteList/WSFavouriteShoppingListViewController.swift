//
//  WSFavouriteShoppingListViewController.swift
//  yB2CApp
//
//  Created by Ramakrishna on 11/26/17.
//

import UIKit
protocol WSFavouriteShoppingListViewDelegate {
  func showHideNoFavouriteView(showHide: Bool)
  func addToCartMethod(productCode:String, quantity:String)
}
class WSFavouriteShoppingListViewController: UIViewController, NoInternetDelegate, NetworkStatusDelegate {
  
  //var product : [HYBProduct] = []
  //var backendService:HYBB2CService = (UIApplication.shared.delegate as! HYBAppDelegate).backEndService
  var webServiceBusinessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
  var delegate :WSFavouriteShoppingListViewDelegate?
  var sortedArray: [[String: Any]] = []
  var OriginalFavouriteArray:[[String:Any]] = []
  var noInternetView:UFSNoInternetView?
  var networkStatus = UFSNetworkReachablityHandler.shared
    var selectedUnit = ""
    
  @IBOutlet weak var bottomViewPlaceOrder: UIView!
  @IBOutlet weak var totalProductsLabel: UILabel!
  @IBOutlet weak var sortByButton: UIButton!
  @IBOutlet weak var shoppingListTableView: UITableView!
  @IBOutlet weak var sortLabelText: UILabel!
  var sortIndex: Int = 0
    var isPersonalizePriceEnable = false
    var numberOfTimeRetriveSifuToken = 2
  var activeField:UITextField?
  @IBOutlet weak var filterViewConstraintH: NSLayoutConstraint!
  override func viewDidLoad() {
    super.viewDidLoad()
    //networkStatus.startNetworkReachabilityObserver()
    shoppingListTableView.tableFooterView = UIView(frame: CGRect.zero)
    
    if WSUtility.isLoginWithTurkey(){
        filterViewConstraintH.constant = 0
    }
    else{
        filterViewConstraintH.constant = 70
    }
    
    UFSGATracker.trackScreenViews(withScreenName: "Shopping List Screen")
    FireBaseTracker.ScreenNaming(screenName: "Shopping List Screen", ScreenClass: String(describing: self))
    FBSDKAppEvents.logEvent("Shopping Listing Screen")
    
    // Do any additional setup after loading the view.
    
    registerForKeyboardNotifications()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // WSUtility.setCartBadgeCount(ViewController: self)
    
    UITtitle()
    networkStatus.startNetworkReachabilityObserver()
    networkStatus.delegate = self
    networkCheckAndApiCall()

    
  }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.trackingScreens(screenName: "Shopping Listing Screen")
        isPersonalizePriceEnable = false
        if WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
            isPersonalizePriceEnable = true
        }
        
        
    }
  override func viewWillDisappear(_ animated: Bool) {
    WSUtility.removeNoNetworkView(internetView: &noInternetView)
    
   
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
  @IBAction func rightBarButtonPressed(_ sender: UIButton)  {
    WSUtility.cartButtonPressed(viewController: self)
  }
  func UITtitle() {
    sortByButton.setTitle(WSUtility.getlocalizedString(key: "Sort by", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    sortLabelText.text = WSUtility.getlocalizedString(key: "Recent orders", lang: WSUtility.getLanguage(), table: "Localizable")!
  }
  
  func registerForKeyboardNotifications() {
    
    NotificationCenter.default.addObserver(self, selector:#selector(keyboardWasShown), name:
      NSNotification.Name.UIKeyboardDidShow, object: nil)
    
    NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillBeHidden), name:
      NSNotification.Name.UIKeyboardWillHide, object: nil)
    
  }
  
  func getFavouriteList() {
    UFSProgressView.showWaitingDialog("")
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.makeFavouriteListRequest(methodName: Favourites_List_API, successResponse: { (response) in
      WSUtility.removeProductCode()
      UFSProgressView.stopWaitingDialog()
      let modifiedResults : [[String :Any]] = response.map { dictionary in
        print("response as dictionary is \(dictionary)")
        var dict = dictionary
        dict["qunatiy"] = 1
        dict["modified_product_code"] = "cu-du"
        
        let productDict = dict ["product"] as! [String: Any]
        
        let add = dict ["automaticallyAdded"] as! Bool
        if !add{//Don't convert ordered products into favourites
          let productNumber =  productDict["productNumber"] as! String
          WSUtility.setProductCode(productNumber: productNumber)
        }
        /*
         if let price = productDict["cuPriceInCents"] as? Int {
         //priceLabel.text = "€ \(price) *"
         
         if price == 0 {
         dict["modified_product_code"] = productCode+"-du"
         }
         else {
         dict["modified_product_code"] = productCode+"-cu"
         }
         }
         
         */
        
        print("defaultPackagingType in shoppig page \(String(describing: productDict["defaultPackagingType"] as? String))")
        if let productPackagingType = productDict["defaultPackagingType"] as? String{
          /*
           if productPackagingType == "ONLYDU"{
           dict["modified_product_code"] = productCode+"-du"
           }else{
           dict["modified_product_code"] = productCode+"-cu"
           }
           */
          let productCode =  productDict["productCode"] as! String
          
          dict["modified_product_code"] = productCode+"-du"
          
        }
        return dict
      }
      UFSProgressView.stopWaitingDialog()
      self.sortedArray = modifiedResults
      self.OriginalFavouriteArray.removeAll()
      self.OriginalFavouriteArray.append(contentsOf: self.sortedArray)
      if self.sortedArray.count == 0{
        self.delegate?.showHideNoFavouriteView(showHide: false)
      }else{
        self.delegate?.showHideNoFavouriteView(showHide: true)
      }
      
      self.totalProductsLabel.text = "(\(self.sortedArray.count) \(WSUtility.getlocalizedString(key: "Products", lang: WSUtility.getLanguage(), table: "Localizable")!))"
      self.shoppingListTableView.reloadData()
    }) { (errorMessage) in
      
      if errorMessage == "Session_Token_Expire" && self.numberOfTimeRetriveSifuToken > 0 {
        print("session token expired in homescreen")
        self.numberOfTimeRetriveSifuToken -= 1
        self.getSifuAccessToken()
        
      }else{
        self.delegate?.showHideNoFavouriteView(showHide: false)
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
      self.getFavouriteList()
      
      
    }) { (errorMessage) in
      
    }
  }
  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if segue.identifier == "sortVC"{
      let sorbyVC = segue.destination as! SortByViewController
      sorbyVC.delegate = self
      sorbyVC.selectedIndex = sortIndex
    }else if segue.destination is WSProductDetailViewController{
      let productVC = segue.destination as? WSProductDetailViewController
      let productCode = (sender as? String)!
      productVC?.productCode = productCode
    }
  }
  func checkExcludedProductsFoundOrNotForDTO(productDict: [String: Any])->Bool{
    let excludedProducts:[String] = UserDefaults.standard.value(forKey: "ExcludedProducts") as! [String]
    //print(excludedProducts)
    if let value = productDict["productNumber"] as? String{
      let foundExcludedProducts = excludedProducts.filter() { $0 == value }
      //print(foundExcludedProducts)
      if foundExcludedProducts.count > 0{

        WSUtility.showAlertWith(message: WSUtility.getlocalizedString(key: "The product is currently not available.", lang: WSUtility.getLanguage(), table: "Localizable")!, title: "", forController: self)
        UFSProgressView.stopWaitingDialog()

//        self.showNotifyMessage(WSUtility.getlocalizedString(key: "The product is currently not available.", lang: WSUtility.getLanguage(), table: "Localizable"))
        return true
      }
      return false
    }
    return false
  }
  func addtoCartPressed (sender: UIButton) {
    let selectedIndex = sender.tag
    // DDLogDebug("Add to cart pressed at row %ld", Int(selectedIndex))
    let indexPath = IndexPath(row: selectedIndex, section: 0)
    let cell = shoppingListTableView.cellForRow(at: indexPath) as? WSShoppingListTableViewCell
    addProductToCart(from: cell!, selectedIndex: selectedIndex)
  }
  
  
  func addProductToCart(from cell: WSShoppingListTableViewCell, selectedIndex: Int) {
    
    let product = self.sortedArray[selectedIndex]
    let productDict = product ["product"] as! [String: Any]
//    var productCode =  product["modified_product_code"] as! String
//   productCode = productCode.replacingOccurrences(of: "du", with: selectedUnit)
    
    var quantiyValue = "1"
    if let quantity = cell.quantityTextField.text{
      quantiyValue = quantity
    }
    
    // For DTO User
    if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
      if let tmpDict = product ["product"] as? [String: Any]{
        if self.checkExcludedProductsFoundOrNotForDTO(productDict: tmpDict){
          return
        }
      }
    }
    var productCode = ""
    if cell.selectedVariantType == "cu" {
       productCode  = productDict["cuEanCode"] as! String
    } else {
        productCode = productDict["duEanCode"] as! String
    }
    
    delegate?.addToCartMethod(productCode: productCode, quantity: quantiyValue)
    
  }
  
  func retriveCurrentCart(){
    /*
    let backendService:HYBB2CService = (UIApplication.shared.delegate as! HYBAppDelegate).backEndService
    backendService.getCartsForUserId(backendService.userId, withParams: nil, andExecute: {(_ response, _ error) in
      
      if response == nil {
        self.showNotifyMessage((error)?.localizedDescription)
      }else{
        let arr: [Any] = response as! [Any]
        let cart: HYBCart? = arr[0] as? HYBCart
        backendService.saveCart(inCacheNotifyObservers: cart)
        UFSProgressView.stopWaitingDialog()
        self.showNotifyMessage(WSUtility.getlocalizedString(key: "Added to cart", lang: WSUtility.getLanguage(), table: "Localizable"))
      }
    })
    UFSProgressView.stopWaitingDialog()
 */
    
    let addToCartBussinessLogic = WSAddToCartBussinessLogic()
    addToCartBussinessLogic.getCartDetail(forController: self)
  }
  
  func deleteProductFromSifu(productNumber:String, forIndex index:Int)  {
    
    if activeField != nil{
      activeField?.resignFirstResponder()
    }
    
    UFSProgressView.showWaitingDialog("")
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.deleteFavoriteProductFromSifu(productNumber: productNumber, successResponse: { (response) in
      UFSProgressView.stopWaitingDialog()
      self.sortedArray.remove(at: index)
      WSUtility.removeFavoriteItem(item: productNumber)
      if self.sortedArray.count == 0{
        self.delegate?.showHideNoFavouriteView(showHide: false)
      }
      
      self.totalProductsLabel.text = "(\(self.sortedArray.count) \(WSUtility.getlocalizedString(key: "Products", lang: WSUtility.getLanguage(), table: "Localizable")!))"
      
      self.shoppingListTableView.reloadData()
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
    }
    
  }
  
    func SelectedUnitInShoppingList(Unit: String) {
        selectedUnit = Unit
    }
  
  func keyboardWasShown(aNotification: NSNotification) {
    
    if activeField == nil{
      return
    }
    
    let info = aNotification.userInfo as! [String: AnyObject],
    kbSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size,
    contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
    
    shoppingListTableView.contentInset = contentInsets
    shoppingListTableView.scrollIndicatorInsets = contentInsets
    
    var aRect = self.view.frame
    aRect.size.height -= kbSize.height
    
    let pointInTable = activeField!.superview!.convert(activeField!.frame.origin, to: shoppingListTableView)
    let rectInTable = activeField!.superview!.convert(activeField!.frame, to: shoppingListTableView)
    
    if !aRect.contains(pointInTable) {
      shoppingListTableView.scrollRectToVisible(rectInTable, animated: true)
    }
  }
  
  func keyboardWillBeHidden(aNotification: NSNotification) {
    //UIEdgeInsetsZero is used in view without tabBar
    //let contentInsets = UIEdgeInsetsZero
    let tabBarHeight = 44 //self.tabBarController!.tabBar.frame.height
    let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: CGFloat(tabBarHeight), right: 0)
    shoppingListTableView.contentInset = contentInsets
    shoppingListTableView.scrollIndicatorInsets = contentInsets
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
    self.getFavouriteList()
    WSUtility.removeNoNetworkView(internetView: &noInternetView)
    self.shoppingListTableView.reloadData()
  }
  
  func NonReachableNetwork() {
    if noInternetView == nil {
      WSUtility.loadNoInternetView(internetView: &noInternetView, controllerView: self)
    }
  }
  
}

extension WSFavouriteShoppingListViewController: UITableViewDataSource,UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sortedArray.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: WSShoppingListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WSShoppingListTableViewCell
    
    cell.btnCU.tag = indexPath.row
    cell.btnDU.tag = indexPath.row
    cell.plusButton.tag = indexPath.row
    cell.minusButton.tag = indexPath.row
    cell.addToCartButton.tag = indexPath.row
    cell.transparentButtonName.tag = indexPath.row
    cell.transparentButtonOnImageView.tag = indexPath.row
    cell.removeButton.tag = indexPath.row
  
    
    cell.addToCartButton.addTarget(self, action: #selector(addtoCartPressed), for: .touchUpInside)
    cell.delegate = self
    cell.favoriteIcon.tag = indexPath.row
    cell.quantityTextField.tag = indexPath.row
    cell.quantityTextField.delegate = self
    cell.quantityTextField.addDoneButtonToKeyboard(myAction:  #selector(cell.quantityTextField.resignFirstResponder))
    cell.setUI(dict: sortedArray[indexPath.row])
    cell.setPersonlizePriceUI(isenable: isPersonalizePriceEnable)
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}
extension WSFavouriteShoppingListViewController: sortByViewControllerDelegate{
  func sortByName(type: String, selectedRow: Int) {
    sortLabelText.text = type
    sortIndex = selectedRow
    self.sortedArray .removeAll()
    self.sortedArray.append(contentsOf: self.OriginalFavouriteArray)
    
    if selectedRow == 0 {
      //recent orders
      let tmpArray = self.sortedArray.sorted{ ($0["lastOrderedAt"] as! Int) > ($1["lastOrderedAt"] as! Int) }
      self.sortedArray = tmpArray
    }
    else if selectedRow == 1{
      let tmpArray = self.sortedArray.sorted{ ($0["orderCount"] as! Int) > ($1["orderCount"] as! Int) }
      self.sortedArray = tmpArray
    }
    else if selectedRow == 2{
      var favArray: [[String: Any]] = []
      var tempArray:[[String: Any]] = []
      for dict in self.sortedArray{
        
        if dict["lastOrderedAt"] as! Int == 0 && dict["orderCount"]as! Int == 0 {
          favArray.append(dict)
        }
        else {
          tempArray.append(dict)
        }
        
      }
      sortedArray.removeAll()
      sortedArray += favArray
      sortedArray += tempArray
    }
    shoppingListTableView.reloadData()
  }
}
extension WSFavouriteShoppingListViewController: WSShoppingListTableViewCellDelegate{
  
  func updateQuantityLabelText(value: Int, row: Int) {
    
    // adding quantity for each product
    var dict = sortedArray[row]
    dict["qunatiy"] = value
    sortedArray[row] = dict
    let dict1 = dict ["product"] as! [String: Any]
    let path = IndexPath(row: row, section: 0)
    if let cell: WSShoppingListTableViewCell = shoppingListTableView.cellForRow(at: path) as? WSShoppingListTableViewCell{
    cell.quantityTextField.text = "\(value)"
    if value == 1{
        if let price = dict1["cuPriceInCents"] as? Double {
            
            // let price = dict1["duPriceInCents"] as! Double
            let priceInDouble = (Double(Double(price)/100) * Double(dict["qunatiy"] as! Int))
            var strPrice = "\(priceInDouble)"
            strPrice = strPrice.replacingOccurrences(of: ".", with: ",")
            
//            if !WSUtility.isLoginWithTurkey(){
//                cell.CUPriceLabel.text = "€ \(strPrice) *"
//            }
//            else{
//                cell.CUPriceLabel.text = "\(strPrice) ₺ *"
//            }
            
            let countryCode =  WSUtility.getCountryCode()
            
            if countryCode == "TR" {
                cell.CUPriceLabel.text = "\(strPrice) ₺ *"
            }
            else if countryCode == "CH" {
                cell.CUPriceLabel.text = "CHF \(strPrice) *"
            }
            else {
                cell.CUPriceLabel.text = "€ \(strPrice) *"
            }
        }
        if let price = dict1["duPriceInCents"] as? Double {
            
            // let price = dict1["duPriceInCents"] as! Double
            let priceInDouble = (Double(Double(price)/100) * Double(dict["qunatiy"] as! Int))
            var strPrice = "\(priceInDouble)"
            strPrice = strPrice.replacingOccurrences(of: ".", with: ",")
            
//            if !WSUtility.isLoginWithTurkey(){
//                cell.DUPriceLabel.text = "€ \(strPrice) *"
//            }
//            else{
//                cell.DUPriceLabel.text = "\(strPrice) ₺ *"
//            }
            let countryCode =  WSUtility.getCountryCode()
            
            if countryCode == "TR" {
                cell.DUPriceLabel.text = "\(strPrice) ₺ *"
            }
            else if countryCode == "CH" {
                cell.DUPriceLabel.text = "CHF \(strPrice) *"
            }
            else {
                cell.DUPriceLabel.text = "€ \(strPrice) *"
            }
        }

    }
    else{
        if cell.selectedVariantType == "cu"{
            if let price = dict1["cuPriceInCents"] as? Double {
                
                // let price = dict1["duPriceInCents"] as! Double
                let priceInDouble = (Double(Double(price)/100) * Double(dict["qunatiy"] as! Int))
                var strPrice = "\(priceInDouble)"
                strPrice = strPrice.replacingOccurrences(of: ".", with: ",")
                
//                if !WSUtility.isLoginWithTurkey(){
//                    cell.CUPriceLabel.text = "€ \(strPrice) *"
//                }
//                else{
//                    cell.CUPriceLabel.text = "\(strPrice) ₺ *"
//                }
                let countryCode =  WSUtility.getCountryCode()
                
                if countryCode == "TR" {
                    cell.CUPriceLabel.text = "\(strPrice) ₺ *"
                }
                else if countryCode == "CH" {
                    cell.CUPriceLabel.text = "CHF \(strPrice) *"
                }
                else {
                    cell.CUPriceLabel.text = "€ \(strPrice) *"
                }
            }
        }
        else{
            if let price = dict1["duPriceInCents"] as? Double {
                
                // let price = dict1["duPriceInCents"] as! Double
                let priceInDouble = (Double(Double(price)/100) * Double(dict["qunatiy"] as! Int))
                var strPrice = "\(priceInDouble)"
                strPrice = strPrice.replacingOccurrences(of: ".", with: ",")
            
                let countryCode =  WSUtility.getCountryCode()
                
                if countryCode == "TR" {
                    cell.DUPriceLabel.text = "\(strPrice) ₺ *"
                }
                else if countryCode == "CH" {
                    cell.DUPriceLabel.text = "CHF \(strPrice) *"
                }
                else {
                    cell.DUPriceLabel.text = "€ \(strPrice) *"
                }
            }
        }
        
    }
    }
    
    /*
     let price = dict1["cuPriceInCents"] as! Double
     if price == 0 {
     let price = dict1["duPriceInCents"] as! Double
     let priceInDouble = (Double(Double(price)/100) * Double(dict["qunatiy"] as! Int))
     var strPrice = "\(priceInDouble)"
     strPrice = strPrice.replacingOccurrences(of: ".", with: ",")
     
     let countryCode =  WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "CountryCode"))
     if countryCode == "AT" {
     cell.priceLabel.text = "€ \(strPrice) *"
     //priceLabel.text = "€ \(String(format: "%d", (dict["qunatiy"] as! Int * priceInDouble))) *"
     
     }
     
     }
     else {
     
     let price = dict1["cuPriceInCents"] as! Double
     let priceInDouble = (Double(Double(price)/100) * Double(dict["qunatiy"] as! Int))
     var strPrice = "\(priceInDouble)"
     strPrice = strPrice.replacingOccurrences(of: ".", with: ",")
     
     let countryCode =  WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "CountryCode"))
     if countryCode == "AT" {
     cell.priceLabel.text = "€ \(strPrice) *"
     //priceLabel.text = "€ \(String(format: ".2%d", strPrice) *"
     
     }
     }
     */
    
    
  }
  
  func deleteFavoriteProduct(senderTag: Int) {
    var product = sortedArray[senderTag]
    let productDict = product ["product"] as! [String: Any]
    deleteProductFromSifu(productNumber: productDict["productNumber"] as! String, forIndex: senderTag)
  }
  
  func didSelectOnCell(senderTag: Int) {
    let product = self.sortedArray[senderTag]
    let productDict = product ["product"] as! [String: Any]
    self.performSegue(withIdentifier: "ProductDetailSegue", sender: productDict["productNumber"])
  }
}

extension WSFavouriteShoppingListViewController:UITextFieldDelegate{
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    activeField  = textField
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    var quantity = 1
    if let quantityValue = textField.text, textField.text != "0"{
      if quantityValue.count > 0{
        quantity = Int(quantityValue)!
      }
      
    }
    
    updateQuantityLabelText(value: quantity, row: textField.tag)
    
    activeField = nil
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
    if string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil {
        if string == ""{
            return true
        }
        let num = Int(textField.text!+string)
        if textField.text?.count == 0 || textField.text == "" {
            if string == "" || string == "0"{
                textField.text = "1"
                return false
            }
        }
        else if num! > 1000 {
            return false
        }
        return true

    }
    else{
        return false
    }
    
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}

extension UITextField{
  
  func addDoneButtonToKeyboard(myAction:Selector?){
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    doneToolbar.barStyle = UIBarStyle.default
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: myAction)
    
    var items = [UIBarButtonItem]()
    items.append(flexSpace)
    items.append(done)
    
    doneToolbar.items = items
    doneToolbar.sizeToFit()
    
    self.inputAccessoryView = doneToolbar
  }
  func resignKeyboardInScanViewController(){
    self.resignFirstResponder()
  }
  
}

extension WSFavouriteShoppingListViewController: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
