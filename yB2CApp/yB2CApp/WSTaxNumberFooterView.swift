//
//  WSTaxNumberFooterView.swift
//  UFS
//
//  Created by Guddu Gaurav on 17/05/2018.
//

import UIKit

class WSTaxNumberFooterView: UIView {
  @IBOutlet weak var labelMessage: UILabel!
  @IBOutlet weak var btnTaxNum: UIButton!
  
 // static let sharedTaxNumberView:WSTaxNumberFooterView = UINib(nibName: "WSTaxNumberFooterView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WSTaxNumberFooterView
  
  
  class func loadnib() ->WSTaxNumberFooterView{
    
    return UINib(nibName: "WSTaxNumberFooterView", bundle: nil).instantiate(withOwner: nil , options: nil)[0] as! WSTaxNumberFooterView
    
//    let taxNumberView:WSTaxNumberFooterView = self.sharedTaxNumberView
//    return taxNumberView
    
  }
  
}
