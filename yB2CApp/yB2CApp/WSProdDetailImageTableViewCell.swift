//
//  WSProdDetailImageTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 09/12/2017.
//

import UIKit

class WSProdDetailImageTableViewCell: UITableViewCell {

  @IBOutlet weak var topBannerTitleLabel: UILabel!
  @IBOutlet weak var topBannerImageView: UIImageView!
  @IBOutlet weak var bottomBannerTitleLabel: UILabel!
  @IBOutlet weak var bottomBannerImageView: UIImageView!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  func updateCellContent(productDetail:[String:Any])  {
  
    if let sellingStory = productDetail["sellingStory"] as? [[String:Any]] {
      
      if sellingStory.count > 0{
        
        if let bottomTitle = sellingStory[0]["reasonToBelieveCopy"] as? String{
           bottomBannerTitleLabel.text = bottomTitle
        }else if let bottomTitle = sellingStory[0]["rtbClaim"] as? String{
          bottomBannerTitleLabel.text = bottomTitle
        }
        
       
        /*
        if let bannerImagePath = sellingStory[0]["picOriPicType"] as? String{
           bottomBannerImageView.sd_setImage(with: URL(string:bannerImagePath), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
      */
        
        topBannerTitleLabel.text = sellingStory[0]["truthcopy"] as? String
        
        if let pictures = sellingStory[0]["pictures"] as? [[String:Any]]{
        
          if pictures.count == 0{
            
            if let topImageUrl = sellingStory[0]["truthVisualImageUrl"] as? String{
              
              topBannerImageView.sd_setImage(with: URL(string:(topImageUrl)), placeholderImage: #imageLiteral(resourceName: "placeholder"))
              
              if let bottomImageUrl = sellingStory[0]["rtbImageAfterUrl"] as? String{
                bottomBannerImageView.sd_setImage(with: URL(string:(bottomImageUrl)), placeholderImage: #imageLiteral(resourceName: "placeholder"))
              }
              
            }
            
            
          }else{
          
          for (index, element) in pictures.enumerated() {
            print("Item \(index): \(element)")
            
              if let imageURL = pictures[index]["imageUrl"] as? String {
                //let urlComponents = NSURLComponents(string: imageURL)
                //urlComponents?.user =  "ufsstage"
                //urlComponents?.password = "emakina"
                
                if index == 0{
                  topBannerImageView.sd_setImage(with: URL(string:(imageURL)), placeholderImage: #imageLiteral(resourceName: "placeholder"))
                }else{
                  bottomBannerImageView.sd_setImage(with: URL(string:(imageURL)), placeholderImage: #imageLiteral(resourceName: "placeholder"))
                }
                
              }
              
            
          }
          
          }
          
        }else if let topImageUrl = sellingStory[0]["rtbImageAfterUrl"] as? String{
          
          topBannerImageView.sd_setImage(with: URL(string:(topImageUrl)), placeholderImage: #imageLiteral(resourceName: "placeholder"))
          
          if let bottomImageUrl = sellingStory[0]["truthVisualImageUrl"] as? String{
             bottomBannerImageView.sd_setImage(with: URL(string:(bottomImageUrl)), placeholderImage: #imageLiteral(resourceName: "placeholder"))
          }
          
        }
        
      }
    }
    
  }
  
}
