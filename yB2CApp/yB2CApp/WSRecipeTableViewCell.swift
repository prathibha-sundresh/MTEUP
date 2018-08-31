//
//  WSRecipeTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 14/11/2017.
//

import UIKit

@objc protocol RecommendedRecipeCellDelegate{
  func didSelectOnRecipeCell(recipeDetail:[String:Any])
}

class WSRecipeTableViewCell: UITableViewCell {
  @IBOutlet weak var recipeCollectionView: UICollectionView!
  
    @IBOutlet weak var allRecipesLabel: UIButton!
    @IBOutlet weak var recipesTextLabel: UILabel!
  var recipeLists = [[String:Any]]()
  weak var delegate:RecommendedRecipeCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    func setUI(){
        recipesTextLabel.text = WSUtility.getlocalizedString(key: "Recipes", lang: WSUtility.getLanguage(), table: "Localizable")
        allRecipesLabel.setTitle(WSUtility.getlocalizedString(key: "All recipes", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal) 
    }
  @IBAction func showAllRecipeButtonAction(_ sender: UIButton) {
    //let tabBarController = window?.rootViewController as? UITabBarController
   // tabBarController?.selectedIndex = 3
  }
  func reloadCollectionViewWithRecipes(recipes:[[String:Any]]) {
    recipeLists = recipes
    recipeCollectionView.reloadData()
  }

}

extension WSRecipeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return recipeLists.count
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    
    return CGSize(width: 257, height: 258)
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 let recipeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WSRecipeCollectionViewCell", for: indexPath) as! WSRecipeCollectionViewCell
    
    var categoryName = ""
    var recipeName = ""
    var imageUrlPath = ""
    
    
    if let name = recipeLists[indexPath.row]["name"] as? String{
      recipeName = name
    }else if let name = recipeLists[indexPath.row]["title"] as? String{
      recipeName = name
    }
    
    if let catName = recipeLists[indexPath.row]["name"] as? String{
      categoryName = catName
    }else if let catName = recipeLists[indexPath.row]["title"] as? String{
      categoryName = catName
    }
    
    if let imageUrl = recipeLists[indexPath.row]["previewImageUrl"] as? String{
      imageUrlPath = imageUrl
    }else if let imageUrl = recipeLists[indexPath.row]["banner_image_url"] as? String{
      imageUrlPath = imageUrl
    }else if let imageUrl = recipeLists[indexPath.row]["packshotUrl"] as? String{
      imageUrlPath = imageUrl
    }else if let imageUrl = recipeLists[indexPath.row]["imageUrl"] as? String {
      imageUrlPath = imageUrl
    }
    
    //recipeCell.categoryName.text = categoryName
    recipeCell.categoryName.isHidden = true
     recipeCell.titleLabel.text = recipeName
     recipeCell.recipeImageView.sd_setImage(with: URL(string: imageUrlPath), placeholderImage: UIImage(named: "placeholder.png"), options: .allowInvalidSSLCertificates)
   
    
    return recipeCell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.didSelectOnRecipeCell(recipeDetail: recipeLists[indexPath.row])
  }
}
