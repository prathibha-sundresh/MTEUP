//
//  UFSCatlogViewController.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 27/09/17.
//

import UIKit

@objc class UFSCatlogViewController: BaseViewController {
  
  @IBOutlet weak var catlogTableView: UITableView!
  var isGridView = false
  var currentCategoryId = ""
  var product = [HYBProducts]()
  
  var blockScroll = false
  var loading = false
  var  allItemsLoaded = false
  
    var webServiceBusinessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()

  //var  backgroundDownloadQueue = dispatch_time_t()
  //var backendServiceCatLog:HYBB2CService = (UIApplication.shared.delegate as! HYBAppDelegate).backEndService
  
 /*
  override init(backEnd backendService: HYBB2CService) {
    super.init(backEnd: backendService)
    
   // isGridView = false
   // backgroundDownloadQueue = DispatchQueue(label: "backgroundDownloadQueue")
   // assert(self.backendServiceCatLog != nil, "Provide a valid backEndService.")

  }
 */
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    // fatalError("init(coder:) has not been implemented")
  }
  /*
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

   
  */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
      addSlideMenuButton()
      catlogTableView.estimatedRowHeight = 50
      catlogTableView.tableFooterView = UIView(frame: CGRect.zero)
      
    }

  override func  viewDidAppear(_ animated: Bool) {
   // loadAllProducts()
    
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func loadAllProducts() {
    

  }
  
  func loadBaseProducts(byCategoryId categoryId: String) {
   // backendServiceCatLog.resetPagination()
    product.removeAll()
    allItemsLoaded = false
    loading = true
    loadProductsByCategoryId(categoryId: categoryId)
   // loadProducts(byCategoryId: categoryId)
  }
  
  func loadProductsByCategoryId(categoryId: String) {
//    cacheCurrentCategoryId(categoryId)
//    //DDLogDebug("Loading products for category %@", currentCategoryId)
//     print("Loading products for category %@", currentCategoryId)
//
//    self.backendServiceCatLog.findProducts(byCategoryId: currentCategoryId, andExecute: {[weak self] (_ products, _ error) in
//      if error != nil {
//       // DDLogError("Problems during the retrieval of the products from the web service: %@", error?.localizedDescription)
//      }
//      else {
//        print("products : %@",products)
//        guard products != nil else{
//          self?.processNewProducts([HYBProduct]())
//          return
//        }
//        self?.processNewProducts(products as! [HYBProduct])
//      }
//    })
  }
  
  func loadProducts() {
//    self.backendServiceCatLog.getProductsAndExecute({(_ products, _ error) in
//      if error != nil {
//       // DDLogError("Problems during the retrieval of the products from the web service: %@", error?.localizedDescription)
//      }
//      else {
//
//        guard products != nil else{
//          self.processNewProducts([HYBProduct]())
//          return
//        }
//
//        print("products : %@",products!)
//       self.processNewProducts(products as! [HYBProduct])
//      }
//    })
  }

  func cacheCurrentCategoryId(_ newCatID: String) {
    if (currentCategoryId.characters.count == 0 || (currentCategoryId != newCatID)) {
      currentCategoryId = newCatID
    }
  }
  
  /**
   *  refresh ui with new products added by scrolling down
   *
   *  @param newProducts array of products
   */
  
    func processNewProducts(_ newProducts: [HYBProducts]) {
        
    }
  func forceReload()  {
    catlogTableView.reloadData()
  }
  
  func loadNextProducts() {
    if !loading {
      loading = true
      forceReload()
      //small delay to allow ui to display loading indicator
      perform(#selector(self.doLoad), with: nil, afterDelay: 0.2)
    }
  }
  
  func doLoad() {
    
      if currentCategoryId.characters.count > 0 {
        loadProductsByCategoryId(categoryId: currentCategoryId)
      }
      else {
        loadProducts()
      }
  }
  
//  func calculateTotals(for cell: UFSCatlogListTableViewCell, with prod: HYBProduct) {
//    let quantity = NumberFormatter().number(from: cell.quantityInputField.text!)
//    if (quantity != nil) && prod.price.hyb_isNotBlank() {
//      let totalPrice = CGFloat(Float(prod.price.value) * Float(cell.quantityInputField.text!)!)
//      //TODO: adapt for currencyIso
//      let currencySign = "€"
//      let totalPriceLabelValue = "\(currencySign) \(totalPrice)" //String(format: "% %.2f", currencySign,totalPrice)
//
//      cell.totalItemPrice.text = totalPriceLabelValue
//      cell.setNeedsLayout()
//    }
//  }
  
  @IBAction func myShoppingButtonAction(_ sender: UIButton) {
    self.tabBarController?.selectedIndex = 0
  }
  //  func addProductToCart(from cell: UFSCatlogListTableViewCell, selectedIndex: Int) {
//    let orderInputField: UITextField? = cell.quantityInputField
//    orderInputField?.resignFirstResponder()
//    let product: HYBProduct? = self.product[selectedIndex]
//    let amount = NumberFormatter().number(from: (orderInputField?.text)!)
//    if amount != nil {
//     // DDLogDebug("Adding product %@ in amount %d to cart ", product?.code, amount!)
//     // weakify(self)
//      backendServiceCatLog.addProduct(toCurrentCart: product?.code, amount: amount, andExecute: {(_ cart, _ error) in
//        //strongify(self)
//        if cart == nil {
//          //DDLogError("Product %@ not added to cart.", product?.code)
//          print("product not added to cart : %@",product?.code ?? "no value")
//        }
//        else {
//          orderInputField?.text = "1"
//          self.calculateTotals(for: cell, with: product!)
//        }
//        self.showNotifyMessage((error as! Error).localizedDescription)
//
//      })
//    }
//  }
  
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
      print("cat prepare start")
      
      let indexPath = (sender as! IndexPath)
      let navigationController = segue.destination as! UINavigationController
      let productDetail = navigationController.childViewControllers[0] as! UFSProductDetailsViewController
      productDetail.product = self.product[indexPath.row]
 
 
      print("cat prepare end")
    }
  
  func itemsQuantityChanged(_ field: UITextField, andAddToCart addToCart: Bool) {
//    let selectedIndex: Int = field.tag
//    let indexPath = IndexPath(item: selectedIndex, section: 0)
//    let cell = catlogTableView.cellForRow(at: indexPath) as? UFSCatlogListTableViewCell
//    let selectedProduct: HYBProducts? = product[selectedIndex]
//    //calculateTotals(for: cell!, with: selectedProduct!)
//    assert(cell?.hyb_isNotBlank() != nil, "Cell was not found")
//    if addToCart {
//      //addProductToCart(from: cell!, selectedIndex: selectedIndex)
//    }
  }
  
//  func drawerController() -> HYBDrawerController {
//  let appDelegate =  (UIApplication.shared.delegate as! HYBAppDelegate)
//    return  (appDelegate.window.rootViewController as! HYBDrawerController)
//  }
}

