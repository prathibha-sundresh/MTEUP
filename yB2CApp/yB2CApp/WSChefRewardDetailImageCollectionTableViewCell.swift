//
//  WSChefRewardDetailImageCollectionTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 27/11/2017.
//

import UIKit

@objc protocol WSChefRewardDetailImageCellDelegate {
  
  @objc optional func showTestMessage()
  func reloadAllProductsRow()
  
}
class WSChefRewardDetailImageCollectionTableViewCell: UITableViewCell {
  
  @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var topSetGoalDisplayLabel: UILabel!
  @IBOutlet weak var imageCollectionView: UICollectionView!
  @IBOutlet weak var favouriteBtn: UIButton!
  
  var productNumber = ""
  var productCode = ""
  var imageArray = [[String:Any]]()
  var delegate: WSChefRewardDetailImageCellDelegate?
  var productArray = [String:Any]()
 
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func updateUI(){
    topSetGoalDisplayLabel?.text = WSUtility.getlocalizedString(key: "This reward is set as your goal", lang: WSUtility.getLanguage(), table: "Localizable")
    
  }
 func updateCellContent(productDetail:[String:Any])  {
        favouriteBtn.isHidden = true
        if let variants = productDetail["variantOptions"] as? [[String:Any]]{
            for varaintInfo in variants{
                
                let varaintDict = varaintInfo["typeOfProduct"] as? [String:Any]
                if varaintDict!["name"] as! String == "CU"{
                    // caseLabel?.text = varaintInfo["packaging"] as? String
                    
                    if WSUtility.isLoginWithTurkey(){
                        if let priceVisible = varaintInfo["priceVisible"] as? Bool{
                            if priceVisible == false{
                                continue
                            }
                        }
                    }
                    
                    
                    if let priceInfo = varaintInfo["priceData"] as? [String:Any]{
//                        if let priceValue = priceInfo["value"] as? Double{
//                            if priceValue == 0{
//                                // print("test->\(priceValue)")
//                                continue
//                            }
//                        }
                    }
                    if let stock = varaintInfo["stock"] as? [String:Any], let stockStatus = stock["stockLevelStatus"] as? String{
                        if stockStatus == StockStatus().IN_STOCK{
                            favouriteBtn.isHidden = false
                        }
                    }
                }else if varaintDict!["name"] as! String == "DU"{
                    // unitLabel?.text = varaintInfo["packaging"] as? String
                    
                    if WSUtility.isLoginWithTurkey(){
                        if let priceVisible = varaintInfo["priceVisible"] as? Bool{
                            if priceVisible == false{
                                continue
                            }
                        }
                    }
                    
                    if let priceInfo = varaintInfo["priceData"] as? [String:Any] {
                        
//                        if let priceValue = priceInfo["value"] as? Double{
//                            if priceValue == 0{
//                                // print("test->\(priceValue)")
//                                continue
//                            }
//                        }
                    }
                    if let stock = varaintInfo["stock"] as? [String:Any], let stockStatus = stock["stockLevelStatus"] as? String{
                        if stockStatus == StockStatus().IN_STOCK{
                             favouriteBtn.isHidden = false
                        }
                    }
                }
            }
        }
  }
    
  func getThumbNailImageFromVariantOption(variantOption:[[String:Any]]) -> String  {
    for varaintInfo in variantOption{
      
      let varaintDict = varaintInfo["typeOfProduct"] as? [String:Any]
      
      
      if varaintDict!["name"] as! String == "CU"{
        // caseLabel?.text = varaintInfo["packaging"] as? String
        if let imageUrl = varaintInfo["thumbnailUrl"] as? String{
          return imageUrl
        }
        
      }else if varaintDict!["name"] as! String == "DU" {
        if let imageUrl = varaintInfo["thumbnailUrl"] as? String{
          return imageUrl
        }
      }
    }
    return ""
  }

  
  func reloadCollectionViewWithVariantOptionImage(images:[[String:Any]]) {
    
    imageArray = images
    self.imageCollectionView.reloadData()
    
  }
  
