//
//  UFSCatlogListTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 28/09/17.
//

import UIKit
@objc protocol UFSCatlogCellDelegate {
  func addtoCartPressed(senderTag:Int)
  func updateTotalAmountFromInputTextField(textField:UITextField, cell:UFSCatlogListTableViewCell, isAddTocart:Bool)
}

class UFSCatlogListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var productIcon: UIImageView!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var viewersLabel: UILabel!
  @IBOutlet weak var totalItemPrice: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var stockLabel: UILabel!
  @IBOutlet weak var quantityInputField: UITextField!
  @IBOutlet weak var cartButton: UIButton!
  @IBOutlet weak var productCodeLabel: UILabel!
  
  var firstResponderOriginalValue = ""
  
 weak var delegate:UFSCatlogCellDelegate?
 // @IBOutlet weak var starsView: RatingView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func updateCellContent(productInfo: HYBProducts)  {
    productNameLabel.text = productInfo.name
    productCodeLabel.text = productInfo.code
   
    
 //   if let thumbnailUrl = productInfo.thumbnailURL {
//      let backendServiceCatLog:HYBB2CService = (UIApplication.shared.delegate as! HYBAppDelegate).backEndService
//      let baseURL = backendServiceCatLog.baseURL()
//      let endIndex = baseURL?.index((baseURL?.endIndex)!, offsetBy: -5)
//      let baseURLNoRest = baseURL?.substring(to: endIndex!)
//      
//      let fullURLstring: String = baseURLNoRest! + (thumbnailUrl)
//      // productIcon.sd_setImage(with: URL(string: fullURLstring), placeholderImage: UIImage(named: "placeholder.png"))
//        
//        productIcon.sd_setImage(with: URL(string: fullURLstring), placeholderImage: UIImage(named: "placeholder.png"), options: .allowInvalidSSLCertificates)
      
//    }
    
//    var stockLabelValue = ""
//
//    if productInfo.multidimensional {
//    //  setHiddenForAddToCartArea(cell, toValue: true)
//    }
//    else {
//     // setHiddenForAddToCartArea(cell, toValue: false)
//      // stock info in the live view is present only for not multi-d products
//      if productInfo.isInStock() && !productInfo.lowStock() {
//        stockLabelValue = NSLocalizedString("product_list_in_stock", comment: "")
//        stockLabel.textColor = UIColor.green
//      }
//      else if productInfo.lowStock() {
//        stockLabelValue = String(format: NSLocalizedString("product_list_low_stock_number", comment: ""), productInfo.stock.stockLevel)
//        stockLabel.textColor = UIColor.red
//      }
//      else if !productInfo.isInStock() {
//       // buttonEnabled = false
//        stockLabelValue = NSLocalizedString("product_list_out_of_stock", comment: "out of stock")
//        stockLabel.textColor = UIColor.red
//      }
//    }
//    stockLabel.text = stockLabelValue
//
    
    //calculateTotals(prod: productInfo)
    
  }
  
  
  @IBAction func updateTotalAmount(_ sender: UITextField) {
    delegate?.updateTotalAmountFromInputTextField(textField: sender, cell: self, isAddTocart: false)
  }
  
  @IBAction func addToCartButtonAction(_ sender: UIButton) {
    delegate?.addtoCartPressed(senderTag: sender.tag)
  }
}

extension UFSCatlogListTableViewCell:UITextFieldDelegate{
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    firstResponderOriginalValue = textField.text!
    return true;
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    
    if textField.text! == "" {
      textField.text = firstResponderOriginalValue
    }
    return true;
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
   // self.itemsQuantityChanged(textField, andAddToCart: true)
   // delegate?.updateTotalAmountFromInputTextField(textField: textField, cell: self, isAddTocart: true)
    textField.resignFirstResponder()
    return false
  }
  
  
  
  
}
