//
//  AllProductsViewController.swift
//  yB2CApp
//
//  Created by Anandita on 11/29/17.
//

import UIKit

@objc class AllProductsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
  
  @objc enum ProductListOpenedFor:Int {
    case SUBCATEGORY_PRODUCT
    case ALL_PRODUCT
    case DOUBLE_LOYALTY_PRODUCT
  }
  
  var enableRecommendedProduct = false
  @IBOutlet weak var allProductsLabel: UILabel!
  @IBOutlet weak var filterButton: UIButton!{
    didSet{
      filterButton.layer.cornerRadius = 5.0
      filterButton.layer.borderWidth = 1.0
      filterButton.layer.borderColor = UIColor(red:1.00, green:0.35, blue:0.00, alpha:1.0).cgColor
    }
  }
  @IBOutlet weak var filterSectionHeaderView: UIView!
  @IBOutlet weak var sectionBottomSepratorView: UIView!
  @IBOutlet weak var productListTableView: UITableView!
  @IBOutlet weak var allProducts_label: UILabel!
  
  var productsListArray: [[String: Any]] = []
  var selectedSubCategoryDict: [String: Any] = [:]
  var filterDict: [String: Any] = [:]
  var recommededProductList = [[String:Any]]()
  var productListScreenOpenedBy = ProductListOpenedFor.SUBCATEGORY_PRODUCT
  
  var loadMoreCellHeight = 0
  let TaxNumberViewHeight = 75
  var currentPage = 0
  var isNavigatingToOtherScreen = false
  
  var selectedCellArray = [String]()
  var subCategoryID = ""
  var isFilterOptionSelected = false
  var selectedCellIndex = Int()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UISetUP()
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    
    serviceBussinessLayer.trackingScreens(screenName: "Product Listing Screen")
    UFSGATracker.trackScreenViews(withScreenName: "Product Listing Screen")
    FireBaseTracker.ScreenNaming(screenName: "Product Listing Screen", ScreenClass: String(describing: self))
    FBSDKAppEvents.logEvent("Product Listing Screen")
    
    
    productListTableView.register(UINib(nibName: "ChangeTPTableViewCell", bundle: nil), forCellReuseIdentifier: "ChangeTPTableViewCell")
    //allProductsLabel.text = WSUtility.getlocalizedString(key: "All products", lang: WSUtility.getLanguage(), table: "Localizable")
    filterButton.setTitle(WSUtility.getlocalizedString(key: "Filter", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
  }
  func UISetUP()  {
    WSUtility.addNavigationBarBackButton(controller: self)
    WSUtility.addNavigationRightBarButton(toViewController: self)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
  
    WSUtility.setCartBadgeCount(ViewController: self)
    if isNavigatingToOtherScreen == false {
      productAPICallForSelectedType(loadMoreCell: nil)
    }
    
    if recommededProductList.count == 0{
      getRecommendedProductListFromSifu()
    }
    enableRecommendedProduct = false
    if WSUtility.isFeatureEnabled(feature: featureId.Recommended_Product.rawValue) {
        enableRecommendedProduct = true
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    
    if !WSUtility.isTaxNumberAvailable(VCview: self.view){
      WSUtility.addTaxNumberView(viewController: self)
    } else if let view = self.view.viewWithTag(9006){
      view.removeFromSuperview()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    isNavigatingToOtherScreen = true
  }
    func btnTaxTapped(sender:UIButton)  {
      self.performSegue(withIdentifier: "ShowTaxNumberPopUp", sender: self)
    }
  
  
  func getRecommendedProductDetailForTurkey(productCode:String)  {
    let getProductDetail:WSGetProductsFromCode = WSGetProductsFromCode()
    getProductDetail.getProductDetail(codes: productCode, successResponse: { (response) in
      UFSProgressView.stopWaitingDialog()
      self.recommededProductList = response
      self.productListTableView.reloadData()
    }) { (errorMessage) in
      print("error in getting recommended product detail")
    }
  }
  
    func getRecommendedProductListFromSifu() {
        
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.getRecommendedProductEANCodesRequest(successResponse: { (response) in
            
            if response.count > 0{
                UFSProgressView.showWaitingDialog("")
              if WSUtility.isLoginWithTurkey(){
                let recommendedProductCodes = response.map({$0["product_code"] as! String})
                let recommededProductCodeStr = recommendedProductCodes.joined(separator: ",")
                self.getRecommendedProductDetailForTurkey(productCode: recommededProductCodeStr)
                
              }else{
                
                let recommendedEanCodes = response.map({$0["recommendation"] as! String})
                let recommededEanStr = recommendedEanCodes.joined(separator: ",")
                serviceBussinessLayer.getRecommendedProductsFromEANCodesRequest(eanString: recommededEanStr, successResponse: { (response) in
                  
                  UFSProgressView.stopWaitingDialog()
                  self.recommededProductList = response
                  self.productListTableView.reloadData()
                }, faliureResponse: { (errorMessage) in
                  UFSProgressView.stopWaitingDialog()
                })
              }
            }
            else{
                self.getRecommendedProductListFromAdmin()
            }
        }) { (errorMessage) in
            self.getRecommendedProductListFromAdmin()
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
               }else{
              
                let recommendedEanCodes = response.map({$0["product_cu_ean_code"] as! String})
                let recommededEanStr = recommendedEanCodes.joined(separator: ",")
                UFSProgressView.showWaitingDialog("")
                businessLayer.getRecommendedProductsFromEANCodesRequest(eanString: recommededEanStr, successResponse: { (response) in
                    
                    UFSProgressView.stopWaitingDialog()
                    self.recommededProductList = response
                    self.productListTableView.reloadData()
                }, faliureResponse: { (errorMessage) in
                    UFSProgressView.stopWaitingDialog()
                })
            }
          }
            
        }) { (error) in
            print(error)
        }
    }
  
  func productAPICallForSelectedType(loadMoreCell:WSLoadMoreTableViewCell?)  {
    
    var queryString = ""
    
    switch productListScreenOpenedBy {
    case .SUBCATEGORY_PRODUCT:
      
      if let subCategoryID = selectedSubCategoryDict["id"] as? String {
        
        if filterDict.keys.count > 0{
          if let queryKey_str = filterDict["query"] as? String{
            if queryKey_str.count > 0 {
              queryString = queryKey_str
            }
          }
        }
        else{
          self.subCategoryID = subCategoryID
            
            if let subCategoryID = selectedSubCategoryDict["url"] as? String {
                let tmpArray = subCategoryID.components(separatedBy: "/")
                if tmpArray.count > 0{
                    queryString  = ":category:\(tmpArray[tmpArray.count - 1])"
                }
            }
        }
        getProductsFromSubCategory(queryStr: queryString, loadMoreCell: nil)
      }
      allProductsLabel.text = selectedSubCategoryDict["name"] as? String
    case .ALL_PRODUCT :
      if filterDict.keys.count > 0{
        if let queryKey_str = filterDict["query"] as? String{
          if queryKey_str.count > 0 {
            queryString = queryKey_str
          }
        }
      }
      else{
        queryString = ""
      }
      
      getProductListFromHybris(queryStr: queryString, loadMoreCell: nil)
      allProductsLabel.text = WSUtility.getTranslatedString(forString: "All products")
    case .DOUBLE_LOYALTY_PRODUCT :
      queryString = ":doubleLoyalty:true"
      allProductsLabel.text = WSUtility.getTranslatedString(forString: "All products")
      getProductListFromHybris(queryStr: queryString, loadMoreCell: loadMoreCell)
      //getDoubleProductListFromHybris(queryStr: queryString, loadMoreCell: nil)
    }
    
  }
  
  func getProductListFromHybris(queryStr:String,loadMoreCell:WSLoadMoreTableViewCell?)  {
    let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    businessLayer.getProductListFromHybris(queryWithID: queryStr, pageNumber: "\(currentPage)", successResponse: { (response) in
      
      if self.currentPage == 0{
        UFSProgressView.showWaitingDialog("")
      }
      
      let productsText = WSUtility.getlocalizedString(key: "Products", lang: WSUtility.getLanguage(), table: "Localizable")!
      
      if let array = response["products"] {
        if self.currentPage == 0{
          self.productsListArray = array as! [[String : Any]]
        }else{
          let newArray = array as! [[String : Any]]
          self.productsListArray.append(contentsOf: newArray)
        }
        
        //self.allProducts_label.text = "(\(self.productsListArray.count) \(productsText))"
        self.currentPage += 1
      }
      
      if let paginationDict = response["pagination"] as? [String:Any] {
        
        if let totalProductCount = paginationDict["totalResults"] as? Int{
          self.allProducts_label.text = "(\(totalProductCount) \(productsText))"
          self.loadMoreCellHeight = (self.productsListArray.count >= totalProductCount) ? 0 : 60
        }
      }
      
      loadMoreCell?.activityIndicator.isHidden = true
      loadMoreCell?.loadmoreButton.isHidden = false
      loadMoreCell?.isHidden = false
      
      self.productListTableView.reloadData()
      
      if self.productsListArray.count == 0 {
        self.filterButton.isEnabled = false
        self.filterButton.alpha = 0.6
        self.allProducts_label.text = "(0 \(productsText))"
      }
      else{
        self.filterButton.isEnabled = true
        self.filterButton.alpha = 1.0
      }
      
      UFSProgressView.stopWaitingDialog()
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
    }
    
  }
  
  
  func getProductsFromSubCategory(queryStr: String,loadMoreCell:WSLoadMoreTableViewCell?){
    UFSProgressView.showWaitingDialog("")
    
    let productsText = WSUtility.getlocalizedString(key: "Products", lang: WSUtility.getLanguage(), table: "Localizable")!
    let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    businessLayer.getProductsForSubCategory(queryWithID: queryStr, pageNumber: "\(currentPage)", successResponse: { (response) in
      if let array = response["products"] {
        
        if self.currentPage == 0{
          self.productsListArray = array as! [[String : Any]]
        }else{
          let newArray = array as! [[String : Any]]
          self.productsListArray.append(contentsOf: newArray)
        }
        
        self.currentPage += 1
        
      }else{
        self.productsListArray.removeAll()
        self.currentPage = 0
        
        
      }
      
      if let paginationDict = response["pagination"] as? [String:Any] {
        
        if let totalProductCount = paginationDict["totalResults"] as? Int{
          self.allProducts_label.text = "(\(totalProductCount) \(productsText))"
          self.loadMoreCellHeight = (self.productsListArray.count >= totalProductCount) ? 0 : 60
        }
      }
      loadMoreCell?.activityIndicator.isHidden = true
      loadMoreCell?.loadmoreButton.isHidden = false
      loadMoreCell?.isHidden = false
      
      self.productListTableView.reloadData()
      if self.productsListArray.count == 0 {
        
        if self.isFilterOptionSelected == true{
          self.filterButton.isEnabled = true
          self.filterButton.alpha = 1.0
        }else{
          self.filterButton.isEnabled = false
          self.filterButton.alpha = 0.6
          self.allProducts_label.text = "(0 \(productsText))"
        }
        
      }
      else{
        self.filterButton.isEnabled = true
        self.filterButton.alpha = 1.0
      }
      
      UFSProgressView.stopWaitingDialog()
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
    }
  }
  
  //  func loadProducts() {
  //    backendService.getCategoriesAndExecute({(_ products, _ error) in
  //      if error != nil {
  //        // DDLogError("Problems during the retrieval of the products from the web service: %@", error?.localizedDescription)
  //      }
  //      else {
  //
  //        guard products != nil else{
  //          return
  //        }
  //
  //        print("products : %@",products!)
  //      }
  //    })
  //  }
  
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
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    
    if segue.destination is WSProductDetailViewController{
        
        let productVC = segue.destination as? WSProductDetailViewController
        productVC?.delegate = self
        productVC?.cellIndex = selectedCellIndex
        let productCode = (sender as? String)!
        productVC?.productCode = String(productCode)
        
    }
    else if segue.identifier == "ProductFilterVC"{
      
      let filterVC: WSProductListFilterViewController = segue.destination as! WSProductListFilterViewController
      filterVC.delegate = self
      filterVC.filterDict = filterDict
      filterVC.subCategoryID = subCategoryID
    }
    else if segue.identifier == "TradePartnerList"{
      
      let tpListVC: WSTradePartnerListViewController = segue.destination as! WSTradePartnerListViewController
      tpListVC.delegate = self
        tpListVC.callBack = {
            self.currentPage = 0
            self.viewWillAppear(true)
        }
    }else if segue.destination is WSEnterTaxNumberViewController {
      
       let taxNumberVC: WSEnterTaxNumberViewController = segue.destination as! WSEnterTaxNumberViewController
      taxNumberVC.callBack = {
        if let view = self.view.viewWithTag(9006){
          view.removeFromSuperview()
        }
        self.productAPICallForSelectedType(loadMoreCell: nil)
        
      }
      
    }
    
  }
  
  func addProductToCart(forProduct productCode:String) {
    
    let addToCartBussinessHandler = WSAddToCartBussinessLogic()
    addToCartBussinessHandler.addProductToCart(forProduct: productCode, addedFrom: self)
    
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    if section == 0{
      if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
        return 0
      }
      return 1
    }
    else if section == 1 {
      return productsListArray.count + 1
    }
    return 1
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 1 {
      return 100
    }
    return 0
  }
    
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
    if indexPath.section == 1{
      if indexPath.row == 0{
        return productListScreenOpenedBy == .SUBCATEGORY_PRODUCT ? 0 : (recommededProductList.count > 0 && enableRecommendedProduct == true) ? 480 : 0
        //return 480.0
      }
      return getThehightOfRow(dict: productsListArray[indexPath.row - 1])// difault 350 || 270
        
    }else if indexPath.section == 2 {
        
      var height = 0
      if WSUser().getUserProfile().taxNumber == ""{
         height = TaxNumberViewHeight
      }
      return CGFloat(loadMoreCellHeight + height)
    }
    else{
        
        return 105
    }
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    var cell = UITableViewCell()
    if indexPath.section == 0 {
      let changeTPTableViewCell: ChangeTPTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChangeTPTableViewCell", for: indexPath) as! ChangeTPTableViewCell
      changeTPTableViewCell.setUI()
      changeTPTableViewCell.changeTradePartnerButton.addTarget(self, action: #selector(openChangeTradePartnerVC), for: .touchUpInside)
      cell = changeTPTableViewCell
    }else if indexPath.section == 2{
      
      let loadMoreCell:WSLoadMoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WSLoadMoreTableViewCell") as! WSLoadMoreTableViewCell
      loadMoreCell.setUI()
      loadMoreCell.delegate = self
      cell = loadMoreCell
    }
    else{
      if(indexPath.row == 0){
        let recommendedProdCell:WSRecommendedProdTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WSRecommendedProdTableViewCell", for: indexPath) as! WSRecommendedProdTableViewCell
        recommendedProdCell.delegate = self
        recommendedProdCell.updateSetUI(recommendedProduct: recommededProductList)
        cell = recommendedProdCell
      }
      else{
        let productCell:WSProductListerCell = tableView.dequeueReusableCell(withIdentifier: "WSProductListerCell", for: indexPath) as! WSProductListerCell
        //productCell.unitViewButton(productCell.unitButton)
        productCell.cellIndex = indexPath.row
        let dict = productsListArray[indexPath.row - 1]
        productCell.setUI(dict : dict, selectedCellArray: selectedCellArray)
        if let productCode = dict["number"] as? String{
            let favoriteProductList = WSUtility.getProductCode()
            if favoriteProductList .contains(productCode) {
                print("True for favourit")
                productCell.isProductFavorite(isfavourite: true)
            } else {
                productCell.isProductFavorite(isfavourite: false)
            }
        }
        
        productCell.delegate = self
        cell = productCell
        }
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 1{
      sectionBottomSepratorView.isHidden = productListScreenOpenedBy == .SUBCATEGORY_PRODUCT ? false : true
      return filterSectionHeaderView
    }
    else{
      return UIView(frame: CGRect.zero)
    }
  }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row > 0{
            selectedCellIndex = indexPath.row
            let dict = productsListArray[indexPath.row - 1]
            let productCode = dict["code"]
            self.performSegue(withIdentifier: "ProductDetailVC", sender: productCode)
            
        }
    }
  
    func getThehightOfRow(dict: [String: Any]) -> (CGFloat) {
        
        var caseHightDifault : Bool = false
        var unitHightDifault : Bool = false
        
        if let variants = dict["variantOptions"] as? [[String:Any]]{
            for varaintInfo in variants{
                if varaintInfo["container"] as! String == "Unit"{
                    if let priceInfo = varaintInfo["priceData"] as? [String:Any]{
                        if let priceValue = priceInfo["value"] as? Double{
                            if priceValue == 0{
                                caseHightDifault  = false//270
                            }
                            else{
                                caseHightDifault  = true
                            }
                        }
                    }
                }else if varaintInfo["container"] as! String == "Case" {
                    if let priceInfo = varaintInfo["priceData"] as? [String:Any] {
                        if let priceValue = priceInfo["value"] as? Double{
                            if priceValue == 0{
                                unitHightDifault  = false//270
                            }
                            else{
                                unitHightDifault  = true
                            }
                        }
                    }
                }
            }
        }
        if ( caseHightDifault || unitHightDifault){
            return 350
        }else{
            return 250
        }
 }
  @objc func openChangeTradePartnerVC(sender: UIButton){
    self.performSegue(withIdentifier: "TradePartnerList", sender: self)
  }
}

