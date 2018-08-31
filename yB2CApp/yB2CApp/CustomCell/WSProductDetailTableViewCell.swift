//
//  WSProductDetailTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 04/10/17.
//

import UIKit

class WSProductDetailTableViewCell: UITableViewCell {
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var updatedPriceLabel: UILabel!
  @IBOutlet weak var stockLabel: UILabel!
  @IBOutlet weak var quantityInputTextField: UITextField!
  @IBOutlet weak var addToCartButton: UIButton!
  @IBOutlet weak var productDescriptionLabel: UILabel!
  @IBOutlet weak var imageCollectionView: UICollectionView!
 @IBOutlet weak var pageControl: UIPageControl!
  
  var fetchedProductImageArray = [UIImage]()
    override func awakeFromNib() {
      
      super.awakeFromNib()
        // Initialization code
    }
    
    func setUI(){
        addToCartButton.setTitle(WSUtility.getlocalizedString(key: "Add to cart", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  func updateCellContent(productInfo:HYBProducts, fetchedProductImageArray:[UIImage])  {
    self.fetchedProductImageArray = fetchedProductImageArray
    pageControl.numberOfPages = fetchedProductImageArray.count
    imageCollectionView.reloadData()
    productNameLabel.text = productInfo.name;
    //_productCodeLabel.text      = productInfo.code;
    //TODO AJAY
    //let formattedPrice = productInfo.price.formattedValue.replacingOccurrences(of: "$", with: "€");
    //priceLabel.text = formattedPrice.replacingOccurrences(of: ".", with: ",");

    
    productDescriptionLabel.text = productInfo.summary;
    //TODO AJAY
//    if let inStockValue = productInfo.stock.stockLevel{
//      stockLabel.text = "\(inStockValue) "+"in stock"
//    }else{
//      stockLabel.text = "\(0) "+"in stock"
//    }
//    //[NSString stringWithFormat:NSLocalizedString(@"%d in stock", nil), [productInfo.stock.stockLevel integerValue]];
//
//    if (productInfo.lowStock() == true) {
//      stockLabel.textColor = UIColor.green
//    }else {
//      stockLabel.textColor = UIColor.red
//    }
//
//    if let stockLevel = productInfo.stock.stockLevel{
//      addToCartButton.isEnabled = Int(stockLevel) > 0 ? true : false
//    }
    
  }
  
  
  @IBAction func addToCartButtonTapped(_ sender: UIButton) {
  }
}

extension WSProductDetailTableViewCell:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.fetchedProductImageArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let imageCell:WSProductImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WSProductImageCollectionViewCell", for: indexPath) as! WSProductImageCollectionViewCell
    imageCell.productImage.image = fetchedProductImageArray[indexPath.row]
    return imageCell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let screenWidth = UIScreen.main.bounds.width
    return CGSize(width: (screenWidth - 30), height: 150)
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
    let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
    pageControl.currentPage = Int(pageNumber)
  }
  
}

