//
//  WSCustomChefRewardDetailAddToCartTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 27/11/2017.
//

import UIKit
@objc protocol ContainerTypeDelegate {
  func updateContainerType(strType:String)
}
class WSCustomChefRewardDetailAddToCartTableViewCell: UITableViewCell {
  var isTouchUpInside = false
  @IBOutlet weak var btnCase: UIButton!
  @IBOutlet weak var btnUnit: UIButton!
  @IBOutlet weak var tfQuantity: UITextField!
  @IBOutlet weak var shadowView: UIView!
  @IBOutlet weak var sellingPointLabel: UILabel!
  @IBOutlet weak var chefRewardsPointsLabel: UILabel!
  @IBOutlet weak var deliveryPaymentLabel: UILabel!
  @IBOutlet weak var getRewardedWithLabel: UILabel!
  @IBOutlet weak var setGoalButton: WSDesignableButton!
  @IBOutlet weak var loyaltyPointLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var articleLabel: UILabel!
  @IBOutlet weak var unitView: UIView!
  @IBOutlet weak var unitLabel: UILabel!
  @IBOutlet weak var unitPriceLabel: UILabel!
  @IBOutlet weak var caseView: UIView!
  @IBOutlet weak var caseLabel: UILabel!
  @IBOutlet weak var casePriceLabel: UILabel!
  @IBOutlet weak var orderSampleButton: WSDesignableButton!
  @IBOutlet weak var packagingInfoLabel: UILabel!
  @IBOutlet weak var sampleOrderButtonHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var setGoalBtnHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var productLoyaltyPointLabel: UILabel!
  @IBOutlet weak var addToCartButton: WSDesignableButton!
  @IBOutlet weak var moreProductBtn: UIButton!
  
  @IBOutlet weak var quantityTextLabel: UILabel!
  @IBOutlet weak var quantityBoxView: UIView!
  var isUnitViewSelected = true
  var isCaseViewSelected = false
  var isSmapleOrderAvailable = false
  
  let BUTTON_SET_GOAL_TAG = 100
  let BUTTON_REMOVE_GOAL_TAG = 200
  