extension AllProductsViewController:WSRecommendedProdCellDelegate{
  func didSelectRecommendedItem(productNumber: String) {
    self.performSegue(withIdentifier: "ProductDetailVC", sender: productNumber)
  }
}

extension AllProductsViewController:ProductListerCellDeleagte{
  func deleteUnfavouriteProductitem(productNumber: String) {
    
  }
  
  func storeOrDeleteSelectedCellProductNumber(productNumber: String, actionType: Int) {
    if actionType == 1 {
      selectedCellArray.append(productNumber)
    }else{
      if let index = selectedCellArray.index(of: productNumber){
        selectedCellArray.remove(at: index)
      }
      
    }
    
  }
  
  func didselectOnProductCell(productDetail: [String : Any]) {
    
  }
  
  func addToCartFromProductList(productCode: String) {
    let addToCartBussinessHandler = WSAddToCartBussinessLogic()
   // addToCartBussinessHandler.addMultipleOrderToCart(productsArray: [productCode], addedFrom: self)
    addToCartBussinessHandler.addProductToCart(forProduct: productCode, addedFrom: self)
  }
  /*
  func addToCartFromProductList(productCode: [String]) {
    // addProductToCart(forProduct: productCode)
    let addToCartBussinessHandler = WSAddToCartBussinessLogic()
    addToCartBussinessHandler.addMultipleOrderToCart(productsArray: productCode, addedFrom: self)
  }
  */
}

