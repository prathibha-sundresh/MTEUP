//
//  WSRecipeListViewController.swift
//  yB2CApp
//
//  Created by Sahana Rao on 30/11/17.
//

import UIKit

class WSRecipeListViewController: UIViewController {
  
  @IBOutlet weak var searchBoxContainer: UIView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var allRecipesLabel: UILabel!
  @IBOutlet weak var recipeCountLabel: UILabel!
  @IBOutlet weak var filterButton: UIButton!
  @IBOutlet weak var recipeListTableView: UITableView!
  
  var loadMoreCellHeight = 0
  var currentPage = 1
  //var recipeMaincurrentPage = 1
  
  var recipeArray = [[String:Any]]()
  
  // var recipeMainArray = [[String:Any]]()
  var likeDislikeDict = [String: Any]()
  var selectedIndex: Int?
  var isTradePartnerBannerEnable = false
  
  var filterDict: [String: Any] = [:]
  var isFilterEnabled = false
  var currentFilterString = ""
  // var tradePartnerBannerUrl = ""
  var bannerDict = [String:Any]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if SHOW_ALL_RECIPES_FROM_SAMPLE_ORDER_SUCCESS {
      SHOW_ALL_RECIPES_FROM_SAMPLE_ORDER_SUCCESS = false
    }
    
