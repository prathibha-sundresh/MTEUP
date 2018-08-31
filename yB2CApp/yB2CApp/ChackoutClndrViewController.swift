//
//  ChackoutClndrViewController.swift
//  yB2CApp
//
//  Created by Ajay on 10/12/17.
//

import UIKit
import FSCalendar

protocol ChackoutClndrViewControllerDelegate {
    func getSelectedDate(dateStr: String)
}
class ChackoutClndrViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance,UITableViewDelegate {
    var arrHolidays = [Date]()
    var arrWeekdays = [Int]()
    var dicPossibleDays = [String:Any]()
    var strDate = ""
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tapPrfrdLbl: UILabel!
    @IBOutlet weak var ablblDatesLbl: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    
    
    
    var delegate: ChackoutClndrViewControllerDelegate?
    var selectedDateStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       calendar.firstWeekday = 2
        getAllPossibleDaysForDelivery() //Enable/disable dates in the calender

        applyDefaultStyle()
    }
    func getAllPossibleDaysForDelivery(){
        UFSProgressView.showWaitingDialog("")
        let localizedString = WSUtility.getlocalizedString(key: "Choose different day (optional)", lang: WSUtility.getLanguage(), table: "Localizable")
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.getAvailableDeliveryDatesToUpdateCalender(successResponse: { (response) in
            print(response)
            UFSProgressView.stopWaitingDialog()
            let dictionaryData = response["data"] as! [String: Any]
            let dictionaryHolidays = dictionaryData["holidays"] as? [[String: String]]
            self.dicPossibleDays = dictionaryData["possible_days"] as! [String : Any]
            self.strDate = self.dicPossibleDays["possible_dates_after"] as! String
            var strPossibleDays = self.dicPossibleDays["possible_week_days"] as! String
            strPossibleDays = strPossibleDays.replacingOccurrences(of: ",", with: "")
            let temp  = strPossibleDays.map{String($0)}
            self.arrWeekdays = temp.map({Int($0)!+1})
            
            for item in dictionaryHolidays! {
                for (kind, value) in item {
                    print(kind, value)
                    if kind == "holiday_date"{
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let date = dateFormatter.date(from: value)
                        self.arrHolidays.append(date!)
                    }
                }
            }

            if self.selectedDateStr != "" && self.selectedDateStr != localizedString {
                self.calendar.select(self.formatter.date(from: self.selectedDateStr)!)
            }
            self.calendar.reloadData()
            
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
            self.dismiss(animated: false, completion: nil)
            print(errorMessage)
        }
    }
    func applyDefaultStyle(){
        tapPrfrdLbl.text = WSUtility.getlocalizedString(key: "Tap on prefered delivery date", lang: WSUtility.getLanguage(), table: "Localizable")
        ablblDatesLbl.text = WSUtility.getlocalizedString(key: "Available dates are highlighted in orange", lang: WSUtility.getLanguage(), table: "Localizable")
        doneBtn.setTitle(WSUtility.getlocalizedString(key: "Cancel", lang: WSUtility.getLanguage(), table: "Localizable")! + "  X", for: .normal)

    }
    
    @IBAction func closeCalendarClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneCalander(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func dismissCalenderView(){
        delegate?.getSelectedDate(dateStr: selectedDateStr)
        dismiss(animated: true, completion: nil)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("change page to \(self.formatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("calendar did select date \(selectedDateStr = self.formatter.string(from: date))")
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        dismissCalenderView()
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        //self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool
    {
// Disabling weekends
        let dayIndex = self.getDayOfWeek(date)
        if self.arrWeekdays.contains(dayIndex!){
// Disabling unavailable days
            if strDate.count>0 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let datepossible = dateFormatter.date(from: strDate)
                if(date <= datepossible!)
                {
                    return false
                }
            }
// Disabling holidays
            if  arrHolidays.contains(date) {
                return false
            }
            
            return true
        }
        else{
            return false
        }
        
        

// Disabling present day
        if(date < Date())
        {
            if self.formatter.string(from: date) == self.formatter.string(from: Date()){
                return true
            }
            return false
        }
        else
        {
            return true
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
// Disabling weekend
        let dayIndex = self.getDayOfWeek(date)
        if !(self.arrWeekdays.contains(dayIndex!)){
            return UIColor.lightGray
        }

// Disabling holidays
        if  arrHolidays.contains(date) {
            return UIColor.lightGray
        }

// Disabling unavailable days
        if strDate.count>0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let datepossible = dateFormatter.date(from: strDate)
            if(date <= datepossible!)
            {
                return UIColor.lightGray
            }
        }


// Disabling present day
        if(date < Date())
        {
            if self.formatter.string(from: date) == self.formatter.string(from: Date()){
                return UIColor.white
            }
            return UIColor.lightGray
        }
        else
        {
            return UIColor.orange
        }
    }
    
    func getDayOfWeek(_ today:Date) -> Int? {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: today)
        return weekDay
    }

    @IBAction func previousMonthClicked(_ sender: Any) {
        calendarBackClicked(calendar: self.calendar)
    }
    
    @IBAction func nextMonthClicked(_ sender: Any) {
        calendarForwardClicked(calendar: self.calendar)
    }
    func calendarBackClicked(calendar: FSCalendar){
        let currentMonth: NSDate = calendar.currentPage as NSDate
        let nextMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth as Date)
        calendar.setCurrentPage(nextMonth! as Date, animated: true)
    }
    
    func calendarForwardClicked(calendar: FSCalendar){
        let currentMonth: NSDate = calendar.currentPage as NSDate
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth as Date)
        calendar.setCurrentPage(nextMonth! as Date, animated: true)
    }
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
}

