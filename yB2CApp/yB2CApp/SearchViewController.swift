 //
 //  SearchViewController.swift
 //  yB2CApp
 //
 //  Created by Anandita on 11/21/17.
 //
 
 import UIKit
 
 class SearchViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,NoInternetDelegate,NetworkStatusDelegate {
  
  @IBOutlet weak var searchCancelButton: UIButton!
  @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var customSearchView: UIView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var productTableView: UITableView!
  //var maximumNumberOfItems : Int = 11
  @IBOutlet weak var loadProductsbutton: UIButton!
  @IBOutlet weak var totalNumberOfProductsLabel: UILabel!
  @IBOutlet weak var whiteButton: UIButton!
  @IBOutlet weak var sepratorView: UIView!
  @IBOutlet weak var scanButton: UIButton!
  
  var noInternetView:UFSNoInternetView?
  var networkStatus = UFSNetworkReachablityHandler.shared
  var selectedCellIndex = Int()
  //var product : [HYBProduct] = []
  var product  = [[String:Any]] ()
  var originalProduct  = [[String:Any]] ()
  
  var webServiceBusinessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
  //var backendServiceNew:HYBB2CService = (UIApplication.shared.delegate as! HYBAppDelegate).backEndService
  var currentSearchQuery = ""
  private let numberOfItemsToAdd = 10
  private var numberOfItems = 10
  var isScreenOpenFromProductCategory = false
  var loadMoreCellHeight = 0
  var currentPage = 0
  let TaxNumberViewHeight = 75
  
  @IBAction func scanButtonPressed(_ sender: Any) {
    self.openViewControllerBasedOnIdentifier("ScanVCID")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    networkStatus.startNetworkReachabilityObserver()
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    
    serviceBussinessLayer.trackingScreens(screenName: "Search Screen")
    UFSGATracker.trackScreenViews(withScreenName: "Search Screen")
    FireBaseTracker.ScreenNaming(screenName: "Search Screen", ScreenClass: String(describing: self))
    FBSDKAppEvents.logEvent(FBSDKAppEventNameSearched)
    FBSDKAppEvents.logEvent("Search Screen")
    
    
    customSearchView.addBottomBorderWithColor(color: UIColor(red: 247.0/255.0, green: 245.0/255.0, blue: 243.0/255.0, alpha: 1), width: 1)
    
    resetSearchVariables()
    
    // Add notification for keyboard show and hide
    let center = NotificationCenter.default
    center.addObserver(self,
                       selector: #selector(keyboardWillShow(_:)),
                       name: .UIKeyboardWillShow,
                       object: nil)
    
    center.addObserver(self,
                       selector: #selector(keyboardWillHide(_:)),
                       name: .UIKeyboardWillHide,
                       object: nil)
    
    scanButton.setTitle(WSUtility.getlocalizedString(key:"Scan", lang:WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    
    
    let navigationBar = navigationController!.navigationBar
    navigationBar.setBackgroundImage(UIImage(),
                                     for: .default)
    navigationBar.shadowImage = UIImage()
    //loadCqategory()
    
    
    // dismiss the keyboard when tapped elsewhere in screen
    let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
    tap.cancelsTouchesInView = false
    self.view.addGestureRecognizer(tap)
    if isScreenOpenFromProductCategory {
      WSUtility.addNavigationBarBackButton(controller: self)
      WSUtility.addNavigationRightBarButton(toViewController: self)
    }else{
      addSlideMenuButton()
    }
    
  }
  override func viewDidAppear(_ animated: Bool) {
    customizeSearchBar()
    if !WSUtility.isTaxNumberAvailable(VCview: self.view){
        WSUtility.addTaxNumberView(viewController: self)
     // productTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 75))
    }else{
        if let view = self.view.viewWithTag(9006){
            view.removeFromSuperview()
        }
       // productTableView.tableFooterView = UIView(frame: CGRect.zero)
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
        
        self.performSearchOperation()
        
      }
        present(vc, animated: true, completion: nil)
        
    }
  
  @IBAction func backAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  @IBAction func rightBarButtonPressed(_ sender: UIButton)  {
    WSUtility.cartButtonPressed(viewController: self)
    
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
    if searchBar.text == ""{
        self.searchBar.becomeFirstResponder()
    }
    WSUtility.removeNoNetworkView(internetView: &noInternetView)
    self.getFavouriteList()
  }
  
  func NonReachableNetwork() {
    if noInternetView == nil {
      WSUtility.loadNoInternetView(internetView: &noInternetView, controllerView: self)
    }
  }
  

  
  func getFavouriteList() {
    UFSProgressView.showWaitingDialog("")
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.makeFavouriteListRequest(methodName: Favourites_List_API, successResponse: { (response) in
      WSUtility.removeProductCode()
      UFSProgressView.stopWaitingDialog()
      
      let _ : [[String :Any]] = response.map { dictionary in
        var dict = dictionary
        dict["qunatiy"] = 1
        dict["modified_product_code"] = "cu-du"
        
        let productDict = dict ["product"] as! [String: Any]
        
        let add = dict ["automaticallyAdded"] as! Bool
        if !add{//Don't convert ordered products into favourites
          let productNumber =  productDict["productNumber"] as! String
          WSUtility.setProductCode(productNumber: productNumber)
        }
        let productCode =  productDict["productCode"] as! String
        if (productDict["defaultPackagingType"] as? String) != nil{
          dict["modified_product_code"] = productCode+"-du"
          
        }
        return dict
      }
      
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
    }
  }
  func customizeSearchBar() {
    self.searchBar.delegate = self
    let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
    textFieldInsideUISearchBar?.clearButtonMode = .never
    let image = #imageLiteral(resourceName: "search")
    //    let imageView = UIImageView(image: image)
    let searchButton = UIButton(type: .custom)
    searchButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    searchButton.setImage(image, for: .normal)
    searchButton.addTarget(self, action: #selector(performSearchOperation), for: .touchUpInside)
    textFieldInsideUISearchBar?.leftView = nil
    textFieldInsideUISearchBar?.rightView = searchButton
    textFieldInsideUISearchBar?.rightViewMode = .always
    
    let placeholderLabel = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
    placeholderLabel?.font = UIFont.init(name: "DINPro-Regular", size: 14)
  }
  
  //  func loadCqategory() {
  //    backendService.getCategoriesAndExecute({(_ categories, _ error) in
  //      if error != nil {
  //        // DDLogError("Problems during the retrieval of the products from the web service: %@", error?.localizedDescription)
  //      }
  //      else {
  //
  //        guard categories != nil else{
  //          return
  //        }
  //
  //        print("products : %@",categories!)
  //      }
  //    })
  //  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.searchBar.setTextFieldColor(color: UIColor(red: 247.0/255.0, green: 245.0/255.0, blue: 243.0/255.0, alpha: 1))
    self.searchBar.placeholder = WSUtility.getlocalizedString(key: "Search for a product", lang: WSUtility.getLanguage(), table: "Localizable")
    WSUtility.setCartBadgeCount(ViewController: self)
    networkCheckAndApiCall()
    networkStatus.delegate = self
    
  }
  override func viewWillDisappear(_ animated: Bool) {
    WSUtility.removeNoNetworkView(internetView: &noInternetView)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @objc func keyboardWillShow(_ notification:Notification) {
    self.tableViewBottomConstraint.constant = 130
  }
  
  @objc func keyboardWillHide(_ notification:Notification) {
    self.tableViewBottomConstraint.constant = 0
  }
  
  func doPerformSearch(loadMoreCell:WSLoadMoreTableViewCell?)  {
    webServiceBusinessLayer.getProductsByQuery(currentSearchQuery: self.searchBar.text!, currentPage: self.currentPage, successResponse:{ (response) in
      print(response)
      UFSProgressView.stopWaitingDialog()
      
      let dictResponse = response as! [String:Any]
        
        if let products = dictResponse["products"]{
            let pagination = dictResponse["pagination"] as! [String:Any]
            let totalSearchResults = pagination["totalResults"] as! Int
            
            self.totalNumberOfProductsLabel.text = "[" + "\(totalSearchResults)" + " " + WSUtility.getlocalizedString(key:"Results", lang: WSUtility.getLanguage(), table: "Localizable")! + "]"
            
            
            self.productTableView.isHidden = false
            
            if self.currentPage == 0{
                self.product = products as! [[String:Any]]
                self.originalProduct = products as! [[String : Any]]
            }else {
                let tempProductArray = products as! [[String:Any]]
                self.product.append(contentsOf: tempProductArray)
                self.originalProduct.append(contentsOf: tempProductArray)
            }
            
            self.currentPage += 1
            
            self.loadMoreCellHeight = (self.product.count >= totalSearchResults) ? 0 : 60
            self.productTableView.reloadData()
        }
        else{
            self.productTableView.isHidden = true
            self.totalNumberOfProductsLabel.text = "[0 " + (WSUtility.getlocalizedString(key: "Results", lang: WSUtility.getLanguage(), table: "Localizable"))! + "]"
        }
      
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
      print(errorMessage)
      
      loadMoreCell?.activityIndicator.stopAnimating()
      
      //self.productTableView.isHidden = true
     // self.totalNumberOfProductsLabel.text = "[0 " + (WSUtility.getlocalizedString(key: "Results", lang: WSUtility.getLanguage(), table: "Localizable"))! + "]"
      
    }
    
    
    //    backendService.getProductsByQuery(self.searchBar.text! ,andExecute: { (products, spellingSuggestion, error) in
    //      if (products == nil)
    //      {
    //        self.productTableView.isHidden = true
    //        self.totalNumberOfProductsLabel.text = "[0 " + (WSUtility.getlocalizedString(key: "Results", lang: WSUtility.getLanguage(), table: "Localizable"))! + "]"
    //      }
    //      else
    //      {
    //        //print(products!)
    //        self.totalNumberOfProductsLabel.text = "[" + "\(self.backendService.totalSearchResults)" + " " + WSUtility.getlocalizedString(key:"Results", lang: WSUtility.getLanguage(), table: "Localizable")! + "]"
    //
    //
    //        self.productTableView.isHidden = false
    //
    //        if self.backendService.currentPage == 0{
    //          self.product = products as! [[String:Any]]
    //            self.originalProduct = products as! [[String : Any]]
    //        }else {
    //          let tempProductArray = products as! [[String:Any]]
    //          self.product.append(contentsOf: tempProductArray)
    //            self.originalProduct.append(contentsOf: tempProductArray)
    //        }
    //
    //        self.backendService.nextPage()
    //        self.loadMoreCellHeight = (self.product.count >= self.backendService.totalSearchResults) ? 0 : 60
    //        self.productTableView.reloadData()
    //      }
    //
    //    })
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is WSProductDetailViewController{
      
      let productVC = segue.destination as? WSProductDetailViewController
      let productCode = (sender as? String)!
      //let baseCode = productCode.dropLast(3)
      productVC?.productCode = String(productCode)
      productVC?.cellIndex = selectedCellIndex
      productVC?.delegate = self
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    if product.count == 0{
      return 0
    }
    return product.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
    var cell = UITableViewCell()
    
    if indexPath.row  == product.count {
      
      let loadMoreCell:WSLoadMoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WSLoadMoreTableViewCell") as! WSLoadMoreTableViewCell
      loadMoreCell.setUI()
      loadMoreCell.delegate = self
      cell = loadMoreCell
    }else {
      
      let productCell:WSSearchProductViewCell = tableView.dequeueReusableCell(withIdentifier: "WSSearchProductViewCell") as! WSSearchProductViewCell
      
      let productDict = product[indexPath.row]
      
      productCell.delegate = self
      productCell.addToFavouriteBtn.tag = indexPath.row
      productCell.updateCellContent(productDetail: productDict)
      productCell.setUI(dict: productDict)
      
      //Manage fav/unfav
      
      if let productNumber = productDict["number"] as? String{
        let productCode = productNumber
        let favoriteProductList = WSUtility.getProductCode()
        if favoriteProductList .contains(productCode) {
          // print("True for favourit")
          productCell.isProductFavorite(isfavourite: true)
        } else {
          productCell.isProductFavorite(isfavourite: false)
        }
      }
     
      //////////
      cell = productCell
    }
    
    return cell
  }
  func deleteUnfavouriteProductitem(productNumber: String) {
    WSUtility.removeFavoriteItem(item: productNumber)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
    if indexPath.row == product.count{
      var height = 0
    
      if WSUser().getUserProfile().taxNumber == ""{
        height = TaxNumberViewHeight
      }
      return CGFloat(loadMoreCellHeight + height)
    }
    
    return UITableViewAutomaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == product.count{
      return
    }
    let productDict = product[indexPath.row]
    selectedCellIndex = indexPath.row
    
    self.performSegue(withIdentifier: "ProductDetailSegue", sender: productDict["code"])
  }
 
  
  @IBAction func cancelButtonClicked(_ sender: UIButton) {
    
    self.searchBar.text = ""
    resetSearchVariables()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
    performSearchOperation()
  }
  
  func performSearchOperation(){
    self.searchBar.resignFirstResponder()
    if self.searchBar.text?.count == 0 {
      return
    }
    else {
      resetSearchVariables()
      doPerformSearch(loadMoreCell: nil)
    }
    
  }
  func resetSearchVariables()  {
    self.product.removeAll()
    
    currentPage = 0
    self.totalNumberOfProductsLabel.text = ""
    self.searchCancelButton.isHidden = true
    self.productTableView.reloadData()
    
    
  }
  
  public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)
    /*
    if let charsize =  searchText.count as? Int
    {
      if (charsize == 3)
      {
        resetSearchVariables()
        currentSearchQuery = searchText
        doPerformSearch(loadMoreCell: nil)
      }else if (charsize > 3){
        product.removeAll()
        product = originalProduct.filter { ($0["name"] as! String).range(of: searchText, options: [.caseInsensitive]) != nil }
        if product.count == 0{
          self.productTableView.isHidden = true
          self.totalNumberOfProductsLabel.text = "[0 " + (WSUtility.getlocalizedString(key: "Results", lang: WSUtility.getLanguage(), table: "Localizable"))! + "]"
          product.removeAll()
        }
        self.productTableView.reloadData()
      }else if (charsize == 0){
        self.searchBar.text = ""
        resetSearchVariables()
      }
    }
    */
    self.searchCancelButton.isHidden = false
    
  }
  
 }
 extension UISearchBar {
  
  private func getViewElement<T>(type: T.Type) -> T? {
    
    let svs = subviews.flatMap { $0.subviews }
    guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
    return element
  }
  //    func change(textFont : UIFont?) {
  //
  //        for view : UIView in (self.subviews[0]).subviews {
  //
  //            if let textField = view as? UITextField {
  //                textField.attributedPlaceholder?.attribute(WSUtility.getlocalizedString(key:"Search for a product", lang:WSUtility.getLanguage(), table: "Localizable")!, at: 0, longestEffectiveRange: 0, in: (0,textField.text?.count))
  //            }
  //        }
  //    }
  func setTextFieldColor(color: UIColor) {
    
    if let textField = getViewElement(type: UITextField.self) {
      switch searchBarStyle {
      case .minimal:
        textField.layer.backgroundColor = color.cgColor
        textField.layer.cornerRadius = 6
        
      case .prominent, .default:
        textField.backgroundColor = color
      }
    }
  }
  
 }
 // extension SearchViewController:WSSearchProductCellDelegate{
 //    func storeOrDeleteSelectedCellProductNumber(productNumber: String, actionType: Int) {
 //        if actionType == 1 {
 //            selectedCellArray.append(productNumber)
 //        }else{
 //            if let index = selectedCellArray.index(of: productNumber){
 //                selectedCellArray.remove(at: index)
 //            }
 //
 //        }
 //
 //    }
 // }
 extension UIView {
  
  func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: UIScreen.main.bounds.width, height: width)
    self.layer.addSublayer(border)
    
    let upperborder = CALayer()
    upperborder.backgroundColor = color.cgColor
    upperborder.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: width)
    self.layer.addSublayer(upperborder)
    
  }
  func addTopBorderWithColor(color: UIColor, height: CGFloat, origin_y: CGFloat) {
    let upperborder = CALayer()
    upperborder.backgroundColor = color.cgColor
    upperborder.frame = CGRect(x: 0, y: origin_y, width: UIScreen.main.bounds.width, height: height)
    self.layer.addSublayer(upperborder)
  }
 }
 extension SearchViewController:WSLoadMoreTableViewCellDelegate {
  
  func loadMoreButtonAction(loadMoreCell: WSLoadMoreTableViewCell) {
    doPerformSearch(loadMoreCell: loadMoreCell)
  }
 }
 
 extension SearchViewController:WSSearchProductCellDelegate {
  func actionOnContainerType(packagingType: String, containerType: String, selectedProductCode Code: String) {
    // self.selectedProductCode = Code
    
  }
  func addToCartButtonAction(productCode: String) {
    print(productCode)
    let addToCartBussinessHandler = WSAddToCartBussinessLogic()
    addToCartBussinessHandler.addProductToCart(forProduct: productCode, addedFrom: self)
  }
  
 }
 
 extension String {
  func contains(find: String) -> Bool{
    return self.range(of: find) != nil
  }
  func containsIgnoringCase(find: String) -> Bool{
    return self.range(of: find, options: .caseInsensitive) != nil
  }
 }
 
 extension SearchViewController:ProductDetailDelegate{
  func reloadRow(cellIndex:Int){
    let indexPath = IndexPath(item: cellIndex, section: 0)
    productTableView.reloadRows(at: [indexPath], with: .top)
    
  }
 }
 
