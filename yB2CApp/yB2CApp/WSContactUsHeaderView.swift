//
//  WSContactUsHeaderView.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 30/01/2018.
//

import UIKit

protocol HeaderViewDelegate: class {
  func toggleSection(header: WSContactUsHeaderView, section: Int)
}

class WSContactUsHeaderView: UITableViewHeaderFooterView {
  
  @IBOutlet weak var headerTitleLabel: UILabel!
  @IBOutlet weak var arrowImageView: UIImageView!
  
  var section: Int = 0
  weak var delegate: HeaderViewDelegate?
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
     addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }

  
  func setCollapsed(collapsed: Bool) {
   // arrowImageView?.rotate(collapsed ? 0.0 : .pi/3)
  }
  
  @objc private func didTapHeader() {
     delegate?.toggleSection(header: self, section: section)
  }
}

extension UIView {
  func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
    let animation = CABasicAnimation(keyPath: "transform.rotation")
    animation.toValue = toValue
    animation.duration = duration
    animation.isRemovedOnCompletion = false
    animation.fillMode = kCAFillModeForwards
    self.layer.add(animation, forKey: nil)
  }
}
