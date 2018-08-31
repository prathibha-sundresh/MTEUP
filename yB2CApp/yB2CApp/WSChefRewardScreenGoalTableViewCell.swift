//
//  WSChefRewardScreenGoalTableViewCell.swift
//  yB2CApp
//
//  Created by Lakshminarayana on 05/12/17.
//

import UIKit

@objc protocol WSChefRewardScreenGoalTableViewCellDelegate {
  func openChefRewardCategory()
  func didSelectOnChefRewardProdcut(productDetail:[String:Any])
}

class WSChefRewardScreenGoalTableViewCell: UITableViewCell {

    @IBOutlet weak var joinLoyaltyLogoImage: UIImageView!
  @IBOutlet weak var TopHeaderTextLabel: UILabel!
  @IBOutlet weak var earnPointsLabel: UILabel!
    @IBOutlet weak var orderingText: UILabel!
    @IBOutlet weak var saveForFreeGiftsLabel: UILabel!
    @IBOutlet weak var earnLoyalityLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var earnPointsCollectionView: UICollectionView!
  
    @IBOutlet weak var thirdTickMark: UIImageView!
    @IBOutlet weak var exploreAllRewardButton: WSDesignableButton!
    weak var delegate:WSChefRewardScreenGoalTableViewCellDelegate?
  var loyaltyProdcutList = [[String:Any]]()
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        
        registerCollectionView()
       // pointsLabel.font = UIFont.init(name: "DINPro-Medium", size: 18)
      TopHeaderTextLabel.text = WSUtility.getTranslatedString(forString: "Save for a great reward by setting a goal-CR")
    }
  func shopNowButtonMultilineSetUp()  {
    exploreAllRewardButton.titleLabel!.numberOfLines = 0
    exploreAllRewardButton.titleLabel!.adjustsFontSizeToFitWidth = true
    exploreAllRewardButton.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
    exploreAllRewardButton.titleLabel!.textAlignment = .center
  }
  
    func setUI(){
    
      shopNowButtonMultilineSetUp()
      joinLoyaltyLogoImage.image = UIImage(named: WSUtility.isLoginWithTurkey() ? "trLoyaltyProgrammeIcon" : "TutorialchefRewards")
      var pointString = WSUtility.getTranslatedString(forString: "€ 1") + " = " + WSUtility.getTranslatedString(forString: "ChefReward_1_Point")
        if WSUtility.getCountryCode() == "CH" && WSUtility.getLanguageCode() == "de"{
            pointString =  pointString.replacingOccurrences(of: "€", with: "CHF")
        }
      WSUtility.setAttributedLabel(originalText: pointString, attributedText: WSUtility.getTranslatedString(forString: "ChefReward_1_Point"), forLabel: pointsLabel, withFont: UIFont(name: "DINPro-Bold", size: 17)!, withColor: ApplicationOrangeColor)
      
        earnLoyalityLabel.text = WSUtility.getlocalizedString(key: "Earn loyalty points on all your orders", lang: WSUtility.getLanguage(), table: "Localizable")
        saveForFreeGiftsLabel.text = WSUtility.getlocalizedString(key: "Save for great gifts", lang: WSUtility.getLanguage(), table: "Localizable")
        
        if let dict = UserDefaults.standard.value(forKey: "First_Order_Incentive_Data") as? [String: Any]{
            
            var strProductName = ""
            if let productName = dict["product_name"] as? String{
                strProductName = productName
            }
            if WSUtility.getCountryCode() == "CH" && WSUtility.getLanguageCode() == "fr"{
                if let minValue = dict["minimum_order_amount"]{
                    orderingText.text = String(format: WSUtility.getlocalizedString(key: "Start ordering and get a free X over XX chefrewards", lang: WSUtility.getLanguage(), table: "Localizable")!,strProductName,"\(minValue)")
                }
                
            }
            else{
                if let minValue = dict["minimum_order_amount"]{
                    orderingText.text = String(format: WSUtility.getlocalizedString(key: "Start ordering and get a free X over XX-Home", lang: WSUtility.getLanguage(), table: "Localizable")!,"\(minValue)",strProductName)
                }
                
            }
            
            if WSUtility.getCountryCode() == "CH" && WSUtility.getLanguageCode() == "de"{
                orderingText.text =  orderingText.text?.replacingOccurrences(of: "€", with: "CHF")
            }
            if WSUtility.isLoginWithTurkey(){
                
                if let minValue = dict["minimum_order_amount"]{
                    if "\(minValue)" == "0"{
                        orderingText.text = String(format: WSUtility.getlocalizedString(key: "Free XXX gift for first order", lang: WSUtility.getLanguage(), table: "Localizable")!,strProductName)
                    }
                    
                }
            }
        }
        if orderingText.text == ""{
            thirdTickMark.isHidden = true
        }
       // orderingText.text = WSUtility.getlocalizedString(key: "Start ordering and get a free X over XX chefrewards", lang: WSUtility.getLanguage(), table: "Localizable")
        earnPointsLabel.text = WSUtility.getlocalizedString(key: "Earn points for great rewards", lang: WSUtility.getLanguage(), table: "Localizable")
        
        exploreAllRewardButton.setTitle(WSUtility.getlocalizedString(key:"Explore all reward and set a goal", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func upadateCellContent(ProductDetail:[[String:Any]])  {
    loyaltyProdcutList = ProductDetail
    earnPointsCollectionView.reloadData()
  }
  
  func registerCollectionView(){
        earnPointsCollectionView.delegate = self
        earnPointsCollectionView.dataSource = self

    }
    
  @IBAction func exploreAllRewardButtonAction(_ sender: WSDesignableButton) {
    delegate?.openChefRewardCategory()
  }
}

extension WSChefRewardScreenGoalTableViewCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loyaltyProdcutList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let chefRewardCell = earnPointsCollectionView.dequeueReusableCell(withReuseIdentifier: "ChefRewardCollectionViewCell", for: indexPath) as! ChefRewardCollectionViewCell
        
      
      let productInfo = loyaltyProdcutList[indexPath.row]
      chefRewardCell.itemImageView.sd_setImage(with: URL(string: productInfo["packshotUrl"] as! String), placeholderImage: UIImage(named: "placeholder.png"))
      
      let attributedString = NSMutableAttributedString(string:"\(String(describing: productInfo["cuLoyaltyPoints"]!))")
      attributedString.setColorForText("\(productInfo["cuLoyaltyPoints"]!)", with: UIColor(red: 250.0/255.0, green: 90.0/255.0, blue: 0, alpha: 1), with: UIFont(name: "DINPro-Medium", size: 12.0)!)
      chefRewardCell.rewardPointLabel.attributedText = attributedString
      
        return chefRewardCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 110, height: 130)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productInfo = loyaltyProdcutList[indexPath.row]
        delegate?.didSelectOnChefRewardProdcut(productDetail: productInfo)
    }
}
