//
//  WSRecipeSwipeTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 29/11/2017.
//

import UIKit

@objc protocol WSRecipesSwipeTableViewCellDelegate{
  func stopTableViewScroll()
  func startTableViewScroll()
  func tappedOnRecipeCard(recipeInfo:[String:String])
  func exploreMoreAction(recipeTableViewCell:WSRecipeSwipeTableViewCell)
  func removeAllRecipeObject(cell:WSRecipeSwipeTableViewCell)
  func removeSelectedRecipeObjectFromMainArray(personalized_id:String)
  
}

class WSRecipeSwipeTableViewCell: UITableViewCell {
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  var swipeView: DMSwipeCardsView<String>!
  private var count = 0
  weak var delegate:WSRecipesSwipeTableViewCellDelegate?
  
  var cardViewSize = 295
  var cardViewTopPadding = 35
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var recipesCollectionView: UICollectionView!
  
  @IBOutlet weak var exploreMoreView: UIView!
    @IBOutlet weak var seeMoreRecipesLabel: UILabel!
    @IBOutlet weak var titleLabelHeightConstraints: NSLayoutConstraint!
  
  @IBOutlet weak var exploreTitleLabel: UILabel!
  @IBOutlet weak var exploreMoreButton: UIButton!
  @IBOutlet weak var bottomExploreButton: WSDesignableButton!
  
  var recipies = [WSRecipeModal]()
  var isReachedLastIndex = false
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    //cardViewSize = UIScreen.main.bounds.height <= 568 ? 240 : (Int)(UIScreen.main.bounds.width - 40)
    
