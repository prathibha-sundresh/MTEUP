//
//  UFSSavedCardTableViewCell.swift
//  UFSDev
//
//  Created by Newlaptop on 25/07/18.
//

import UIKit

class UFSSavedCardsTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate
,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var addAnotherCard: UIButton!
    @IBOutlet weak var addAnotherCardImgBtn: UIButton!
    
    
    var arrayOfCards = [[String: Any]]()
    var deleteAndreloadCards : ((String) -> Void)?
    var updateTheArrayCards : (([[String: Any]]) -> Void)?
    var deletingId : String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        let nib1 = UINib(nibName: "UFSSavedCardCollectionViewCell", bundle: nil)
        self.collectionV?.register(nib1, forCellWithReuseIdentifier: "UFSSavedCardCollectionViewCell")
         pageControl.hidesForSinglePage = true
    }
    func updateColletionV( arrayCards: [[String: Any]]) -> () {
        self.arrayOfCards = arrayCards
        pageControl.numberOfPages = arrayCards.count
        collectionV.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfCards.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UFSSavedCardCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UFSSavedCardCollectionViewCell", for: indexPath) as! UFSSavedCardCollectionViewCell
        //Set image
        let Dic : [String : Any] = arrayOfCards [indexPath.row]
        var imageType = Dic ["cardType"] as! [String : String]
        cell.cardImgV.image = UIImage(named: (imageType["code"]) ?? "")

        //Set Owner name
        cell.cardOwnerNameLbl.text = Dic ["accountHolderName"] as? String
        
        //Set Card Name
        let cardNumber = Dic ["cardNumber"] as? String
        cell.cardTitleLbl.text =  String(format: "%@  %@ \(WSUtility.getlocalizedString(key: "Card ending in", lang: WSUtility.getLanguage())!)", (imageType["code"]) ?? "" ,String((cardNumber?.suffix(4))!))
        
        //Set Date
        let year = Dic ["expiryYear"] as? String
        let month = Dic ["expiryMonth"] as? String
        cell.expiryDateLbl.text =  String(format: "Expiry %@/%@",month!, String((year?.suffix(2))!))
        
        //set seletion
        if let _ = Dic ["IsSelected"] {
            if Dic ["IsSelected"] as! Bool == true{
                cell.radioBtn.isSelected = true
            }else{
                cell.radioBtn.isSelected = false
            }
        }else{
            cell.radioBtn.isSelected = false
        }
        
        // Set delete action in cell
        
        deletingId = (Dic ["id"] as? String) ?? ""
        let underlineAttributes : [String: Any] = [
            NSFontAttributeName : UIFont(name: "DinPro-Regular", size: 14.0)!,
            NSForegroundColorAttributeName : ApplicationOrangeColor,
            NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
        let attributeString = NSMutableAttributedString(string: (WSUtility.getlocalizedString(key: "delete", lang: WSUtility.getLanguage(), table: "Localizable"))!,
                                                        attributes: underlineAttributes)
        cell.deleteBtn.setAttributedTitle(attributeString, for: .normal)
        
        cell.deleteBtn.addTarget(self, action: #selector(deleteCard), for:.touchUpInside )
    
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var Dic : [String : Any] = arrayOfCards [indexPath.row]
        Dic ["IsSelected"] = true
        
        print ("%@",Dic)
        
        var tempArrayOfCards = [[String: Any]]()
        for var cardsDic in arrayOfCards {
            cardsDic ["IsSelected"] = false
            tempArrayOfCards.append(cardsDic)
        }
        tempArrayOfCards [indexPath.row] = Dic
        arrayOfCards = tempArrayOfCards
        updateTheArrayCards!(arrayOfCards) //sync with parent class
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionV.frame.width
        let hight =  self.collectionV.frame.height
        return CGSize(width: width, height: hight)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    @objc func deleteCard(sender : UIButton) {
        deleteAndreloadCards! (deletingId)
    }
 
}
