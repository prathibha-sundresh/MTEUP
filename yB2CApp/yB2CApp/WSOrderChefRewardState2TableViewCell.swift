

//
//  WSChefRewardState2TableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 21/11/2017.
//

import UIKit

@objc protocol WSOrderChefRewardState2Delegate{
  func didSelectOnChefRewardState2Prodcut(productDetail:[String:Any])
  func learnMoreAboutChefRewardState2Action()
}


class WSOrderChefRewardState2TableViewCell: UITableViewCell {
  @IBOutlet weak var buyAndEarnLabel: UILabel!
  @IBOutlet weak var earnRewardsLabel: UILabel!
  @IBOutlet weak var shopNowcontainerView: WSChefRewardShopNowView!
  @IBOutlet weak var pointEarnMessageLabel: UILabel!
  @IBOutlet weak var loyaltyBalanceLabel: UILabel!
  @IBOutlet weak var chefRewardCollectionView: UICollectionView!
  @IBOutlet weak var exploreAllRewardButton: WSDesignableButton!
  
  var loyaltyProdcutList = [[String:Any]]()
  weak var delegate:WSOrderChefRewardState2Delegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  exploreAllRewardButtonMultilineSetUp()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
 
  func exploreAllRewardButtonMultilineSetUp()  {
    exploreAllRewardButton.titleLabel!.numberOfLines = 0
    exploreAllRewardButton.titleLabel!.adjustsFontSizeToFitWidth = true
    exploreAllRewardButton.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
    exploreAllRewardButton.titleLabel!.textAlignment = .center
  }
  
  func upadateCellContent(with ProductDetail:[[String:Any]]) {
    
    
    //WSUtility.setLoyaltyPoint(label: loyaltyBalanceLabel)
    // updateMessage()
    loyaltyProdcutList = ProductDetail
    chefRewardCollectionView.reloadData()
    let loyaltyPoint = UserDefaults.standard.value(forKey: LOYALTY_BALANCE_KEY) as! String
    setUI(loyaltyBalance: loyaltyPoint)
    
  }
  
 
  func setUI(loyaltyBalance:String){
   // buyAndEarnLabel.text = WSUtility.getlocalizedString(key: "Buy and earn Chef rewards", lang: WSUtility.getLanguage(), table: "Localizable")
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
extension WSOrderChefRewardState2TableViewCell : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
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
