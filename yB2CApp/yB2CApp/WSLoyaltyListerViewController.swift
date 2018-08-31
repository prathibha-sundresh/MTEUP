//
//  WSChefRewardGoalSetViewController.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 27/11/2017.
//

import UIKit

class WSLoyaltyListerViewController: BaseViewController {
  var selectedCategoryCode = "*"
  var selectedCategoryName = ""
  var currentPage = 0
  var loyaltyProduct = [[String:Any]] ()
  var loadMoreCellHeight = 0
  var sortIndex: Int = 3
  var sortedArray = [[String:Any]] ()
  var selectedSortType = WSUtility.getTranslatedString(forString: "Without filter")
  var previousSelectedGoalIndex:IndexPath?
  
  @IBOutlet weak var sortbyButton: UIButton!
  @IBOutlet weak var allRewardsLabel: UILabel!
  @IBOutlet weak var loyaltyPointLabel: UILabel!
  @IBOutlet weak var selectedSortTypeLabel: UILabel!
  @IBOutlet weak var totalProductCountLabel: UILabel!
  @IBOutlet weak var loyaltyTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.trackingScreens(screenName: "Loyalty Listing Screen")
    UFSGATracker.trackScreenViews(withScreenName: "Loyalty Listing Screen")
    FireBaseTracker.ScreenNaming(screenName: "Loyalty Listing Screen", ScreenClass: String(describing: self))
    FBSDKAppEvents.logEvent("Loyalty Listing Screen")
    allRewardsLabel.text = selectedCategoryName
    UISetUP()
    getLoyaltyProductCatlog(loadMoreCell: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    loyaltyTableView.reloadData()
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func UISetUP()  {
    //allRewardsLabel.text = WSUtility.getlocalizedString(key: "All rewards", lang: WSUtility.getLanguage(), table: "Localizable")
    sortbyButton.setTitle(WSUtility.getlocalizedString(key: "Sort by", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    
    WSUtility.addNavigationBarBackButton(controller: self)
    WSUtility.setLoyaltyPoint(label: loyaltyPointLabel)
  }
  
  @IBAction func backAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func setLoyaltyPoint()  {
    let loyaltyBalance = UserDefaults.standard.value(forKey: LOYALTY_BALANCE_KEY) as! String
    let loyalitypointsText = WSUtility.getlocalizedString(key: "Your points balance", lang: WSUtility.getLanguage(), table: "Localizable")
    let attributedString = NSMutableAttributedString(string: loyalitypointsText! + " \(loyaltyBalance)")
    attributedString.setColorForText(loyaltyBalance, with: UIColor(red: 250.0/255.0, green: 90.0/255.0, blue: 0, alpha: 1), with: nil)
    attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "DinPro-Medium", size: 16.0)!, range: NSRange(location: 0, length: attributedString.length))
    loyaltyPointLabel.attributedText = attributedString
  }
  
  // API Call
  func getLoyaltyProductCatlog(loadMoreCell:WSLoadMoreTableViewCell?)  {
    if self.currentPage == 0{
      UFSProgressView.showWaitingDialog("")
    }
    
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.makeLoyaltyProductCatlogRequest(methodName: "", categoryName: selectedCategoryCode, skip: "\(currentPage*100)", take: "100", successResponse: { (response) in
      UFSProgressView.stopWaitingDialog()
      let dictResponse = response as! [String:Any]
      print(dictResponse)
      if self.currentPage == 0{
        if let dictResponse = dictResponse["hits"] as? [[String:Any]]{
          self.loyaltyProduct = dictResponse
        }
        
      }else{
        
        if (dictResponse["hits"] as? [[String:Any]]) != nil {
          let newArray = dictResponse["hits"] as! [[String:Any]]
          self.loyaltyProduct.append(contentsOf: newArray)
          //self.sortedArray = self.loyaltyProduct
          
        }
        else {
          loadMoreCell?.activityIndicator.isHidden = true
          loadMoreCell?.loadmoreButton.isHidden = false
          return
        }
      }
      self.sortArray(type: self.selectedSortType)
      
      self.totalProductCountLabel.text = "(\(dictResponse["found"]!) \(WSUtility.getTranslatedString(forString: "rewards")))"
      self.currentPage = self.currentPage + 1
      let totalNumberOfProduct = dictResponse["found"] as! Int
      self.loadMoreCellHeight = (totalNumberOfProduct > self.loyaltyProduct.count) ? 60 : 0
      
      loadMoreCell?.activityIndicator.isHidden = true
      loadMoreCell?.loadmoreButton.isHidden = false
      
      self.loyaltyTableView.reloadData()
      
    }) { (errorMessage) in
      
      loadMoreCell?.activityIndicator.isHidden = true
      loadMoreCell?.loadmoreButton.isHidden = false
      UFSProgressView.stopWaitingDialog()
    }
  }
  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if segue.identifier == "SortingVC"{
      let sorbyVC = segue.destination as! SortByViewController
      sorbyVC.delegate = self
      //let pointsText = WSUtility.getlocalizedString(key: "Points", lang: WSUtility.getLanguage(), table: "Localizable")
     
      sorbyVC.sortArray = [WSUtility.getTranslatedString(forString: "Up to 500 points"),WSUtility.getTranslatedString(forString: "501 - 1,500 points"),WSUtility.getTranslatedString(forString: "Above 1,501 points"),WSUtility.getTranslatedString(forString: "Without filter")]
      sorbyVC.selectedIndex = sortIndex
    }else if segue.destination is WSChefRewardDetailViewController {
      let chefRewardDetailVc = segue.destination as! WSChefRewardDetailViewController
      chefRewardDetailVc.productDetail = sender as! [String:Any]
    }
  }
  
