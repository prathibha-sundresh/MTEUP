//
//  UFSRecipeDetailViewController.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 24/07/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit

class UFSRecipeDetailViewController: UIViewController {
  
    @IBOutlet weak var ingredientsButton: UIButton!
    @IBOutlet weak var preparationButton: UIButton!
    @IBOutlet weak var recipeTableView: UITableView!
    @IBOutlet weak var rightBorderView: UIView!
    @IBOutlet weak var leftBorderView: UIView!
    
    var recipeArray = [[String:Any]]()
    
  var preparationArray = [UFSRecipeDetailPreparation]()
  var ingredientsArray = [UFSRecipeDetailAllIngredients]()
  var otherIngredientsInRecipeArray = [UFSRecipeDetailIngredients]()
  var totalNumberOfSection = 0
  var recipeImageName = ""
  var recipeTitle = ""
  var recipeNumber = "R0064971"
  var recipePersonalized = ""
  var callBack: ((_ likeStatus:String) -> Void)?
  var recipeLikeStatus:String = "0"
  var recipeInfoDict = [String:String]()
  var isLikeStatusUpdated = false
  
  enum SelectedSegment {
    case Preparation
    case Ingredient
  }
  var selectedSegmentIndex:SelectedSegment = .Ingredient
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.getAllRecipe()
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.trackingScreens(screenName: "Recipe Detail Screen")
    UFSGATracker.trackScreenViews(withScreenName: "Recipe Detail Screen")
    FireBaseTracker.ScreenNaming(screenName: "Recipe Detail Screen", ScreenClass: String(describing: self))
    FBSDKAppEvents.logEvent("Recipe Detail Screen")
    
    // Do any additional setup after loading the view.
    
    //recipeLikeStatus = recipeInfoDict["Flag"]
    
    
    // WSUtility.addNavigationRightBarButton(controller: self, image:favImage! , isRoundedCorner: false, isSelected: recipeInfoDict["Flag"] == "1" ? true : false)
    WSUtility.addNavigationBarBackButton(controller: self)
    
    //recipeCode = "14-TR-212447"
    getRecipeCodeFromServer()
    
    recipeTableView.rowHeight = UITableViewAutomaticDimension
    recipeTableView.estimatedRowHeight = 140
    
    self.recipeTableView.isHidden = true
    self.navigationController?.navigationBar.isTranslucent = false
    
    leftBorderView.layer.borderColor = (ApplicationOrangeColor).cgColor
    rightBorderView.layer.borderColor = UIColor.clear.cgColor
    
