//
//  WSChefRewardCatalogueTableViewCell.swift
//  yB2CApp
//
//  Created by Lakshminarayana on 05/12/17.
//

import UIKit

@objc protocol ChefRewardCatalogueCellDelegate{
 func showAllChefRewardCategory()
 func didSelectOnChefRewardCatalogueProduct(productDetail:[String:Any])
}

class WSChefRewardCatalogueTableViewCell: UITableViewCell {

    @IBOutlet weak var chefRewardCollectionView: UICollectionView!
  
    @IBOutlet weak var seeAllChefRewardsButton: UIButton!
    @IBOutlet weak var exploreChefRewardsLabel: UILabel!
    weak var delegate : ChefRewardCatalogueCellDelegate?
  var loyaltyProdcutList = [[String:Any]]()
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCollectionView()
        
    }
  
  func shopNowButtonMultilineSetUp()  {
    seeAllChefRewardsButton.titleLabel!.numberOfLines = 0
    seeAllChefRewardsButton.titleLabel!.adjustsFontSizeToFitWidth = true
    seeAllChefRewardsButton.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
    seeAllChefRewardsButton.titleLabel!.textAlignment = .center
  }

    func updateUI(){
      shopNowButtonMultilineSetUp()
     exploreChefRewardsLabel.text =   WSUtility.getlocalizedString(key: "Explore the Chef Rewards Catalogue", lang: WSUtility.getLanguage(), table: "Localizable")
        
        seeAllChefRewardsButton.setTitle(WSUtility.getlocalizedString(key: "See all Chef Rewards", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func registerCollectionView(){
        chefRewardCollectionView.delegate = self
        chefRewardCollectionView.dataSource = self
    }
  
  func upadateCellContent(ProductDetail:[[String:Any]])  {
    loyaltyProdcutList = ProductDetail
    loyaltyProdcutList = loyaltyProdcutList.sorted {($0["cuLoyaltyPoints"] as! Int) < ($1["cuLoyaltyPoints"] as! Int) }
    chefRewardCollectionView.reloadData()
  }
  
  @IBAction func seaAllCategoryButtonAction(_ sender: UIButton) {
    delegate?.showAllChefRewardCategory()
  }
}
extension WSChefRewardCatalogueTableViewCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loyaltyProdcutList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let chefRewardCell = chefRewardCollectionView.dequeueReusableCell(withReuseIdentifier: "ChefRewardCollectionViewCell", for: indexPath) as! ChefRewardCollectionViewCell
        
        
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
        delegate?.didSelectOnChefRewardCatalogueProduct(productDetail: productInfo)
    }
}