  @IBAction func sortButtonTapped(_ sender: UIButton) {
    self.performSegue(withIdentifier: "SortingVC", sender: self)
  }
  
  func sortArray(type:String)  {
    
    self.selectedSortTypeLabel.text = type
    
    
    var sortingRange1 = 0
    var sortingRange2 = 0
    if type == WSUtility.getTranslatedString(forString: "Up to 500 points") {
        if WSUtility.isLoginWithTurkey(){
            sortingRange1 = 0
            sortingRange2 = 400
        }
        else{
            sortingRange1 = 0
            sortingRange2 = 500
        }
    }else if type == WSUtility.getTranslatedString(forString: "501 - 1,500 points")  {
        if WSUtility.isLoginWithTurkey(){
            sortingRange1 = 401
            sortingRange2 = 1000
        }
        else{
            sortingRange1 = 501
            sortingRange2 = 1500
        }
      
    }else if type == WSUtility.getTranslatedString(forString: "Above 1,501 points")  {
        if WSUtility.isLoginWithTurkey(){
            sortingRange1 = 1001
            sortingRange2 = 100000
        }
        else{
            sortingRange1 = 1501
            sortingRange2 = 100000
        }
    }else if type == WSUtility.getTranslatedString(forString: "Without filter"){
      sortedArray = loyaltyProduct
        // sort products in increasing order
        sortedArray = sortedArray.sorted {($0["cuLoyaltyPoints"] as! Int) < ($1["cuLoyaltyPoints"] as! Int) }
      return
    }
    let loyaltyPredicate = NSPredicate(format: "cuLoyaltyPoints >= %d AND cuLoyaltyPoints <= %d",sortingRange1,sortingRange2)
    
    sortedArray = loyaltyProduct.filter { loyaltyPredicate.evaluate(with: $0) }
    
    // sort products in increasing order
    sortedArray = sortedArray.sorted {($0["cuLoyaltyPoints"] as! Int) < ($1["cuLoyaltyPoints"] as! Int) }
  }
}

