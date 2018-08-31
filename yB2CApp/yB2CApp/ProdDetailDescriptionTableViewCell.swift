//
//  ProdDetailDescriptionTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 09/12/2017.
//

import UIKit

class ProdDetailDescriptionTableViewCell: UITableViewCell {

  @IBOutlet weak var productDescriptionTextLabel: UILabel!
  @IBOutlet weak var fourthDescriptionValueLabel: UILabel!
  @IBOutlet weak var fourthDescriptionLabel: UILabel!
  @IBOutlet weak var thirdDescriptionValueLabel: UILabel!
  @IBOutlet weak var thirdDescriptionLabel: UILabel!
  @IBOutlet weak var secondDescriptionValueLabel: UILabel!
  @IBOutlet weak var secondDescriptionBoxLabel: UILabel!
  @IBOutlet weak var firstDescriptionLabel: UILabel!
  @IBOutlet weak var firstDescriptionValueLabel: UILabel!
  @IBOutlet weak var fifthDescriptionLabel: UILabel!
  @IBOutlet weak var fifthDescriptionValueLabel: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func updateCellContent()  {
    
  }
  
}
