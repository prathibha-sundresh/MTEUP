//
//  WSChefRewardDetailViewController.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 27/11/2017.
//

import UIKit

class WSChefRewardDetailViewController: UIViewController {
  @IBOutlet weak var chefRewardTableviewCell: UITableView!
  @IBOutlet weak var loyaltyPointLabel: UILabel!
  
  var productDetail = [String:Any]()
  var products : [HYBProducts] = []
  var isGoalSet = false
  var webServiceBusinessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
  //var backendService:HYBB2CService = (UIApplication.shared.delegate as! HYBAppDelegate).backEndService
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let isGoalSelectedForProduct = productDetail["isGoalSelected"] as? Bool{
      isGoalSet = isGoalSelectedForProduct
    }
    
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.trackingScreens(screenName: "Loyalty Detail Screen")
    UFSGATracker.trackScreenViews(withScreenName: "Loyalty Detail Screen")
    FireBaseTracker.ScreenNaming(screenName: "Loyalty Detail Screen", ScreenClass: String(describing: self))
    FBSDKAppEvents.logEvent("Loyalty Detail Screen")
    
    
    // Do any additional setup after loading the view.
    chefRewardTableviewCell.rowHeight = UITableViewAutomaticDimension;
    chefRewardTableviewCell.estimatedRowHeight = 400;
    
    UISetUP()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func UISetUP()  {
    WSUtility.addNavigationBarBackButton(controller: self)
    WSUtility.setLoyaltyPoint(label: loyaltyPointLabel)
  }
  
  @IBAction func backAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}

