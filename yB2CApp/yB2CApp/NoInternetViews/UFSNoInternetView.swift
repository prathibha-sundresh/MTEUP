//
//  UFSNoInternetView.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 23/08/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit

protocol NoInternetDelegate: class {
  func reloadView()
}

class UFSNoInternetView: UIView {
  @IBOutlet weak var noInternetLabel: UILabel!
  weak var delegate:NoInternetDelegate?

  class func instanceFromNib() ->UFSNoInternetView{
    return UINib(nibName: "UFSNoInternetView", bundle: nil).instantiate(withOwner: nil , options: nil)[0] as! UFSNoInternetView
  }

  
  @IBAction func tapOnViewAction(_ sender: UITapGestureRecognizer) {
    delegate?.reloadView()
  }

  
}

