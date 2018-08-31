//
//  File.swift
//  UFS
//
//  Created by Prathibha Sundresh on 29/06/18.
//

import Foundation

class FAQModel: NSObject {
    var answer : [String] = []
    var question : [String] = []
    func ParseJson () {
        var resourcePath = ""
        if WSUtility.getCountryCode() == "AT" {
            resourcePath = "faq_qus_ans_at"
        } else if WSUtility.getCountryCode() == "DE" {
            resourcePath = "faq_qus_ans_de"
        } else if WSUtility.getCountryCode() == "CH" {
            if WSUtility.getLanguageCode() == "fr" {
                resourcePath = "faq_qus_ans_ch_fr"
            } else if WSUtility.getLanguageCode() == "de" {
                resourcePath = "faq_qus_ans_ch_de"
            }
        } else if WSUtility.getCountryCode() == "TR" {
            resourcePath = "faq_qus_ans_tr"
        }
        
        if let url = Bundle.main.url(forResource: resourcePath, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let dictionary = object as? [String: AnyObject] {
                    let jsonValue = dictionary["data"] as! [[String:Any]]
                    for json in jsonValue {
                        answer.append(json["answer"] as! String)
                        question.append(json["question"] as! String)
                    }
                }
            } catch {

            }
        }
        
    }
}
