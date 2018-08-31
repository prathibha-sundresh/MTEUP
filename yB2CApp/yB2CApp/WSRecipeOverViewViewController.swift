//
//  WSRecipeOverViewViewController.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 29/11/2017. 
//

import UIKit

class WSRecipeOverViewViewController: BaseViewController, NoInternetDelegate,NetworkStatusDelegate {
  
  @IBOutlet weak var recipeContainerView: UIView!
  @IBOutlet weak var recipeTableView: UITableView!
  
  @IBOutlet weak var tableViewBottomConstaint: NSLayoutConstraint!
  @IBOutlet weak var recipeSearchBar: UISearchBar!
  
  @IBOutlet weak var cancelSearchButton: UIButton!
    var noInternetView:UFSNoInternetView?
  
  var isShowActivityIndicatorOnRecipeView = false
  var recipeArray = [WSRecipeModal]()
  var isSearchActive : Bool = false
  var searchResultsArray : [[String:Any]] = []
  var filteredArray :[String] = []
  var currentPage = 0
  var resultsFound :Int = 0
  var searchString : String = ""
  var loadMoreCellHeight = 0
  var networkstatus = UFSNetworkReachablityHandler.shared
  
  let RECIPE_SWIPE_CELL_TYPE = 0
  let RECIPE_CATEGORY_CELL_TYPE = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    networkstatus.startNetworkReachabilityObserver()
    self.cancelSearchButton.isHidden = true
    let navigationBar = navigationController!.navigationBar
    navigationBar.setBackgroundImage(UIImage(),
                                     for: .default)
    navigationBar.shadowImage = UIImage()
    
    recipeContainerView.addBottomBorderWithColor(color: UIColor(red: 247.0/255.0, green: 245.0/255.0, blue: 243.0/255.0, alpha: 1), width: 1)
    
    addSlideMenuButton()
    getRecipeToSwipe()
    
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
    
    // dismiss the keyboard when tapped elsewhere in screen
    let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
    tap.cancelsTouchesInView = false
    self.view.addGestureRecognizer(tap)
    recipeSearchBar.placeholder = WSUtility.getlocalizedString(key: "Search for a recipe", lang: WSUtility.getLanguage(), table: "Localizable")
    
  }
    override func viewDidAppear(_ animated: Bool) {
        UFSGATracker.trackScreenViews(withScreenName: "Recipe Screen")
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.trackingScreens(screenName: "Recipe Screen")
        customizeSearchBar()

    }
  override func viewWillAppear(_ animated: Bool) {
    networkstatus.delegate = self
    networkCheckAndApiCall()
    if SHOW_ALL_RECIPES_FROM_SAMPLE_ORDER_SUCCESS{//on tap of explore recipes from Sample product thanky you screen.
//        self.navigationController?.popToRootViewController(animated: false)
        let storyboard = UIStoryboard(name: "Recipe", bundle: nil)
        let recipeListVC =  storyboard.instantiateViewController(withIdentifier: "RecipeStoryboard") as! WSRecipeListViewController
        self.navigationController?.pushViewController(recipeListVC, animated: true)
    }
    isSearchActive = false
    WSUtility.setCartBadgeCount(ViewController: self)
    self.recipeTableView.reloadData()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    WSUtility.removeNoNetworkView(internetView: &noInternetView)
    isSearchActive = false
    let nc = NotificationCenter.default
    nc.removeObserver(self, name:NSNotification.Name.UIKeyboardWillHide, object:self)
    nc.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object:self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @objc func keyboardWillShow(_ notification:Notification) {
    self.tableViewBottomConstaint.constant = -226
  }
  
  @objc func keyboardWillHide(_ notification:Notification) {
    self.tableViewBottomConstaint.constant = 0
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
        self.recipeTableView.reloadData()
    }

    func NonReachableNetwork() {
        if noInternetView == nil {
            WSUtility.loadNoInternetView(internetView: &noInternetView, controllerView: self)
        }
    }

  func customizeSearchBar() {
    self.recipeSearchBar.delegate = self
    let textFieldInsideUISearchBar = recipeSearchBar.value(forKey: "searchField") as? UITextField
    textFieldInsideUISearchBar?.clearButtonMode = .never
    let image = #imageLiteral(resourceName: "search")
    let imageView = UIImageView(image: image)
    textFieldInsideUISearchBar?.leftView = nil
    textFieldInsideUISearchBar?.rightView = imageView
    textFieldInsideUISearchBar?.rightViewMode = .always
    let placeholderLabel = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
    placeholderLabel?.font = UIFont.init(name: "DINPro-Regular", size: 14)
  }
  
  func getRecipeSearch(loadMoreCell:WSLoadMoreTableViewCell?)  {
    if self.currentPage == 0{
      UFSProgressView.showWaitingDialog("")
    }
    
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.makeRecipeSearchRequest(searchString: self.searchString, skip: "\(currentPage*10)", take: "10", successResponse: { (response) in
      UFSProgressView.stopWaitingDialog()
      if let result = response["found"] as? Int{
        self.resultsFound = result
      }
      
      if let searchResult = response["hits"] as? [[String:Any]] {
        if self.currentPage == 0 {
          self.searchResultsArray = searchResult
        }else{
          self.searchResultsArray.append(contentsOf: searchResult)
        }
        
        self.currentPage += 1
        self.loadMoreCellHeight = (self.resultsFound > self.searchResultsArray.count) ? 60 : 0
        
      }
      
      /*
       if(self.searchResultsArray.count == 0){
       self.isSearchActive = false;
       } else {
       self.isSearchActive = true;
       }
       */
      
      self.recipeTableView.reloadData()
    }) { (errorMessage) in
      loadMoreCell?.activityIndicator.isHidden = true
      //loadMoreCell?.loadmoreButton.isHidden = false
      UFSProgressView.stopWaitingDialog()
      self.recipeTableView.reloadData()
      
    }
  }
  
  func getRecipeToSwipe() {
    UFSProgressView.showWaitingDialog("")
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.getRecipeToSwipe(successResponse: { (response) in
      UFSProgressView.stopWaitingDialog()
      self.recipeArray = response
      self.recipeTableView.reloadData()
    }) { (errorResponse) in
      UFSProgressView.stopWaitingDialog()
    }
  }
  
  @IBAction func cancelSearch(_ sender: UIButton) {
    
    isSearchActive = false
    self.searchResultsArray.removeAll()
    self.recipeSearchBar.text = ""
    self.currentPage = 0
    self.cancelSearchButton.isHidden = true
    
    if resultsFound > 0{
      let index = IndexPath(row: 0, section: 0)
      recipeTableView.scrollToRow(at: index, at: .none, animated: true)
    }
    self.recipeTableView.reloadData()
    resultsFound = 0
  }
  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    
    if segue.destination is UFSRecipeDetailViewController{
      
      let recipeDetailVC = segue.destination as? UFSRecipeDetailViewController
      //recipeDetailVC?.recipeNumber = (sender as? String)!
      
      let dict = sender as? [String:Any]
      
      recipeDetailVC?.recipeNumber = "\(dict!["recipe_code"]!)"
      recipeDetailVC?.recipePersonalized = "\(dict!["personalised_id"]!)"
      recipeDetailVC?.recipeLikeStatus = "0"
      
      /*
       let likeStatusFromCachedData = getLikeStausFromCachedData(recipeId: "\(dict!["recipe_id"]!)")
       if likeStatusFromCachedData.0{
       recipeDetailVC?.recipeLikeStatus = likeStatusFromCachedData.1
       }else{
       recipeDetailVC?.recipeLikeStatus = "\(dict!["favorite_flag"]!)"
       }
       */
      
      
    }
  }
  
  
}