  func reloadCollectionViewWith(images:[[String:Any]])  {
    var imageUrl = ""
    
    for dict in images{
      if let picName = dict["picName"] as? String{
        if picName == "PackshotPNG" || picName == "Packshot"{
          
          if let image = dict["imageUrl"] as? String,image.hasPrefix("http") {
            imageUrl = image
            break
          }else if let image = dict["uri"] as? String, image.hasPrefix("http"){
            imageUrl = image
            break
          }
          
          
        }
        
        
      }
    }
    
    if imageUrl.count == 0{
      
      if let variants = self.productArray["variantOptions"] as? [[String:Any]] {
        
        let thumbNailImage = getThumbNailImageFromVariantOption(variantOption: variants)
        if thumbNailImage.count > 0{
          imageUrl = thumbNailImage
          
        }
        
      }
      
    }
    
    let ImageDict = ["thumbNailImage":imageUrl]
    imageArray = [ImageDict]
    
    
    
    self.imageCollectionView.reloadData()
  }
  func isProductFavorite(isfavourite:Bool) {
    if isfavourite {
      self.favouriteBtn.setImage(#imageLiteral(resourceName: "star-selected"), for: .normal)
      self.favouriteBtn.isSelected = true
    } else {
      self.favouriteBtn.setImage(#imageLiteral(resourceName: "star"), for: .normal)
      self.favouriteBtn.isSelected = false
    }
  }
  
  func deleteProductFromSifu(productNumber:String)  {
    
    UFSProgressView.showWaitingDialog("")
    let productNumber = "\(productNumber)"
    
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.deleteFavoriteProductFromSifu(productNumber: productNumber, successResponse: { (response) in
      WSUtility.removeFavoriteItem(item: productNumber)
      self.delegate?.reloadAllProductsRow()
      self.favouriteBtn.setImage(#imageLiteral(resourceName: "star"), for: .normal)
      self.favouriteBtn.isSelected = false
      
      UFSProgressView.stopWaitingDialog()
      
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
    }
    
  }
  
  @IBAction func addFavouriteOrUnFavourite(sender: UIButton){
    
    if checkExcludedProductsFoundOrNotForDTO(){
      delegate?.showTestMessage!()
      return
    }
    if favouriteBtn.isSelected {
      WSUtility.removeFavoriteItem(item: self.productNumber)
      deleteProductFromSifu(productNumber: productNumber)
      
    }else{
      
      UFSProgressView.showWaitingDialog("")
      var dict:[String: Any] = [:]
      dict["countryCode"] = WSUtility.getCountryCode()
      dict["favoriteListId"] = "0"
      dict["languageCode"] = WSUtility.getLanguageCode()
      dict["productNumber"] = productNumber
      
      let businessLayer = WSWebServiceBusinessLayer()
      businessLayer.addFavouriteItemRequest(parameter: dict, successResponse: { (response) in
        WSUtility.setProductCode(productNumber: self.productNumber)
        UFSProgressView.stopWaitingDialog()
        self.favouriteBtn.setImage(#imageLiteral(resourceName: "star-selected"), for: .normal)
        self.favouriteBtn.isSelected = true
        self.delegate?.reloadAllProductsRow()
        
      }) { (errorMessage) in
        UFSProgressView.stopWaitingDialog()
      }
      
    }
    
  }
}

extension WSChefRewardDetailImageCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageArray.count > 0 ? 1 : 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    
    return CGSize(width: (UIScreen.main.bounds.width) - 35, height: (UIScreen.main.bounds.width) - 35)
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WSImageCollectionViewCell", for: indexPath) as! WSImageCollectionViewCell
    
    if let imageURL = imageArray[indexPath.row]["uri"] as? String { // Product detail Image
      if imageURL.hasPrefix("http"){
        reloadImageView(imageUrl: imageURL, forCell: productCell)
      }else if let otherImageUrl = imageArray[indexPath.row]["imageUrl"] as? String{
        
        reloadImageView(imageUrl: otherImageUrl, forCell: productCell)
      }
    }else if let imageUrl = imageArray[indexPath.row]["thumbNailImage"]{
      productCell.productImageView.sd_setImage(with: URL(string:imageUrl as! String),  placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }
    else if let imageURL = imageArray[indexPath.row]["picName"] as? String { //Loyalty Product detail
      if imageURL.hasPrefix("http"){
        reloadImageView(imageUrl: imageURL, forCell: productCell)
      }
    }
    
    return productCell
  }
  
  func reloadImageView(imageUrl:String,forCell cell:WSImageCollectionViewCell)  {
    let urlComponents = NSURLComponents(string: imageUrl)
    urlComponents?.user =  "ufsstage"
    urlComponents?.password = "emakina"
    
    cell.productImageView.sd_setImage(with: URL(string:(urlComponents?.string)!), placeholderImage: UIImage(named: "placeholder.png"))
  }
  
  func checkExcludedProductsFoundOrNotForDTO()->Bool{
    // For DTO User
    if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
      let excludedProducts:[String] = UserDefaults.standard.value(forKey: "ExcludedProducts") as! [String]
      //print(excludedProducts)
      let foundExcludedProducts = excludedProducts.filter() { $0 == productNumber }
      //print(foundExcludedProducts)
      if foundExcludedProducts.count > 0{
        return true
      }
      return false
    }
    return false
  }
}
