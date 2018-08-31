//
//  WSOrderDetailsTableViewCell.swift
//  yB2CApp
//
//  Created by Sahana Rao on 06/12/17.
//

import UIKit
@objc protocol WSOrderDetailsTableViewCellDelegate{
  func addToCartButtonTapped(index:Int)
 
}

class WSOrderDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var addToCartButton: WSDesignableButton!
    @IBOutlet weak var orderImageView: UIImageView!
    @IBOutlet weak var orderNameLabel: UILabel!{
        didSet{
            //orderNameLabel.sizeToFit()
        }
    }
    @IBOutlet weak var orderVolumeLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var pointsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var orderQuantityLabel: UILabel!
    @IBOutlet weak var orderCostLabel: UILabel!
  
    let quantityText = "\(WSUtility.getlocalizedString(key: "Quantity", lang: WSUtility.getLanguage(), table: "Localizable")!): "
 weak var delegate:WSOrderDetailsTableViewCellDelegate?
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
  
  @IBAction func addToCart(_ sender: UIButton) {
    
    delegate?.addToCartButtonTapped(index: sender.tag)
    
    /*
    var appVersion = ""

    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        appVersion = version
    }
*/
    
    UFSGATracker.trackEvent(withCategory: "add to cart", action: "Button click", label: "added product to cart", value: nil)
    FBSDKAppEvents.logEvent("add to cart Button clicked")
  }
  
    func translateUI(){
        let attributedString = NSMutableAttributedString(string: WSUtility.getlocalizedString(key: "Remove", lang: WSUtility.getLanguage(), table: "Localizable")!)
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 255.0/255.0, green: 90.0/255.0, blue: 0.0/255.0, alpha: 1.0), range: NSRange(location: 0, length: attributedString.length))
        removeButton .setAttributedTitle(attributedString, for: .normal)
        removeButton.isHidden = true
        let font = UIFont(name:"DINPro-Regular", size: 13.0)
        pointsSegmentedControl.setTitleTextAttributes([NSFontAttributeName: font!],
                                                      for: .normal)
       pointsSegmentedControl.setTitle(WSUtility.getlocalizedString(key: "Points", lang: WSUtility.getLanguage(), table: "Localizable"), forSegmentAt: 1)
        
        addToCartButton.setTitle(WSUtility.getlocalizedString(key: "Add to cart", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    }
    
    func setUI(dict:[String:Any]){
       
                    if let orderName = dict["productName"] as? String{
                        orderNameLabel.text = orderName
                    }
                    if let totalLoyaltyPoints = dict["totalLoyaltyPoints"] as? Int{
                        pointsSegmentedControl.setTitle("\(totalLoyaltyPoints)", forSegmentAt: 0)
                        
                        
                    }
                    
                    if let orderVolume =  dict["packagingDescription"]  as? String{
                        orderVolumeLabel.text = "Verpakking: \(orderVolume)"
                    }
                    if let orderQuantity = dict["quantity"] as? Int{
                        orderQuantityLabel.text = quantityText + "\(orderQuantity)"
                    }
      /*
                    if let orderCost = dict["totalPrice"] as? Double{
                      let removeDotFromPrice = "\(orderCost)".replacingOccurrences(of: ".", with: ",")
                        if WSUtility.getCountryCode() == "CH"{
                            orderCostLabel.text = "CHF \(removeDotFromPrice)"
                        }
                        else if WSUtility.getCountryCode() == "TR"{
                            orderCostLabel.text = "\(removeDotFromPrice) ₺"
                        }
                        else{
                            orderCostLabel.text = "€ \(removeDotFromPrice)"
                        }
                      
                    }
 */
      
      if let orderCost = dict["totalPrice"] as? String{
        orderCostLabel.text = orderCost
      }else{
        orderCostLabel.text = ""
      }
      
      
                    if let orderimageview = dict["productImageUrl"] as? String{
                        orderImageView.sd_setImage(with: URL(string:orderimageview), placeholderImage: UIImage(named: "placeholder.png"))

                    }
        
        
    }
    
}

