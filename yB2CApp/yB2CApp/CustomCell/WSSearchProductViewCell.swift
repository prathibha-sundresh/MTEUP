//
//  WSProductViewCell.swift
//  yB2CApp
//
//  Created by Anandita on 11/21/17.
//

import UIKit

@objc protocol WSSearchProductCellDelegate {
  func actionOnContainerType(packagingType:String, containerType:String, selectedProductCode Code:String)
  func addToCartButtonAction(productCode:String)
//  func storeOrDeleteSelectedCellProductNumber(productNumber:String, actionType:Int)
  func deleteUnfavouriteProductitem(productNumber:String)

}
class WSSearchProductViewCell: UITableViewCell {
  
    var productDetail = [String:Any]()
    
  @IBOutlet weak var productNotvailableLbl: UILabel!
  @IBOutlet weak var hightOfAddToCartBtn: NSLayoutConstraint!
  @IBOutlet weak var hightOfLoyaltyPointsV: NSLayoutConstraint!
  @IBOutlet weak var hightOfRecomentationLbl: NSLayoutConstraint!
    
    
  @IBOutlet weak var productImage: UIImageView!
  @IBOutlet weak var productName: UILabel!
  @IBOutlet weak var productPrice: UILabel!
  @IBOutlet weak var recommendationLabel: UILabel!
  @IBOutlet weak var loyalityPoints: UILabel!
  @IBOutlet weak var unitView: UIView!
  @IBOutlet weak var caseView: UIView!
  @IBOutlet weak var caseLabel: UILabel!
  @IBOutlet weak var casePriceLabel: UILabel!
  @IBOutlet weak var unitLabel: UILabel!
  @IBOutlet weak var unitPriceLabel: UILabel!
  @IBOutlet weak var addToCartButton: WSDesignableButton!
  @IBOutlet weak var pointsLabel: UFSLoyaltyPointLabel!
  
  @IBOutlet weak var addToFavouriteBtn: UIButton!
  weak var delegate:WSSearchProductCellDelegate?
  var isUnitViewSelected = true
  var isCaseViewSelected = false
  
