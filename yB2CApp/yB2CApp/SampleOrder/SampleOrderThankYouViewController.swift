
//
//  SampleOrderThankYouViewController.swift
//  yB2CApp
//
//  Created by Ramakrishna on 12/11/17.
//

import UIKit

class SampleOrderThankYouViewController: UIViewController {
    @IBOutlet weak var freeSampleTextLabel: UILabel!
    
    @IBOutlet weak var headerProductNameLabel: UILabel!
    @IBOutlet weak var exploreRecipes: UIButton!
    @IBOutlet weak var DiscoverLabel: UILabel!
    @IBOutlet weak var subHeaderLabel: UILabel!
    @IBOutlet weak var thankYouLabel: UILabel!
    @IBOutlet weak var pImage: UIImageView!
    
    var prodDetailsDict: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appVersion = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }

            UFSGATracker.trackEvent(withCategory: "Sample order", action: "\(prodDetailsDict["name"] as! String) - \(prodDetailsDict["number"]!)", label: "Unit-1", value: nil)

        headerProductNameLabel.text = "\(prodDetailsDict["name"] as! String)"
        freeSampleTextLabel.text = WSUtility.getlocalizedString(key: "Free sample", lang: WSUtility.getLanguage(), table: "Localizable")
        
        WSUtility.sendTrackingEvent(events: "Orders", categories: "Sample order",actions:"\(prodDetailsDict["name"] as! String) - \(prodDetailsDict["number"]!)")
        WSUtility.addNavigationBarBackButton(controller: self)
        // Do any additional setup after loading the view.
        thankYouLabel.text =  (prodDetailsDict["name"] as! String) + WSUtility.getlocalizedString(key: "Thank you for ordering a sample of", lang: WSUtility.getLanguage(), table: "Localizable")!
        subHeaderLabel.text = WSUtility.getlocalizedString(key: "We will get in touch with you shortly to confirm", lang: WSUtility.getLanguage(), table: "Localizable")
        DiscoverLabel.text = WSUtility.getlocalizedString(key: "Discover how UFS products can be used in recipes", lang: WSUtility.getLanguage(), table: "Localizable")
        exploreRecipes.setTitle(WSUtility.getlocalizedString(key: "Explore Recipes", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if SHOW_ALL_RECIPES_FROM_SAMPLE_ORDER_SUCCESS{//on tap of explore recipes from Sample product thanky you screen.
            self.navigationController?.popToRootViewController(animated: false)
        }
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func exploreRecipeAction(_ sender: UIButton) {
        
        SHOW_ALL_RECIPES_FROM_SAMPLE_ORDER_SUCCESS = true
        tabBarController?.selectedIndex = 3
        self.navigationController?.popToRootViewController(animated: false)

    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