    cardViewSize = (Int)(UIScreen.main.bounds.width - 50)
    
  }
    func setUI(){
        titleLabel.text = WSUtility.getlocalizedString(key: "Swipe right if you might", lang: WSUtility.getLanguage(), table: "Localizable")
        exploreTitleLabel.text = WSUtility.getlocalizedString(key: "You're all swiped out", lang: WSUtility.getLanguage(), table: "Localizable")
        exploreMoreButton.setTitle(WSUtility.getlocalizedString(key: "Go to My Recipe", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        
        seeMoreRecipesLabel.text = WSUtility.getlocalizedString(key: "See more recipes", lang: WSUtility.getLanguage(), table: "Localizable")
        bottomExploreButton.setTitle(WSUtility.getlocalizedString(key: "Explore all recipes", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func loadCardView()  {
    generateView()
  }
  
  func addreceipeToCardView(receipeLists:[WSRecipeModal])  {
    recipies = receipeLists
    guard receipeLists.count > 0 else {
      return
    }
    self.swipeView.addCards((0...receipeLists.count - 1).map({
      "\($0)"
    }), onTop: true)
  }
  
  func generateView()  {
    
    let viewGenerator: (String, CGRect) -> (UIView) = { (element: String, frame: CGRect) -> (UIView) in
      let container = UIView(frame: CGRect(x: 0, y: 0, width: self.cardViewSize, height: self.cardViewSize - 25))
      
      let index = Int(element)
      let recipesModal:WSRecipeModal = self.recipies[index!]
      
      let cardView:UFSCardView = UFSCardView.instanceFromNib() as! UFSCardView
      cardView.frame = container.frame
      cardView.recepieTitle.frame = CGRect(x: 1, y: cardView.frame.height - 55, width: (UIScreen.main.bounds.width - 42), height: 53)
      
      if recipesModal.recipeImagePath!.hasPrefix("http") {
        cardView.receipeImageView.sd_setImage(with: URL(string: recipesModal.recipeImagePath!), placeholderImage: UIImage(named: "placeholder.png"))
      }else{
        let imagePath = WSUtility.getImagePathFor(imageName: recipesModal.recipeImagePath!)
        cardView.receipeImageView.image = UIImage(contentsOfFile: imagePath)
      }
      
      
      cardView.recepieTitle.text = recipesModal.recipeTitle
      cardView.recepieTitle.roundCorners([.bottomLeft, .bottomRight], radius: 4)
      //cardView.titleLabelWidthConstraints.constant = (UIScreen.main.bounds.width - 40)
      
      //self.personalized_id = recipesModal.recipe_Personalized_id!
      
      // print(self.personalized_id + UFSUtility.getImagePathFor(imageName: recipesModal.recipeImagePath!))
      container.tag = index!
      
      container.addSubview(cardView)
      
      return container
      
    }
    
    let overlayGenerator: (SwipeMode, CGRect) -> (UIView) = { (mode: SwipeMode, frame: CGRect) -> (UIView) in
      let label = UILabel()
      label.frame = CGRect(x: 0, y: 0, width: self.cardViewSize , height: self.cardViewSize - 25)
      label.layer.cornerRadius = 4
      label.backgroundColor = UIColor.clear
      
      label.layer.borderWidth = 4
      label.layer.borderColor = UIColor.white.cgColor
      label.layer.borderColor  = mode == .left ? (ApplicationBlackColor).cgColor : ApplicationOrangeColor.cgColor
      return label
    }
    
    cardViewTopPadding = Int(titleLabel.frame.size.height + 15.0)
    let screenWidth = UIScreen.main.bounds.width
    let frame = CGRect(x: Int(screenWidth/2 - (CGFloat)(cardViewSize/2)), y: cardViewTopPadding, width: cardViewSize, height: cardViewSize)
    swipeView = DMSwipeCardsView<String>(frame: frame,
                                         
                                         viewGenerator: viewGenerator,
                                         overlayGenerator: overlayGenerator)
    swipeView.delegate = self as DMSwipeCardsViewDelegate
    // swipeView.backgroundColor = UIColor.red
    
    swipeView.layer.cornerRadius = 4
    self.contentView.addSubview(swipeView)
    
    addLikeAndDisLikeIcon()
  }
  
  func addLikeAndDisLikeIcon(){
    
    let xAxis = swipeView.frame.origin.x - 25
    let yAxis = swipeView.frame.size.height/2 - 63/2
    
    let disLikeButton = UIButton(type: .custom)
    disLikeButton.frame = CGRect(x: Int(xAxis), y: Int(yAxis + (CGFloat)(cardViewTopPadding)), width: 63, height: 63)
    disLikeButton.tag = 100
    disLikeButton.setImage(#imageLiteral(resourceName: "Recipe-Dislike"), for: .normal)
    //disLikeButton.setTitle("X", for: .normal)
    //disLikeButton.titleLabel?.textAlignment = .center
    disLikeButton.setTitleColor(UIColor.black, for: .normal)
    disLikeButton.addTarget(self, action: #selector(disLikeButtonAction), for: .touchUpInside)
    disLikeButton.backgroundColor = UIColor.white
    disLikeButton.layer.cornerRadius = 32
    self.contentView.addSubview(disLikeButton)
    
    let xAxisLike = (swipeView.frame.origin.x + swipeView.frame.size.width) - 25
    let yAxisLike = swipeView.frame.size.height/2 - 50/2
    
    let likeButton = UIButton(type: .custom)
    likeButton.frame = CGRect(x: Int(xAxisLike), y: Int(yAxisLike + (CGFloat)(cardViewTopPadding)), width: 63, height: 63)
    likeButton.tag = 200
    likeButton.setImage(#imageLiteral(resourceName: "Swipe-Like"), for: .normal)
    likeButton.addTarget(self, action: #selector(likeButtonAction), for: .touchUpInside)
    likeButton.backgroundColor = UIColor.white
    likeButton.layer.cornerRadius = 32
    self.contentView.addSubview(likeButton)
    
  }
  
  func disLikeButtonAction(sender:UIButton){
    let cardView:DMSwipeCard = swipeView.loadedCards.first!
    cardView.leftOverlay?.alpha = 1
    cardView.leftAction()

  }
  
  func likeButtonAction(sender:UIButton){
    let cardView:DMSwipeCard = swipeView.loadedCards.first!
    cardView.rightOverlay?.alpha = 1
    cardView.rightAction()

  }
  
  @IBAction func exploreMoreButtonAction(_ sender: UIButton) {
    delegate?.exploreMoreAction(recipeTableViewCell: self)
  }
  
}

  func favouriteAndunfavouriteAction(likeStatus: Int16, recipePersonalized:String){
    
    // like = 1
    // dislike = 0
    
    var requestDict = [String: Any]()
    requestDict["recipe_code"] = recipePersonalized
    
    requestDict["ISFavorite"] = (likeStatus == 1) ? true : false
    
    let bussinessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    bussinessLayer.favouriteUnfavouriteFromAdmin(parameterDict: requestDict, successResponse: { (response) in
      
     // self.updateRecipeLikeAndUnlikeStatusInDB(recipePersonilisedId: requestDict["personalized_id"] as! String, status: 2)
      
    }) { (errorMessage) in
      print(errorMessage)
      
    }
    
  }

  func updateRecipeLikeAndUnlikeStatusInDB(recipePersonilisedId:String, status:Int16)  {
    /*
    let date = UFSUtility.getCurrentDate(dateFormatString: "yyyy-MM-dd")
    let predicate = NSPredicate(format: "recipeStoreDate == %@ && recipe_Personalized_id == %@", date,recipePersonilisedId)
    UFSCoreDataHandler.updateHomeRecipeStatusInDB(likeOrUnlikeStatus: status, predicate: predicate)
    */
  }
  


extension WSRecipeSwipeTableViewCell: DMSwipeCardsViewDelegate {
  func swipedLeft(_ object: Any) {
    
    let cardIndex = (object as! Int)
    let recipesModal:WSRecipeModal = self.recipies[cardIndex]
    //print("Swiped left: \(recipesModal.recipeTitle, recipesModal.recipe_Personalized_id)")
    favouriteAndunfavouriteAction(likeStatus: 0, recipePersonalized: recipesModal.recipe_Number!)
    //recipies.remove(at: cardIndex)
    
    WSUtility.sendTrackingEvent(events: "Other", categories: "Recipe swipe",actions: "\(recipesModal.recipeTitle ?? "") - \(recipesModal.recipe_Number ?? "")", labels:"Dislike" )
    FireBaseTracker .fireBaseTrackerWith(Events: "Other", Category: "Recipe swipe", Action: "\(recipesModal.recipeTitle ?? "") - \(recipesModal.recipe_Number ?? "")", Label: "Dislike")
    
    var appVersion = ""
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        appVersion = version
    }
    

        UFSGATracker.trackEvent(withCategory: "Recipe swipe", action: "\(recipesModal.recipeTitle ?? "") - \(recipesModal.recipe_Number ?? "")", label: "Dislike", value: nil)
    
    if exploreMoreView.isHidden {
      delegate?.removeSelectedRecipeObjectFromMainArray(personalized_id: recipesModal.recipe_Personalized_id!)
    }else{
      delegate?.removeAllRecipeObject(cell: self)
    }
    
  }
  
  func swipedRight(_ object: Any) {
    let cardIndex = (object as! Int)
    let recipesModal:WSRecipeModal = self.recipies[cardIndex]
    // print("Swiped left: \(recipesModal.recipeTitle, recipesModal.recipe_Personalized_id)")
    favouriteAndunfavouriteAction(likeStatus: 1, recipePersonalized: recipesModal.recipe_Number!)
    WSUtility.sendTrackingEvent(events: "Other", categories: "Recipe swipe",actions: "\(recipesModal.recipeTitle ?? "") - \(recipesModal.recipe_Number ?? "")", labels:"Like" )
    var appVersion = ""
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        appVersion = version
    }
    
    
    UFSGATracker.trackEvent(withCategory: "Recipe swipe", action: "\(recipesModal.recipeTitle ?? "") - \(recipesModal.recipe_Number ?? "")", label: "Like", value: nil)
        FireBaseTracker .fireBaseTrackerWith(Events: "Other", Category: "Recipe swipe", Action: "\(recipesModal.recipeTitle ?? "") - \(recipesModal.recipe_Number ?? "")", Label: "Like")
        
    FBSDKAppEvents.logEvent("add to favorite Button clicked")
    FBSDKAppEvents.logEvent("recipe Button clicked")
    if exploreMoreView.isHidden {
      delegate?.removeSelectedRecipeObjectFromMainArray(personalized_id: recipesModal.recipe_Personalized_id!)
    }else{
      delegate?.removeAllRecipeObject(cell: self)
    }
    
    
  }
  
  func cardTapped(_ object: Any) {
    let cardIndex = (object as! Int)
    print("Tapped on: \(cardIndex)")
    
    let recipesModal:WSRecipeModal = self.recipies[cardIndex]
    let recipe = ["Title":recipesModal.recipeTitle,"banner_image":recipesModal.recipeImagePath,"recipe_code":recipesModal.recipe_Number,"personalised_id":recipesModal.recipe_Personalized_id]
    delegate?.tappedOnRecipeCard(recipeInfo: recipe as! [String : String])
  
    var appVersion = ""
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        appVersion = version
    }
    
    
        UFSGATracker.trackEvent(withCategory: "Recipe click", action: "\(recipesModal.recipeTitle ?? "") - \(recipesModal.recipe_Number ?? "")", label: "", value: nil)
  }
  
  func reachedEndOfStack() {
    print("Reached end of stack")
    //swipeView.isHidden = true
    for view in contentView.subviews{
      view.isHidden = true
    }
    
    exploreMoreView.isHidden = false
    
    
  }
  
  func draggingStarted() {
    delegate?.stopTableViewScroll()
  }
  
  func draggingStopped() {
    delegate?.startTableViewScroll()
  }
}