    preparationButton.setTitle(WSUtility.getlocalizedString(key:"Ingredients", lang:WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    ingredientsButton.setTitle(WSUtility.getlocalizedString(key:"Preparation", lang:WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    sendLastVisitedStatus(recipeCode: recipeNumber)
    var appVersion = ""
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        appVersion = version
    }

    UFSGATracker.trackEvent(withCategory: "view recipe", action: "Button click", label: "viewed recipe", value: nil)
    FBSDKAppEvents.logEvent("view recipe Button clicked")
    
  }
    override func viewWillAppear(_ animated: Bool) {

        if SHOW_ALL_RECIPES_FROM_SAMPLE_ORDER_SUCCESS{//on tap of explore recipes from Sample product thanky you screen.
            self.navigationController?.popToRootViewController(animated: false)
        }

        WSUtility.addNavigationRightBarButton(toViewController: self)
        WSUtility.setCartBadgeCount(ViewController: self)
    }

    @IBAction func rightBarButtonPressed(_ sender: UIButton)  {
        WSUtility.cartButtonPressed(viewController: self)
    }

  override func viewWillDisappear(_ animated: Bool) {
    if let callBackBlock = callBack{
        callBackBlock(recipeLikeStatus)
    }
    
    if isLikeStatusUpdated {
      
      let recipeCachedData = WSCacheSingleton.shared.cache.object(forKey: Cached_Recipe_Like_Status as NSString) as Any
      
      var finalLikeDictArray = [[String:String]]()
      
      if var tempRecipeLikeArray =  recipeCachedData as? [[String:String]]{
        
        let index = tempRecipeLikeArray.index(where: { ( item) -> Bool in
          item["RecipeID"] == recipePersonalized
          
        })
        
        let updateIndexWithNewDict = ["RecipeID":recipePersonalized,"isFavorite":recipeLikeStatus]
        if index != nil{
          tempRecipeLikeArray[index!] = updateIndexWithNewDict as! [String : String]
        }else{
          tempRecipeLikeArray.append(updateIndexWithNewDict as! [String : String])
        }
        finalLikeDictArray = tempRecipeLikeArray
        
      }else{
        
        finalLikeDictArray = [["RecipeID":recipePersonalized,"isFavorite":recipeLikeStatus]]
        
      }
      
      
      WSCacheSingleton.shared.cache.setObject(finalLikeDictArray as AnyObject, forKey: Cached_Recipe_Like_Status as NSString)
      
      
    }
  }
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
    func getAllRecipe() {
        
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.getMyRecipes(successResponse: { (response) in
            
            // When there is no data
            if response["NoData"] as? String == "True" {
                //print(n)
                //UFSProgressView.stopWaitingDialog()
            }
            else {
                self.recipeArray = response["data"] as! [[String:Any]]
                    for index in 0 ..< self.recipeArray.count{
                        let dict = self.recipeArray[index]
                        
                        let recipeNo = dict["recipe_code"] as? String
                        if recipeNo != self.recipeNumber{
                            continue
                        }
                        else{
                            self.recipeLikeStatus = "1"
                            self.recipeTableView.reloadData()
                            break
                        }
                    }
            
            }
        }) { (errorMessage) in
            
            //UFSProgressView.stopWaitingDialog()
        }
    }
    
  @IBAction func backAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func favoriteButtonAction(sender:UIButton) {
    
    isLikeStatusUpdated = true
    let image = sender.isSelected ? #imageLiteral(resourceName: "favoriteSymbolCopy") : #imageLiteral(resourceName: "favoriteSymbolLiked")
    sender.setImage(image, for: .normal)
    sender.isSelected = !sender.isSelected
    
    recipeLikeStatus = sender.isSelected ? "1" : "0"
    favouriteAndunfavouriteAction(likeStatus: sender.isSelected ? 1 : 0, recipeCode: recipeNumber)
    
  }
  
  func leftBarButtonAction(sender:UIButton)  {
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:WSUtility.getlocalizedString(key:"Back", lang: WSUtility.getLanguage(), table: "Localizable"), style: .plain, target: self, action: nil)
    self.performSegue(withIdentifier: "FavouriteSegueID", sender: sender)
  }
  
  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is WSProductDetailViewController{
      let productVC = segue.destination as? WSProductDetailViewController
      productVC?.productCode = (sender as? String)!
      
    }
  }
  
  //MARK: API Call
  func getRecipeDetailFromServer(recipeCode:String)  {
    
    // UFSProgressView.showWaitingDialog("")
    
    let bussinessLayer:WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    bussinessLayer.getRecipeDetailsRequest(recipeCode: recipeCode, methodName: "", successResponse: { (rcipeDetailResponse) in
      
      self.preparationArray = rcipeDetailResponse.0
      self.otherIngredientsInRecipeArray = rcipeDetailResponse.1
      self.ingredientsArray = rcipeDetailResponse.2
      
      //print("otherIngredients Count : %@",self.otherIngredientsInRecipeArray)
      DispatchQueue.main.async {
        self.recipeTableView.reloadData()
        self.recipeTableView.isHidden = false
        UFSGATracker.trackScreenViews(withScreenName: "Ingredients Screen")
        UFSGATracker.trackScreenViews(withScreenName: "Recipe Preparation Screen")

      }
      
        
      UFSProgressView.stopWaitingDialog()
      
    }) { (errorMessage) in
      
      UFSProgressView.stopWaitingDialog()
      WSUtility.showAlertWith(message: errorMessage, title: "UnileverFoodSolutions", forController: self)
    }
  }
  
  func favouriteAndunfavouriteAction(likeStatus: Int16, recipeCode:String){
    
    // like = 1
    // dislike = 0
    
    var requestDict = [String: Any]()
    requestDict["recipe_code"] = recipeCode
    
    requestDict["favorite_flag"] = "\(likeStatus)"
    requestDict["ISFavorite"] =  likeStatus == 1 ? true : false
    if likeStatus == 1{
        var appVersion = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }

        UFSGATracker.trackEvent(withCategory: "recipe", action: "Button click", label: "liked recipe", value: nil)
        FBSDKAppEvents.logEvent("add to favorite Button clicked")
        FBSDKAppEvents.logEvent("recipe Button clicked")
    }
    
