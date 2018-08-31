//
//  WSProductCatalogueViewController.swift
//  yB2CApp
//
//  Created by Anandita on 11/25/17.
//

import UIKit

class WSProductCatalogueViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,NoInternetDelegate, NetworkStatusDelegate {
  
    @IBOutlet weak var ScanButtonTitle: UIButton!
    @IBOutlet weak var searchContainerView: UIView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var productCategoriesLabel: UILabel!
  @IBOutlet weak var orderShoppingListLabel: UILabel!
  @IBOutlet weak var searchProductTF: UITextField!
  @IBOutlet weak var scanButton: UIButton!
   var productCategories : [[String: Any]] = []
  @IBOutlet weak var mainCategoriesTableView: UITableView!
  @IBOutlet weak var headerView: UIView!
    var noInternetView:UFSNoInternetView?
    var networkStatus = UFSNetworkReachablityHandler.shared
  //  var selectedIndex: Int = 0
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
     networkStatus.startNetworkReachabilityObserver()
    searchBar.placeholder = WSUtility.getlocalizedString(key: "Search for a product", lang: WSUtility.getLanguage(), table: "Localizable")
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.trackingScreens(screenName: "Product Category Screen")
    UFSGATracker.trackScreenViews(withScreenName: "Product Category Screen")
    FireBaseTracker.ScreenNaming(screenName: "Product Category Screen", ScreenClass: String(describing: self))
    FBSDKAppEvents.logEvent("Product Category Screen")
    

    mainCategoriesTableView.tableHeaderView = headerView
    
    /*
    let navigationBar = navigationController!.navigationBar
    navigationBar.setBackgroundImage(UIImage(),for: .default)
    navigationBar.shadowImage = UIImage()
    */
     addSlideMenuButton()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    UITitles()
    networkStatus.delegate = self
    networkCheckAndApiCall()
    
    WSUtility.setCartBadgeCount(ViewController: self)
  }
    
    override func viewWillDisappear(_ animated: Bool) {
        WSUtility.removeNoNetworkView(internetView: &noInternetView)
    }
  override func viewDidAppear(_ animated: Bool) {
    customizeSearchBar()
    if !WSUtility.isTaxNumberAvailable(VCview: self.view){
        WSUtility.addTaxNumberView(viewController: self)
        mainCategoriesTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 75))
    }else{
        if let view = self.view.viewWithTag(9006){
            view.removeFromSuperview()
        }
        mainCategoriesTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
    func UITitles()  {
        orderShoppingListLabel.text = WSUtility.getlocalizedString(key: "Order with my shopping list", lang: WSUtility.getLanguage(), table: "Localizable")
        
        scanButton.setTitle(WSUtility.getlocalizedString(key: "Scan", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        ScanButtonTitle.setTitle(WSUtility.getlocalizedString(key: "Scan", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        productCategoriesLabel.text = WSUtility.getlocalizedString(key: "Product categories", lang: WSUtility.getLanguage(), table: "Localizable")
    }
    
  func customizeSearchBar() {
    let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
    textFieldInsideUISearchBar?.clearButtonMode = .never
    let image = #imageLiteral(resourceName: "search")
    let imageView = UIImageView(image: image)
    textFieldInsideUISearchBar?.leftView = nil
    textFieldInsideUISearchBar?.rightView = imageView
    textFieldInsideUISearchBar?.rightViewMode = .always
    let placeholderLabel = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
    placeholderLabel?.font = UIFont.init(name: "DINPro-Regular", size: 14)
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
        WSUtility.removeNoNetworkView(internetView: &noInternetView)
      /*
        if productCategories.count == 0{
            getProductCategoryList()
        }else{
            self.mainCategoriesTableView.reloadData()
        }
 */
      getProductCategoryList()
    }

    func NonReachableNetwork() {
        if noInternetView == nil {
            WSUtility.loadNoInternetView(internetView: &noInternetView, controllerView: self)
        }
    }
    func btnTaxTapped(sender:UIButton)  {
        let storyBoard: UIStoryboard = UIStoryboard(name: "EnterTaxNumberStoryboard", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WSEnterTaxNumberViewController") as! WSEnterTaxNumberViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.callBack = {
            if let view = self.view.viewWithTag(9006){
                view.removeFromSuperview()
            }
        }
        present(vc, animated: true, completion: nil)
        
    }
  func getProductCategoryList() {
    
    UFSProgressView.showWaitingDialog("")
    let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    businessLayer.getMainCategories(successResponse: { (response) in
      
      self.productCategories = response["subcategories"] as! [[String:Any]]
      self.productCategories.insert(["name":WSUtility.getTranslatedString(forString: "See all products")], at: 0)
      self.mainCategoriesTableView.reloadData()
      UFSProgressView.stopWaitingDialog()
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
    }
    
  }
  
  @IBAction func myShoppingButtonAction(_ sender: UIButton) {
    self.tabBarController?.selectedIndex = 1
  }
  @IBAction func backAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func rightBarButtonPressed(_ sender: UIButton)  {
    WSUtility.cartButtonPressed(viewController: self)
    
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return productCategories.count;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let productCell:ProductCatalogueCell = tableView.dequeueReusableCell(withIdentifier: "ProductCatalogueCell") as! ProductCatalogueCell
    let dict = productCategories[indexPath.row]
    if let name = dict["name"] as? String{
      productCell.productCategoryLabel.text = name
    }else{
      productCell.productCategoryLabel.text = ""
    }
    return productCell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
    return 90;
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    //selectedIndex = indexPath.row
    if indexPath.row == 0 {
       self.performSegue(withIdentifier: "showAllProductListSegue", sender: indexPath)
    }else{
      self.performSegue(withIdentifier: "productSubCategorySegue", sender: indexPath)
    }
   
  }
  
  // This function is called before the segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    // get a reference to the second view controller
    if segue.identifier == "productSubCategorySegue"{
      
      let indexPath = (sender as! IndexPath)
      let subcategoryViewController = segue.destination as! WSProductSubCategoryViewController
      subcategoryViewController.selectedCategoryDict = productCategories[indexPath.row]
      
    }else if segue.destination is AllProductsViewController {
      let productViewController = segue.destination as! AllProductsViewController
      productViewController.productListScreenOpenedBy = .ALL_PRODUCT
      
    }else if segue.destination is SearchViewController{
      let searchViewController = segue.destination as! SearchViewController
      searchViewController.isScreenOpenFromProductCategory = true
    }
  }
}


extension WSProductCatalogueViewController : UISearchBarDelegate {
  
  public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.performSegue(withIdentifier: "SearchSeagueVC", sender: self)
  }
  
  public func searchBarTextDidEndEditing(_ searchBar: UISearchBar)  {
    //  isSearchActive = false
  }
  
  public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
  }
  
  public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
  }
  
}
