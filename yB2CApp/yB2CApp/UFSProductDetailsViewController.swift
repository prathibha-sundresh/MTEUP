//
//  UFSProductDetailsViewController.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 04/10/17.
//

import UIKit

class UFSProductDetailsViewController: UIViewController {
  @IBOutlet weak var productTableView: UITableView!
  var code = ""
 var product:HYBProducts?
  var productImageArray = [UIImage]()
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      self.title = "Product Detail"
      createNavigationLeftBarButton()
      
      print("viewDidLoad")
    }
  
  override func viewWillAppear(_ animated: Bool) {
     print("viewWillAppear")
    loadAllProductImages()
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  // MARK: - Custom Navigation Bar Button
  func createNavigationLeftBarButton() {
    let btn = UIButton(type: .custom)
    //btn.frame = CGRect(x: 0, y: 0, width: 38, height: 35)
    btn.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
    btn.setImage(#imageLiteral(resourceName: "Cancel"), for: .normal)
    btn.imageView?.clipsToBounds = true
    btn.addTarget(self, action: #selector(leftBarButtonAction(sender:)), for: .touchUpInside)
    let emailButton = UIBarButtonItem(customView: btn)
    navigationItem.leftBarButtonItem = emailButton
    
  }
  
  func leftBarButtonAction(sender:UIButton)  {
    self.dismiss(animated: true, completion: nil)
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  
  func loadAllProductImages() {
    //TODO AJAY
//    let backendService:HYBB2CService = (UIApplication.shared.delegate as! HYBAppDelegate).backEndService
//    backendService.loadImages(for: product, andExecute: {(_ fetchedImages, _ error)  in
//      if error != nil {
//       // DDLogError("Can not retrieve images for product %@ - %@", product.code, error?.localizedDescription)
//      }
//      else {
//       // DDLogDebug("Retrieved %lu images, starting controller images init...", UInt(fetchedImages.count))
//       // mainView.displayProductsImages(fetchedImages)
//        self.productImageArray = fetchedImages as! [UIImage]
//        self.productTableView.reloadData()
//      }
//    })
  }
  
}
extension UFSProductDetailsViewController:UITableViewDelegate, UITableViewDataSource{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell:WSProductDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WSProductDetailTableViewCell") as! WSProductDetailTableViewCell
    cell.setUI()
    cell.updateCellContent(productInfo:product!, fetchedProductImageArray: productImageArray)
    return cell
  }
  
}

