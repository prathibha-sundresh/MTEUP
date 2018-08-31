//
//  SortByViewController.swift
//  yB2CApp
//
//  Created by Ramakrishna on 11/26/17.
//

import UIKit

protocol sortByViewControllerDelegate {
    func sortByName(type: String, selectedRow: Int)
}

class SortByViewController: UIViewController {
    @IBOutlet weak var sortByHeaderLabel: UILabel!
    
    var delegate :sortByViewControllerDelegate?
    @IBOutlet weak var sortByTableView: UITableView!
    var recentOrder = WSUtility.getlocalizedString(key: "Recent orders", lang: WSUtility.getLanguage(), table: "Localizable")!
    var mostBought = WSUtility.getlocalizedString(key: "Most Bought", lang: WSUtility.getLanguage(), table: "Localizable")!
    var favItems = WSUtility.getlocalizedString(key: "Favourite items", lang: WSUtility.getLanguage(), table: "Localizable")!
   // var sortArray: [String] = "\(recentOrder)","\(mostBought)","\(favItems)"]
    var sortArray:[String] = [WSUtility.getlocalizedString(key: "Recent orders", lang: WSUtility.getLanguage(), table: "Localizable")!, WSUtility.getlocalizedString(key: "Most Bought", lang: WSUtility.getLanguage(), table: "Localizable")!, WSUtility.getlocalizedString(key: "Favourite items", lang: WSUtility.getLanguage(), table: "Localizable")!]
    var selectedIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 151.0 / 255.0, green: 151.0 / 255.0, blue: 151.0 / 255.0, alpha: 0.6)
        sortByTableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
        sortByHeaderLabel.text = WSUtility.getlocalizedString(key: "Sort by", lang: WSUtility.getLanguage(), table: "Localizable")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonAction(sender: UIButton){
        //self.dismiss(animated: true, completion: nil)
        dismissSortView()
    }
    
    func dismissSortView(){
        self.dismiss(animated: true) {
            self.delegate?.sortByName(type: self.sortArray[self.selectedIndex],selectedRow: self.selectedIndex)
        }
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

extension SortByViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SortByTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SortByTableViewCell
        if selectedIndex == indexPath.row {
            cell.nameLabel.font = UIFont.init(name: "DINPro-Medium", size: 14)
            cell.checkboxButton.setImage(#imageLiteral(resourceName: "check_orange"), for: .normal)
        }
        else{
            cell.checkboxButton.setImage(nil, for: .normal)
            cell.nameLabel.font = UIFont.init(name: "DINPro-Regular", size: 14)
        }
        cell.nameLabel.text = sortArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        dismissSortView()
        sortByTableView.reloadData()
    }
}
