//
//  EmptyCartViewController.swift
//  yB2CApp
//
//  Created by Ajay on 22/11/17.
//

import UIKit

class EmptyCartViewController: UIViewController {
    @IBOutlet weak var emptyCartTextLabel: UILabel!
    
    @IBOutlet weak var startShoppingButton: WSDesignableButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      WSUtility.addNavigationBarBackButton(controller: self)
        emptyCartTextLabel.text = WSUtility.getlocalizedString(key: "An empty cart breaks my heart", lang: WSUtility.getLanguage(), table: "Localizable")
        
        startShoppingButton.setTitle(WSUtility.getlocalizedString(key: "Start shopping", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        goBack()
    }
    
    func goBack()
    {
        WSUtility.addNavigationBarBackButton(controller: self)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func startShopingClicked(_ sender: Any) {
       navigationController?.popViewController(animated: true)
      self.tabBarController?.selectedIndex = 2
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
