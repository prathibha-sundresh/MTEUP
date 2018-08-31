
//
//  WSShoppingListTableViewCell.swift
//  yB2CApp
//
//  Created by Ramakrishna on 11/26/17.
//

import UIKit
protocol WSShoppingListTableViewCellDelegate {
  func updateQuantityLabelText(value: Int, row: Int)
  func deleteFavoriteProduct(senderTag:Int)
  func didSelectOnCell(senderTag:Int)
  func SelectedUnitInShoppingList(Unit:String)
}
class WSShoppingListTableViewCell: UITableViewCell {
  @IBAction func FavouriteButtonPressed(_ sender: UIButton) {
    delegate?.deleteFavoriteProduct(senderTag: sender.tag)
  }
    @IBOutlet weak var SelectPackagingTopConstrainst: NSLayoutConstraint!
    @IBOutlet weak var CUViewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var CUViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var btnCU: UIButton!
    @IBOutlet weak var btnDU: UIButton!
    @IBOutlet weak var favoriteIcon: UIButton!
  @IBOutlet weak var pointsLabel: UFSLoyaltyPointLabel!
  @IBOutlet weak var proceedToOrderButton: UIButton!
  @IBOutlet weak var indicativeLabel: UILabel!
  @IBOutlet weak var ProductName: UILabel!
  @IBOutlet weak var productImage: UIImageView!
  @IBOutlet weak var quantityLabel: UILabel!
  @IBOutlet weak var removeButton: UIButton!
  @IBOutlet weak var loyaltyPointsLabel: UILabel!
  @IBOutlet weak var cartValueLabel: UILabel!
  @IBOutlet weak var minusButton: UIButton!
  @IBOutlet weak var plusButton: UIButton!
  @IBOutlet weak var AddToCartView: UIView!
  @IBOutlet weak var QuantityMinusPlusView: UIView!
  @IBOutlet weak var AddToCartLabel: UILabel!
  
  @IBAction func CUViewTap(_ sender: Any) {
    let btn = sender as? UIButton
    delegate?.SelectedUnitInShoppingList(Unit: "cu")
    selectedVariantType = "cu"
    AddborderToView(view: CUUnitView, Color: UIColor.init(red: 255.0/255.0, green: 90.0/255.0, blue: 0.0/255.0, alpha: 1.0))
    RemoveBorderFromView(view: DUUnitView)
    self.quantityTextField.text = "\(1)"
    delegate?.updateQuantityLabelText(value: Int(quantityTextField.text!)!, row: btn!.tag)
  }
  //  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var quantityTextField: UITextField!
  @IBOutlet weak var DUUnitView: UIView!
  @IBOutlet weak var DUCaseLabel: UILabel!
  @IBOutlet weak var DUPriceLabel: UILabel!
  @IBOutlet weak var CUUnitView: UIView!
  @IBOutlet weak var CUUnitLabel: UILabel!
  @IBOutlet weak var CUPriceLabel: UILabel!
  @IBOutlet weak var SelectPackagingLabel: UILabel!
  
  @IBOutlet weak var IndicativePriceLabel: UILabel!
  
  @IBAction func DUViewTap(_ sender: Any) {
    let btn = sender as? UIButton
    delegate?.SelectedUnitInShoppingList(Unit: "du")
    selectedVariantType = "du"
    AddborderToView(view: DUUnitView, Color: UIColor.init(red: 255.0/255.0, green: 90.0/255.0, blue: 0.0/255.0, alpha: 1.0))
    RemoveBorderFromView(view: CUUnitView)
    self.quantityTextField.text = "\(1)"
    delegate?.updateQuantityLabelText(value: Int(quantityTextField.text!)!, row: btn!.tag)
  }
  
  
  @IBOutlet weak var addToCartButton: UIButton!{
    didSet{
      addToCartButton.layer.borderWidth = 1
      addToCartButton.layer.borderColor = UIColor.init(red: 255.0/255.0, green: 90.0/255.0, blue: 0, alpha: 1.0).cgColor
    }
  }
  @IBOutlet weak var transparentButtonName: UIButton!
  @IBOutlet weak var transparentButtonOnImageView: UIButton!
  