    let bussinessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    bussinessLayer.favouriteUnfavouriteFromAdmin(parameterDict: requestDict, successResponse: { (response) in
      
    }) { (errorMessage) in
      print(errorMessage)
      
    }
  }
    func sendLastVisitedStatus(recipeCode:String){
        let bussinessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        bussinessLayer.sendLastVisitedRecipeStatus(recipe_code: recipeCode, successResponse: { (response) in
        }) { (errorMessage) in
        }
    }
  func getRecipeCodeFromServer() {
    
    UFSProgressView.showWaitingDialog("")
    
    let bussinessLayer:WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    bussinessLayer.getRecipeCodeRequest(recipeNumber: recipeNumber, methodName: "", successResponse: { (recipeDictInfo) in
      // UFSProgressView.stopWaitingDialog()
      
      self.recipeImageName = recipeDictInfo["banner_image"]!
      self.getRecipeDetailFromServer(recipeCode: recipeDictInfo["recipe_code"]!)
      self.recipeTitle = recipeDictInfo["title"]!
    
    WSUtility.sendTrackingEvent(events: "Other", categories: "Recipe click",actions:"\(self.recipeTitle) - \(self.recipeNumber)")
    FireBaseTracker.fireBaseTrackerWith(Events: "Other", Category: "Recipe click", Action: "\(self.recipeTitle) - \(self.recipeNumber)")

      
    }) { (errorMessage) in
      
      UFSProgressView.stopWaitingDialog()
      WSUtility.showAlertWith(message: errorMessage, title: "UnileverFoodSolutions", forController: self)
      
    }
    
  }
  
  func modifyIngredientArrayWithNewQuantity(newQuantity:Int)  {
    
    for ingredientProduct in ingredientsArray {
      ingredientProduct.yieldQuantity = "\(newQuantity)"
      let productArray = ingredientProduct.allProducts
      
      for product in productArray {
        
        let oldQuantity = product.quantity
        let baseQuantity = Double(product.baseQuantiy)
        
        var quantiryArray = oldQuantity.components(separatedBy: " ")
        
        guard quantiryArray.count > 0 else {
          break
        }
        
        var finalQuantity = "\(baseQuantity! * Double(newQuantity))"
        //var (finalQuantity, newWeightType) = weightConversion(quantity: (baseQuantity! * Double(newQuantity)), weightType: quantiryArray[1])
        let finalQuantityArray = finalQuantity.components(separatedBy: ".")
        if finalQuantityArray.count > 1 {
          
          let stringAfterDecimal = finalQuantityArray[1]
          if stringAfterDecimal == "0" {
            finalQuantity = finalQuantityArray[0]
          }else if stringAfterDecimal.characters.count > 1{
            
            let trimmedStringAfterDecimal = String(stringAfterDecimal.characters.dropLast(stringAfterDecimal.characters.count - 2 ))
            finalQuantity = "\(finalQuantityArray[0]).\(trimmedStringAfterDecimal)"
          }
          
        }
        
        product.quantity = "\(finalQuantity) \(quantiryArray[1])"
        
      }
      
    }
    
    recipeTableView.reloadData()
  }
  
  func weightConversion(quantity:Double, weightType:String) -> (String,String) {
    
    var newWeightType = weightType
    var convertedQuantity = "\(quantity)"
    if quantity >= 1000 {
      if weightType == "g" {
        convertedQuantity = "\(quantity/1000.0)"
        newWeightType = "kg"
      }
      
    }
    
    return (convertedQuantity,newWeightType)
  }