extension WSRecipeOverViewViewController:UITableViewDelegate, UITableViewDataSource{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if isSearchActive == true {
      if searchResultsArray.count == 0{
        return 0
      }
      return searchResultsArray.count + 1
    }
    return 1
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if isSearchActive == true {
      
      if (indexPath.row == searchResultsArray.count) {
        return CGFloat(self.loadMoreCellHeight)
      }
      return 156
    }
    else {
      if indexPath.row == RECIPE_SWIPE_CELL_TYPE{
        let height = (UIScreen.main.bounds.width - 75) + 150
        return recipeArray.count > 0 ? height : height
      }
      return 100
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell()
    if isSearchActive == false {
      if indexPath.row == RECIPE_SWIPE_CELL_TYPE {
        let recipesSwipeCell:WSRecipeSwipeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WSRecipeSwipeTableViewCell") as! WSRecipeSwipeTableViewCell
        
        recipesSwipeCell.setUI()
        if recipesSwipeCell.swipeView != nil{
          recipesSwipeCell.swipeView.loadedCards.removeAll()
          recipesSwipeCell.swipeView.removeFromSuperview()
          recipesSwipeCell.titleLabel.isHidden = true
          let likeButton = recipesSwipeCell.viewWithTag(200)
          let disLIkeButton = recipesSwipeCell.viewWithTag(100)
          likeButton?.removeFromSuperview()
          disLIkeButton?.removeFromSuperview()
        }
        // recipesSwipeCell.titleLabel.text = "Swipe right if you might"//WSUtility.getlocalizedString(key:"These 👇 catch your eye 👀? Tap recipe for full details.", lang:WSUtility.getLanguage(), table: "Localizable")
        
        // recipesSwipeCell.exploreTitleLabel.text = "You’re all swiped out" //WSUtility.getlocalizedString(key:"Hold up! We got more for you.", lang:WSUtility.getLanguage(), table: "Localizable")!
        // recipesSwipeCell.exploreMoreButton.setTitle("Go to My Recipe ", for: .normal)
        
        recipesSwipeCell.recipies = recipeArray
        recipesSwipeCell.loadCardView()
        recipesSwipeCell.delegate = self
        if recipeArray.count == 0{
          for view in recipesSwipeCell.contentView.subviews{
            view.isHidden = true
          }
          
          recipesSwipeCell.titleLabel.isHidden = !isShowActivityIndicatorOnRecipeView
          recipesSwipeCell.exploreMoreView.isHidden = isShowActivityIndicatorOnRecipeView
          recipesSwipeCell.activityIndicator.startAnimating()
          recipesSwipeCell.activityIndicator.isHidden = !isShowActivityIndicatorOnRecipeView
          
          
        }else{
          for view in recipesSwipeCell.contentView.subviews{
            view.isHidden = false
          }
          recipesSwipeCell.exploreMoreView.isHidden = true
          recipesSwipeCell.addreceipeToCardView(receipeLists: recipeArray)
        }
        
        recipesSwipeCell.bottomExploreButton.isHidden = false
        cell = recipesSwipeCell
      }
    }
    else {
      
      if  indexPath.row == self.searchResultsArray.count {
        let loadMoreCell:WSLoadMoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WSLoadMoreTableViewCell") as! WSLoadMoreTableViewCell
        loadMoreCell.setUI()
        loadMoreCell.delegate = self
        cell = loadMoreCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
      }
      else {
        let recipeListCell : WSRecipeListerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "recipeListerIdentifier", for: indexPath) as! WSRecipeListerTableViewCell
        let dictionary = searchResultsArray[indexPath.row]
        recipeListCell.recipeNameLabel.text = dictionary["name"] as? String
        if let imageUrl = dictionary["previewImageUrl"] as? String {
          recipeListCell.recipeImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
        }
        cell = recipeListCell
      }
      
    }
    return cell
    
  }

  
  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if isSearchActive == true {
      let headerView = UIView(frame: CGRect(x: 0, y: 0, width:self.recipeTableView.frame.size.width , height: 78))
      headerView.backgroundColor = UIColor.white
      let label = UILabel(frame: CGRect(x: 20, y: 27, width: 100, height: 21))
      label.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1)
      if searchResultsArray.count >= 0 && recipeSearchBar.text != ""{
        label.text = "\(resultsFound) \(WSUtility.getlocalizedString(key: "Results", lang: WSUtility.getLanguage(), table: "Localizable")!)"
      }
      label.font = UIFont (name: "DINPro-Regular", size: 16)
      headerView.addSubview(label)
      return headerView
    }
    else {
      return nil
    }
  }
  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if isSearchActive == true {
      return 78
    }
    return 0
  }
  
}
extension WSRecipeOverViewViewController:WSRecipesSwipeTableViewCellDelegate{
  func stopTableViewScroll() {
    // print("table stop Scrolling")
    self.recipeTableView.isScrollEnabled = false
  }
  func startTableViewScroll() {
    self.recipeTableView.isScrollEnabled = true
  }
  
