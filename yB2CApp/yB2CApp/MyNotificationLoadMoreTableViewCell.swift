//
//  MyNotificationLoadMoreTableViewCell.swift
//  yB2CApp
//
//  Created by Lakshminarayana on 26/12/17.
//

import UIKit
@objc protocol MyNotificationLoadMoreTableViewCellDelegate{
    func loadMoreButtonAction(loadMoreCell:MyNotificationLoadMoreTableViewCell)
}
class MyNotificationLoadMoreTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadMoreButton: UIButton!{
        didSet{
            loadMoreButton.setTitle( WSUtility.getlocalizedString(key: "Load More", lang: WSUtility.getLanguage(), table: "Localizable"), for: UIControlState.normal)
        }
    }
    weak var delegate:MyNotificationLoadMoreTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUI()
    }
    func setUI(){
        loadMoreButton.setTitle(WSUtility.getlocalizedString(key: "Load More", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
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