extension WSChefRewardDetailViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell()
    if indexPath.row == 0{
      let chefRewardImageCell = tableView.dequeueReusableCell(withIdentifier: "WSChefRewardDetailImageCollectionTableViewCell") as! WSChefRewardDetailImageCollectionTableViewCell
      if let prodName = productDetail["productName"] as? String{
        chefRewardImageCell.titleLabel.text = prodName
      }else if let prodName = productDetail["name"] as? String{
        chefRewardImageCell.titleLabel.text = prodName
      }
      
      chefRewardImageCell.collectionViewHeight.constant = (UIScreen.main.bounds.width) - 10
      let imageArray = [["picName":(productDetail["packshotUrl"] as? String)!]]
      let rewardString = WSUtility.getlocalizedString(key: "This reward is set as your goal", lang: WSUtility.getLanguage(), table: "Localizable")
      chefRewardImageCell.imageArray = imageArray //[(prodcutDetail["packshotUrl"] as? String)!]
      chefRewardImageCell.topSetGoalDisplayLabel.text = isGoalSet ? rewardString! : ""
      
      cell = chefRewardImageCell
    }else{
      let chefRewardAddToCartCell = tableView.dequeueReusableCell(withIdentifier: "WSChefRewardDetailAddToCartTableViewCell") as! WSChefRewardDetailAddToCartTableViewCell
      chefRewardAddToCartCell.loyaltyPointLabel.text = "\(productDetail["cuLoyaltyPoints"]!)"
      
     
        
        if WSUtility.isLoginWithTurkey() {
            var descriptionValue = ""
            for value in 1..<5 {
                if let sellingStoryDict = productDetail["claim\(value)"] as? String {
                    descriptionValue.append("• \(sellingStoryDict)\n")
                }
            }
            chefRewardAddToCartCell.descriptionLabel.text = descriptionValue
        } else {
            if let sellingStoryDict = productDetail["sellingStory"] as? [String:Any]{
                if let sellingStoryText = sellingStoryDict["sellingPointTitle"] as? String{
                    chefRewardAddToCartCell.descriptionLabel.text = sellingStoryText
                }else{
                    chefRewardAddToCartCell.descriptionLabel.text = ""
                }
            }
        }
      
      let productNumber = "• \(WSUtility.getlocalizedString(key: "item number", lang: WSUtility.getLanguage())!): " + (productDetail["productNumber"] as! String)
      let eanNumber = "• \(WSUtility.getlocalizedString(key: "Unit", lang: WSUtility.getLanguage())!) EAN: " + (productDetail["cuEanCode"] as! String)
      
      chefRewardAddToCartCell.articleLabel.text = "\(productNumber) \n \(eanNumber)"
      if WSUtility.isLoginWithTurkey(){
        chefRewardAddToCartCell.prodcutID = productDetail["code"] as! String
      }else{
        chefRewardAddToCartCell.prodcutID = productDetail["productNumber"] as! String
      }
      
      chefRewardAddToCartCell.delegate = self
      
      let selectedGoalID = WSUtility.getGoalId()  
      let goalID = WSUtility.isLoginWithTurkey() ? (productDetail["code"] as! String) : (productDetail["productNumber"] as! String)
      if selectedGoalID  ==  goalID{
        chefRewardAddToCartCell.setGoalBtnHeightConstraint.constant = 0
        chefRewardAddToCartCell.setGoalButton.isHidden = true
        chefRewardAddToCartCell.setGoalButton.setTitle("", for: .normal)
      }else{
        chefRewardAddToCartCell.setGoalBtnHeightConstraint.constant = 40
        chefRewardAddToCartCell.setGoalButton.isHidden = false
        chefRewardAddToCartCell.setGoalButton.setTitle(WSUtility.getlocalizedString(key: "Set as a goal", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        
      }
      chefRewardAddToCartCell.isFromPDP = false
      chefRewardAddToCartCell.setUI()
      chefRewardAddToCartCell.setGoalButton.tag = isGoalSet ? 200 : 100
      cell = chefRewardAddToCartCell
    }
    
    return cell
  }
  func addtoCartPressed (sender: UIButton) {
    let selectedIndex = sender.tag
    // DDLogDebug("Add to cart pressed at row %ld", Int(selectedIndex))
    let indexPath = IndexPath(row: selectedIndex, section: 0)
    let cell = chefRewardTableviewCell.cellForRow(at: indexPath) as? WSChefRewardDetailAddToCartTableViewCell
    addProductToCart(from: cell!, selectedIndex: selectedIndex)
  }
  
  func addProductToCart(from cell: WSChefRewardDetailAddToCartTableViewCell, selectedIndex: Int) {
    
    let product: HYBProducts? = self.products[selectedIndex]
    // let amount = NumberFormatter().number(from: ("1"))
    let variantOption: HYBVariantOption = (product!.variantOptions[0] as? HYBVariantOption)!;
    let cartId = UFSHybrisUtility.uniqueCartId
    //if let currentCart = backendService.currentCartFromCache(){
      UFSProgressView.showWaitingDialog("")
      webServiceBusinessLayer.addToCart(product: (variantOption.code)!, cart_id: cartId, successResponse: {(response) in
        print(response)
        self.retriveCurrentCart()
      }) {(errorMessage) in
        UFSProgressView.stopWaitingDialog()
      }
    //}
  }
  
  func retriveCurrentCart(){
    let addToCartBussinessLogic = WSAddToCartBussinessLogic()
    addToCartBussinessLogic.getCartDetail(forController: self)
    UFSProgressView.stopWaitingDialog()
  }
}

extension WSChefRewardDetailViewController: ChefRewardDetailDelegate {
  func updateQtyString(string: String) {
    //empty
  }
  
  
  
  func actionOnContainerType(packagingType: String, containerType: String, eanCode: String) {
    //empty
  }
  
  func addToCartFromDetailCell(prodCode: String, quantity: String) {
    //empty
  }
  
  func updateCellAfterGoalSet(isGoalSet:Bool) {
    self.isGoalSet = isGoalSet
    self.chefRewardTableviewCell.reloadData()
    
  
    var goalDict = [String:Any]()
    
    if let prodName = productDetail["productName"]{
      goalDict["ProductName"] = prodName
    }else if let prodName = productDetail["name"]{
      goalDict["ProductName"] = prodName
    }
    goalDict["ImageUrl"] = productDetail["packshotUrl"]
    goalDict["LoyaltyPoint"] = productDetail["cuLoyaltyPoints"]
    
    if WSUtility.isLoginWithTurkey(){
       goalDict["ProductId"] = productDetail["code"]
    }else{
       goalDict["ProductId"] = productDetail["productNumber"]
    }
   
    
    UserDefaults.standard.setValue(goalDict, forKey: USER_GOAL_DETAIL_KEY)
  }
  
  
  func showMoreProductInforamtionSection() {
 
  }
    

}