  var prodcutID = ""
  var productLoyaltyPointForCase = ""
  var productLoyaltyPointForUnit = ""
  var caseValue = ""
  var unitValue = ""
  var cuProductCode = ""
  var duProductCode = ""
  var cuEanCode = ""
  var duEanCode = ""
  var strLoyaltyPoints = ""
  weak var delegate:ChefRewardDetailDelegate?
  weak var delegateContainerType:ContainerTypeDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    unitView?.layer.borderColor = ApplicationOrangeColor.cgColor
    caseView?.layer.borderColor = Search_UnitBox_UnSelectedColor.cgColor
    quantityBoxView?.layer.borderColor = unselectedTextFieldBorderColor
    let selectText = WSUtility.getlocalizedString(key: "Select the packaging", lang: WSUtility.getLanguage(), table: "Localizable")
    var attributedString = NSMutableAttributedString(string: selectText!)
    let excludingVAT = WSUtility.getTranslatedString(forString: "Indicative price (Excluding UAT)")
    if !WSUtility.isFeatureEnabled(feature: featureId.Personalized_Pricing.rawValue) {
      attributedString = NSMutableAttributedString(string: selectText! + " \(excludingVAT)")
      attributedString.setColorForText(excludingVAT, with: UIColor(red: 183.0/255.0, green: 183.0/255.0, blue: 183.0/255.0, alpha: 1), with: UIFont(name: "DINPro-Regular", size: 10))
    }
    packagingInfoLabel?.attributedText = attributedString
    addToCartButton?.setTitle(WSUtility.getlocalizedString(key: "Add to cart", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    
    quantityTextLabel?.text =  WSUtility.getlocalizedString(key: "Quantity", lang: WSUtility.getLanguage(), table: "Localizable")
  }
  
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  func setUI(){
    chefRewardsPointsLabel?.text = WSUtility.getlocalizedString(key: "Chef Rewards Points", lang: WSUtility.getLanguage(), table: "Localizable")
    
    setGoalButton?.setTitle(WSUtility.getlocalizedString(key:"Set as a goal", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    deliveryPaymentLabel?.text = WSUtility.getlocalizedString(key: "Delivery and payment via your trusted trade partner", lang: WSUtility.getLanguage(), table: "Localizable")
    
    getRewardedWithLabel?.text = WSUtility.getlocalizedString(key: "Get rewarded with Chef Rewards", lang: WSUtility.getLanguage(), table: "Localizable")
    orderSampleButton?.setTitle(WSUtility.getTranslatedString(forString: "Order a Sample"), for: .normal)
    moreProductBtn?.setTitle(" \(WSUtility.getTranslatedString(forString: "More product and allergy information")) ", for: .normal)
    orderSampleButton.addTarget(self, action:#selector(SampleOrderButtonAction(_sender:)), for: UIControlEvents.touchUpInside)
  }
  @IBAction func SampleOrderButtonAction(_sender: UIButton) {
    if !isSmapleOrderAvailable{
      return
    }
    self.delegate?.ScreenNavigateDelegate!()
    
  }
  
  @IBAction func setGoalButtonAction(_ sender: UIButton) {
    UFSProgressView.showWaitingDialog("")
    setGoalAPICall(senderTag: sender.tag)
  }
  
  func setGoalAPICall(senderTag:Int)  {
    
    UFSProgressView.showWaitingDialog("")
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.setGoalForProduct(productID: prodcutID, successResponse: { (response) in
      WSUtility.sendTrackingEvent(events: "Other", categories: "Set-up Loyalty Goal",actions:"Loyalty",labels: self.prodcutID)
      UserDefaults.standard.set(self.prodcutID, forKey: USER_LOYALTY_GOAL_ID_KEY)
      UFSProgressView.stopWaitingDialog()
      self.delegate?.updateCellAfterGoalSet(isGoalSet: true)
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
    }
  }
  
  @IBAction func addToCartButtonAction(_ sender: UIButton) {
    let productCode = isUnitViewSelected == true ? cuProductCode : duProductCode
    delegate?.addToCartFromDetailCell(prodCode: productCode, quantity: tfQuantity.text!)
    var appVersion = ""
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      appVersion = version
    }
    UFSGATracker.trackEvent(withCategory: "add to cart", action: "Button click", label: "added product to cart", value: nil)
    FBSDKAppEvents.logEvent("add to cart Button clicked")
  }
  func updateCellContent(productDetail:[String:Any])  {
    
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
            
            var forPrice = ""
            if WSUtility.getCountryCode() == "CH"{
              let x = priceInfo["value"] as? Double
              let y = Double(round(1000*x!)/1000)
              forPrice = "CHF \(y)"
            }
            else{
              if let str = priceInfo["formattedValue"] as? String{
                forPrice = str
              }
            }
            unitPriceLabel?.text = forPrice.replacingOccurrences(of: ".", with: ",")
          }
          if let packaging = varaintInfo["packaging"]{
            unitLabel?.text = "\(WSUtility.getTranslatedString(forString: "Unit"))\n\(packaging)"
            unitValue = "\(packaging)"
          }
          
          unitView?.isHidden = false
          productLoyaltyPointForUnit = "\(varaintInfo["loyalty"]!)"
          if strLoyaltyPoints == ""{
            strLoyaltyPoints = productLoyaltyPointForUnit
          }
          cuProductCode = "\(varaintInfo["code"]!)"
          cuEanCode = "\(varaintInfo["ean"]!)"
          
        }else if varaintDict!["name"] as! String == "DU"{
          
          if WSUtility.isLoginWithTurkey(){
            if let priceVisible = varaintInfo["priceVisible"] as? Bool{
              if priceVisible == false{
                continue
              }
            }
          }
          
          // unitLabel?.text = varaintInfo["packaging"] as? String
          if let priceInfo = varaintInfo["priceData"] as? [String:Any]{
            
            var forPrice = ""
            if WSUtility.getCountryCode() == "CH"{
              let x = priceInfo["value"] as? Double
              let y = Double(round(1000*x!)/1000)
              forPrice = "CHF \(y)"
            }
            else{
              if let str = priceInfo["formattedValue"] as? String{
                forPrice = str
              }
            }
            
            casePriceLabel?.text = forPrice.replacingOccurrences(of: ".", with: ",")
          }
          if let packaging =  varaintInfo["packaging"]{
            caseLabel?.text = "\(WSUtility.getTranslatedString(forString: "Case"))\n\(packaging)"
            caseValue = "\(packaging)"
          }
          
          caseView?.isHidden = false
          
          productLoyaltyPointForCase = "\(varaintInfo["loyalty"]!)"
          if strLoyaltyPoints == ""{
            strLoyaltyPoints = productLoyaltyPointForCase
          }
          duProductCode = "\(varaintInfo["code"]!)"
          duEanCode = "\(varaintInfo["ean"]!)"
        }
      }
    }
    
    if unitView?.isHidden == false{
      let loyaltyPointString =  productLoyaltyPointForUnit
      strLoyaltyPoints = productLoyaltyPointForUnit
      setProductLoyaltyPoint(loyaltyPoint: loyaltyPointString)
      delegate?.actionOnContainerType(packagingType: unitValue, containerType: "Unit", eanCode: cuEanCode)
      //        WSUtility.setProductType(strType: "Unit")
      //        selectUnitView()
      isUnitViewSelected = true
      isCaseViewSelected = false
      
    }else{
      let loyaltyPointString =  productLoyaltyPointForCase
      strLoyaltyPoints = productLoyaltyPointForCase
      setProductLoyaltyPoint(loyaltyPoint: loyaltyPointString)
      delegate?.actionOnContainerType(packagingType: caseValue, containerType: "Case", eanCode: duEanCode)
      //        WSUtility.setProductType(strType: "Case")
      //caseView?.layer.borderColor = ApplicationOrangeColor.cgColor
      //        selectCaseView()
      isUnitViewSelected = false
      isCaseViewSelected = true
    }
    
    var sellingPointFinalString:String?
    if let sellingStory = productDetail["sellingStory"] as? [[String:Any]] {
      
      if sellingStory.count > 1{
        let sellingStoryValues = sellingStory[1]
        for index in 0...10{
          
          if let sellingPoint = sellingStoryValues["sellingPoint\(index)"] {
            if sellingPointFinalString == nil{
              sellingPointFinalString = "•  \(sellingPoint as! String)\n\n"
            }else{
              sellingPointFinalString = sellingPointFinalString?.appendingFormat("•  %@\n\n", (sellingPoint as? String)!)
            }
            
          }
          
        }
        
      }
      
      
    }
    
    if let sellingPoints =  sellingPointFinalString{
      let removelastNextLine = sellingPoints.dropLast(2)
      sellingPointLabel?.text = String(removelastNextLine)
    }else{
      sellingPointLabel?.text = ""
    }
    //    delegate?.productDetails!(productCode: isUnitViewSelected == true ? cuProductCode : duProductCode, qnt: quantityLabel.text!)
  }
  
