//
//  UFSMenuFooterView.swift
//  yB2CApp
//
//  Created by Ramakrishna on 9/29/17.
//

import UIKit

@objc protocol MenuFooterViewDelegate{
    func addFooterViewWithTag(value: Int)
}

@objc class UFSMenuFooterView: UIView {
    @IBOutlet weak var menuIconView: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var mFooterButton: UIButton!
    weak var delegate: MenuFooterViewDelegate?
    class func loadnib() ->UFSMenuFooterView{
        return UINib(nibName: "UFSMenuFooterView", bundle: nil).instantiate(withOwner: nil , options: nil)[0] as! UFSMenuFooterView
    }
    
    @IBAction func footerViewButtonAction(sender: UIButton){
        delegate?.addFooterViewWithTag(value: mFooterButton.tag)
    }
    
    public func setUIWithParams(params: [String: Any]){
        
        menuIconView.image = UIImage(named: params[MENU_ICON] as! String)
        menuLabel.text = params[MENU_TITLE] as? String
        mFooterButton.tag = params[MENU_ACTION_TAG] as! Int
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
