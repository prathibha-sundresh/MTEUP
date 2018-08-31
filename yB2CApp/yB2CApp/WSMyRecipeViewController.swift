//
//  WSMyRecipeViewController.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 08/12/2017.
//

import UIKit

class WSMyRecipeViewController: UIViewController {
  @IBOutlet weak var myRecipeTableView: UITableView!
  @IBOutlet weak var noFavoriteLabel: UILabel!
  @IBOutlet weak var myRecipesLabel: UILabel!
    @IBOutlet weak var MyRecipeLabelView: UIView!
    
  var loadMoreCellHeight = 0
  var currentPage = 0
  var recipeArray = [[String:Any]]()
  var selectedIndex: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.trackingScreens(screenName: "Recipe Favorites Screen")
    UFSGATracker.trackScreenViews(withScreenName: "Recipe Favorites Screen")
    FireBaseTracker.ScreenNaming(screenName: "Recipe Favorites Screen", ScreenClass: String(describing: self))
    FBSDKAppEvents.logEvent("Recipe Favorites Screen")
    self.noFavoriteLabel.isHidden = true
  self.noFavoriteLabel.text = WSUtility.getlocalizedString(key:"No_Favourite_Message", lang: WSUtility.getLanguage(), table: "Localizable")
    // Do any additional setup after loading the view.
    WSUtility.addNavigationBarBackButton(controller: self)
    MyRecipeLabelView.addTopBorderWithColor(color: UIColor(red: 247.0/255.0, green: 245.0/255.0, blue: 243.0/255.0, alpha: 1), height: 1,origin_y: 0)
    myRecipeTableView.addBottomBorderWithColor(color: UIColor(red: 247.0/255.0, green: 245.0/255.0, blue: 243.0/255.0, alpha: 1), width: 1)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if SHOW_ALL_RECIPES_FROM_SAMPLE_ORDER_SUCCESS{//on tap of explore recipes from Sample product thanky you screen.
        self.navigationController?.popToRootViewController(animated: false)
    }
    WSUtility.addNavigationRightBarButton(toViewController: self)
    WSUtility.setCartBadgeCount(ViewController: self)
    currentPage = 1
    getAllRecipe(loadMoreCell: nil)
      myRecipesLabel.text = WSUtility.getlocalizedString(key:"My Recipes", lang: WSUtility.getLanguage(), table: "Localizable")
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

  func getAllRecipe(loadMoreCell:WSLoadMoreTableViewCell?) {
    
    if self.currentPage == 1{
      UFSProgressView.showWaitingDialog("")
    }
    
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.getMyRecipes(successResponse: { (response) in
      
      // When there is no data
      if response["NoData"] as? String == "True" {
        self.noFavoriteLabel.isHidden = false
        UFSProgressView.stopWaitingDialog()
        self.recipeArray.removeAll()
        self.myRecipeTableView.reloadData()
      }
      else {
        if self.currentPage == 1{
          self.recipeArray = response["data"] as! [[String:Any]]
        }else{
          let newArray = response["data"] as! [[String:Any]]
          self.recipeArray.append(contentsOf: newArray)
        }
        
        self.currentPage = self.currentPage + 1
        let totalNumberOfProduct = response["total"] as! Int
        // self.recipeCountLabel.text = "(\(response["total"]!) recipes)"
        self.loadMoreCellHeight = (totalNumberOfProduct > self.recipeArray.count) ? 60 : 0
        
        loadMoreCell?.activityIndicator.isHidden = true
        loadMoreCell?.loadmoreButton.isHidden = false
        
        self.myRecipeTableView.reloadData()
        
        UFSProgressView.stopWaitingDialog()
      }
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
    
    if segue.destination is UFSRecipeDetailViewController{
      let recipeDetailVC = segue.destination as? UFSRecipeDetailViewController
      
      let dict = sender as? [String:Any]
      
      recipeDetailVC?.recipeNumber = "\(dict!["recipe_code"]!)"
      recipeDetailVC?.recipePersonalized = "\(dict!["recipe_id"]!)"
      recipeDetailVC?.recipeLikeStatus = "1"
    }
  }
  
}
extension WSMyRecipeViewController: UITableViewDelegate, UITableViewDataSource{
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return recipeArray.count + 1
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell  = UITableViewCell()
    
    
    if indexPath.row == recipeArray.count  {
      let loadMoreCell:WSLoadMoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WSLoadMoreTableViewCell") as! WSLoadMoreTableViewCell
      loadMoreCell.delegate = self
      
      cell = loadMoreCell
    } else {
      
      let dict = recipeArray[indexPath.row]
      let recipeListCell : WSRecipeListerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WSRecipeListerTableViewCell") as! WSRecipeListerTableViewCell
        recipeListCell.setUI()
      recipeListCell.recipeNameLabel.text = dict["title"] as? String
      recipeListCell.recipeImage.sd_setImage(with: URL(string: dict["banner_image_url"] as! String), placeholderImage: UIImage(named: "placeholder.png"))
      recipeListCell.recipeNameLabel.sizeToFit()
    recipeListCell.removeFavButton.setTitle(WSUtility.getlocalizedString(key: "Remove", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
      recipeListCell.removeFavButton.addTarget(self, action: #selector(unfavouriteAction), for: .touchUpInside)
      recipeListCell.removeFavButton.tag = indexPath.row
      cell = recipeListCell
    }
    
    return cell
    
  }
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if indexPath.row == recipeArray.count  {
      return
    }
    
    let dict = recipeArray[indexPath.row]
    
    self.performSegue(withIdentifier: "RecipeDetailSegue", sender: dict)
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == recipeArray.count {
      return CGFloat(loadMoreCellHeight)
    }
    return 156
  }
  
  func unfavouriteAction(sender: UIButton){
    
    selectedIndex = sender.tag
    
    let selectedDict = recipeArray[sender.tag]
    var requestDict = [String: Any]()
    
    requestDict["recipe_code"] = "\(selectedDict["recipe_code"]!)"
    
    requestDict["ISFavorite"] = false
    
    let bussinessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    bussinessLayer.favouriteUnfavouriteFromAdmin(parameterDict: requestDict, successResponse: { (response) in
      
      DispatchQueue.main.async {
        self.recipeArray.remove(at: self.selectedIndex!)
        // self.myRecipeTableView.deleteRows(at: [IndexPath.init(row: self.selectedIndex!, section: 0)], with: .fade)
        
        self.myRecipeTableView.reloadData()
        
        if self.recipeArray.count == 0{
          self.noFavoriteLabel.isHidden = false
        }
      }}) { (errorMessage) in
        print(errorMessage)
        
    }
    
  }
}

extension WSMyRecipeViewController:WSLoadMoreTableViewCellDelegate{
  
  func loadMoreButtonAction(loadMoreCell: WSLoadMoreTableViewCell) {
    getAllRecipe(loadMoreCell: loadMoreCell)
  }
}
