//
//  WSOrderSummaryView.swift
//  yB2CApp
//
//  Created by Ramakrishna on 10/10/17.
//

import UIKit

class WSOrderSummaryView: UIView {
    
    @IBOutlet weak var subtotalValue: UILabel!
    @IBOutlet weak var savingsValue: UILabel!
    @IBOutlet weak var taxValue: UILabel!
    @IBOutlet weak var shippingValue: UILabel!
    @IBOutlet weak var orderTotalValue: UILabel!
    
    class func loadnib() ->WSOrderSummaryView{
        return UINib(nibName: "WSOrderSummaryView", bundle: nil).instantiate(withOwner: nil , options: nil)[0] as! WSOrderSummaryView
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
