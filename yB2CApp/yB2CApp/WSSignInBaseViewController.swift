//
//  WSSignInBaseViewController.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 09/11/17.
//

import UIKit

class WSSignInBaseViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var changeLocationButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var secondImageView: UIImageView!
    
    @IBOutlet weak var InfoView: UIView!
    @IBOutlet weak var ImagesView: UIView!
    @IBOutlet weak var brandsColletionView: UICollectionView!
    var listOfBrands: [[String: Any]] = []
    @IBOutlet weak var infoLabel: UILabel!{
        didSet{
            infoLabel.layer.cornerRadius = 6
            infoLabel.layer.masksToBounds = true
            infoLabel.numberOfLines = 0
            infoLabel.sizeToFit()
        }
    }

    @IBOutlet weak var createAccountButton: WSDesignableButton!
    @IBOutlet weak var loginButton: WSDesignableButton!
    var infoLabelString:String = ""
    var CountryloyaltyPoints = ""
    var attributedString = NSMutableAttributedString()
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightSmallView: UIView!
    
    @IBOutlet weak var brandsCVHeight: NSLayoutConstraint!
    @IBOutlet weak var brandsImagesHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
      //  createAccountButton.setTitle(WSUtility.getlocalizedString(key:"Create a FREE account", lang:WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        let mainScreenBound = UIScreen.main.bounds
        self.scrollView.frame = CGRect(x:0, y:0, width:mainScreenBound.width, height:mainScreenBound.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        //2
        let imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgOne.image = UIImage(named: "USP3")
        let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "USP1")
        let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "USP2")
        
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        //3
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 3, height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        self.automaticallyAdjustsScrollViewInsets = false;
      

    }
    func setUpView(){
        
        self.createAccountButton.setTitle(WSUtility.getlocalizedString(key:"Create a FREE account", lang:WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        self.changeLocationButton.setTitle(WSUtility.getlocalizedString(key:"Change location and language", lang:WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        loginButton.setTitle(WSUtility.getlocalizedString(key:"Log in", lang:WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        enableDisableFeature()
        getCountryLoyaltyPoints()
        self.showFirstView()
      
    }
  override func viewWillAppear(_ animated: Bool) {
    
    self.pageControl.currentPage = 0
    self.brandsCVHeight.constant = 104
    self.brandsImagesHeight.constant = 174
    scrollView.contentOffset = CGPoint(x: 0, y: 0)
    self.navigationController?.navigationBar.isHidden = true
    setUpView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    
    self.navigationController?.navigationBar.isHidden = false
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  func enableDisableFeature() {
    UFSProgressView.showWaitingDialog("")
    let webservice = WSWebServiceBusinessLayer()
    webservice.featureEnableDisableForcountries(success: { (response) in
      UFSProgressView.stopWaitingDialog()
      self.getHybrisToken()
    }) { (error) in
      //Error
      UFSProgressView.stopWaitingDialog()
    }
  }
  
    //MARK: UIScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        if scrollView != brandsColletionView{
            let pageWidth:CGFloat = scrollView.frame.width
            let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
            pageControl.currentPage = Int(currentPage)
            
            self.brandsCVHeight.constant = 104
            self.brandsImagesHeight.constant = 174
           // ImagesView.isUserInteractionEnabled = false
            
            if Int(currentPage) == 2{
                showSecondView()
            } else if Int(currentPage) == 0{
                showFirstView()
            } else {
                showThirdView()
              //  ImagesView.isUserInteractionEnabled = true
                if self.listOfBrands.count == 0{
                    self.brandsImagesHeight.constant = 110
                    self.brandsCVHeight.constant = 0
                }
            }
        }
    }
    
    
    
    func showThirdView(){
        infoLabel.backgroundColor = UIColor.clear
        
        brandsColletionView.isHidden = false
        secondImageView.isHidden = true
        ImagesView.isHidden = false
        attributedString = NSMutableAttributedString(string: WSUtility.getlocalizedString(key:"Order our products and get them delivered by your trusted trade partner", lang:WSUtility.getLanguage(), table: "Localizable")!, attributes:[NSFontAttributeName:
            UIFont(name: "DinPro-Medium", size: 16.0)!])
        infoLabel.attributedText = attributedString
    }
    func showFirstView(){
        infoLabel.backgroundColor = UIColor.white
        
        brandsColletionView.isHidden = true
        secondImageView.isHidden = true
        ImagesView.isHidden = true
        attributedString = NSMutableAttributedString(string: (WSUtility.getlocalizedString(key:"Get rewarded! Register now and get 50 loyalty points.", lang:WSUtility.getLanguage(), table: "Localizable")?.replacingOccurrences(of: "%@", with: CountryloyaltyPoints))!, attributes:[NSFontAttributeName: UIFont(name: "DinPro-Medium", size: 16.0)!])
        
        attributedString.setColorForText((WSUtility.getlocalizedString(key: "Register now and get", lang: WSUtility.getLanguage()))!, with: UIColor(red: 51 / 255.0, green: 51 / 255.0, blue: 51 / 255.0, alpha: 1.0), with: UIFont(name: "DinPro-Bold", size: 16.0))
        
        attributedString.setColorForText((WSUtility.getlocalizedString(key: "50 loyalty points", lang: WSUtility.getLanguage())?.replacingOccurrences(of: "%@", with: CountryloyaltyPoints))!, with: UIColor.orange, with: UIFont(name: "DinPro-Bold", size: 16.0))
        
        if WSUtility.getLanguage() == "en" {
            attributedString.setAttributes([NSFontAttributeName : UIFont(name: "DinPro-Medium", size: 16.0)!
                , NSForegroundColorAttributeName : UIColor(red: 232 / 255.0, green: 117 / 255.0, blue: 40 / 255.0, alpha: 1.0)], range: NSRange(location:35,length:18))
        }
        infoLabel.attributedText = attributedString
    }
    func showSecondView(){
        infoLabel.backgroundColor = UIColor.clear
        
        brandsColletionView.isHidden = true
        secondImageView.isHidden = false
        ImagesView.isHidden = false
        attributedString = NSMutableAttributedString(string: WSUtility.getlocalizedString(key:"Earn loyalty points for kitchen equipment.", lang:WSUtility.getLanguage(), table: "Localizable")!, attributes:[NSFontAttributeName:
            UIFont(name: "DinPro-Medium", size: 16.0)!])
        infoLabel.attributedText = attributedString
    }
    func getCountryLoyaltyPoints() {
        UFSProgressView.showWaitingDialog("")
        let wsserviceLayer = WSWebServiceBusinessLayer()
        wsserviceLayer.getCountryLoyaltyPoints(success: {(response) in
            UFSProgressView.stopWaitingDialog()
            if let loyaltyPoints = response["loyalty_points"]{
                self.CountryloyaltyPoints = "\(loyaltyPoints)"
                UserDefaults.standard.setValue(loyaltyPoints, forKey: COUNTRY_LOYALTY_POINTS)
                self.infoLabel.backgroundColor = UIColor.white
                self.showFirstView()
            }
            
            self.listOfBrands.removeAll()
            if let brands = response["brands"] as? [[String: Any]], brands.count > 0{
                self.listOfBrands = brands
            }
            if self.listOfBrands.count > 4{
                self.brandsColletionView.isScrollEnabled = true
            }
            else{
                self.brandsColletionView.isScrollEnabled = false
            }
            self.brandsColletionView.reloadData()
        }, failure: {(error) in
            UFSProgressView.stopWaitingDialog()
        })
    }
  
  /// Get Hybris Token
  func getHybrisToken()   {
    UFSProgressView.showWaitingDialog("")
    let webServiceBussinessLayer = WSWebServiceBusinessLayer()
    webServiceBussinessLayer.makeGuestTrustedClientAndExecute(successResponse: { (success) in
      UFSProgressView.stopWaitingDialog()
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
    }
  }
  
}
extension UIView {
    
    func addTopBorder(_ color: UIColor, height: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutAttribute.height,
                                                relatedBy: NSLayoutRelation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutAttribute.height,
                                                multiplier: 1, constant: height))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.top,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.top,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.leading,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.leading,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.trailing,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.trailing,
                                              multiplier: 1, constant: 0))
    }
    
    
}
extension WSSignInBaseViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfBrands.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "brandsCellID", for: indexPath) as! BrandsCell
        let dict = listOfBrands[indexPath.row]
        if let imageURL = dict["brand_image"] as? String {
            cell.imageView.sd_setImage(with: URL(string:(imageURL)), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
        
        return cell
    }
}
