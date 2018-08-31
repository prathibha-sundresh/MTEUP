//
//  ProdDetailVideoTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 09/12/2017.
//

import UIKit

class ProdDetailVideoTableViewCell: UITableViewCell {
  @IBOutlet weak var videoThumbnailImage: UIImageView!
    @IBOutlet weak var PlayVideoText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        PlayVideoText.text = WSUtility.getlocalizedString(key: "Play_Video", lang: WSUtility.getLanguage())
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