//    func ingredientsButtonAction(segmentTableViewCell: UFSRecipeDetailSegmentTableViewCell) {
//        selectedSegmentIndex = .Ingredient
//        recipeTableView.reloadData()
//    }
//    
//    func preparationButtonAction(segmentTableViewCell: UFSRecipeDetailSegmentTableViewCell) {
//        selectedSegmentIndex = .Preparation
//        
//        UIView.transition(with: recipeTableView,
//                          duration: 0.35,
//                          options: .transitionCrossDissolve,
//                          animations: { self.recipeTableView.reloadData() })
//        // recipeTableView.reloadData()
//    }
    @IBAction func preparationAction(_ sender: UIButton) {
        leftBorderView.backgroundColor = (ApplicationOrangeColor)
        // sender.backgroundColor = UIColor(red: 250.0 / 255.0, green: 242.0 / 255.0, blue: 233.0 / 255.0, alpha: 1)
        sender.setTitleColor(ApplicationBlackColor, for: .normal)
        ingredientsButton.setTitleColor(UIColor(red: 183.0 / 255.0, green: 183.0 / 255.0, blue: 183.0 / 255.0, alpha: 1), for: .normal)
        
        // buttonPreparation.backgroundColor = UIColor.white
        rightBorderView.backgroundColor = UIColor.clear
        selectedSegmentIndex = .Ingredient
        recipeTableView.reloadData()
    }
    @IBAction func ingredientsAction(_ sender: UIButton) {

        rightBorderView.backgroundColor = (ApplicationOrangeColor)
        //  sender.backgroundColor = UIColor(red: 250.0 / 255.0, green: 242.0 / 255.0, blue: 233.0 / 255.0, alpha: 1)
        sender.setTitleColor(ApplicationBlackColor, for: .normal)
        
        preparationButton.setTitleColor(UIColor(red: 183.0 / 255.0, green: 183.0 / 255.0, blue: 183.0 / 255.0, alpha: 1), for: .normal)
        // buttonIngredient.backgroundColor = UIColor.white
        leftBorderView.backgroundColor = UIColor.clear
 
        selectedSegmentIndex = .Preparation
        
        UIView.transition(with: recipeTableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.recipeTableView.reloadData() })
        

    }
    
}

