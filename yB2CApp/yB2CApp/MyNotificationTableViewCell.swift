
//
//  MyNotificationTableViewCell.swift
//  yB2CApp
//
//  Created by Lakshminarayana on 26/12/17.
//

import UIKit

class MyNotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var notificationTypeButton: UIButton!
    @IBOutlet weak var bgView: UIView!{
        didSet{
           bgView.layer.borderWidth = 1
            if #available(iOS 10.0, *) {
                bgView.layer.borderColor = UIColor(displayP3Red: 230/255, green: 230/255, blue: 230/255, alpha: 1).cgColor
            } else {
                bgView.layer.borderColor = UIColor(red: 230/255,green: 230/255,blue: 230/255,alpha: 1).cgColor
            }
            bgView.clipsToBounds = true
        }
    }
    @IBOutlet weak var readUnreadLineLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
            descriptionLabel.numberOfLines = 0
            descriptionLabel.sizeToFit()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUI(dict:[String:Any]){
        print(dict)
        
        if let button_title = dict["button_title"] as? String{
            notificationTypeButton.setTitle(button_title, for: UIControlState.normal)
        }
        if let message = dict["message"] as? String{
            descriptionLabel.text = message
        }
        if let flag = dict["flag"] as? String{
            if flag == "Unread"{
                readUnreadLineLabel.isHidden = false
            }else{
                readUnreadLineLabel.isHidden = true
            }
        }
        
        if let duration = dict["updated_at"] as? String{
            /*
            let array = duration.components(separatedBy: " ")
            if let time = array[1] as? String{
                let seconds = timeInterval(time)
                let hours = abs(Int(seconds!)/60)
                timeAgoLabel.text = "\(String(describing: timeDuration(duration: hours).1)) \(timeDuration(duration: hours).0) ago"
            }
*/
          
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
          //dateFormatter.timeZone = TimeZone.init(abbreviation: TimeZone.current.identifier)
          guard let date = dateFormatter.date(from: duration) else {
           // fatalError("ERROR: Date conversion failed due to mismatched format.")
            timeAgoLabel.text = duration
            
            return
          }
          
          timeAgoLabel.text = date.timeAgoDisplay()
        }
    }
}

func timeInterval(_ timeString:String)->TimeInterval!{
    let timeMultipilers = [1.0,60.0,3600.0] //seconds for unit
    var time = 0.0
    var timeComponents = timeString.components(separatedBy: ":")
    timeComponents.reverse()
    if timeComponents.count > timeMultipilers.count{return nil}
    for index in 0..<timeComponents.count{
        guard let timeComponent = Double(timeComponents[index]) else { return nil}
        time += timeComponent * timeMultipilers[index]
    }
    return time
}

func timeDuration(duration:Int) -> (String, Int){
    let duration = abs(duration)
    var timeduration:Int = 0
    var timeDurationString = ""

    if duration <= 60 && duration >= 0{
        timeDurationString = "minutes"
        timeduration = duration
    }else{
        let hours = duration / 60
        if hours <= 24{
            timeDurationString = "hours"
            timeduration = hours
        }
        else if hours > 24{
            let days =  hours/24
            if days >= 1{
                if days == 1{
                    timeDurationString = "day"
                }else{
                    timeDurationString = "days"
                }
                timeduration = days
            }
        }
    }
    return (timeDurationString , timeduration)
}

extension Date {
  func timeAgoDisplay() -> String {

    let weeks = Calendar.current.dateComponents([.weekOfMonth], from: self, to: Date()).weekOfMonth ?? 0
    let days = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
    let hours =  Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
    let min:Int = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
    let sec:Int = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
    
    if sec < 60 {
        return (WSUtility.getlocalizedString(key: "5 sec ago", lang: WSUtility.getLanguage(), table: "Localizable")?.replacingOccurrences(of: "%@", with: "\(sec)"))!
    } else if min < 60 {
        return (WSUtility.getlocalizedString(key: "5 min ago", lang: WSUtility.getLanguage(), table: "Localizable")?.replacingOccurrences(of: "%@", with: "\(min)"))!
    } else if hours < 24 {
        return (WSUtility.getlocalizedString(key: "5 hrs ago", lang: WSUtility.getLanguage(), table: "Localizable")?.replacingOccurrences(of: "%@", with: "\(hours)"))!
    } else if days < 7 {
        return (WSUtility.getlocalizedString(key: "5 days ago", lang: WSUtility.getLanguage(), table: "Localizable")?.replacingOccurrences(of: "%@", with: "\(days)"))!
    }
    return (WSUtility.getlocalizedString(key: "5 weeks ago", lang: WSUtility.getLanguage(), table: "Localizable")?.replacingOccurrences(of: "%@", with: "\(weeks)"))!
  }
}
