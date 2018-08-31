//
//  WSRecipeFilterViewController.swift
//  yB2CApp
//
//  Created by Sahana Rao on 01/12/17.
//

import UIKit

protocol WSRecipeFilterViewControllerDelegate {
    func sendFilterDict(dict: [String: Any])
}
class WSRecipeFilterViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var delegate: WSRecipeFilterViewControllerDelegate?
    @IBOutlet weak var recipeFilterTableView: UITableView!
    var filterKeyWords: [[String: Any]] = []
    var selectedKeyWords: [[String: Any]] = []
    var expandedArray: [Int] = []
    var filterDict: [String: Any] = [:]
    
    @IBOutlet weak var clearAllButton: UIButton!
    
    @IBOutlet weak var filterCountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       clearAllButton.setTitle(WSUtility.getlocalizedString(key: "Clear all", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        filterCountLabel.text = WSUtility.getlocalizedString(key: "Filter", lang: WSUtility.getLanguage(), table: "Localizable")
        recipeFilterTableView.tableFooterView = UIView(frame: CGRect.zero)
        if filterDict.isEmpty{
            getFilterKeyWords()
        }
        else{
            filterKeyWords = filterDict["response"] as! [[String: Any]]
            expandedArray = filterDict["expandedSections"] as! [Int]
            selectedKeyWords = filterDict["selectedKeyWords"] as! [[String: Any]]
            updateFilterCountLabel()
            recipeFilterTableView.reloadData()
        }
        
        self.view.backgroundColor = UIColor(red: 151.0 / 255.0, green: 151.0 / 255.0, blue: 151.0 / 255.0, alpha: 0.6)
        self.recipeFilterTableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updateFilterCountLabel(){
        let filterText = WSUtility.getlocalizedString(key: "Filter", lang: WSUtility.getLanguage(), table: "Localizable")
        if selectedKeyWords.count > 0{
            filterCountLabel.text = filterText! + "(\(selectedKeyWords.count))"
        }
        else{
            filterCountLabel.text = filterText!
        }
    }
    func getFilterKeyWords(){
        UFSProgressView.showWaitingDialog("")
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.getFilterKeywordsForRecipes(successResponse: { (response) in
            print(response)
            self.filterKeyWords.removeAll()
            self.filterKeyWords = response
            for index in 0..<self.filterKeyWords.count {
                self.expandedArray.append(index)
            }
            self.recipeFilterTableView.reloadData()
            UFSProgressView.stopWaitingDialog()
        }) { (errorMessage) in
            print(errorMessage)
            UFSProgressView.stopWaitingDialog()
        }
    }
    @IBAction func dismissButtonClicked(_ sender: UIButton) {
        
        var fiterStrArray :[String] = []
        for dict in selectedKeyWords{
            let section = dict["section"] as? Int
            let row = dict["row"] as? Int
            let dict = filterKeyWords[section!]
            if let array = dict["children"] as? [[String: Any]] {
                let dict1 = array[row!]
                fiterStrArray.append(dict1["parentPrefixedSlugifiedName"] as! String)
            }
        }
        let str = fiterStrArray.joined(separator: ",")
        filterDict["response"] = filterKeyWords
        filterDict["expandedSections"] = expandedArray
        filterDict["selectedKeyWords"] = selectedKeyWords
        filterDict["sub_key"] = str
        self.delegate?.sendFilterDict(dict: filterDict)
        self.dismiss(animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if expandedArray.contains(section){
            let dict = filterKeyWords[section]
            if let array = dict["children"] as? [[String: Any]] {
                return array.count
            }
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width:self.recipeFilterTableView.frame.size.width , height: 60))
        headerView.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: self.recipeFilterTableView.frame.size.width - 72 , height: 60))
        label.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1)
        label.numberOfLines = 2
        let dict = filterKeyWords[section]
        if let name = dict["name"] as? String{
            label.text = name
        }
        label.font = UIFont (name: "DINPro-Medium", size: 20)
        
        let dropDownImage = UIImageView(frame: CGRect(x: tableView.frame.size.width - 40, y: 22, width: 16, height: 16))
        if expandedArray.contains(section){
            dropDownImage.image = #imageLiteral(resourceName: "orange_up_arrow")
        }
        else{
            dropDownImage.image = #imageLiteral(resourceName: "orange_down_arrow")
        }
        
        dropDownImage.contentMode = .scaleAspectFit
        headerView.addSubview(dropDownImage)
        let expandedButton = UIButton(type: .custom)
        expandedButton.frame = CGRect(x: 0, y: 20, width: tableView.frame.size.width, height: 60)
        expandedButton.addTarget(self, action: #selector(expandedButton_click(sender:)), for: .touchUpInside)
        expandedButton.tag = section
        headerView.addSubview(expandedButton)
        
        headerView.addSubview(label)
        if section != 0{
            let separatorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.recipeFilterTableView.frame.size.width , height: 1))
            separatorLabel.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
            headerView.addSubview(separatorLabel)
        }
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "recipeFilterIdentifier"
        let cell : WSRecipeFilterTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! WSRecipeFilterTableViewCell
        
        let tmpdict = ["section": indexPath.section, "row": indexPath.row]

        var isExists: Bool = false
        for index in 0..<selectedKeyWords.count {
            let tmpdict = selectedKeyWords[index]
            if indexPath.section == tmpdict["section"] as? Int && indexPath.row == tmpdict["row"] as? Int{
                isExists = true
                break
            }
            isExists = false
        }
        
        if isExists {
            cell.filterOptionCheckboxButton .setImage(#imageLiteral(resourceName: "check_orange"), for: UIControlState.normal)
            cell.filterOptionLabel.textColor = UIColor(red: 255.0/255.0, green: 90.0/255.0, blue: 0.0/255.0, alpha: 1)
            cell.filterOptionLabel.font = UIFont(name: "DINPro-Medium", size: 16.0)
        }
        else {
            cell.filterOptionCheckboxButton .setImage(nil, for: UIControlState.normal)
            cell.filterOptionLabel.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1)
            cell.filterOptionLabel.font = UIFont(name: "DINPro-Regular", size: 16.0)
        }
        let dict = filterKeyWords[indexPath.section]
        if let array = dict["children"] as? [[String: Any]] {
            let dict1 = array[indexPath.row]
           cell.filterOptionLabel.text = dict1["name"] as? String
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
        
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.filterKeyWords.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var isExists: Bool = false
        for index in 0..<selectedKeyWords.count {
            let tmpdict = selectedKeyWords[index]
            if indexPath.section == tmpdict["section"] as? Int && indexPath.row == tmpdict["row"] as? Int{
                selectedKeyWords.remove(at: index)
                isExists = true
                break
            }
            isExists = false
        }
        if !isExists {
            let dict = ["section": indexPath.section, "row": indexPath.row]
            selectedKeyWords.append(dict)
        }
        let tpPredicate = NSPredicate(format: "section = %d",indexPath.section)
        let filterArray = selectedKeyWords.filter { tpPredicate.evaluate(with: $0) }
        if filterArray.count > 0{
            selectedKeyWords = filterArray
        }
        updateFilterCountLabel()
        recipeFilterTableView.reloadData()
        
    }
    
    func expandedButton_click(sender: UIButton){
        let section = sender.tag
        if let index = expandedArray.index(of: section) {
            expandedArray.remove(at: index)
        }
        else{
            expandedArray.append(section)
        }
        recipeFilterTableView.reloadData()
    }
    
    @IBAction func clearButton_click(sender: UIButton){
        filterCountLabel.text = "Filter"
        selectedKeyWords.removeAll()
        filterDict.removeAll()
        recipeFilterTableView.reloadData()
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

