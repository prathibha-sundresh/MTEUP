//
//  WSChefRewardState2TableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 21/11/2017.
//

import UIKit

@objc protocol WSChefRewardState2Delegate{
  func didSelectOnChefRewardState2Prodcut(productDetail:[String:Any])
  func learnMoreAboutChefRewardState2Action()
}


class WSChefRewardState2TableViewCell: UITableViewCell {
    @IBOutlet weak var joinLoyaltyLogoImage: UIImageView!
    @IBOutlet weak var shopNowContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buyAndEarnLabel: UILabel!
  @IBOutlet weak var earnRewardsLabel: UILabel!
  @IBOutlet weak var shopNowcontainerView: WSChefRewardShopNowView!
  @IBOutlet weak var pointEarnMessageLabel: UILabel!
  @IBOutlet weak var loyaltyBalanceLabel: UILabel!
  @IBOutlet weak var chefRewardCollectionView: UICollectionView!
  @IBOutlet weak var exploreAllRewardButton: WSDesignableButton!
  
  var loyaltyProdcutList = [[String:Any]]()
  weak var delegate:WSChefRewardState2Delegate?
 
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
 
  func shopNowButtonMultilineSetUp()  {
    exploreAllRewardButton.titleLabel!.numberOfLines = 0
    exploreAllRewardButton.titleLabel!.adjustsFontSizeToFitWidth = true
    exploreAllRewardButton.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
    exploreAllRewardButton.titleLabel!.textAlignment = .center
  }
    
    func toHideShowNowContainer(hide:Bool) {
        if hide {
            shopNowcontainerView.isHidden = true
            shopNowContainerHeightConstraint.constant = 0
        } else {
            shopNowcontainerView.isHidden = false
            shopNowContainerHeightConstraint.constant = 210
        }
    }
  
