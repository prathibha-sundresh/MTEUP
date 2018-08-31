//
//  WSScanDetailViewController.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 21/11/2017.
//
import UIKit
@objc class WSScanDetailViewController: UIViewController {
    var currentProduct = [String:Any]()
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var scanTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    // var product : [HYBProduct] = []
    var selectedCellIndex = Int()
    
    var webServiceBusinessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    
    var selectedProductCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetUp()
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.trackingScreens(screenName: "Product Scan Detail screen")
        UFSGATracker.trackScreenViews(withScreenName: "Product Scan Detail screen")
        FireBaseTracker.ScreenNaming(screenName: "Product Scan Detail Screen", ScreenClass: String(describing: self))
        FBSDKAppEvents.logEvent("Product Scan Detail screen")
    }
    override func viewWillAppear(_ animated: Bool) {
        WSUtility.setCartBadgeCount(ViewController: self)
      if !WSUtility.isTaxNumberAvailable(VCview: self.view){
            WSUtility.addTaxNumberView(viewController: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func btnTaxTapped(sender:UIButton)  {
        let storyBoard: UIStoryboard = UIStoryboard(name: "EnterTaxNumberStoryboard", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WSEnterTaxNumberViewController") as! WSEnterTaxNumberViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.callBack = {
            if let view = self.view.viewWithTag(9006){
                view.removeFromSuperview()
            }
        }
        present(vc, animated: true, completion: nil)
        
    }
    
    /*
     func addBackButton() {
     let backButton = UIButton(type: .custom)
     backButton.setImage(UIImage(named: "signup_back.png"), for: .normal)
     backButton.setTitle(" Back", for: .normal)
     backButton.setTitleColor(ApplicationOrangeColor, for: .normal)
     backButton.titleLabel?.font = UIFont(name: "DINPro-Regular", size: 15)
     backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
     
     self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
     }
     */
    
    @IBAction func rightBarButtonPressed(_ sender: UIButton)  {
        WSUtility.cartButtonPressed(viewController: self)
    }
    func UISetUp()  {
        // nameLabel.text = currentProduct?.name
        WSUtility.addNavigationBarBackButton(controller: self)
        WSUtility.addNavigationRightBarButton(toViewController: self)
    }
    
    @IBAction func addToCartButtonAction(_ sender: UIButton) {
        WSUtility.cartButtonPressed(viewController: self)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.destination is WSProductDetailViewController {
            
            let productVC = segue.destination as? WSProductDetailViewController
            let productCode = currentProduct["baseProduct"]
            productVC?.productCode = "\(productCode!)"
            productVC?.delegate = self
            productVC?.cellIndex = selectedCellIndex
        }
        
    }
}
extension WSScanDetailViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 300.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let productCell:WSScanDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WSScanDetailTableViewCell") as! WSScanDetailTableViewCell
        
        productCell.delegate = self
        productCell.updateCellContent(productDetail: currentProduct)
        productCell.setUI()
        
        productCell.productName.text = currentProduct["name"] as? String
        productCell.addToCartButton.tag = indexPath.row
        productCell.addToCartButton.addTarget(self, action: #selector(addtoCartPressed), for: .touchUpInside)
        //Manage fav/unfav
        if let baseOptions = currentProduct["baseOptions"] as? [[String: Any]]{
            if baseOptions.count > 0{
                let dict = baseOptions[0]
                if let options = dict["options"] as? [[String: Any]]{
                    if options.count > 0{
                        let tmpDict = options[0]
                        
                        if let number = tmpDict["number"] as? String,number != ""{
                            let favoriteProductList = WSUtility.getProductCode()
                            if favoriteProductList .contains(number) {
                                productCell.isProductFavorite(isfavourite: true)
                            } else {
                                productCell.isProductFavorite(isfavourite: false)
                            }
                        }
                    }
                }
            }
        }
        return productCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndex = indexPath.row
        self.performSegue(withIdentifier: "ProductDetailSegue", sender: self)
    }
    
    func addtoCartPressed (sender: UIButton) {
        let selectedIndex = sender.tag
        // DDLogDebug("Add to cart pressed at row %ld", Int(selectedIndex))
        let indexPath = IndexPath(row: selectedIndex, section: 0)
        let cell = scanTableView.cellForRow(at: indexPath) as? WSScanDetailTableViewCell
        addProductToCart(from: cell!, selectedIndex: selectedIndex)
    }
    
    func addProductToCart(from cell: WSScanDetailTableViewCell, selectedIndex: Int) {
        
        let addToCartBussinessHandler = WSAddToCartBussinessLogic()
        addToCartBussinessHandler.addProductToCart(forProduct: selectedProductCode, addedFrom: self)
        
    }
}
extension WSScanDetailViewController:WSScanProductCellDelegate {
    func deleteUnfavouriteProductitem(productNumber: String) {
        WSUtility.removeFavoriteItem(item: productNumber)
    }
    
    func actionOnContainerType(packagingType: String, containerType: String, selectedProductCode Code: String) {
        self.selectedProductCode = Code
    }
    
    
}
extension WSScanDetailViewController:ProductDetailDelegate{
    func reloadRow(cellIndex:Int){
        let indexPath = IndexPath(item: cellIndex, section: 0)
        scanTableView.reloadRows(at: [indexPath], with: .top)
        
    }
}

