//
//  SampleOrderStepThreeViewController.swift
//  yB2CApp
//
//  Created by Ramakrishna on 12/10/17.
//

import UIKit


class SampleOrderStepThreeViewController: UIViewController, SampleOrderSummaryTableViewCellDelegate {
    @IBOutlet weak var fillInLabel: UILabel!
    
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var orderSampleButton: UIButton!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var summaryTableView: UITableView!
    @IBOutlet weak var fillSampleLbl: UILabel!
    @IBOutlet weak var pImage: UIImageView!
    @IBOutlet weak var myDetailProcessLbl: UILabel!
    @IBOutlet weak var deliveryProcessLbl: UILabel!
    @IBOutlet weak var summaryProcessLbl: UILabel!
    
    @IBOutlet weak var freeSampleTextLabel: UILabel!
    @IBOutlet weak var headerProductNameLabel: UILabel!
    var summaryArray: [[String: Any]] = []
    var prodDetailsDict: [String: Any] = [:]
    var sampleOrderDict = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        summaryTableView.tableFooterView = UIView(frame: CGRect.zero)
        summaryTableView.estimatedRowHeight = 60
        WSUtility.addNavigationBarBackButton(controller: self)
        // Do any additional setup after loading the view.
        fillInLabel.text = WSUtility.getlocalizedString(key: "Fill in your details below and get your free sample", lang: WSUtility.getLanguage(), table: "Localizable")
        summaryLabel.text = WSUtility.getlocalizedString(key: "Summary", lang: WSUtility.getLanguage(), table: "Localizable")
        termsLabel.text = WSUtility.getlocalizedString(key: "By continuing you are agree with our", lang: WSUtility.getLanguage(), table: "Localizable")
        termsButton.setTitle(WSUtility.getlocalizedString(key: "Terms and Conditions", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        termsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        orderSampleButton.setTitle(WSUtility.getlocalizedString(key: "Order Sample", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        fillSampleLbl.text = WSUtility.getlocalizedString(key: "Fill in your details below and get your free sample", lang: WSUtility.getLanguage(), table: "Localizable")
        var picDict: [String: Any] = [:]
        if let pictures = prodDetailsDict["pictures"] as? [AnyObject]{
            
            if pictures.count > 0{
                picDict = pictures[0] as! [String : Any]
                if let imageURL = picDict["imageUrl"] as? String {
                    let urlComponents = NSURLComponents(string: imageURL)
                    urlComponents?.user =  "ufsstage"
                    urlComponents?.password = "emakina"
                    pImage.sd_setImage(with: URL(string:(urlComponents?.string)!), placeholderImage: UIImage(named: "placeholder.png"))
                }
            }
            else{
                if let variants = self.prodDetailsDict["variantOptions"] as? [[String:Any]],variants.count > 0{
                    
                    let picDict = variants[0]
                    if let imageURL = picDict["thumbnailUrl"] as? String {
                        let urlComponents = NSURLComponents(string: imageURL)
                        urlComponents?.user =  "ufsstage"
                        urlComponents?.password = "emakina"
                        pImage.sd_setImage(with: URL(string:(urlComponents?.string)!), placeholderImage: UIImage(named: "placeholder.png"))
                    }
                }
            }
        }
        
        myDetailProcessLbl.text = WSUtility.getlocalizedString(key: "My Detail", lang: WSUtility.getLanguage(), table: "Localizable")
        deliveryProcessLbl.text = WSUtility.getlocalizedString(key: "Delivery", lang: WSUtility.getLanguage(), table: "Localizable")
        summaryProcessLbl.text = WSUtility.getlocalizedString(key: "Summary", lang: WSUtility.getLanguage(), table: "Localizable")
        
        headerProductNameLabel.text = "\(prodDetailsDict["name"] as! String)"
        freeSampleTextLabel.text = WSUtility.getlocalizedString(key: "Free sample", lang: WSUtility.getLanguage(), table: "Localizable")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if SHOW_ALL_RECIPES_FROM_SAMPLE_ORDER_SUCCESS{//on tap of explore recipes from Sample product thanky you screen.
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ThankYouSampleOrder"{
            let sampleOrder3VC = segue.destination as! SampleOrderThankYouViewController
            sampleOrder3VC.prodDetailsDict = self.prodDetailsDict
        }
    }
    
    @IBAction func orderSampleButton(_ sender: UIButton) {
        placeSampleOrder()
    }
    
    func placeSampleOrder(){
        print(sampleOrderDict)
        summaryArray.append(prodDetailsDict)
        summaryArray.append(sampleOrderDict)
        UFSProgressView.showWaitingDialog("")
        let url = ""
        let webServiceBusinessLayer = WSWebServiceBusinessLayer()
        webServiceBusinessLayer.placeSampleOrder(postURL: url,params: summaryArray, successResponse: { (response) in
            print("response:%@",response)
            UFSProgressView.stopWaitingDialog()
            self.performSegue(withIdentifier: "ThankYouSampleOrder", sender: self)
        }) { (errorMessage) in
            print("error")
            UFSProgressView.stopWaitingDialog()
            //self.showNotifyMessage(errorMessage)
        }
    }
    
    func didSelectItem(indexNo:Int){
        if(indexNo == 0){
            // self.navigationController?.popViewController(animated: true)
            self.performSegue(withIdentifier: "unwindToStep1", sender: self)
        }else{
            //self.popBack(toControllerType: SampleOrderStepOneViewController.self)
            self.performSegue(withIdentifier: "unwindToStep2", sender: self)
        }
        
    }
    
    
    func popBack<T: UIViewController>(toControllerType: T.Type) {
        if var viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            viewControllers = viewControllers.reversed()
            for currentViewController in viewControllers {
                if currentViewController .isKind(of: toControllerType) {
                    self.navigationController?.popToViewController(currentViewController, animated: true)
                    break
                }
            }
        }
    }
    
}
extension SampleOrderStepThreeViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SampleOrderSummaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SampleOrderSummaryTableViewCell
        cell.SetUIForCell(row: indexPath.row, dict: summaryArray[indexPath.row])
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaryArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