  func exploreMoreAction(recipeTableViewCell: WSRecipeSwipeTableViewCell) {
    // self.tabBarController?.selectedIndex = 3
  }
  
  func tappedOnRecipeCard(recipeInfo: [String : String]) {
    // let recipeNumber = recipeInfo["recipe_code"]
    self.performSegue(withIdentifier: "RecipeDetailVcSegue", sender: recipeInfo)
    WSUtility.sendTrackingEvent(events: "Other", categories: "Recipe click",actions: "\(recipeInfo["Title"] ?? "") - \(recipeInfo["recipe_code"] ?? "")")
  }
  
  func removeSelectedRecipeObjectFromMainArray(personalized_id:String){
    print("card index",personalized_id)
    
    if let i = recipeArray.index(where: { $0.recipe_Personalized_id == personalized_id }) {
      print("removed index", i)
      recipeArray.remove(at: i)
    }
    
  }
  
  func removeAllRecipeObject(cell: WSRecipeSwipeTableViewCell) {
    recipeArray.removeAll()
    recipeTableView.reloadData()
  }
}

extension WSRecipeOverViewViewController : UISearchBarDelegate {
  
  public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    //isSearchActive = true
   // self.recipeTableView.reloadData()
    
    self.performSegue(withIdentifier: "RecipeSearchSegue", sender: self)
  }
  
  public func searchBarTextDidEndEditing(_ searchBar: UISearchBar)  {
    //  isSearchActive = false
  }
  
  public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    /*
    searchBar.resignFirstResponder()
    searchResultsArray.removeAll()
     self.searchString = searchBar.text!.trimmingCharacters(in: .whitespaces)
    //self.searchString = searchBar.text!
    resultsFound = 0
    currentPage = 0
    recipeTableView.reloadData()
    getRecipeSearch(loadMoreCell:nil)
 */
  }
  
  public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.cancelSearchButton.isHidden = false
    isSearchActive = true
    // searchBar.enablesReturnKeyAutomatically = false
    // self.recipeTableView.reloadData()
  }
  
}
extension WSRecipeOverViewViewController:WSLoadMoreTableViewCellDelegate{
  
  func loadMoreButtonAction(loadMoreCell: WSLoadMoreTableViewCell) {
    getRecipeSearch(loadMoreCell: loadMoreCell)
  }
}
