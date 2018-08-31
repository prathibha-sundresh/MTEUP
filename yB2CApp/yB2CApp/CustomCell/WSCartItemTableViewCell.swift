//
//  WSCartItemTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 06/10/17.
//

import UIKit

class WSCartItemTableViewCell: UITableViewCell {
  
 // _productDetailsTapArea
  
  @IBOutlet weak var productImage: UIImageView!
  @IBOutlet weak var productNameLabel:UILabel!
  @IBOutlet weak var productPriceLabel:UILabel!
  @IBOutlet weak var productPromoLabel:UILabel!
  @IBOutlet weak var itemsInputTextfield:UITextField!
  @IBOutlet weak var totalPriceLabel:UILabel!
  
  var cartItemPosition = ""
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  func load(withItem item: HYBOrderEntry, withProductImage itemImage: UIImage!) {
    //productCode = item.product.code
    productNameLabel.text = item.product.name
    
//    if let promoline = item.discountMessage {
//      productNameLabel.text = promoline
//    }
    
//    let prodformattedPrice : String = (item.basePrice.formattedValue)!
 //   productPriceLabel.text = prodformattedPrice.replacingOccurrences(of: ".", with: ",")
 //   let totformattedPrice : String = (item.basePrice.formattedValue)!
 //   totalPriceLabel.text = totformattedPrice.replacingOccurrences(of: ".", with: ",")
    itemsInputTextfield.text = "\(item.quantity!)"
    cartItemPosition = "\(item.entryNumber)"
    if  let _ = itemImage {
      self.productImage.image = itemImage
    }
  }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
