//
//  UFSProductsTableViewCell.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 03/07/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit
@objc protocol ProductsTableViewCellDelegate{
    func didSelectAtItem(productTableCell:UFSProductsTableViewCell,productBaseId:String)
    
}

class UFSProductsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate:ProductsTableViewCellDelegate?
    var products = [Any]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       titleLabel.text = WSUtility.getTranslatedString(forString: "UFS Ingredients in this recipe")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension UFSProductsTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WSProductCollectionViewCell", for: indexPath) as! WSProductCollectionViewCell
        
        var title = ""
        var imageName = ""
        var price = ""
      var loyaltyPoint = ""
        
        if products is [UFSRecommendedProductModal]{
            let recommendedProductHome = products[indexPath.row] as! UFSRecommendedProductModal
            title = recommendedProductHome.product_name
            
            //cell.productImage.sd_setImage(with: URL(string: recommendedProductHome.product_image_url), placeholderImage: UIImage(named: ""))
            imageName = recommendedProductHome.product_image_url
            var recommendedPrice = recommendedProductHome.product_price
            recommendedPrice = recommendedPrice.replacingOccurrences(of: ".", with: ",")
            
            let countryCode =  WSUtility.getCountryCode()
            if countryCode == "TR" {
                price = "\(recommendedPrice) ₺"
            }
            else {
                price = "€ \(recommendedPrice)"
            }
            
        }else if products is [UFSRecipeDetailIngredients]{
            let recipeDetail:UFSRecipeDetailIngredients = products[indexPath.row] as! UFSRecipeDetailIngredients
            title = recipeDetail.title
            imageName = recipeDetail.imageUrl
            price = "\(recipeDetail.price)"
            
            // cell.productImage.sd_setImage(with: URL(string: imageName), placeholderImage: UIImage(named: "placeholder.png"))
             loyaltyPoint = recipeDetail.loyaltyPoint
        }
      
      cell.productImageView.sd_setImage(with: URL(string: imageName), placeholderImage: UIImage(named: "placeholder.png"), options: .allowInvalidSSLCertificates)
        
        cell.moreInformationBtn.setTitle(WSUtility.getlocalizedString(key: "More information", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        cell.pointsTitle.text = WSUtility.getlocalizedString(key:"Points", lang: WSUtility.getLanguage(), table: "Localizable")
      if WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
        cell.recomendLabel.isHidden = true
      }else{
        cell.recomendLabel.isHidden = false
         cell.recomendLabel.text = WSUtility.getlocalizedString(key:"Recommended price from UFS", lang: WSUtility.getLanguage(), table: "Localizable")
      }
      
      
        //cell.moreButton.setTitle("See more detail", for: .normal)
      
        cell.productNameLabel.text = title
        cell.priceLabel.text = price
        cell.loyaltyPointLabel.text = loyaltyPoint
        if WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
        cell.isViewHidden(hide: true)
        }
        else{
            cell.isViewHidden(hide: false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        if products is [UFSRecommendedProductModal]{
            let recommendedProductHome = products[indexPath.row] as! UFSRecommendedProductModal
          delegate?.didSelectAtItem(productTableCell: self, productBaseId: recommendedProductHome.product_url)
            
        }else if products is [UFSRecipeDetailIngredients]{
          let recipeDetail:UFSRecipeDetailIngredients = products[indexPath.row] as! UFSRecipeDetailIngredients
          delegate?.didSelectAtItem(productTableCell: self, productBaseId: recipeDetail.productNumber)
            
        }
     
  }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
            return CGSize(width: (UIScreen.main.bounds.width/2) - 20, height: 240)
        }
        else{
            return CGSize(width: 190, height: 350)
        }
    }

    
    
}
