//
//  WSProductTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 14/11/2017.
//

import UIKit

@objc protocol RecommendedProductDelegate{
  func didSelectOnRecommendedProdcut(productDetail:[String:Any])
}

class WSProductTableViewCell: UITableViewCell {
  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var subHeaderLabel: UILabel!
  @IBOutlet weak var productCollectionView: UICollectionView!
  
    @IBOutlet weak var allProductsButton: UIButton!
    var delegate:RecommendedProductDelegate?
  var recommended_Prod = [[String:Any]]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      }
    
    func setUI(){
        headerLabel.text = WSUtility.getlocalizedString(key:"We reckon you’ll like these", lang: WSUtility.getLanguage(), table: "Localizable")
        allProductsButton.setTitle(WSUtility.getlocalizedString(key: "All products", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        productCollectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  @IBAction func showAllProductAction(_ sender: UIButton) {
    let tabBarController = window?.rootViewController as? UITabBarController
//    let navInTab:UINavigationController = tabBarController!.viewControllers?[2] as! UINavigationController
//    let storyboard = UIStoryboard(name: "ProductCatalogue", bundle: nil)
//    let destinationViewController = storyboard.instantiateViewController(withIdentifier: "ProductCatalogue") as? WSProductCatalogueViewController
//    navInTab.pushViewController(destinationViewController!, animated: true)

    tabBarController?.selectedIndex = 2
  }
}

extension WSProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return recommended_Prod.count
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    
    if WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
        return CGSize(width: (UIScreen.main.bounds.width/2) - 20, height: 240)
    }
    else{
        return CGSize(width: (UIScreen.main.bounds.width/2) - 20, height: 316)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WSProductCollectionViewCell", for: indexPath) as! WSProductCollectionViewCell
    
    productCell.updateUI(productInfo: recommended_Prod[indexPath.row])
    //productCell.isViewHidden(hide: false)
    
    if WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
        productCell.isViewHidden(hide: true)
    }
    else{
        productCell.isViewHidden(hide: false)
    }
    
//    if (WSUtility.isLoginWithTurkey()) {
//        productCell.isViewHidden(hide: true)
//    }
    return productCell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let productDetailInfo = recommended_Prod[indexPath.row]
    delegate?.didSelectOnRecommendedProdcut(productDetail: productDetailInfo)
  }
}
