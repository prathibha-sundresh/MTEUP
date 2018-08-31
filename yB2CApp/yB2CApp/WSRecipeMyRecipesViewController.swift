//
//  WSRecipeMyRecipesViewController.swift
//  yB2CApp
//
//  Created by Lakshminarayana on 07/12/17.
//

import UIKit

class WSRecipeMyRecipesViewController: UIViewController {
    @IBOutlet weak var myRecipeTableview: UITableView!
    var myRecipessArray : [[String:Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableview()
        UISetUP()
        getMyrecipes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func UISetUP()  {
        WSUtility.addNavigationBarBackButton(controller: self)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func registerTableview(){
        myRecipeTableview.delegate = self
        myRecipeTableview.dataSource = self
        myRecipeTableview.register(UINib(nibName: "WSRecipeMyRecipesTableViewCell", bundle: nil), forCellReuseIdentifier: "WSRecipeMyRecipesTableViewCell")

    }
    func getMyrecipes() {
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.getMyRecipes(successResponse: { (response) in
            self.myRecipessArray = response
//            for index in response{
//                if let data = index["data"] as? NSDictionary{
//                    print(data)
//                    if let dict = data["data"] as? NSArray{
////                        self.myRecipessArray.append(dict as! [String:Any])
//                        self.myRecipessArray.append(dict)
//                    }
////                    if let arrayofdata = data["data"] as? [String:Any]{
//////                        self.myRecipessArray = [arrayofdata]
////                        for index in arrayofdata{
////                            print(index)
////                            self.myRecipessArray.append(index as [String:Any])
////                        }
////                    }
//                }
//            }
            
            self.myRecipeTableview.reloadData()
            
            
            
        }, failureResponse: { (errorMessage) in
        })
    }
}

extension WSRecipeMyRecipesViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRecipessArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myRecipeTableview.dequeueReusableCell(withIdentifier: "WSRecipeMyRecipesTableViewCell") as! WSRecipeMyRecipesTableViewCell

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
}