extension UFSCatlogViewController: UITableViewDelegate,UITableViewDataSource{
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    let cell: UFSCatlogListTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "UFSCatlogListTableViewCell") as! UFSCatlogListTableViewCell
   // cell.starsView.rating = 3.5
    cell.delegate = self
    cell.cartButton.tag = indexPath.row
    cell.quantityInputField.tag = indexPath.row
    let prod:HYBProducts = self.product[indexPath.row]
    cell.updateCellContent(productInfo:prod)
    
    return cell
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("cat didSelectRowAt")
    //self.drawerController().closeDrawersIfNeeded()
    //self.drawerController().refreshLayout()
     self.performSegue(withIdentifier: "ProductDetailSegueID", sender: indexPath)
  // self.performSegue(withIdentifier: "testSegueID", sender: indexPath)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //block initial table view scroll
    if blockScroll {
      return
    }
    // UITableView only moves in one direction, y axis
    let currentOffset: CGFloat = scrollView.contentOffset.y
    let maximumOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
    // Change 10.0 to adjust the distance from bottom
    if maximumOffset - currentOffset <= 10.0 {
      if !allItemsLoaded {
        loadNextProducts()
      }
    }
  }
}

extension UFSCatlogViewController:UFSCatlogCellDelegate{
  func updateTotalAmountFromInputTextField(textField: UITextField, cell: UFSCatlogListTableViewCell, isAddTocart: Bool) {
    itemsQuantityChanged(textField, andAddToCart: isAddTocart)
  }
  
//  func addtoCartPressed (senderTag: Int) {
//    let selectedIndex = senderTag
//    // DDLogDebug("Add to cart pressed at row %ld", Int(selectedIndex))
//    let indexPath = IndexPath(row: selectedIndex, section: 0)
//    let cell = catlogTableView.cellForRow(at: indexPath) as? UFSCatlogListTableViewCell
//    addProductToCart(from: cell!, selectedIndex: selectedIndex)
//  }
//
    func addtoCartPressed (senderTag: Int) {
        let selectedIndex = senderTag
        // DDLogDebug("Add to cart pressed at row %ld", Int(selectedIndex))
        let indexPath = IndexPath(row: selectedIndex, section: 0)
        let cell = catlogTableView.cellForRow(at: indexPath) as? UFSCatlogListTableViewCell
        //addProductToCart(from: cell!, selectedIndex: selectedIndex)
    }
//    func addProductToCart(from cell: UFSCatlogListTableViewCell, selectedIndex: Int) {
//
//
//        let product: HYBProduct? = self.product[selectedIndex]
//        let variantOption: HYBVariantOption = (product!.variantOptions[0] as? HYBVariantOption)!;
//        if let currentCart = backendService.currentCartFromCache(){
//            UFSProgressView.showWaitingDialog("")
//            webServiceBusinessLayer.addToCart(product: (variantOption.code)!, cart_id: currentCart.code, successResponse: {(response) in
//                print(response)
//                self.retriveCurrentCart()
//            }) {(errorMessage) in
//                UFSProgressView.stopWaitingDialog()
//            }
//        }
//    }
    
    func retriveCurrentCart(){

    }
}


