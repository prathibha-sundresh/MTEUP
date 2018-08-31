//
//  MoneyTransferFooterCell.swift
//  UFS
//
//  Created by Rajesh Reddy on 14/06/18.
//

import UIKit

class MoneyTransferFooterCell: UITableViewCell {
  @IBOutlet weak var lblHeader: UILabel!
  @IBOutlet weak var lblDesc: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    lblHeader.text = WSUtility.getlocalizedString(key: "(Placeholder title) Disclaimer. Payment Terms and Conditions", lang: WSUtility.getLanguage())
    lblDesc.text = "•  Havale/EFT işlemlerinde, siparişinizin gecikmemesi için bankanızın size sunduğu açıklama bölümüne firma isminizi ve sipariş numaranızı girmeniz gereklidir.\n•  Sipariş numaranız, siparişinizi onayladıktan sonra size belirtilecektir.\n•  Sipariş numaranızı \"Sipariş Geçmişim\" sayfasından da görüntüleyebilirsiniz.\n•  Siparişinizin sevkiyatı, Havale / EFT işleminizin bize ulaşmasını takiben 2 iş günü içerisinde yapılacaktır.\n•  HAVALE / EFT işleminizin siparişi takip eden 3 iş günü içerisinde bize ulaşmaması halinde, siparişiniz iptal edilecektir."
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