    UFSGATracker.trackScreenViews(withScreenName: "Recipe Listing Screen")
    FireBaseTracker.ScreenNaming(screenName: "Recipe Listing Screen", ScreenClass: String(describing: self))
    FBSDKAppEvents.logEvent("Recipes Viewed")
    WSUtility.addNavigationBarBackButton(controller: self)
    WSUtility.addNavigationRightBarButton(toViewController: self)
    self.recipeListTableView.separatorStyle = UITableViewCellSeparatorStyle.none
    filterButton.layer.borderColor = UIColor(red: 255.0 / 255.0, green: 90.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0).cgColor
    //    getAllRecipe(loadMoreCell: nil)
    //
    //    recipeListTableView.reloadData()
    allRecipesLabel.text = WSUtility.getlocalizedString(key: "All recipes", lang: WSUtility.getLanguage(), table: "Localizable")
    filterButton.setTitle(WSUtility.getlocalizedString(key: "Filter", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    
    let navigationBar = navigationController!.navigationBar
    navigationBar.setBackgroundImage(UIImage(),
                                     for: .default)
    navigationBar.shadowImage = UIImage()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    NotificationCenter.default.addObserver(self, selector:#selector(applicationWillEnterForeground), name:
      NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    
//    let tradePartnerBannerResponse = WSCacheSingleton.shared.cache.object(forKey: Cached_TradePartner_Banner as NSString) as Any
//    if let dict = tradePartnerBannerResponse as? [String:Any]{
//      // tradePartnerBannerUrl = bannerDict["banner_image"] as! String
//      bannerDict = dict
//      
//    }
    WSUtility.setCartBadgeCount(ViewController: self)
    isTradePartnerBannerEnable = false
    if WSUtility.isFeatureEnabled(feature: featureId.Trade_partner_promotion_banners.rawValue) {
      isTradePartnerBannerEnable = true
      getTradePartnerBanner()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.trackingScreens(screenName: "Recipe Listing Screen")
    customizeSearchBar()
    searchBar.placeholder = WSUtility.getlocalizedString(key: "Search for a recipe", lang: WSUtility.getLanguage(), table: "Localizable")
    if self.currentPage == 1{
      getAllRecipe(loadMoreCell: nil)
      let indxPth = IndexPath(item: 0, section:0)
      recipeListTableView.scrollToRow(at: indxPth, at: .top, animated: true)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self)
  }
  
  func applicationWillEnterForeground()  {
    
    WSUtility.setCartBadgeCount(ViewController: self)
    getTradePartnerBanner()
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
  
  func getTradePartnerBanner()  {
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    let tradePartnerID = WSUtility.getValueFromUserDefault(key: TRADE_PARTNER_ID)
    
    serviceBussinessLayer.getTradePartnerBanner(tradePartnerId: tradePartnerID, successResponse: { (response) in
      self.bannerDict = response
      self.recipeListTableView.reloadData()
      
    }) { (errorMessage) in
      
    }
  }
  
  func getAllRecipe(loadMoreCell:WSLoadMoreTableViewCell?) {
    
    if self.currentPage == 1{
      UFSProgressView.showWaitingDialog("")
    }
    
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.getAllRecipe(forPage: "\(currentPage)", successResponse: { (response) in
      
      if self.currentPage == 1{
        self.recipeArray = response["data"] as! [[String:Any]]
        let indexToAddBannerImage = self.recipeArray.count >= 10 ? 6 : self.recipeArray.count
        self.recipeArray.insert([String:Any](), at: indexToAddBannerImage)
      }else{
        let newArray = response["data"] as! [[String:Any]]
        self.recipeArray.append(contentsOf: newArray)
      }
      
      self.currentPage = self.currentPage + 1
      let totalNumberOfProduct = response["total"] as! Int
      self.recipeCountLabel.text = "(\(response["total"]!) " + WSUtility.getlocalizedString(key: "recipes", lang: WSUtility.getLanguage(), table: "Localizable")! + ")"
      self.loadMoreCellHeight = (totalNumberOfProduct > self.recipeArray.count) ? 60 : 0
      
      loadMoreCell?.activityIndicator.isHidden = true
      loadMoreCell?.loadmoreButton.isHidden = false
      
      self.recipeListTableView.reloadData()
      
      UFSProgressView.stopWaitingDialog()
    }) { (errorMessage) in
      
      loadMoreCell?.activityIndicator.isHidden = true
      loadMoreCell?.loadmoreButton.isHidden = false
      UFSProgressView.stopWaitingDialog()
    }
  }
  
  @IBAction func filterButtonClicked(_ sender: UIButton) {
    
  }
  
  func getLikeStausFromCachedData(recipeId:String) -> (Bool,String) {
    
    var isRecipeIdPresentInCachedData = false
    var likeStatus = "0"
    
    let cachedLikeStatusDict = WSCacheSingleton.shared.cache.object(forKey: Cached_Recipe_Like_Status as NSString) as Any
    if let arrayLikeStatus = cachedLikeStatusDict as? [[String:String]], arrayLikeStatus.count > 0{
      
      let predicate = NSPredicate(format: "RecipeID == %@",recipeId )
      let filteredArray = arrayLikeStatus.filter { predicate.evaluate(with: $0) }
      
      if filteredArray.count > 0{
        let dict = filteredArray[0]
        isRecipeIdPresentInCachedData = true
        likeStatus = dict["isFavorite"]!
      }
      
    }
    
    return (isRecipeIdPresentInCachedData, likeStatus)
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is UFSRecipeDetailViewController{
      
      let dict = sender as? [String:Any]
      
      let recipeDetailVC = segue.destination as? UFSRecipeDetailViewController
      recipeDetailVC?.recipeNumber = "\(dict!["recipe_code"]!)"
      recipeDetailVC?.recipePersonalized = "\(dict!["recipe_id"]!)"
      
      let likeStatusFromCachedData = getLikeStausFromCachedData(recipeId: "\(dict!["recipe_id"]!)")
      if likeStatusFromCachedData.0{
        recipeDetailVC?.recipeLikeStatus = likeStatusFromCachedData.1
      }else{
        recipeDetailVC?.recipeLikeStatus = "\(dict!["favorite_flag"]!)"
      }
      
      
    } else if segue.identifier == "FilterOptionsVC"{
      self.currentPage = 1
      isFilterEnabled = true
      let filterVC: WSRecipeFilterViewController = segue.destination as! WSRecipeFilterViewController
      filterVC.delegate = self
      filterVC.filterDict = filterDict
    }else if segue.destination is WSProductDetailViewController{
      
      let productVC = segue.destination as? WSProductDetailViewController
      if let number = (sender as? String){
        productVC?.productCode = number
      }
      
      // productVC?.productCode = (sender as? String)!
    }
    else if segue.destination is WSMyRecipeViewController{
      self.currentPage = 1
    }
  }
  
}

extension WSRecipeListViewController: WSRecipeFilterViewControllerDelegate {
  func sendFilterDict(dict: [String: Any]){
    
    if let selectedKeyWords = dict["selectedKeyWords"] as? [[String :Any]]{
      if selectedKeyWords.count > 0{
        filterButton.setTitle( WSUtility.getlocalizedString(key: "Filter", lang: WSUtility.getLanguage(), table: "Localizable")! + "(\(selectedKeyWords.count))", for: .normal)
      }
      else{
        filterDict.removeAll()
        filterButton.setTitle(WSUtility.getlocalizedString(key: "Filter", lang: WSUtility.getLanguage(), table: "Localizable") , for: .normal)
        isFilterEnabled = false
        self.currentPage = 1
        getAllRecipe(loadMoreCell: nil)
        
        return
      }
    }
    
    filterDict = dict
    
    if let subKey_str = dict["sub_key"] as? String{
      if subKey_str.count > 0 {
        currentFilterString = subKey_str
        filterRecipeAPICall(filterString: subKey_str, loadMoreCell: nil)
      }
    }
    else{
      self.currentPage = 1
      getAllRecipe(loadMoreCell: nil)
    }
  }
  
  func filterRecipeAPICall(filterString:String,loadMoreCell:WSLoadMoreTableViewCell?) {
    
    
    let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    businessLayer.getFilteredRecipeList(forPage: "\(currentPage)", recipeFilterStr: filterString, successResponse: { (response) in
      if self.currentPage == 1{
        UFSProgressView.showWaitingDialog("")
        self.recipeArray = response["data"] as! [[String:Any]]
        let indexToAddBannerImage = self.recipeArray.count >= 10 ? 6 : self.recipeArray.count
        self.recipeArray.insert([String:Any](), at: indexToAddBannerImage)
      }else{
        let newArray = response["data"] as! [[String:Any]]
        self.recipeArray.append(contentsOf: newArray)
      }
      let recipeString = WSUtility.getlocalizedString(key: "recipes", lang: WSUtility.getLanguage(), table: "Localizable")
      self.currentPage = self.currentPage + 1
      let totalNumberOfProduct = response["total"] as! Int
      self.recipeCountLabel.text = "(\(response["total"]!) " + recipeString! + ")"
      self.loadMoreCellHeight = (totalNumberOfProduct > self.recipeArray.count) ? 60 : 0
      
      loadMoreCell?.activityIndicator.isHidden = true
      loadMoreCell?.loadmoreButton.isHidden = false
      
      self.recipeListTableView.reloadData()
      UFSProgressView.stopWaitingDialog()
    }, failureResponse: { (errorMessage) in
      loadMoreCell?.activityIndicator.isHidden = true
      loadMoreCell?.loadmoreButton.isHidden = false
      UFSProgressView.stopWaitingDialog()
    })
    
  }
  
  @objc func shopNowButton_click(sender: UIButton){
    
    if WSUtility.isLoginWithTurkey(){
        //as per UFSAPP-3772
        return
    }
    
//    var appVersion = ""
//    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
//      appVersion = version
//    }
    
    UFSGATracker.trackEvent(withCategory: "Banner click", action: "Recipe List", label: "", value: nil)
    if bannerDict.count > 0{
        let productCode = bannerDict["article_number"]
        self.performSegue(withIdentifier: "ProductDetailSegue", sender: productCode)
    
    }
  }
}
extension WSRecipeListViewController: UITableViewDelegate, UITableViewDataSource{
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return recipeArray.count + 1
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell  = UITableViewCell()
    
    if indexPath.row == recipeArray.count  {
      let loadMoreCell:WSLoadMoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WSLoadMoreTableViewCell") as! WSLoadMoreTableViewCell
      loadMoreCell.setUI()
      loadMoreCell.delegate = self
      
      cell = loadMoreCell
    } else if indexPath.row ==  (recipeArray.count >= 10 ? 6 : (recipeArray.count-1)) {
      let promotionCell = tableView.dequeueReusableCell(withIdentifier: "WSPromotionTableViewCell") as! WSPromotionTableViewCell
      
      promotionCell.updateCellContent(dict: bannerDict)
      
      // create an NSMutableAttributedString that we'll append everything to
      let promotionText = NSMutableAttributedString(string: WSUtility.getlocalizedString(key: "Careful these are hot 🔥", lang: WSUtility.getLanguage(), table: "Localizable")!)
      
      promotionCell.subHeaderTitleLabel?.attributedText = promotionText
      promotionCell.shopNowButton.addTarget(self, action: #selector(shopNowButton_click), for: .touchUpInside)
      cell = promotionCell
      
    }else {
      
      let dict = recipeArray[indexPath.row]
      let recipeListCell : WSRecipeListerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WSRecipeListerTableViewCell") as! WSRecipeListerTableViewCell
      recipeListCell.setUI()
      recipeListCell.recipeNameLabel.text = dict["title"] as? String
      if let imageURL = dict["banner_image_url"] as? String{
        recipeListCell.recipeImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "placeholder.png"))
      }
      
      
      
      let likeStatusFromCachedData = getLikeStausFromCachedData(recipeId: "\(dict["recipe_id"]!)")
      
      if likeStatusFromCachedData.0{
        let likeStatus = likeStatusFromCachedData.1
        recipeListCell.addRemoveFavButton.setImage((likeStatus == "1") ? #imageLiteral(resourceName: "favoriteSymbolLiked") : #imageLiteral(resourceName: "favoriteSymbolCopy"), for: .normal)
      }else{
        let likeStatus = dict["favorite_flag"] as? String
        recipeListCell.addRemoveFavButton.setImage((likeStatus == "1") ? #imageLiteral(resourceName: "favoriteSymbolLiked") : #imageLiteral(resourceName: "favoriteSymbolCopy"), for: .normal)
      }
      
      /*
       if  dictLikeStatus["RecipeID"] == "\(dict["recipe_id"]!)" {
       let likeStatus = dictLikeStatus["isFavorite"]
       recipeListCell.addRemoveFavButton.setImage((likeStatus == "1") ? #imageLiteral(resourceName: "favoriteSymbolLiked") : #imageLiteral(resourceName: "favoriteSymbolCopy"), for: .normal)
       }
       */
      
      recipeListCell.addRemoveFavButton.addTarget(self, action: #selector(favouriteAndunfavouriteAction), for: .touchUpInside)
      recipeListCell.addRemoveFavButton.tag = indexPath.row
      cell = recipeListCell
    }
    
    return cell
    
  }
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == recipeArray.count {
      return CGFloat(loadMoreCellHeight)
    }else if indexPath.row == (recipeArray.count >= 10 ? 6 : (recipeArray.count-1)){
      if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
        return 0
      }
      if isTradePartnerBannerEnable == false{
        return 0
      }
      else{
        return 295
      }
      
    }
    return 156
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let tradePartnerBannerIndex = (recipeArray.count >= 10 ? 6 : (recipeArray.count-1))
    if (indexPath.row == recipeArray.count) || indexPath.row == tradePartnerBannerIndex{
      if indexPath.row == tradePartnerBannerIndex{
        
        var appVersion = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
          appVersion = version
        }
        
        
        //        let productCode = bannerDict["product_ean_code"]
        //        self.performSegue(withIdentifier: "ProductDetailSegue", sender: productCode)
      }
      return
    }
    
    let dict = recipeArray[indexPath.row]
    
    var appVersion = ""
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      appVersion = version
    }
    
    
    UFSGATracker.trackEvent(withCategory: "Recipe click", action: "\(dict["title"] as? String) - \(dict["recipe_id"]!)", label: "", value: nil)
    
    self.performSegue(withIdentifier: "RecipeDetailSegue", sender: dict)
  }
  
  
  func favouriteAndunfavouriteAction(sender: UIButton){
    
    // like = 1
    // dislike = 0
    
    selectedIndex = sender.tag
    
    var selectedDict = recipeArray[sender.tag]
    var requestDict = [String: Any]()
    
    requestDict["recipe_code"] = "\(selectedDict["recipe_code"]!)"
    
    if selectedDict["favorite_flag"] as? String == "1" {
      requestDict["ISFavorite"] = false
      selectedDict["favorite_flag"] = "0"
    }
    else {
      requestDict["ISFavorite"] = true
      selectedDict["favorite_flag"] = "1"
      
    }
    
    recipeArray[sender.tag] = selectedDict
    
    let bussinessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    bussinessLayer.favouriteUnfavouriteFromAdmin(parameterDict: requestDict, successResponse: { (response) in
      
      DispatchQueue.main.async {
        let indexPath = IndexPath(row: self.selectedIndex!, section: 0)
        self.recipeListTableView.reloadRows(at: [indexPath], with: .none)
      }
    }) { (errorMessage) in
      print(errorMessage)
      
    }
    
  }
}

extension WSRecipeListViewController:WSLoadMoreTableViewCellDelegate{
  
  func loadMoreButtonAction(loadMoreCell: WSLoadMoreTableViewCell) {
    
    if isFilterEnabled {
      filterRecipeAPICall(filterString: currentFilterString, loadMoreCell: loadMoreCell)
    }else{
      getAllRecipe(loadMoreCell: loadMoreCell)
    }
    
  }
}

extension WSRecipeListViewController : UISearchBarDelegate {
  
  public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.performSegue(withIdentifier: "RecipeSearchSegue", sender: self)
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
