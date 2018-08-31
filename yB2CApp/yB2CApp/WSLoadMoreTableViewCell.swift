//
//  WSLoadMoreTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 06/12/2017.
//

import UIKit

@objc protocol WSLoadMoreTableViewCellDelegate{
  func loadMoreButtonAction(loadMoreCell:WSLoadMoreTableViewCell)
}

class WSLoadMoreTableViewCell: UITableViewCell {
  @IBOutlet weak var loadmoreButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  weak var delegate:WSLoadMoreTableViewCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
   
  }
    func setUI(){
         loadmoreButton.setTitle(WSUtility.getlocalizedString(key: "Load More", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
      loadmoreButton.isHidden = false
    }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func loadMoreButtonAction(_ sender: UIButton) {
    sender.isHidden = true
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
    delegate?.loadMoreButtonAction(loadMoreCell: self)
  }
}
