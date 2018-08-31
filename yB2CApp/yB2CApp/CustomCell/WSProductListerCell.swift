//
//  WSProductListerCell.swift
//  yB2CApp
//
//  Created by Anandita on 11/30/17.
//

import UIKit

@objc protocol ProductListerCellDeleagte {
  
  func didselectOnProductCell(productDetail:[String:Any])
  func addToCartFromProductList(productCode:String)
  func storeOrDeleteSelectedCellProductNumber(productNumber:String, actionType:Int)
  func deleteUnfavouriteProductitem(productNumber:String)
}

class WSProductListerCell: UITableViewCell {
  
  @IBOutlet weak var productNotAvailableLabel: UILabel!
  @IBOutlet weak var prodImage: UIImageView!
  @IBOutlet weak var prodName: UILabel!
  @IBOutlet weak var unitView: UIView!
  @IBOutlet weak var caseView: UIView!
  
  @IBOutlet weak var favButton: UIButton!
  @IBOutlet weak var unitButton: UIButton!
  @IBOutlet weak var caseButton: UIButton!
  
  @IBOutlet weak var loyalityPoints: UILabel!
  @IBOutlet weak var pointsLabel: UFSLoyaltyPointLabel!
  @IBOutlet weak var loyaltyContiner: UIView!

    
  @IBOutlet weak var caseTextLabel: UILabel!
  @IBOutlet weak var unitTextLabel: UILabel!
  @IBOutlet weak var singleQuantityPrice: UILabel!
  @IBOutlet weak var multiplePrice: UILabel!
  @IBOutlet weak var singleAmount: UILabel!
  
  @IBOutlet weak var selectPackageLabel: UILabel!
  
  @IBOutlet weak var addToCartButton: UIButton!

  @IBOutlet weak var hightOfselectPkgLbl: NSLayoutConstraint!
  @IBOutlet weak var hightOfaddtoCartBtn: NSLayoutConstraint!
  @IBOutlet weak var loyaltyContinerHight: NSLayoutConstraint!

  // @IBOutlet weak var indicativeLabel: UILabel!
  
  weak var delegate:ProductListerCellDeleagte?
  
  var productDetail = [String:Any]()
  var duProductCode = ""
  var cuProductCode = ""
  var selectedProductCode = ""
  var duLoyaltyPoint = ""
  var cuLoyaltyPoint = ""
  var cellIndex = Int()
  // var selectedCellDict = [String]()
  
  fileprivate func unitViewSelected() {
    self.unitView.layer.borderWidth = 1
    self.unitView.layer.borderColor = UIColor.init(red:255/255.0, green:90.0/255.0, blue:0.0/255.0, alpha: 1.0).cgColor
    setDeSelectMode()
    
  }
  
  @IBAction func unitViewButton(_ sender: Any) {
    loyalityPoints.text = cuLoyaltyPoint
    selectedProductCode = cuProductCode
    unitViewSelected()
  }
  
  fileprivate func caseViewSelected() {
    self.caseView.layer.borderWidth = 1
    self.caseView.layer.borderColor = UIColor.init(red:255/255.0, green:90.0/255.0, blue:0.0/255.0, alpha: 1.0).cgColor
    setUnitViewDeSelectMode()
  }
  
  func setDeSelectMode(){
    self.caseView.layer.borderWidth = 1
    self.caseView.layer.borderColor = UIColor.init(red:228/255.0, green:229/255.0, blue:236/255.0, alpha: 1.0).cgColor
  }
  
  func setUnitViewDeSelectMode(){
    
    self.unitView.layer.borderWidth = 1
    self.unitView.layer.borderColor = UIColor.init(red:228/255.0, green:229/255.0, blue:236/255.0, alpha: 1.0).cgColor
  }
  func isProductFavorite(isfavourite:Bool) {
    if isfavourite {
      self.favButton.setImage(#imageLiteral(resourceName: "star-selected"), for: .normal)
      self.favButton.isSelected = true
    } else {
      self.favButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
      self.favButton.isSelected = false
    }
  }
  
  @IBAction func caseViewButton(_ sender: Any) {
    loyalityPoints.text = duLoyaltyPoint
    selectedProductCode = duProductCode
    caseViewSelected()
  }
  
  @IBOutlet weak var multipleAmount: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    let packagingText = WSUtility.getlocalizedString(key: "Select the packaging", lang: WSUtility.getLanguage(), table: "Localizable")
    let excludingVAT = WSUtility.getTranslatedString(forString: "Indicative price (Excluding UAT)")
    
    if WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
      WSUtility.setAttributedLabel(originalText: packagingText!, attributedText: "", forLabel: selectPackageLabel, withFont: UIFont(name: "DINPro-Regular", size: 10)!, withColor: UIColor(red: 183.0/255.0, green: 183.0/255.0, blue: 183.0/255.0, alpha: 1))
    }
    else{
      
      WSUtility.setAttributedLabel(originalText: packagingText! + " \(excludingVAT)", attributedText: excludingVAT, forLabel: selectPackageLabel, withFont: UIFont(name: "DINPro-Regular", size: 10)!, withColor: UIColor(red: 183.0/255.0, green: 183.0/255.0, blue: 183.0/255.0, alpha: 1))
    }
    