  func showDoubleLoyaltyProduct()  {
    
    shopNowcontainerView.subviews.forEach { $0.isHidden = true }
    
    let doubleLoyaltyProductCachedResponse = WSCacheSingleton.shared.cache.object(forKey: Cached_Double_Loyalty_Product_KEY as NSString) as Any
    
    if let dobleLoyaltyProductArray = doubleLoyaltyProductCachedResponse as? [String:Any]{
      
      if dobleLoyaltyProductArray.count > 0{
        shopNowcontainerView.subviews.forEach { $0.isHidden = false }
        
        let prodcutDict = dobleLoyaltyProductArray
        
        var productname = ""
        if let str = prodcutDict["productName"] as? String{
            productname = str
        }
        else if let str = prodcutDict["name"] as? String{
            productname = str
        }
        if productname != ""{
          let productName:String = productname
          
            shopNowcontainerView.termsText.isHidden = true
          
          var captionText = ""
          if (prodcutDict["productLoyaltyRemark"] as? String)?.range(of:"2x") != nil || (prodcutDict["productLoyaltyRemark"] as? String)?.range(of:"2 fach") != nil {
            captionText = String(format: WSUtility.getlocalizedString(key: "Order product and get double loyatly points", lang: WSUtility.getLanguage(), table: "Localizable")!, productName)
            shopNowcontainerView.placeTextLabel.attributedText = self.makeAttributeText(stringVal: captionText, typeStr: WSUtility.getlocalizedString(key: "double loyalty points", lang: WSUtility.getLanguage(), table: "Localizable")!, productName: productName)
          }else if (prodcutDict["productLoyaltyRemark"] as? String)?.range(of:"3x") != nil || (prodcutDict["productLoyaltyRemark"] as? String)?.range(of:"3 fach") != nil{
            captionText = String(format: WSUtility.getlocalizedString(key: "Order product and get triple loyatly points", lang: WSUtility.getLanguage(), table: "Localizable")!, productName)
            
            shopNowcontainerView.placeTextLabel.attributedText = self.makeAttributeText(stringVal: captionText, typeStr: WSUtility.getlocalizedString(key: "triple loyatly points", lang: WSUtility.getLanguage(), table: "Localizable")!, productName: productName)
          }else {
            captionText = String(format: WSUtility.getlocalizedString(key: "Order product and get extra loyatly points", lang: WSUtility.getLanguage(), table: "Localizable")!, productName)
            
            shopNowcontainerView.placeTextLabel.attributedText = self.makeAttributeText(stringVal: captionText, typeStr: WSUtility.getlocalizedString(key: "extra loyatly points", lang: WSUtility.getLanguage(), table: "Localizable")!, productName: productName)
          }
          
          shopNowcontainerView.placeTextLabel.text = captionText
        }
        
        
        
        if let product_image_url = prodcutDict["packshotUrl"] as? String {
          //shopNowcontainerView.shopNowImageView.image = #imageLiteral(resourceName: "thai-yellow-curry-paste")
          shopNowcontainerView.shopNowImageView.sd_setImage(with: URL.init(string:product_image_url), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
        
        shopNowcontainerView.doubleLoyaltyProductcode = "\(prodcutDict["productNumber"] ?? "")"
        
      }
      
    }
  }
    func makeAttributeText(stringVal: String, typeStr: String, productName: String)-> NSMutableAttributedString{
        let range = NSString(string: stringVal).range(of: productName)
        let attributedString = NSMutableAttributedString(string: stringVal)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "DINPro-Bold", size: 16.0)!, range: range)
        let range2 = NSString(string: stringVal).range(of: typeStr)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "DINPro-Bold", size: 16.0)!, range: range2)
        return attributedString
    }
  func upadateCellContent(with ProductDetail:[[String:Any]]) {
    
    showDoubleLoyaltyProduct()
    shopNowButtonMultilineSetUp()
    WSUtility.setLoyaltyPoint(label: loyaltyBalanceLabel)
    // updateMessage()
    // sort products in increasing order
    loyaltyProdcutList = ProductDetail.sorted {($0["cuLoyaltyPoints"] as! Int) < ($1["cuLoyaltyPoints"] as! Int) }
    chefRewardCollectionView.reloadData()
    let loyaltyPoint = UserDefaults.standard.value(forKey: LOYALTY_BALANCE_KEY) as! String
    setUI(loyaltyBalance: loyaltyPoint)
    
  }
  
 
  func setUI(loyaltyBalance:String){
    
    joinLoyaltyLogoImage.image = UIImage(named: WSUtility.isLoginWithTurkey() ? "trLoyaltyProgrammeIcon" : "TutorialchefRewards")
    buyAndEarnLabel.text = WSUtility.getlocalizedString(key: "Buy and earn Chef rewards", lang: WSUtility.getLanguage(), table: "Localizable")
    var firstName = ""
    if let name = UserDefaults.standard.value(forKey: "FirstName"){
      firstName = name as! String
    }
    let earnMorePointString = String(format: WSUtility.getTranslatedString(forString: "Hey James, you've earned 1500 points"),firstName,loyaltyBalance )
    var finalTextString = WSUtility.getlocalizedString(key: "Save for a great reward by setting a goal_Home", lang: WSUtility.getLanguage(), table: "Localizable")
    finalTextString = "\(earnMorePointString)\n \(finalTextString!)"
    
    let checkPoint = String(format: WSUtility.getTranslatedString(forString: "1500 points"),loyaltyBalance )
    WSUtility.setAttributedLabel(originalText: finalTextString!, attributedText: checkPoint, forLabel: pointEarnMessageLabel, withFont: UIFont(name: "DINPro-Medium", size: 15.0)!, withColor: UIColor(white: 51.0 / 255.0, alpha: 1.0))
    
    earnRewardsLabel.text = WSUtility.getlocalizedString(key: "Earn points for great rewards", lang: WSUtility.getLanguage(), table: "Localizable")
    
    exploreAllRewardButton.setTitle(WSUtility.getlocalizedString(key: "Explore all reward and set a goal", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
  }
  @IBAction func exploreRewardButtonAction(_ sender: UIButton) {
    delegate?.learnMoreAboutChefRewardState2Action()
  }
  
}
extension WSChefRewardState2TableViewCell : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return loyaltyProdcutList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    
    return CGSize(width: 110, height: 130)
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let chefRewardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChefRewardCollectionViewCell", for: indexPath) as! ChefRewardCollectionViewCell
    
    let productInfo = loyaltyProdcutList[indexPath.row]
    chefRewardCell.itemImageView.sd_setImage(with: URL(string: productInfo["packshotUrl"] as! String), placeholderImage: UIImage(named: "placeholder.png"))
    
    let attributedString = NSMutableAttributedString(string:"\(String(describing: productInfo["cuLoyaltyPoints"]!))")
    attributedString.setColorForText("\(productInfo["cuLoyaltyPoints"]!)", with: UIColor(red: 250.0/255.0, green: 90.0/255.0, blue: 0, alpha: 1), with: UIFont(name: "DINPro-Medium", size: 12.0)!)
    chefRewardCell.rewardPointLabel.attributedText = attributedString
    
    return chefRewardCell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let productInfo = loyaltyProdcutList[indexPath.row]
    delegate?.didSelectOnChefRewardState2Prodcut(productDetail: productInfo)
  }
  
}