  @IBAction func minusButtonAction(_ sender: UIButton) {
    
    let currentCount = Int(tfQuantity.text!)
    
    if currentCount! > 1 {
      tfQuantity.text = "\(currentCount! - 1)"
      WSUtility.setQty(strQty: tfQuantity.text!)
      setProductLoyaltyPoint(loyaltyPoint: strLoyaltyPoints)
    }
    //    delegate?.productDetails!(productCode: isUnitViewSelected == true ? cuProductCode : duProductCode, qnt: quantityLabel.text!)
  }
  @IBAction func plusButtonAction(_ sender: UIButton) {
    let num = Int(tfQuantity.text!)
    if num!+1 <= 1000 {
      let currentCount = Int(tfQuantity.text!)
      tfQuantity.text = "\(currentCount! + 1)"
      WSUtility.setQty(strQty: tfQuantity.text!)
      setProductLoyaltyPoint(loyaltyPoint: strLoyaltyPoints)
    }
  }
  
  @IBAction func buttonActionOnUnitView(_ sender: UIButton) {
    if isUnitViewSelected == true{
      return
    }
    tfQuantity.text = "1"
    isTouchUpInside = true
    selectUnitView()
  }
  func selectUnitView(){
    if isUnitViewSelected == true{
      WSUtility.setProductType(strType: "Unit")
      unitView?.layer.borderColor = ApplicationOrangeColor.cgColor
      caseView?.layer.borderColor = Search_UnitBox_UnSelectedColor.cgColor
      strLoyaltyPoints = productLoyaltyPointForUnit
      return
    }
    
    unitView?.layer.borderColor = isUnitViewSelected ? Search_UnitBox_UnSelectedColor.cgColor : ApplicationOrangeColor.cgColor
    isUnitViewSelected = !isUnitViewSelected
    
    //productLoyaltyPointLabel?.text = productLoyaltyPointForUnit
    setProductLoyaltyPoint(loyaltyPoint: productLoyaltyPointForUnit)
    strLoyaltyPoints = productLoyaltyPointForUnit
    caseView?.layer.borderColor = Search_UnitBox_UnSelectedColor.cgColor
    isCaseViewSelected = false
    WSUtility.setProductType(strType: "Unit")
    if isTouchUpInside{
      WSUtility.setQty(strQty: tfQuantity.text!)
      isTouchUpInside = false
    }
    delegate?.actionOnContainerType(packagingType: unitValue, containerType: "Unit", eanCode: cuEanCode)
  }
  @IBAction func moreProductInformationAction(_ sender: Any) {
    delegate?.showMoreProductInforamtionSection()
  }
  @IBAction func buttonActionOnCaseView(_ sender: UIButton) {
    if isCaseViewSelected == true{
      return
    }
    tfQuantity.text = "1"
    isTouchUpInside = true
    selectCaseView()
  }
  
