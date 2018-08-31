//
//  WSRecipeSearchViewController.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 04/01/2018.
//

import UIKit

class WSRecipeSearchViewController: UIViewController {

  @IBOutlet weak var searchTableView: UITableView!
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var cancelSearchButton: UIButton!
  
  @IBOutlet weak var customSearchCohtainer: UIView!
  var searchResultsArray = [[String:Any]]()
  var currentPage = 0
  var resultsFound :Int = 0
  var searchString : String = ""
  var loadMoreCellHeight = 0
    var searchButton = UIButton()
  
  
  override func viewDidLoad() {
        super.viewDidLoad()

    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.trackingScreens(screenName: "Search Recipe screen")
    UFSGATracker.trackScreenViews(withScreenName: "Search Recipe screen")
    FireBaseTracker.ScreenNaming(screenName: "Search Recipe Screen", ScreenClass: String(describing: self))
    FBSDKAppEvents.logEvent("Recipe Favorites Screen")
    FBSDKAppEvents.logEvent(FBSDKAppEventNameSearched)
    
        // Do any additional setup after loading the view.
   // self.navigationController?.isNavigationBarHidden = true
    searchBar.becomeFirstResponder()
    searchBar.showsCancelButton = false
    WSUtility.addNavigationBarBackButton(controller: self)
    WSUtility.addNavigationRightBarButton(toViewController: self)
   
    
    let navigationBar = navigationController!.navigationBar
    navigationBar.setBackgroundImage(UIImage(),
                                     for: .default)
    navigationBar.shadowImage = UIImage()
    
     customSearchCohtainer.addBottomBorderWithColor(color: UIColor(red: 247.0/255.0, green: 245.0/255.0, blue: 243.0/255.0, alpha: 1), width: 1)
    

    }

  override func viewWillAppear(_ animated: Bool) {
    if SHOW_ALL_RECIPES_FROM_SAMPLE_ORDER_SUCCESS{//on tap of explore recipes from Sample product thanky you screen.
        self.navigationController?.popToRootViewController(animated: false)
    }
      WSUtility.setCartBadgeCount(ViewController: self)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    customizeSearchBar()
     searchBar.placeholder = WSUtility.getlocalizedString(key: "Search for a recipe", lang: WSUtility.getLanguage(), table: "Localizable")
    
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
  
  func customizeSearchBar() {
    let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
    textFieldInsideUISearchBar?.clearButtonMode = .never
    let image = #imageLiteral(resourceName: "search")
    //    let imageView = UIImageView(image: image)
    searchButton = UIButton(type:.custom)
    searchButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    searchButton.setImage(image, for: .normal)
    searchButton.addTarget(self, action: #selector(performSearchOperation), for: .touchUpInside)
    searchButton.isEnabled = false
    textFieldInsideUISearchBar?.leftView = nil
    textFieldInsideUISearchBar?.rightView = searchButton
    textFieldInsideUISearchBar?.rightViewMode = .always
    let placeholderLabel = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
    placeholderLabel?.font = UIFont.init(name: "DINPro-Regular", size: 14)
  }
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
      
      if segue.destination is UFSRecipeDetailViewController{
        
        let recipeDetailVC = segue.destination as? UFSRecipeDetailViewController
        
        let dict = sender as? [String:Any]
        recipeDetailVC?.recipeNumber = "\(dict!["number"]!)"
        recipeDetailVC?.recipePersonalized = ""
        recipeDetailVC?.recipeLikeStatus = "0"
        
      }
      
      
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
      
      self.searchTableView.reloadData()
    }) { (errorMessage) in
      loadMoreCell?.activityIndicator.isHidden = true
      //loadMoreCell?.loadmoreButton.isHidden = false
      UFSProgressView.stopWaitingDialog()
      self.searchTableView.reloadData()
      
    }
  }

}

extension WSRecipeSearchViewController: UITableViewDelegate, UITableViewDataSource{
  
  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
   