  var delegate: WSShoppingListTableViewCellDelegate?
  var selectedVariantType = "cu"
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    //removeButton.isHidden = true
    //removeButton.isUserInteractionEnabled = false
    
    transparentButtonName.titleLabel?.numberOfLines = 0
    
    removeButton.setTitle(WSUtility.getlocalizedString(key: "Remove", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    AddToCartLabel.text = WSUtility.getlocalizedString(key: "Add to cart", lang: WSUtility.getLanguage(), table: "Localizable")
    
    proceedToOrderButton.setTitle(WSUtility.getlocalizedString(key: "Proceed to order", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    SelectPackagingLabel.text = WSUtility.getlocalizedString(key: "Select the packaging", lang: WSUtility.getLanguage())
    indicativeLabel.text = WSUtility.getlocalizedString(key: "Indicative prices from UFS", lang: WSUtility.getLanguage(), table: "Localizable")
    IndicativePriceLabel.text = WSUtility.getlocalizedString(key: "Indicative price (Excluding UAT)", lang: WSUtility.getLanguage())
    logicToHideOrUnHideIndicativePrice()
    
    DUUnitView.layer.cornerRadius = 5
    DUUnitView.layer.borderWidth = 1
    CUUnitView.layer.cornerRadius = 5
    CUUnitView.layer.borderWidth = 1
    AddToCartView.layer.cornerRadius = 5
    AddToCartView.layer.borderWidth = 1
    QuantityMinusPlusView.layer.borderWidth = 1
    QuantityMinusPlusView.layer.cornerRadius = 5
    AddborderToView(view: QuantityMinusPlusView, Color: UIColor.init(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0))
    AddborderToView(view: AddToCartView, Color: UIColor.init(red: 255.0/255.0, green: 90.0/255.0, blue: 0.0/255.0, alpha: 1.0))
    AddborderToView(view: CUUnitView, Color: UIColor.init(red: 255.0/255.0, green: 90.0/255.0, blue: 0.0/255.0, alpha: 1.0))
    RemoveBorderFromView(view: DUUnitView)
    
    self.favoriteIcon.setImage(#imageLiteral(resourceName: "star-selected"), for: .normal)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func logicToHideOrUnHideIndicativePrice()  {
    if WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
      indicativeLabel.isHidden = true
      IndicativePriceLabel.isHidden = true
    }
    else{
      IndicativePriceLabel.isHidden = false
      indicativeLabel.isHidden = false
    }
  }
  
  func addUnderlineToRemoveButton()  {
    let buttonAttributes : [String: Any] = [
      NSForegroundColorAttributeName : ApplicationOrangeColor,
      NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
    
    let attributeString = NSMutableAttributedString(string: WSUtility.getTranslatedString(forString: "Remove"),
                                                    attributes: buttonAttributes)
    removeButton.setAttributedTitle(attributeString, for: .normal)
    
  }
    
    func setPersonlizePriceUI(isenable:Bool) {
        DUUnitView.isHidden = isenable
        CUUnitView.isHidden = isenable
        CUUnitLabel.isHidden = isenable
        DUCaseLabel.isHidden = isenable
        DUPriceLabel.isHidden = isenable
        CUPriceLabel.isHidden = isenable
        SelectPackagingLabel.isHidden = isenable
        indicativeLabel.isHidden = isenable
        IndicativePriceLabel.isHidden = isenable
        if isenable {
            CUViewTopConstraints.constant = 0
            CUViewHeightConstraints.constant = 0
            SelectPackagingTopConstrainst.constant = 0
        } else {
            SelectPackagingTopConstrainst.constant = 16
            CUViewTopConstraints.constant = 13
            CUViewHeightConstraints.constant = 53
        }
        
    }
  
  func setUI(dict : [String: Any]){
    CUUnitView.isHidden = true
    DUUnitView.isHidden = true
    addUnderlineToRemoveButton()
    quantityLabel.isHidden = true
    SelectPackagingLabel.text = WSUtility.getlocalizedString(key: "Select the packaging", lang: WSUtility.getLanguage())
    IndicativePriceLabel.text = WSUtility.getlocalizedString(key: "Indicative price (Excluding UAT)", lang: WSUtility.getLanguage())
    
    logicToHideOrUnHideIndicativePrice()
    
    let dict1 = dict ["product"] as! [String: Any]
    if let productName = dict1["productName"] as? String {
      ProductName.text = productName
    } else if let productName = dict1["name"] as? String {
        ProductName.text = productName
    } else {
        ProductName.text = " "
    }
    if let packagingName = dict1["packagingName"] as? String{
      quantityLabel.text = "Verpackungseinheit: \(packagingName)"
    }
    if let imageurl = dict1["packshotUrl"] as? String{
      productImage.sd_setImage(with: URL.init(string:imageurl), placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }
    
//    if let tempQuantity = dict["qunatiy"] as? Int{
//      quantityTextField.text = "\(tempQuantity)"
//    }else{
      quantityTextField.text = "1"
//    }
    let productDict = dict ["product"] as! [String: Any]
    
    if let productPackagingType = productDict["defaultPackagingType"] as? String{
      
      if productPackagingType == "ONLYDU"{
        CUUnitView.isHidden = true
        DUUnitView.isHidden = false

        delegate?.SelectedUnitInShoppingList(Unit: "du")
        selectedVariantType = "du"
        // SelectPackagingLabel.isHidden = true
        
        if let duOnlineLabel = productDict["logistics"] as? [[String:Any]] {
        for value in duOnlineLabel {
          
          if let productOnlineLabel = value["du"] as? [String:Any] {
            if let onlineLabel = productOnlineLabel["onlineLabel"] as? String {
              
              DUCaseLabel.text = onlineLabel
            }
          }
          
          }
       
        }
      }else if productPackagingType == "ONLYCU" {
        CUUnitView.isHidden = false
        DUUnitView.isHidden = true
        delegate?.SelectedUnitInShoppingList(Unit: "cu")
        selectedVariantType = "cu"
        if let duOnlineLabel = productDict["logistics"] as? [[String:Any]] {
            for value in duOnlineLabel {
                if let cuOnlineLabel = value["cu"] as? [String:Any] {
                    if let onlineLabel = cuOnlineLabel["onlineLabel"] as? String {
                        CUUnitLabel.text = onlineLabel
                    }
                }
            }
        }
        } else {
        if isCUAvailable(value: productDict) {
            CUUnitView.isHidden = false
        }
        if isDUAvailable(value: productDict) {
            DUUnitView.isHidden = false
        }
        delegate?.SelectedUnitInShoppingList(Unit: "cu")
        selectedVariantType = "cu"
        if let duOnlineLabel = productDict["logistics"] as? [[String:Any]] {
          for value in duOnlineLabel {
            if let duvalue = value["du"] as? [String:Any] {
              if let onlineLabel = duvalue["onlineLabel"] as? String {
                DUCaseLabel.text = onlineLabel
              }
            }
            if let cuOnlineLabel = value["cu"] as? [String:Any] {
              if let onlineLabel = cuOnlineLabel["onlineLabel"] as? String {
                CUUnitLabel.text = onlineLabel
              }
            }
          }
        }
      }
      if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
        CUUnitView.isHidden = true
      }
    }
    
    
    if let CUprice = dict1["cuPriceInCents"] as? Double {
      
      // let price = dict1["duPriceInCents"] as! Double
//        let price = (Double(Double(CUprice)/100) * Double(dict["qunatiy"] as! Int))
        let price = Double(Double(CUprice)/100)
      var strPrice = "\(price)"
      strPrice = strPrice.replacingOccurrences(of: ".", with: ",")
      var strPriceLbl = ""
      let countryCode =  WSUtility.getCountryCode()
      if countryCode == "TR" {
        strPriceLbl = "\(strPrice) ₺"
      }
        else if countryCode == "CH" {
            strPriceLbl = "CHF \(strPrice)"
        }
      else {
        strPriceLbl = "€ \(strPrice)"
      }
        
        if !WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
        CUPriceLabel.text = strPriceLbl + " *"
        }
        else{
            CUPriceLabel.text = strPriceLbl
        }
    }
    let keys = dict1.flatMap(){ $0.0 as? String }
    if let price = dict1["duPriceInCents"] as? Double {
      
      // let price = dict1["duPriceInCents"] as! Double
//        let priceInDouble = (Double(Double(price)/100) * Double(dict["qunatiy"] as! Int))
      let priceInDouble = Double(Double(price)/100)
      var strPrice = "\(priceInDouble)"
      strPrice = strPrice.replacingOccurrences(of: ".", with: ",")
      var strPriceLbl = ""
      let countryCode =  WSUtility.getCountryCode()
      if countryCode == "TR" {
        strPriceLbl = "\(strPrice) ₺"
      }
      else if countryCode == "CH" {
        strPriceLbl = "CHF \(strPrice)"
      }
      else {
        strPriceLbl = "€ \(strPrice)"
      }
        if !WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
            DUPriceLabel.text = strPriceLbl + " *"
        }
        else{
            DUPriceLabel.text = strPriceLbl
        }
    }
    

    
    if let isOnlyDu = dict1["duOnlyProduct"] as? Bool{
      if isOnlyDu{
         delegate?.SelectedUnitInShoppingList(Unit: "du")
        AddborderToView(view: DUUnitView, Color: UIColor.init(red: 255.0/255.0, green: 90.0/255.0, blue: 0.0/255.0, alpha: 1.0))
        RemoveBorderFromView(view: CUUnitView)
      }
      else{
        delegate?.SelectedUnitInShoppingList(Unit: "cu")
        AddborderToView(view: CUUnitView, Color: UIColor.init(red: 255.0/255.0, green: 90.0/255.0, blue: 0.0/255.0, alpha: 1.0))
        RemoveBorderFromView(view: DUUnitView)
      }
    }
    
    
  }
  @IBAction func tappedOnPlusButtonAction(sender: UIButton){
    let num = Int(quantityTextField.text!)
    if num!+1 <= 1000 {
      quantityTextField.text = "\(Int(quantityTextField.text!)! + 1)"
      delegate?.updateQuantityLabelText(value: Int(quantityTextField.text!)!, row: sender.tag)
      var appVersion = ""
      
      if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        appVersion = version
      }

            UFSGATracker.trackEvent(withCategory: "add to cart", action: "Button click", label: "added product to cart", value: nil)
        FBSDKAppEvents.logEvent("add to cart clicked")
    }
  }
  @IBAction func tappedOnMinusButtonAction(sender: UIButton){
    if quantityTextField.text != "1" {
      quantityTextField.text = "\(Int(quantityTextField.text!)! - 1)"
      delegate?.updateQuantityLabelText(value: Int(quantityTextField.text!)!,row: sender.tag)
    }
  }
  @IBAction func deleteButtonAction(_ sender: UIButton) {
    delegate?.deleteFavoriteProduct(senderTag: sender.tag)
  }
  
  @IBAction func openProductDetailScreen(_ sender: UIButton) {
    delegate?.didSelectOnCell(senderTag: sender.tag)
  }
  
  func AddborderToView(view:UIView, Color:UIColor) {
    view.layer.borderColor = Color.cgColor
  }
  
  func RemoveBorderFromView(view:UIView) {
    view.layer.borderColor = UIColor.init(red: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor
  }
    
    func isCUAvailable(value : [String:Any]) -> Bool {
        if let cuValue = value["cuAvailable"] as? Int {
            return cuValue == 1 ? true : false
        } else {
            return false
        }
    }
    
    func isDUAvailable(value : [String:Any]) -> Bool {
        if let cuValue = value["duAvailable"] as? Int {
            return cuValue == 1 ? true : false
        } else {
            return false
        }
    }
  
}