  var selectedProdcutCode = ""
  var productLoyaltyPointForCase = ""
  var productLoyaltyPointForUnit = ""
  var caseValue = ""
  var unitValue = ""
  var cuProductCode = ""
  var duProductCode = ""
  var cuEanCode = ""
  var duEanCode = ""
  var searchProductDetail = [String:Any]()
 
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    unitView.layer.borderColor = ApplicationOrangeColor.cgColor
    caseView.layer.borderColor = Search_UnitBox_UnSelectedColor.cgColor
    self.productNotvailableLbl.text = WSUtility.getTranslatedString(forString: "Product not avilable")
    // let attributedString = NSMutableAttributedString(string:  WSUtility.getlocalizedString(key:"Select the packaging Indicative Price (Excluding VAT)", lang:WSUtility.getLanguage(), table: "Localizable")!)
    
  }
  
  func setUI(dict: [String: Any]){
    productDetail = dict

    let packagingText = WSUtility.getlocalizedString(key: "Select the packaging", lang: WSUtility.getLanguage(), table: "Localizable")
    let excludingVAT = WSUtility.getTranslatedString(forString: "Indicative price (Excluding UAT)")
    
    var attributedString = NSMutableAttributedString(string:packagingText!)
    if !WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
       attributedString = NSMutableAttributedString(string:packagingText! + " \(excludingVAT)")
        attributedString.setColorForText(excludingVAT, with: UIColor(red: 183.0/255.0, green: 183.0/255.0, blue: 183.0/255.0, alpha: 1), with: UIFont(name: "DINPro-Regular", size: 10))
    }

    recommendationLabel.attributedText = attributedString
    addToCartButton.setTitle(WSUtility.getlocalizedString(key:"Add to cart", lang:WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    
    pointsLabel.text = WSUtility.getlocalizedString(key:"Points", lang:WSUtility.getLanguage(), table: "Localizable")
  }
    func isProductFavorite(isfavourite:Bool) {
        if isfavourite {
            self.addToFavouriteBtn.setImage(#imageLiteral(resourceName: "star-selected"), for: .normal)
            self.addToFavouriteBtn.isSelected = true
        } else {
            self.addToFavouriteBtn.setImage(#imageLiteral(resourceName: "star"), for: .normal)
            self.addToFavouriteBtn.isSelected = false
        }
    }
    
    
    func showNoProductAvailable() -> () {
        
        productNotvailableLbl.isHidden = false
        recommendationLabel.isHidden = true
        hightOfAddToCartBtn.constant = 0
        hightOfLoyaltyPointsV.constant = 0
        hightOfRecomentationLbl.constant = 0
        addToFavouriteBtn.isHidden = true
        caseView.isHidden = true
        unitView.isHidden = true
    }
    
    func hideNoProductAvailable() -> () {
        
        productNotvailableLbl.isHidden = true
        recommendationLabel.isHidden = false
        addToFavouriteBtn.isHidden = false
        hightOfAddToCartBtn.constant = 40
        hightOfLoyaltyPointsV.constant = 25
        hightOfRecomentationLbl.constant = 30
        
       
    }
    

  func updateCellContent(productDetail:[String:Any])  {
    searchProductDetail = productDetail
     productName.text = productDetail["name"] as? String
    
    
    showNoProductAvailable()
    
    var tempProductImage = ""
    
    if let variants = productDetail["variantOptions"] as? [[String:Any]] {
      for varaintInfo in variants {
        
        
        if varaintInfo["container"] as! String == "Unit"{
            
            if let thumbnailUrl = varaintInfo["thumbnailUrl"] as? String {
                tempProductImage = thumbnailUrl
            }
            
            if WSUtility.isLoginWithTurkey(){
                if let priceVisible = varaintInfo["priceVisible"] as? Bool{
                    if priceVisible == false{
                        continue
                    }
                }
            }

          // caseLabel?.text = varaintInfo["packaging"] as? String
            if let priceInfo = varaintInfo["priceData"] as? [String:Any]{
//            if let priceValue = priceInfo["value"] as? Double{
//              if priceValue == 0{
//                        // print("test->\(priceValue)")
//                        continue
//                    }
//            }
            var formattedString = ""
            if WSUtility.getCountryCode() == "CH"{
                let x = priceInfo["value"] as? Double
                let y = Double(round(1000*x!)/1000)
                formattedString = "CHF \(y)"
            }
            else{
                if let str = priceInfo["formattedValue"] as? String{
                    formattedString = str
                }
            }
            unitPriceLabel?.text = formattedString.replacingOccurrences(of: ".", with: ",")
            }
          if let packaging = varaintInfo["packaging"]{
            let unitTranslatedText = WSUtility.getTranslatedString(forString: "Unit")
            unitLabel?.text = "\(unitTranslatedText)\n\(packaging)"
            unitValue = "\(packaging)"
          }
          
          unitView?.isHidden = false
          hideNoProductAvailable()

          productLoyaltyPointForUnit = "\(varaintInfo["loyalty"]!)"
          cuProductCode = "\(varaintInfo["code"]!)"
          cuEanCode = "\(varaintInfo["ean"]!)"
          
            
        }else if varaintInfo["container"] as! String == "Case" {
            
            
          // unitLabel?.text = varaintInfo["packaging"] as? String
            
            if let thumbnailUrl = varaintInfo["thumbnailUrl"] as? String {
                tempProductImage = thumbnailUrl
            }
            if WSUtility.isLoginWithTurkey(){
                if let priceVisible = varaintInfo["priceVisible"] as? Bool{
                    if priceVisible == false{
                        continue
                    }
                }
            }
            if let priceInfo = varaintInfo["priceData"] as? [String:Any]{
                
//            if let priceValue = priceInfo["value"] as? Double{
//                    if priceValue == 0{
//                        // print("test->\(priceValue)")
//                        continue
//                    }
//            }
          
            var formattedString = ""
            if WSUtility.getCountryCode() == "CH"{
                let x = priceInfo["value"] as? Double
                let y = Double(round(1000*x!)/1000)
                formattedString = "CHF \(y)"
            }
            else{
                if let str = priceInfo["formattedValue"] as? String{
                    formattedString = str
                }
            }
            
            casePriceLabel?.text = formattedString.replacingOccurrences(of: ".", with: ",")
            }
          if let packaging =  varaintInfo["packaging"]{
            let caseTranslatedText = WSUtility.getTranslatedString(forString: "Case")
            caseLabel?.text = "\(caseTranslatedText)\n\(packaging)"
            caseValue = "\(packaging)"
          }
          
          caseView?.isHidden = false
          hideNoProductAvailable()

          productLoyaltyPointForCase = "\(varaintInfo["loyalty"]!)"
          duProductCode = "\(varaintInfo["code"]!)"
          duEanCode = "\(varaintInfo["ean"]!)"
          
         
        }
      }
    }
    
    if unitView?.isHidden == false{
      let loyaltyPointString =  productLoyaltyPointForUnit
      selectedProdcutCode = cuProductCode
      loyalityPoints.text = loyaltyPointString
      delegate?.actionOnContainerType(packagingType: unitValue, containerType: "Unit", selectedProductCode: cuProductCode)
    }else{
      let loyaltyPointString =  productLoyaltyPointForCase
      selectedProdcutCode = duProductCode
      loyalityPoints.text = loyaltyPointString
      delegate?.actionOnContainerType(packagingType: caseValue, containerType: "Case", selectedProductCode: duProductCode)
    }
    
    
    if let thumbnailUrl = productDetail["thumbnailUrl"] as? String {
      
      let urlComponents = NSURLComponents(string: thumbnailUrl)
      urlComponents?.user =  "ufsstage"
      urlComponents?.password = "emakina"
      
      productImage.sd_setImage(with: URL(string: thumbnailUrl), placeholderImage: UIImage(named: "placeholder.png"), options: .allowInvalidSSLCertificates)
      
    }else if tempProductImage.count > 0{
      
      productImage.sd_setImage(with: URL.init(string:tempProductImage), placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }else{
      productImage.image = #imageLiteral(resourceName: "placeholder")
    }
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  @IBAction func addToCartButtonAction(_ sender: UIButton) {
    delegate?.addToCartButtonAction(productCode:selectedProdcutCode)
    var appVersion = ""

    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        appVersion = version
    }

        UFSGATracker.trackEvent(withCategory: "add to cart", action: "Button click", label: "added product to cart", value: nil)
        FBSDKAppEvents.logEvent("add to cart Button clicked")
  }
  
  @IBAction func buttonActionOnUnitView(_ sender: UIButton) {
    unitView.layer.borderColor = isUnitViewSelected ? Search_UnitBox_UnSelectedColor.cgColor : ApplicationOrangeColor.cgColor
    
    isUnitViewSelected = !isUnitViewSelected
    
    caseView.layer.borderColor = Search_UnitBox_UnSelectedColor.cgColor
    isCaseViewSelected = false
    
    selectedProdcutCode = cuProductCode
    delegate?.actionOnContainerType(packagingType: unitValue, containerType: "Unit", selectedProductCode: cuProductCode)
    loyalityPoints.text = productLoyaltyPointForUnit
  }
  
  @IBAction func buttonActionOnCaseView(_ sender: UIButton) {
    caseView.layer.borderColor = isCaseViewSelected ? Search_UnitBox_UnSelectedColor.cgColor : ApplicationOrangeColor.cgColor
    
    isCaseViewSelected = !isCaseViewSelected
    
    unitView.layer.borderColor = Search_UnitBox_UnSelectedColor.cgColor
    isUnitViewSelected = false
    
     selectedProdcutCode = duProductCode
    delegate?.actionOnContainerType(packagingType: unitValue, containerType: "Case", selectedProductCode: duProductCode)
    loyalityPoints.text = productLoyaltyPointForCase
  }
  
  @IBAction func addFavouriteOrUnFavourite(sender: UIButton){
    
    if addToFavouriteBtn.isSelected {
        delegate?.deleteUnfavouriteProductitem(productNumber: productDetail["number"] as! String)
        addToFavouriteBtn.isSelected = false
        deleteProductFromSifu()
      return
    }
    
    addToFavouriteBtn.isSelected = true
    
    var dict:[String: Any] = [:]
    dict["countryCode"] = WSUtility.getCountryCode()
    dict["favoriteListId"] = "0"
    dict["languageCode"] = WSUtility.getLanguageCode()
    dict["productNumber"] = "\(searchProductDetail["number"]!)"
    
     self.addToFavouriteBtn.setImage(#imageLiteral(resourceName: "star-selected"), for: .normal)
    
    let businessLayer = WSWebServiceBusinessLayer()
    businessLayer.addFavouriteItemRequest(parameter: dict, successResponse: { (response) in
        UFSProgressView.stopWaitingDialog()
        WSUtility.setProductCode(productNumber: self.productDetail["number"] as! String)
    }) { (errorMessage) in
      self.addToFavouriteBtn.isSelected = false
      self.addToFavouriteBtn.setImage(#imageLiteral(resourceName: "star"), for: .normal)
    }
  }
  
    
    func deleteProductFromSifu()  {
        
        UFSProgressView.showWaitingDialog("")
        let productNumber = "\(productDetail["number"]!)"
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.deleteFavoriteProductFromSifu(productNumber: productNumber, successResponse: { (response) in
            WSUtility.removeFavoriteItem(item: productNumber)
//            self.delegate?.reloadAllProductsRow()

            self.addToFavouriteBtn.setImage(#imageLiteral(resourceName: "star"), for: .normal)
            self.addToFavouriteBtn.isSelected = false
//            self.delegate?.storeOrDeleteSelectedCellProductNumber(productNumber: "\(self.productDetail["number"]!)", actionType: 0)
            UFSProgressView.stopWaitingDialog()
            
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        }
        
    }

}