extension WSLoyaltyListerViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sortedArray.count + 1
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == sortedArray.count {
      return CGFloat(loadMoreCellHeight)
    }
    return UITableViewAutomaticDimension
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    var cell = UITableViewCell()
    if indexPath.row == sortedArray.count  {
      let loadMoreCell:WSLoadMoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WSLoadMoreTableViewCell") as! WSLoadMoreTableViewCell
      loadMoreCell.delegate = self
      loadMoreCell.setUI()
      //loadMoreCell.loadmoreButton.setTitle(UFSUtility.getlocalizedString(key:"Load more recipes", lang:UFSUtility.getLanguage(), table: "Localizable"), for: .normal)
      cell = loadMoreCell
    } else {
      let prodcutCell = tableView.dequeueReusableCell(withIdentifier: "WSChefRewardSetGoalTableViewCell") as! WSChefRewardSetGoalTableViewCell
      prodcutCell.delegate = self
      prodcutCell.setUI()
      let prodcutDetail = sortedArray[indexPath.row]
       // print(prodcutDetail)
      let selectedGoalID = WSUtility.getGoalId()
      
      let goalID = WSUtility.isLoginWithTurkey() ? (prodcutDetail["code"] as! String) : (prodcutDetail["productNumber"] as! String)
      
      if  selectedGoalID  ==  goalID {
        prodcutCell.goalSetDisplayLabel.text = WSUtility.getlocalizedString(key: "This reward is set as your goal", lang: WSUtility.getLanguage(), table: "Localizable")
        //prodcutCell.setGoalButton.isEnabled = false
        previousSelectedGoalIndex = indexPath
        prodcutCell.setGoalHeightConstraint.constant = 0
        prodcutCell.setGoalButton.isHidden = true
      }else{
        prodcutCell.goalSetDisplayLabel.text = ""
        // prodcutCell.setGoalButton.isEnabled = true
        prodcutCell.setGoalHeightConstraint.constant = 40
        prodcutCell.setGoalButton.isHidden = false
      }
      
      if let productName = prodcutDetail["productName"] as? String{
       prodcutCell.productNameLabel.text = productName
      }else if let productName = prodcutDetail["name"] as? String{
        prodcutCell.productNameLabel.text = productName
      }
      
      if WSUtility.isLoginWithTurkey(){
         prodcutCell.goalProductID = prodcutDetail["code"] as! String
      }else{
         prodcutCell.goalProductID = prodcutDetail["productNumber"] as! String
      }
     
      
      prodcutCell.productImageView.sd_setImage(with: URL(string: prodcutDetail["packshotUrl"] as! String), placeholderImage: UIImage(named: "placeholder.png"))
      
      prodcutCell.setLoyaltyPoint(loyaltyPoint: ("\(prodcutDetail["cuLoyaltyPoints"] ?? "")"))
      cell = prodcutCell
    }
    
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var prodcutDetail = sortedArray[indexPath.row]
    if previousSelectedGoalIndex != nil && indexPath == previousSelectedGoalIndex{
      prodcutDetail["isGoalSelected"] = true
    }else{
      prodcutDetail["isGoalSelected"] = false
    }
    self.performSegue(withIdentifier: "ChefRewardDetailID", sender: prodcutDetail)
  }
  
}
extension WSLoyaltyListerViewController:WSLoadMoreTableViewCellDelegate {
  
  func loadMoreButtonAction(loadMoreCell: WSLoadMoreTableViewCell) {
    getLoyaltyProductCatlog(loadMoreCell: loadMoreCell)
  }
}

extension WSLoyaltyListerViewController: sortByViewControllerDelegate{
  func sortByName(type: String, selectedRow: Int) {
    sortIndex = selectedRow
    selectedSortType = type
    sortArray(type: type)
     self.totalProductCountLabel.text = "(\(sortedArray.count) \(WSUtility.getTranslatedString(forString: "rewards")))"
    self.loyaltyTableView.reloadData()
    
  }
}

extension WSLoyaltyListerViewController : ChefRewardSetGoalDelegate{
  func reloadTableViewAfterSetGoal(cell: WSChefRewardSetGoalTableViewCell) {
    
    let indexPath = loyaltyTableView.indexPath(for: cell)
    let productDetail = sortedArray[(indexPath?.row)!]
    //cell.setGoalHeightConstraint.constant = 0
    if previousSelectedGoalIndex == nil{
      loyaltyTableView.reloadRows(at: [indexPath!], with: .automatic)
      
    }else{
      // let previousSelectedCell = loyaltyTableView.cellForRow(at: previousSelectedGoalIndex!) as? WSChefRewardSetGoalTableViewCell
      // previousSelectedCell?.setGoalHeightConstraint.constant = 40
      loyaltyTableView.reloadRows(at: [indexPath!,previousSelectedGoalIndex!], with: .automatic)
    }
    
    previousSelectedGoalIndex = indexPath
    var goalDict = [String:Any]()
    if let prodName = productDetail["productName"]{
      goalDict["ProductName"] = prodName
    }else if let prodName = productDetail["name"]{
      goalDict["ProductName"] = prodName
    }
    
    goalDict["ImageUrl"] = productDetail["packshotUrl"]
    goalDict["LoyaltyPoint"] = productDetail["cuLoyaltyPoints"]
    goalDict["ProductId"] = productDetail["productNumber"]
    
    UserDefaults.standard.setValue(goalDict, forKey: USER_GOAL_DETAIL_KEY)
    
  }
}
