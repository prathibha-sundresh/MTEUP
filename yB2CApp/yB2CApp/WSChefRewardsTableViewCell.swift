//
//  WSChefRewardsTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 14/11/2017.
//

import UIKit

@objc protocol ChefRewardDelegate{
  func didSelectOnChefRewardProdcut(productDetail:[String:Any])
  func learnMoreAboutChefRewardAction()
  func showAllRewardAction()
}

class WSChefRewardsTableViewCell: UITableViewCell {
  
    @IBOutlet weak var joinLoyaltyLogoImage: UIImageView!
    @IBOutlet weak var shopNowContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shopNowContainerView: WSChefRewardShopNowView!
  @IBOutlet weak var  earnLabel:UILabel!
  @IBOutlet weak var chefRewardCollectionView: UICollectionView!
  @IBOutlet weak var loyaltyPointLabel: UILabel!
  @IBOutlet weak var earnLoyaltyPointText: UILabel!
  @IBOutlet weak var saveGreatGiftText: UILabel!
  @IBOutlet weak var startOrderingText: UILabel!
  @IBOutlet weak var EarnBuyText: UILabel!
  @IBOutlet weak var learnMoreText: UIButton!
  
  weak var delegate:ChefRewardDelegate?
  
  var loyaltyProdcutList = [[String:Any]]()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    /*
     setAttributedText(text: "✓", forLabel: earnLoyaltyPointText)
     setAttributedText(text: "✓", forLabel: saveGreatGiftText)
     setAttributedText(text: "✓", forLabel: startOrderingText)
     */
    