      let headerView = UIView(frame: CGRect(x: 0, y: 0, width:self.searchTableView.frame.size.width , height: 78))
      headerView.backgroundColor = UIColor.white
      let label = UILabel(frame: CGRect(x: 20, y: 27, width: headerView.frame.size.width - 20, height: 21))
      label.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1)
      if searchResultsArray.count >= 0 && searchBar.text != ""{
        label.text = "(\(resultsFound) \(WSUtility.getlocalizedString(key: "Results", lang: WSUtility.getLanguage(), table: "Localizable")!))"
        let seperatorView = UIView(frame: CGRect(x: 15, y: 77, width:self.view.frame.size.width-30 , height: 1))
        seperatorView.backgroundColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        headerView.addSubview(seperatorView)

      }
      label.font = UIFont (name: "DINPro-Regular", size: 16)
      headerView.addSubview(label)
    

      return headerView
   
  }
  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 78
   
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchResultsArray.count + 1
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if searchResultsArray.count == 0{
      return 0
    }
      if (indexPath.row == searchResultsArray.count) {
        return CGFloat(self.loadMoreCellHeight)
    }
      return 156
    }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell  = UITableViewCell()
    
    
    if  indexPath.row == self.searchResultsArray.count {
      let loadMoreCell:WSLoadMoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WSLoadMoreTableViewCell") as! WSLoadMoreTableViewCell
      loadMoreCell.setUI()
      loadMoreCell.delegate = self
      cell = loadMoreCell
      cell.selectionStyle = UITableViewCellSelectionStyle.none
    }
    else {
      let recipeListCell : WSRecipeListerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WSRecipeListerTableViewCell", for: indexPath) as! WSRecipeListerTableViewCell
      let dictionary = searchResultsArray[indexPath.row]
      if let name =  dictionary["name"] as? String{
         recipeListCell.recipeNameLabel.text = name
      }else{
        recipeListCell.recipeNameLabel.text = ""
      }
     
      if let imageUrl = dictionary["imageUrl"] as? String {
        recipeListCell.recipeImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
      }else if let imageUrl = dictionary["previewImageUrl"] as? String {
        recipeListCell.recipeImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
      }
      else {
        recipeListCell.recipeImage.image = #imageLiteral(resourceName: "placeholder")
      }
      cell = recipeListCell
    }
    
    return cell
    
  }
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if  indexPath.row != self.searchResultsArray.count  {
        let dict = searchResultsArray[indexPath.row]
        
//        var appVersion = ""
//        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
//            appVersion = version
//        }
      

            UFSGATracker.trackEvent(withCategory: "Recipe click", action: "\(dict["name"] as! String) - \(dict["number"]!)", label: "", value: nil)
        self.performSegue(withIdentifier: "ShwowRecipeDetail", sender: dict)
    }
  }
  
  @IBAction func cancelSearch(_ sender: UIButton) {
    
    self.searchResultsArray.removeAll()
    self.searchBar.text = ""
    self.currentPage = 0
    self.cancelSearchButton.isHidden = true
    
    self.searchTableView.reloadData()
    resultsFound = 0
  }
  
}

extension WSRecipeSearchViewController:WSLoadMoreTableViewCellDelegate{
  
  func loadMoreButtonAction(loadMoreCell: WSLoadMoreTableViewCell) {
    getRecipeSearch(loadMoreCell: loadMoreCell)
  }
}

extension WSRecipeSearchViewController : UISearchBarDelegate {
  
  public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
   // self.performSegue(withIdentifier: "RecipeSearchSegue", sender: self)
    searchTableView.reloadData()

  }
  
  public func searchBarTextDidEndEditing(_ searchBar: UISearchBar)  {
    //  isSearchActive = false
    
    
  }
  
  public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    performSearchOperation()
  }
    func performSearchOperation(){
    searchBar.resignFirstResponder()
    searchResultsArray.removeAll()
    self.searchString = searchBar.text!.trimmingCharacters(in: .whitespaces)
    //self.searchString = searchBar.text!
    resultsFound = 0
    currentPage = 0
    searchTableView.reloadData()
    getRecipeSearch(loadMoreCell:nil)
    }
  public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.cancelSearchButton.isHidden = false
    if searchText == "" {
        searchButton.isEnabled = false
    }
    else{
        searchButton.isEnabled = true
    }
  }
  
}
