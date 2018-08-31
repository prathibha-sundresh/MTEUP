//
//  ProductDetailSectionHeaderCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 09/12/2017.
//

import UIKit

@objc protocol SectionHeaderDelegate{
  func toggleSection(header:ProductDetailSectionHeaderCell, section:Int)
}

class ProductDetailSectionHeaderCell: UITableViewHeaderFooterView {

  @IBOutlet weak var sectionTitleLabel: UILabel!
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var sectionButton: UIButton!
  @IBOutlet weak var bottomSepratorView: UIView!
  
  var section:Int?
  weak var delegate:SectionHeaderDelegate?
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  
  @IBAction func tappedOnSection(_ sender: UIButton) {
    delegate?.toggleSection(header: self, section: section!)
  }
  
}