    learnMoreText.titleLabel!.numberOfLines = 0
    learnMoreText.titleLabel!.adjustsFontSizeToFitWidth = true
    learnMoreText.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
    learnMoreText.titleLabel!.textAlignment = .center
  }
  
  @IBAction func learnMoreAboutChefAction(_ sender: Any) {
    delegate?.learnMoreAboutChefRewardAction()
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func reloadCollectionView()  {
    chefRewardCollectionView.reloadData()
  }
  
  func setUI(){
    
    joinLoyaltyLogoImage.image = UIImage(named: WSUtility.isLoginWithTurkey() ? "trLoyaltyProgrammeIcon" : "TutorialchefRewards")
    earnLabel.text = WSUtility.getlocalizedString(key: "Earn points for great rewards", lang: WSUtility.getLanguage(), table: "Localizable")
    EarnBuyText.text = WSUtility.getlocalizedString(key: "Buy and earn Chef rewards", lang: WSUtility.getLanguage(), table: "Localizable")
    
    earnLoyaltyPointText.text = WSUtility.getlocalizedString(key: "Earn loyalty points on all your orders-Home", lang: WSUtility.getLanguage(), table: "Localizable")
    
    saveGreatGiftText.text = WSUtility.getlocalizedString(key: "Save for great gifts-Home", lang: WSUtility.getLanguage(), table: "Localizable")
    if let dict = UserDefaults.standard.value(forKey: "First_Order_Incentive_Data") as? [String: Any]{
        var strProductName = ""
        if let productName = dict["product_name"] as? String{
            strProductName = productName
        }
        if WSUtility.getCountryCode() == "CH" && WSUtility.getLanguageCode() == "fr"{
            if let minValue = dict["minimum_order_amount"]{
                startOrderingText.text = String(format: WSUtility.getlocalizedString(key: "Start ordering and get a free X over XX-Home", lang: WSUtility.getLanguage(), table: "Localizable")!,strProductName,"\(minValue)")
            }
        }
        else{
            if let minValue = dict["minimum_order_amount"]{
                startOrderingText.text = String(format: WSUtility.getlocalizedString(key: "Start ordering and get a free X over XX-Home", lang: WSUtility.getLanguage(), table: "Localizable")!,"\(minValue)",strProductName)
            }
        }
        
        if WSUtility.getCountryCode() == "CH" && WSUtility.getLanguageCode() == "de"{
            startOrderingText.text =  startOrderingText.text?.replacingOccurrences(of: "€", with: "CHF")
        }
        if WSUtility.isLoginWithTurkey(){
            if let minValue = dict["minimum_order_amount"]{
                if "\(minValue)" == "0"{
                    startOrderingText.text = String(format: WSUtility.getlocalizedString(key: "Free XXX gift for first order", lang: WSUtility.getLanguage(), table: "Localizable")!,strProductName)
                }
            }
        }
    }
    
    learnMoreText.setTitle(WSUtility.getlocalizedString(key: "Learn more about Chef Rewards", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    shopNowContainerView.setAttributedText()
  }
  
  func setAttributedText(text:String , forLabel label:UILabel)  {
    let attributedString = NSMutableAttributedString(string: label.text!)
    attributedString.setColorForText(text, with: UIColor(red: 250.0/255.0, green: 90.0/255.0, blue: 0, alpha: 1), with: UIFont(name: "DINPro-Medium", size: 15))
    label.attributedText = attributedString
  }
  /*
   func setAttributedText(text:String , forLabel label:UILabel)  {
   let attributedString = NSMutableAttributedString(string: label.text!)
   attributedString.setColorForText(text, with: UIColor(red: 250.0/255.0, green: 90.0/255.0, blue: 0, alpha: 1), with: UIFont(name: "DINPro-Medium", size: 15))
   label.attributedText = attributedString
   
   }
   
   */
  /*
   func setLoyaltyPoint(loyaltyPoint:String)  {
   let attributedString = NSMutableAttributedString(string: "Your points balance " + "\(loyaltyPoint)")
   attributedString.setColorForText(loyaltyPoint, with: UIColor(red: 250.0/255.0, green: 90.0/255.0, blue: 0, alpha: 1), with: nil)
   loyaltyPointLabel.attributedText = attributedString
   }
   */
    
    func toHideShowNowContainer(hide:Bool) {
        if hide {
            shopNowContainerView.isHidden = true
            shopNowContainerHeightConstraint.constant = 0
        } else {
            shopNowContainerView.isHidden = false
            shopNowContainerHeightConstraint.constant = 210
        }
    }
  
  func updateCellContent(with ProductDetail:[[String:Any]]) {
    WSUtility.setLoyaltyPoint(label: loyaltyPointLabel)
    // sort products in increasing order
    loyaltyProdcutList = ProductDetail.sorted {($0["cuLoyaltyPoints"] as! Int) > ($1["cuLoyaltyPoints"] as! Int) }
    chefRewardCollectionView.reloadData()
  }
  
}

extension WSChefRewardsTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return loyaltyProdcutList.count + 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    
    return CGSize(width: 110, height: 130)
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    var cell = UICollectionViewCell()
    
    if indexPath.row == loyaltyProdcutList.count{
      let chefRewardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WSChefRewardsCollectionViewAllProducts", for: indexPath) as! WSChefRewardsCollectionViewAllProducts
      chefRewardCell.setUI()
      cell = chefRewardCell
    }else{
      let chefRewardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChefRewardCollectionViewCell", for: indexPath) as! ChefRewardCollectionViewCell
      let productInfo = loyaltyProdcutList[indexPath.row]
      chefRewardCell.itemImageView.sd_setImage(with: URL(string: productInfo["packshotUrl"] as! String), placeholderImage: UIImage(named: "placeholder.png"))
      
      let attributedString = NSMutableAttributedString(string:"\(String(describing: productInfo["cuLoyaltyPoints"]!))")
      attributedString.setColorForText("\(productInfo["cuLoyaltyPoints"]!)", with: UIColor(red: 250.0/255.0, green: 90.0/255.0, blue: 0, alpha: 1), with: UIFont(name: "DINPro-Medium", size: 12.0)!)
      chefRewardCell.rewardPointLabel.attributedText = attributedString
      chefRewardCell.pointsTextLabel.text = WSUtility.getTranslatedString(forString: "Points")
      
      cell = chefRewardCell
    }
    
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    if indexPath.row == loyaltyProdcutList.count {
      delegate?.showAllRewardAction()
    }else{
      let productInfo = loyaltyProdcutList[indexPath.row]
      delegate?.didSelectOnChefRewardProdcut(productDetail: productInfo)
    }
    
  }
}
extension NSMutableAttributedString{
  func setColorForText(_ textToFind: String, with color: UIColor, with font: UIFont?) {
    let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
    if range.location != NSNotFound {
      if font == nil{
        addAttribute(NSForegroundColorAttributeName, value: color, range: range)
      }else{
        addAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName: color], range: range)
      }
      
    }
  }
}