extension UFSRecipeDetailViewController:UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    totalNumberOfSection = 1 + (selectedSegmentIndex == .Preparation ? preparationArray.count : ingredientsArray.count + 1)
    
    
    if selectedSegmentIndex == .Ingredient && otherIngredientsInRecipeArray.count > 0 {
      totalNumberOfSection += 1
    }
    
    return totalNumberOfSection
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if selectedSegmentIndex == .Ingredient {
      if otherIngredientsInRecipeArray.count > 0 {
        if (section < 3) {
          return 1
        }else{
          let numberOfExcludedSection = (otherIngredientsInRecipeArray.count > 0) ? 3 : 2
          let ingredients = ingredientsArray[section - numberOfExcludedSection]
          return ingredients.allProducts.count
        }
      }else if (section < 2 ) {
        return 1
      }else {
        let numberOfExcludedSection = (otherIngredientsInRecipeArray.count > 0) ? 3 : 2
        let ingredients = ingredientsArray[section - numberOfExcludedSection]
        return ingredients.allProducts.count
      }
    }
    
    return 1
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if selectedSegmentIndex == .Ingredient && (otherIngredientsInRecipeArray.count > 0 && indexPath.section == 1) {
        if WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
            return  330
        }
        else{
            return 430 //350
        }

    }
    else{
      return UITableViewAutomaticDimension
    }
    
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 || (selectedSegmentIndex == .Ingredient && (otherIngredientsInRecipeArray.count) > 0 && (section == 1 || section == 2)) || (selectedSegmentIndex == .Ingredient && (otherIngredientsInRecipeArray.count) == 0 && section == 1)  {
      return 0
    }
    return 44
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    if section == 0 {
      return UIView()
    }else if selectedSegmentIndex == .Ingredient && (otherIngredientsInRecipeArray.count) > 0 && (section == 1 || section == 2){
      return UIView()
    }else if selectedSegmentIndex == .Ingredient && (otherIngredientsInRecipeArray.count) == 0 && (section == 1) {
      return UIView()
    }
    
    let sectionView:UFSRecipeDetailTableViewSectionView = UFSRecipeDetailTableViewSectionView.instanceFromNib() as! UFSRecipeDetailTableViewSectionView
    sectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44)
    
    if selectedSegmentIndex == .Preparation {
      let preparations = preparationArray[section - 1]
      sectionView.sectionTitleLabel.text = "\(section ). " + "\(preparations.title)"
    }else{
      let excludedSections = (otherIngredientsInRecipeArray.count) > 0 ? 3 : 2
      let ingredients = ingredientsArray[section - excludedSections]
      sectionView.sectionTitleLabel.text = "\(section - (excludedSections-1)). " + "\(ingredients.ingredientTitle)"
    }
    
    return sectionView
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    var cell:UITableViewCell = UITableViewCell()
    
   if indexPath.section == 0 {
      let headerCell:UFSRecipeDetailHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UFSRecipeDetailHeaderTableViewCell") as! UFSRecipeDetailHeaderTableViewCell
      
      if recipeImageName.hasPrefix("http") {
        headerCell.recipeImageView.sd_setImage(with: URL(string: recipeImageName))
      }else{
        headerCell.recipeImageView.image = UIImage(contentsOfFile: recipeImageName)
      }
      
      headerCell.recipeTitleLabel.text = recipeTitle
     let recipeStoryText = preparationArray.count > 0 ? (preparationArray[0]).recipeStory : ""

    if selectedSegmentIndex == .Preparation {
        headerCell.recipeDescriptionTitle.isHidden = true
        headerCell.recipeDescriptionTitle.text = ""
    } else {
        headerCell.recipeDescriptionTitle.isHidden = false
        headerCell.recipeDescriptionTitle.setHTMLFromString(htmlText: recipeStoryText, fontName: "DINPro-Medium", fontSize: 14)
    }

      headerCell.favoriteButton.addTarget(self, action: #selector(favoriteButtonAction), for: .touchUpInside)
    
    headerCell.favoriteButton.setImage((recipeLikeStatus == "1") ? #imageLiteral(resourceName: "favoriteSymbolLiked") : #imageLiteral(resourceName: "favoriteSymbolCopy"), for: .normal)
    headerCell.favoriteButton.isSelected = (recipeLikeStatus == "1") ? true : false
      cell = headerCell
    }
    else{
      
      if selectedSegmentIndex == .Preparation {
  
        cell = prepareToShowPreparationCell(tableView: tableView, indexPath: indexPath)
        
      }else{
        
        if indexPath.section == 1 && otherIngredientsInRecipeArray.count > 0 { // other Ingredient in Recipe
          let otherIngredientCell:UFSProductsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UFSProductsTableViewCell") as! UFSProductsTableViewCell
          otherIngredientCell.delegate = self
          otherIngredientCell.collectionView.register(UINib(nibName: "WSProductCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "WSProductCollectionViewCell")
            
          otherIngredientCell.titleLabel.text = "  \(WSUtility.getTranslatedString(forString: "UFS Ingredients in this recipe"))"
          otherIngredientCell.products = otherIngredientsInRecipeArray
          
          otherIngredientCell.delegate = self
          cell = otherIngredientCell
        }else if (indexPath.section == 2  && otherIngredientsInRecipeArray.count > 0) || (indexPath.section == 1 && otherIngredientsInRecipeArray.count == 0) {
          let incrementCell:UFSRecipeDetailIngredientsIncrementTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UFSRecipeDetailIngredientsIncrementTableViewCell") as! UFSRecipeDetailIngredientsIncrementTableViewCell
          if ingredientsArray.count > 0 {
            let ingredients = ingredientsArray[0]
            incrementCell.quantityLabel.text = "\(ingredients.yieldQuantity)"
            incrementCell.deleagte = self
            cell = incrementCell
          }
          
        }
        else{
          
          cell = prepareToShowIngredientCell(tableView: tableView, indexPath: indexPath)
        }
      }
    }
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if selectedSegmentIndex == .Ingredient {
      
      let excludedSection = (otherIngredientsInRecipeArray.count > 0) ? 2 : 1
      
      if ingredientsArray.count > 0 && indexPath.section > excludedSection{
        
        
        let numberOfExcludedSection = (otherIngredientsInRecipeArray.count > 0) ? 3 : 2
        let ingredients = ingredientsArray[indexPath.section - numberOfExcludedSection]
        //let ingredients = ingredientsArray[indexPath.section - 3]
        let ingredientProducts = ingredients.allProducts[indexPath.row]
        
        if ingredientProducts.isUnileverProduct {
          self.performSegue(withIdentifier: "ProductDetailSegue", sender: ingredientProducts.productNumber)
          
        }
      }
    }
    
  }
  
  func prepareToShowIngredientCell(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell {
    
    var cell:UITableViewCell = UITableViewCell()
    
    let numberOfExcludedSection = (otherIngredientsInRecipeArray.count > 0) ? 3 : 2
    let ingredients = ingredientsArray[indexPath.section - numberOfExcludedSection]
    
    if ingredients.allProducts.count > 0 {
      let ingredientProducts = ingredients.allProducts[indexPath.row]
      
      if ingredientProducts.isUnileverProduct {
        
        let ingredientImageCell:UFSRecipeDetailIngredientsImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UFSRecipeDetailIngredientsImageTableViewCell") as! UFSRecipeDetailIngredientsImageTableViewCell
        ingredientImageCell.setUI()
        //ingredientImageCell.productImageView.sd_setImage(with: URL(string: ingredientProducts.imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
      
        ingredientImageCell.productImageView.sd_setImage(with: URL(string: ingredientProducts.imageUrl), placeholderImage: UIImage(named:""),options: .refreshCached, completed: { (image, error, cacheType, imageURL) in
          // Perform operation.
          if image != nil{
            ingredientImageCell.productImageView.backgroundColor = UIColor.clear
          }
        })
        
        ingredientImageCell.titleLabel.text = ingredientProducts.title
        ingredientImageCell.quantityLabel.text = "\(ingredientProducts.quantity)"
        ingredientImageCell.priceLabel.text = ingredientProducts.price
        ingredientImageCell.loyaltyPointLabel.text = "\(ingredientProducts.loyaltyPoint)"
        cell = ingredientImageCell
        
      }else{
        
        let ingredientCell:UFSRecipeDetailIngredientTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UFSRecipeDetailIngredientTableViewCell") as! UFSRecipeDetailIngredientTableViewCell
        
        ingredientCell.titleLabel.text = ingredientProducts.title
        ingredientCell.quantityLabel.text = ingredientProducts.quantity
        cell = ingredientCell
        
      }
      
    }
    return cell
    
  }
  
  func prepareToShowPreparationCell(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell {
    
    var cell:UITableViewCell = UITableViewCell()
    let preparations = preparationArray[indexPath.section - 1]
    
    
    let preparationCell:UFSRecipeDetailPreparationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UFSRecipeDetailPreparationTableViewCell") as! UFSRecipeDetailPreparationTableViewCell
    preparationCell.descriptionLabel.numberOfLines = 0
    preparationCell.descriptionLabel.lineBreakMode = .byWordWrapping
    // preparationCell.descriptionLabel.attributedText = preparations.preparationDescription.html2AttributedString
    preparationCell.descriptionLabel.setHTMLFromString(htmlText: preparations.preparationDescription, fontName: "DINPro-Regular", fontSize: 14)
    
    cell = preparationCell
    
    return cell
    
  }
  
}

extension UFSRecipeDetailViewController:UFSRecipeDetailSegmentTableViewCellDelegate{
  
  func ingredientsButtonAction(segmentTableViewCell: UFSRecipeDetailSegmentTableViewCell) {
    selectedSegmentIndex = .Ingredient
    recipeTableView.reloadData()
  }
  
  func preparationButtonAction(segmentTableViewCell: UFSRecipeDetailSegmentTableViewCell) {
    selectedSegmentIndex = .Preparation
    
    UIView.transition(with: recipeTableView,
                      duration: 0.35,
                      options: .transitionCrossDissolve,
                      animations: { self.recipeTableView.reloadData() })
    // recipeTableView.reloadData()
  }
}

extension UFSRecipeDetailViewController:RecipeDetailIngredientsIncrementCellDelegate{
  func recipeDetailIngredientIncrementPlusAction(cell: UFSRecipeDetailIngredientsIncrementTableViewCell, quantity: Double) {
    self.modifyIngredientArrayWithNewQuantity(newQuantity: Int(quantity))
  }
  
  func recipeDetailIngredientIncrementMinusAction(cell: UFSRecipeDetailIngredientsIncrementTableViewCell, quantity: Int) {
    self.modifyIngredientArrayWithNewQuantity(newQuantity: quantity)
    
  }
}

extension UFSRecipeDetailViewController:ProductsTableViewCellDelegate{
  
  func didSelectAtItem(productTableCell: UFSProductsTableViewCell, productBaseId: String) {
    // self.movetoWebshopWithUrl(url: productUrl)
    self.performSegue(withIdentifier: "ProductDetailSegue", sender: productBaseId)
  }
  
  func movetoWebshopWithUrl(url: String){
    
  }
}

extension UFSRecipeDetailViewController:RecipeDetailPreparationImageCellDelegate{
  
  func shopButtonAction(sender: UIButton) {
    
  }
}

extension String {
  var html2AttributedString: NSAttributedString? {
    do {
      return try NSAttributedString(data: Data(utf8), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
    } catch {
      print("error:", error)
      return nil
    }
  }
  var html2String: String {
    return html2AttributedString?.string ?? ""
  }
}

extension UILabel {
  func setHTMLFromString(htmlText: String,fontName:String, fontSize:Int) {
    let modifiedFont = NSString(format:"<span style=\"font-family: 'DINPro', '\(fontName)'; font-size: \(fontSize)\">%@</span>" as NSString, htmlText) as String
    
    
    //process collection values
    let attrStr = try! NSAttributedString(
      data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
      options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue],
      documentAttributes: nil)
    
    
    self.attributedText = attrStr
  }
}
