//
//  WSScanDetailTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 05/01/2018.
//
import UIKit
@objc protocol WSScanProductCellDelegate {
    func actionOnContainerType(packagingType:String, containerType:String, selectedProductCode Code:String)
    func deleteUnfavouriteProductitem(productNumber:String)
}
class WSScanDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hightOfLoyaltyPoints: NSLayoutConstraint!
    @IBOutlet weak var hightOfRecomentedLb: NSLayoutConstraint!
    @IBOutlet weak var hightOfAddToCard: NSLayoutConstraint!
    
    @IBOutlet weak var productNotVailableLbl: UILabel!
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
    
    @IBOutlet weak var addTofavoriteBtn: UIButton!
    weak var delegate:WSScanProductCellDelegate?
    var isUnitViewSelected = true
    var isCaseViewSelected = false
    
    var prodcutID = ""
    var productLoyaltyPointForCase = ""
    var productLoyaltyPointForUnit = ""
    var caseValue = ""
    var unitValue = ""
    var cuProductCode = ""
    var duProductCode = ""
    var cuEanCode = ""
    var duEanCode = ""
    var thumbnailImageUrl = ""
    var scanProductDetail = [String:Any]()
    var productNumber = ""
    
    enum CellDesignFor {
        case SearchCell
        case ScanDetailCell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        unitView.layer.borderColor = ApplicationOrangeColor.cgColor
        caseView.layer.borderColor = Search_UnitBox_UnSelectedColor.cgColor
        // let attributedString = NSMutableAttributedString(string:  WSUtility.getlocalizedString(key:"Select the packaging Indicative Price (Excluding VAT)", lang:WSUtility.getLanguage(), table: "Localizable")!)
        self.productNotVailableLbl.text = WSUtility.getTranslatedString(forString: "Product not avilable")
        
    }
    
    func setUI(){
        let packagingText = WSUtility.getlocalizedString(key: "Select the packaging", lang: WSUtility.getLanguage(), table: "Localizable")
        let excludingVAT = WSUtility.getTranslatedString(forString: "Indicative price (Excluding UAT)")
        
        var attributedString = NSMutableAttributedString(string:packagingText!)
        
        if !WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
            attributedString = NSMutableAttributedString(string:packagingText! + " \(excludingVAT)")
        }
        attributedString.setColorForText(excludingVAT, with: UIColor(red: 183.0/255.0, green: 183.0/255.0, blue: 183.0/255.0, alpha: 1), with: UIFont(name: "DINPro-Regular", size: 10))
        recommendationLabel.attributedText = attributedString
        addToCartButton.setTitle(WSUtility.getlocalizedString(key:"Add to cart", lang:WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        
        pointsLabel.text = WSUtility.getlocalizedString(key:"Points", lang:WSUtility.getLanguage(), table: "Localizable")
    }

    func showNoProductAvailable() -> () {
        productNotVailableLbl.isHidden = false
        recommendationLabel.isHidden = true
        hightOfAddToCard.constant = 0
        hightOfLoyaltyPoints.constant = 0
        hightOfRecomentedLb.constant = 0
        addTofavoriteBtn.isHidden = true
        caseView.isHidden = true
        unitView.isHidden = true
    }
    
    func hideNoProductAvailable() -> () {
        productNotVailableLbl.isHidden = true
        recommendationLabel.isHidden = false
        addTofavoriteBtn.isHidden = false
        hightOfAddToCard.constant = 40
        hightOfLoyaltyPoints.constant = 25
        hightOfRecomentedLb.constant = 30
    }
    
    func updateCellContent(productDetail:[String:Any])  {
        
        scanProductDetail = productDetail
        /*
         if let variants = productDetail["variantOptions"] as? [[String:Any]]{
         for varaintInfo in variants{
         
         let varaintDict = varaintInfo["typeOfProduct"] as? [String:Any]
         
         
         if varaintDict!["name"] as! String == "CU"{
         // caseLabel?.text = varaintInfo["packaging"] as? String
         let priceInfo = varaintInfo["priceData"] as? [String:Any]
         unitPriceLabel?.text = priceInfo!["formattedValue"] as? String
         
         if let packaging = varaintInfo["packaging"]{
         let unitTranslatedText = WSUtility.getTranslatedString(forString: "Unit")
         unitLabel?.text = "\(unitTranslatedText)\n\(packaging)"
         unitValue = "\(packaging)"
         }
         
         unitView?.isHidden = false
         productLoyaltyPointForUnit = "\(varaintInfo["loyalty"]!)"
         cuProductCode = "\(varaintInfo["code"]!)"
         cuEanCode = "\(varaintInfo["ean"]!)"
         
         }else if varaintDict!["name"] as! String == "DU"{
         // unitLabel?.text = varaintInfo["packaging"] as? String
         let priceInfo = varaintInfo["priceData"] as? [String:Any]
         casePriceLabel?.text = priceInfo!["formattedValue"] as? String
         if let packaging =  varaintInfo["packaging"]{
         let caseTranslatedText = WSUtility.getTranslatedString(forString: "Case")
         caseLabel?.text = "\(caseTranslatedText)\n\(packaging)"
         caseValue = "\(packaging)"
         }
         
         caseView?.isHidden = false
         
         productLoyaltyPointForCase = "\(varaintInfo["loyalty"]!)"
         duProductCode = "\(varaintInfo["code"]!)"
         duEanCode = "\(varaintInfo["ean"]!)"
         }
         }
         }
         
         if unitView?.isHidden == false{
         let loyaltyPointString =  productLoyaltyPointForUnit
         
         loyalityPoints.text = loyaltyPointString
         delegate?.actionOnContainerType(packagingType: unitValue, containerType: "Unit", selectedProductCode: cuProductCode)
         }else{
         let loyaltyPointString =  productLoyaltyPointForCase
         loyalityPoints.text = loyaltyPointString
         delegate?.actionOnContainerType(packagingType: caseValue, containerType: "Case", selectedProductCode: duProductCode)
         }
         */
        
        showNoProductAvailable()
        if let variants = productDetail["baseOptions"] as? [[String:Any]]{
            for varaintInfo in variants{
                
                if let varaintDict = varaintInfo["options"] as? [[String:Any]] {
                    
                    for finalVariantOption in varaintDict{
                        
                        if finalVariantOption["container"] as! String == "Unit"{
                            // caseLabel?.text = varaintInfo["packaging"] as? String
                            
                            if let strUrl = finalVariantOption["thumbnailUrl"] as? String{
                                thumbnailImageUrl = strUrl
                            }
                            
                            if WSUtility.isLoginWithTurkey(){
                                if let priceVisible = finalVariantOption["priceVisible"] as? Bool{
                                    if priceVisible == false{
                                        continue
                                    }
                                }
                            }
                            
                            if let priceInfo = finalVariantOption["priceData"] as? [String:Any]{
                           // unitPriceLabel?.text = priceInfo!["formattedValue"] as? String
                                
//                            if let priceValue = priceInfo["value"] as? Double{
//                                    if priceValue == 0{
//                                        // print("test->\(priceValue)")
//                                        continue
//                                    }
//                            }
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
                            if let packaging = finalVariantOption["packaging"]{
                                let unitTranslatedText = WSUtility.getTranslatedString(forString: "Unit")
                                unitLabel?.text = "\(unitTranslatedText)\n\(packaging)"
                                unitValue = "\(packaging)"
                            }
                            
                            //unitView?.isHidden = false
                            productLoyaltyPointForUnit = "\(finalVariantOption["loyalty"]!)"
                            cuProductCode = "\(finalVariantOption["code"]!)"
                            cuEanCode = "\(finalVariantOption["ean"]!)"
                            
                            productNumber = finalVariantOption["number"] as! String
                          
                          if let stock = finalVariantOption["stock"] as? [String:Any], let stockStatus = stock["stockLevelStatus"] as? String{
                            
                            if stockStatus == StockStatus().IN_STOCK{
                              unitView?.isHidden = false
                            }
                            
                          }
                          hideNoProductAvailable()
                          
                          
                        }else if finalVariantOption["container"] as! String == "Case"{
                            // unitLabel?.text = varaintInfo["packaging"] as? String
                            
                            if let strUrl = finalVariantOption["thumbnailUrl"] as? String{
                                thumbnailImageUrl = strUrl
                            }
                            
                            if WSUtility.isLoginWithTurkey(){
                                if let priceVisible = finalVariantOption["priceVisible"] as? Bool{
                                    if priceVisible == false{
                                        continue
                                    }
                                }
                            }
                            if let priceInfo = finalVariantOption["priceData"] as? [String:Any]{
                            //casePriceLabel?.text = priceInfo!["formattedValue"] as? String
//                            if let priceValue = priceInfo["value"] as? Double{
//                                    if priceValue == 0{
//                                        // print("test->\(priceValue)")
//                                        continue
//                                    }
//                            }
                                
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
                            if let packaging =  finalVariantOption["packaging"]{
                                let caseTranslatedText = WSUtility.getTranslatedString(forString: "Case")
                                caseLabel?.text = "\(caseTranslatedText)\n\(packaging)"
                                caseValue = "\(packaging)"
                            }
                            
                          
                            productLoyaltyPointForCase = "\(finalVariantOption["loyalty"]!)"
                            duProductCode = "\(finalVariantOption["code"]!)"
                            duEanCode = "\(finalVariantOption["ean"]!)"
                            
                            
                            productNumber = finalVariantOption["number"] as! String
                          
                          if let stock = finalVariantOption["stock"] as? [String:Any], let stockStatus = stock["stockLevelStatus"] as? String{
                            
                            if stockStatus == StockStatus().IN_STOCK{
                              caseView?.isHidden = false
                            }
                          }
                        hideNoProductAvailable()
                        }
                    }
                }
                let urlComponents = NSURLComponents(string: thumbnailImageUrl)
                urlComponents?.user =  "ufsstage"
                urlComponents?.password = "emakina"
                
                productImage.sd_setImage(with: URL(string: thumbnailImageUrl), placeholderImage: UIImage(named: "placeholder.png"), options: .allowInvalidSSLCertificates)
                
                
            }
        }
        
        if unitView?.isHidden == false{
            let loyaltyPointString =  productLoyaltyPointForUnit
            
            loyalityPoints.text = loyaltyPointString
            delegate?.actionOnContainerType(packagingType: unitValue, containerType: "Unit", selectedProductCode: cuProductCode)
        }else{
            let loyaltyPointString =  productLoyaltyPointForCase
            loyalityPoints.text = loyaltyPointString
            delegate?.actionOnContainerType(packagingType: caseValue, containerType: "Case", selectedProductCode: duProductCode)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func addToCartButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func buttonActionOnUnitView(_ sender: UIButton) {
        unitView.layer.borderColor = isUnitViewSelected ? Search_UnitBox_UnSelectedColor.cgColor : ApplicationOrangeColor.cgColor
        
        isUnitViewSelected = !isUnitViewSelected
        
        caseView.layer.borderColor = Search_UnitBox_UnSelectedColor.cgColor
        isCaseViewSelected = false
        
        delegate?.actionOnContainerType(packagingType: unitValue, containerType: "Unit", selectedProductCode: cuProductCode)
        loyalityPoints.text = productLoyaltyPointForUnit
    }
    
    @IBAction func buttonActionOnCaseView(_ sender: UIButton) {
        caseView.layer.borderColor = isCaseViewSelected ? Search_UnitBox_UnSelectedColor.cgColor : ApplicationOrangeColor.cgColor
        
        isCaseViewSelected = !isCaseViewSelected
        
        unitView.layer.borderColor = Search_UnitBox_UnSelectedColor.cgColor
        isUnitViewSelected = false
        
        delegate?.actionOnContainerType(packagingType: unitValue, containerType: "Case", selectedProductCode: duProductCode)
        loyalityPoints.text = productLoyaltyPointForCase
    }
    
    func deleteProductFromSifu()  {
        
        UFSProgressView.showWaitingDialog("")
        let productNumber = self.productNumber
        
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.deleteFavoriteProductFromSifu(productNumber: productNumber, successResponse: { (response) in
            WSUtility.removeFavoriteItem(item: productNumber)
            self.addTofavoriteBtn.setImage(#imageLiteral(resourceName: "star"), for: .normal)
            self.addTofavoriteBtn.isSelected = false
            self.delegate?.deleteUnfavouriteProductitem(productNumber: self.productNumber)
            UFSProgressView.stopWaitingDialog()
            
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        }
        
    }
    
    @IBAction func addFavouriteOrUnFavourite(sender: UIButton){
        if addTofavoriteBtn.isSelected {
            delegate?.deleteUnfavouriteProductitem(productNumber: productNumber)
            addTofavoriteBtn.isSelected = false
            deleteProductFromSifu()
        }else{
            
            UFSProgressView.showWaitingDialog("")
            addTofavoriteBtn.isSelected = true
            
            var dict:[String: Any] = [:]
            dict["countryCode"] = WSUtility.getCountryCode()
            dict["favoriteListId"] = "0"
            dict["languageCode"] = WSUtility.getLanguageCode()
            dict["productNumber"] = productNumber
            
            self.addTofavoriteBtn.setImage(#imageLiteral(resourceName: "star-selected"), for: .normal)
            
            let businessLayer = WSWebServiceBusinessLayer()
            businessLayer.addFavouriteItemRequest(parameter: dict, successResponse: { (response) in
                UFSProgressView.stopWaitingDialog()
                WSUtility.setProductCode(productNumber: self.productNumber)
            }) { (errorMessage) in
                self.addTofavoriteBtn.isSelected = false
                self.addTofavoriteBtn.setImage(#imageLiteral(resourceName: "star"), for: .normal)
                UFSProgressView.stopWaitingDialog()
            }
            
        }
        
        
        
    }
    
    
    func isProductFavorite(isfavourite:Bool) {
        if isfavourite {
            addTofavoriteBtn.setImage(#imageLiteral(resourceName: "star-selected"), for: .normal)
            addTofavoriteBtn.isSelected = true
        } else {
            addTofavoriteBtn.setImage(#imageLiteral(resourceName: "star"), for: .normal)
            addTofavoriteBtn.isSelected = false
        }
    }
}