  func selectCaseView(){
    if isCaseViewSelected == true{
      WSUtility.setProductType(strType: "Case")
      caseView?.layer.borderColor = ApplicationOrangeColor.cgColor
      unitView?.layer.borderColor = Search_UnitBox_UnSelectedColor.cgColor
      strLoyaltyPoints = productLoyaltyPointForCase
      return
    }
    caseView?.layer.borderColor = isCaseViewSelected ? Search_UnitBox_UnSelectedColor.cgColor : ApplicationOrangeColor.cgColor
    isCaseViewSelected = !isCaseViewSelected
    //productLoyaltyPointLabel?.text = productLoyaltyPointForCase
    setProductLoyaltyPoint(loyaltyPoint: productLoyaltyPointForCase)
    strLoyaltyPoints = productLoyaltyPointForCase
    unitView?.layer.borderColor = Search_UnitBox_UnSelectedColor.cgColor
    isUnitViewSelected = false
    WSUtility.setProductType(strType: "Case")
    if isTouchUpInside{
      WSUtility.setQty(strQty: tfQuantity.text!)
      isTouchUpInside = false
    }
    //    delegateContainerType?.updateContainerType(strType: "Case")
    delegate?.actionOnContainerType(packagingType: caseValue, containerType: "Case", eanCode: duEanCode)
  }
  
  func setProductLoyaltyPoint(loyaltyPoint:String)  {
    let num = Int(tfQuantity.text!)
    var strPoints = ""
    if let numLoyalty = Int(loyaltyPoint){
      strPoints = String(numLoyalty * num!)
    }
    
    let loyaltyPointLocalizedString = WSUtility.getlocalizedString(key: "Loyalty Points", lang: WSUtility.getLanguage(), table: "Localizable")
    WSUtility.setAttributedLabel(originalText: "\(loyaltyPointLocalizedString!) \(strPoints)", attributedText: strPoints, forLabel: productLoyaltyPointLabel, withFont: UIFont(name: "DINPro-Medium", size: 16.0)!, withColor: UIColor(red: 250.0/255.0, green: 90.0/255.0, blue: 0, alpha: 1))
  }
  
  /*
   let productIDToSend = senderTag == BUTTON_SET_GOAL_TAG ? prodcutID : ""
   let serviceBussinessLayer =  WSWebServiceBusinessLayer()
   serviceBussinessLayer.setGoalForProduct(productID: productIDToSend, successResponse: { (response) in
   UFSProgressView.stopWaitingDialog()
   self.delegate?.updateCellAfterGoalSet(isGoalSet:productIDToSend == "" ? false : true)
   }) { (errorMessage) in
   UFSProgressView.stopWaitingDialog()
   }
   
   */
}