extension AllProductsViewController: WSProductListFilterViewControllerDelegate {
  func sendFilterDict(dict: [String: Any]){
    
    if let selectedKeyWords = dict["selectedKeyWords"] as? [[String :Any]]{
      if selectedKeyWords.count > 0{
        self.isFilterOptionSelected = true
        filterButton.setTitle( WSUtility.getlocalizedString(key: "Filter", lang: WSUtility.getLanguage(), table: "Localizable")! + "(\(selectedKeyWords.count))", for: .normal)
      }
      else{
        self.isFilterOptionSelected = false
        filterButton.setTitle(WSUtility.getlocalizedString(key: "Filter", lang: WSUtility.getLanguage(), table: "Localizable") , for: .normal)
      }
    }
    
    filterDict = dict
    
    if let queryKey_str = dict["query"] as? String{
      var queryString = ""
      currentPage = 0
      if queryKey_str.count > 0 {
        queryString =  queryKey_str
      }
      else{
        if let subCategoryID = selectedSubCategoryDict["id"] as? String {
          queryString  = ":category:\(subCategoryID)"
        }
      }
      getProductsFromSubCategory(queryStr: queryString, loadMoreCell: nil)
    }
    
  }
}
extension AllProductsViewController:WSLoadMoreTableViewCellDelegate{
  
  func loadMoreButtonAction(loadMoreCell: WSLoadMoreTableViewCell) {
    productAPICallForSelectedType(loadMoreCell: loadMoreCell)
  }
}
extension AllProductsViewController: WSTradePartnerListViewControllerDelegate {
  func reloadTPAPI(isDefalut: Bool) {
    
  }
  
  func updateTPName() {
    productListTableView.reloadData()
  }
}

extension AllProductsViewController:ProductDetailDelegate{
    func reloadRow(cellIndex:Int){
        let indexPath = IndexPath(item: cellIndex, section: 1)
        productListTableView.reloadRows(at: [indexPath], with: .top)
        
    }
}
