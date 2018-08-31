//
//  WSRecommendedProdTableViewCell.swift
//  yB2CApp
//
//  Created by Anandita on 11/29/17.
//

import UIKit

@objc protocol WSRecommendedProdCellDelegate {
  func didSelectRecommendedItem(productNumber:String)
}
class WSRecommendedProdTableViewCell: UITableViewCell {
    @IBOutlet weak var RecommendedproductHeightConstraints: NSLayoutConstraint!
    
  @IBOutlet weak var subHeaderLabel: UILabel!
  var recommededProductList: [[String : Any]] = []
  weak var delegate:WSRecommendedProdCellDelegate?
  @IBOutlet weak var recommendedProductCollectionView: UICollectionView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // Initialization code
    
  }
  
  func updateSetUI(recommendedProduct:[[String:Any]]){
    subHeaderLabel.text = WSUtility.getlocalizedString(key: "We reckon you’ll like these", lang: WSUtility.getLanguage(), table: "Localizable")
    
    recommededProductList = recommendedProduct
    recommendedProductCollectionView.reloadData()
    
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

}
extension WSRecommendedProdTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = recommendedProductCollectionView.dequeueReusableCell(withReuseIdentifier: "WSRecommendationProdCollectionViewCell", for: indexPath) as! WSRecommendationProdCollectionViewCell
    cell.setUI(dict: recommededProductList[indexPath.row])
    
    if WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
        cell.isViewHidden(hide: true)
        RecommendedproductHeightConstraints.constant = 360
    }
    else{
        cell.isViewHidden(hide: false)
        RecommendedproductHeightConstraints.constant = 400
    }
    
//    if (WSUtility.isLoginWithTurkey()) {
//        cell.isViewHidden(hide: true)
//        RecommendedproductHeightConstraints.constant = 355
//    } else {
//        cell.isViewHidden(hide: false)
//        RecommendedproductHeightConstraints.constant = 400
//    }
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return recommededProductList.count
  }

  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    var productcodeStr: String = ""
    if let dict = recommededProductList[indexPath.row] as? [String: Any]{
        if let productCode = dict["productNumber"]{
            productcodeStr = "\(productCode)"
        }
      
    }
    delegate?.didSelectRecommendedItem(productNumber: productcodeStr)
    
  }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
//
//        if WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
//            return CGSize(width: (UIScreen.main.bounds.width/2) - 20, height: 240)
//        }
//        else{
//            return CGSize(width: (UIScreen.main.bounds.width/2) - 20, height: 316)
//        }
//    }

}