    //selectPackageLabel.text = WSUtility.getlocalizedString(key: "Select the packaging", lang: WSUtility.getLanguage(), table: "Localizable")
    pointsLabel.text = WSUtility.getlocalizedString(key: "Points", lang: WSUtility.getLanguage(), table: "Localizable")
    addToCartButton.setTitle(WSUtility.getlocalizedString(key: "Add to cart", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    //indicativeLabel.text = WSUtility.getTranslatedString(forString: "Indicative price (Excluding UAT)")
    
    unitView?.layer.borderColor = ApplicationOrangeColor.cgColor
    caseView?.layer.borderColor = Search_UnitBox_UnSelectedColor.cgColor
    
    unitTextLabel.text = WSUtility.getTranslatedString(forString: "Unit")
    caseTextLabel.text = WSUtility.getTranslatedString(forString: "Case")
    productNotAvailableLabel.text = WSUtility.getTranslatedString(forString: "Product not avilable")
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  func setUI(dict: [String: Any], selectedCellArray:[String]){
    
    productDetail = dict
    if let productname = dict["name"] as? String {
      prodName.text = productname
    }
    self.favButton.isSelected = false
    self.favButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
    if let strNum = productDetail["number"]{
      if selectedCellArray.contains("\(strNum)") {
        self.favButton.isSelected = true
        self.favButton.setImage(#imageLiteral(resourceName: "star-selected"), for: .normal)
      }else{
        self.favButton.isSelected = false
        self.favButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
      }
    }
    
    if let points = dict["loyalty"] as? String {
      loyalityPoints.text = points
    }
    
    unitView?.isHidden = true
    caseView?.isHidden = true
    productNotAvailableLabel.isHidden = true
    
    
    var productImage = ""
    
    if let variants = dict["variantOptions"] as? [[String:Any]]{
      for varaintInfo in variants{
        
        // let varaintDict = varaintInfo["container"] as? [String:Any]
        
       
        if varaintInfo["container"] as! String == "Unit"{
            
            if let image = varaintInfo["thumbnailUrl"] as? String {
                productImage = image
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
//
//              if priceValue == 0{
//               // print("test->\(priceValue)")
//                continue
//              }
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
            singleQuantityPrice?.text = formattedString.replacingOccurrences(of: ".", with: ",")
          }
          singleAmount?.text = "\(varaintInfo["packaging"]!)"
          // loyalityPoints.text = "\(varaintInfo["loyalty"]!)"
          cuProductCode = "\(varaintInfo["code"]!)"
          unitView?.isHidden = false
          cuLoyaltyPoint = "\(varaintInfo["loyalty"]!)"
          
         
          
        }else if varaintInfo["container"] as! String == "Case" {
            
            if let image = varaintInfo["thumbnailUrl"] as? String {
                productImage = image
            }
            
            if WSUtility.isLoginWithTurkey(){
                if let priceVisible = varaintInfo["priceVisible"] as? Bool{
                    if priceVisible == false{
                        continue
                    }
                }
            }
            
          if let priceInfo = varaintInfo["priceData"] as? [String:Any] {
            
//            if let priceValue = priceInfo["value"] as? Double{
//
//              if priceValue == 0{
//                //print("test->\(priceValue)")
//                continue
//              }
//            }
            
            var formattedString = ""
            if WSUtility.getCountryCode() == "CH"{
              let x = priceInfo["value"] as? Double
              let y = Double(round(1000*x!)/1000)
              formattedString = "CHF \(y)"
            }
            else{
              if let formatValue = priceInfo["formattedValue"] as? String{
                formattedString = formatValue
                
              }else{
                formattedString = ""
                
              }
              
            }
            
            multiplePrice?.text = formattedString.replacingOccurrences(of: ".", with: ",")
            multipleAmount?.text = "\(varaintInfo["packaging"]!)"
            caseView?.isHidden = false
            // loyalityPoints.text = "\(varaintInfo["loyalty"]!)"
            duProductCode = "\(varaintInfo["code"]!)"
            duLoyaltyPoint = "\(varaintInfo["loyalty"]!)"
            
            
          }else{
            
            // no price data
            multiplePrice?.text = ""
            multipleAmount?.text = ""
            singleQuantityPrice?.text = ""
            singleAmount?.text = ""
            
            
          }
        }
      }

      if unitView?.isHidden == true && caseView?.isHidden == true{
        // if price is not avialable, show "product not avilable" banner
        productNotAvailableLabel.isHidden = false
        addToCartButton.isEnabled = false
        addToCartButton.alpha = 0.4
        selectPackageLabel.isHidden = true
        favButton.isHidden = true
        self.hightOfaddtoCartBtn.constant = 0
        self.loyaltyContinerHight.constant = 0
        self.hightOfselectPkgLbl.constant = 0
        
      }else{
        
        addToCartButton.alpha = 1
        productNotAvailableLabel.isHidden = true
        addToCartButton.isEnabled = true
        selectPackageLabel.isHidden = false
        favButton.isHidden = false
        self.hightOfaddtoCartBtn.constant = 45
        self.loyaltyContinerHight.constant = 25
        self.hightOfselectPkgLbl.constant = 42
        
        if unitView?.isHidden == false{
            self.unitViewButton(self)
        }else{
            self.caseViewButton(self)
        }
      }
    }
    
    if let product_image_url = dict["thumbnailUrl"] as? String {
      prodImage.sd_setImage(with: URL.init(string:product_image_url), placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }else if productImage.count > 0{
      prodImage.sd_setImage(with: URL.init(string:productImage), placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }
    else{
      prodImage.image = #imageLiteral(resourceName: "placeholder")
    }
  }
  
  @IBAction func addToCartButtonActiom(_ sender: UIButton) {
    let productCode = selectedProductCode //cuProductCode.count > 0 ? cuProductCode : duProductCode
    delegate?.addToCartFromProductList(productCode: productCode)
    
    /*
     var appVersion = ""
     
     if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
     appVersion = version
     }
     */
    
    UFSGATracker.trackEvent(withCategory: "add to cart", action: "Button click", label: "added product to cart", value: nil)
    FBSDKAppEvents.logEvent("add to cart Button clicked")
  }
  
  func deleteProductFromSifu()  {
    
    UFSProgressView.showWaitingDialog("")
    var strProductNum = ""
    if let str = productDetail["number"] as? String{
      strProductNum = str
    }
    let productNumber = strProductNum
    
    WSUtility.removeFavoriteItem(item: productNumber)
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.deleteFavoriteProductFromSifu(productNumber: productNumber, successResponse: { (response) in
      
      self.favButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
      self.favButton.isSelected = false
      self.delegate?.storeOrDeleteSelectedCellProductNumber(productNumber: productNumber, actionType: 0)
      UFSProgressView.stopWaitingDialog()
      
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
    }
    
  }
  
  @IBAction func addFavouriteOrUnFavourite(sender: UIButton){
    var strProductNum = ""
    if let str = productDetail["number"] as? String{
      strProductNum = str
    } else if let str = productDetail["code"] as? String{ // for turkey
      strProductNum = str
    }
    
    if favButton.isSelected {
      
      delegate?.deleteUnfavouriteProductitem(productNumber: strProductNum)
      favButton.isSelected = false
      deleteProductFromSifu()
      
    }else{
      
      favButton.isSelected = true
      
      var dict:[String: Any] = [:]
      dict["countryCode"] = WSUtility.getCountryCode()
      dict["favoriteListId"] = "0"
      dict["languageCode"] = WSUtility.getLanguageCode()
      dict["productNumber"] = strProductNum
      
      self.favButton.setImage(#imageLiteral(resourceName: "star-selected"), for: .normal)
      
      delegate?.storeOrDeleteSelectedCellProductNumber(productNumber: strProductNum, actionType: 1)
      
      UFSProgressView.showWaitingDialog("")
      let businessLayer = WSWebServiceBusinessLayer()
      businessLayer.addFavouriteItemRequest(parameter: dict, successResponse: { (response) in
        UFSProgressView.stopWaitingDialog()
        WSUtility.setProductCode(productNumber: strProductNum)
      }) { (errorMessage) in
        UFSProgressView.stopWaitingDialog()
        self.favButton.isSelected = false
        self.favButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
        
      }
    }
  }
}
