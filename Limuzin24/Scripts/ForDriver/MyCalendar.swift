//
//  MyCalendar.swift
//  Limuzin
//
//  Created by Khusan Saidvaliev on 10.06.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation

import UIKit



class MyCalendar: UIViewController,FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    
    @IBOutlet weak var ErrorView: UIView!
    @IBOutlet weak var LoadingIndicator: UIView!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var calView: UIView!
    
    var locManager = SendLocation()
    
    @IBOutlet weak var LocationButton: UISwitch!
    
    @IBAction func SwitchedLocation(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        if(sender.isOn){
            NavigationManager.ShowError(errorText: "геолокация включена",View: self)
            AppData.SendStatus = "true"
            defaults.set(AppData.SendStatus, forKey: localKeys.sendStatus)
        }
        else{
            NavigationManager.ShowError(errorText: "геолокация отключена",View: self)
            AppData.SendStatus = "false"
            defaults.set(AppData.SendStatus, forKey: localKeys.sendStatus)

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadScene()
    }
    
    func LoadScene(){
        LoadingIndicator.isHidden = false
        GetOrders(urlstring: AppData.getDriverOrdersForCustomerUrl, token:AppData.token)
        let timer = Timer.scheduledTimer(timeInterval: AppData.UpdateInterval, target: self, selector: #selector(self.updateCalendar), userInfo: nil, repeats: true)
        NavigationManager.TimerList.append(timer)
        locManager.StartTimer()
        if(AppData.SendStatus == "true"){
            LocationButton.setOn(true, animated: false)
        }
        else{
            LocationButton.setOn(false, animated: false)
        }

    }
    
    func LoadTheme(theme:Int){
        switch (theme) {
        case 0:
            self.calendar.appearance.weekdayTextColor = UIColor(red: 14/255.0, green: 69/255.0, blue: 221/255.0, alpha: 1.0)
            self.calendar.appearance.headerTitleColor = UIColor(red: 14/255.0, green: 69/255.0, blue: 221/255.0, alpha: 1.0)
            self.calendar.appearance.eventDefaultColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
            self.calendar.appearance.selectionColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
            self.calendar.appearance.headerDateFormat = "MMMM yyyy"
            self.calendar.appearance.todayColor = UIColor(red: 198/255.0, green: 51/255.0, blue: 42/255.0, alpha: 1.0)
            self.calendar.appearance.borderRadius = 1.0
            self.calendar.appearance.headerMinimumDissolvedAlpha = 0.2
        case 1:
            self.calendar.appearance.weekdayTextColor = UIColor.red
            self.calendar.appearance.headerTitleColor = UIColor.darkGray
            self.calendar.appearance.eventDefaultColor = UIColor.green
            self.calendar.appearance.selectionColor = UIColor.blue
            self.calendar.appearance.headerDateFormat = "yyyy-MM";
            self.calendar.appearance.todayColor = UIColor.red
            self.calendar.appearance.borderRadius = 1.0
            self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        case 2:
            self.calendar.appearance.weekdayTextColor = UIColor.red
            self.calendar.appearance.headerTitleColor = UIColor.red
            self.calendar.appearance.eventDefaultColor = UIColor.green
            self.calendar.appearance.selectionColor = UIColor.blue
            self.calendar.appearance.headerDateFormat = "yyyy/MM"
            self.calendar.appearance.todayColor = UIColor.orange
            self.calendar.appearance.borderRadius = 0
            self.calendar.appearance.headerMinimumDissolvedAlpha = 1.0
        default:
            break;
        }
    }
    
    @objc func updateCalendar() {
        LoadingIndicator.isHidden = false
        GetOrders(urlstring: AppData.getDriverOrdersForCustomerUrl, token:AppData.token)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //calendarCode
    
    
    private func GetOrders(urlstring: String,token: String){
        
        let parameters = "token=\(token)&imadriver=true"
        
        //print(parameters)
        
        let url = URL(string: urlstring)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = parameters.data(using: .utf8)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                    print(error?.localizedDescription ?? "No data")
                    DispatchQueue.main.async
                        {
                            self.ErrorView.isHidden = false
                            NavigationManager.ShowError(errorText: "Плохое соединение!", View: self)
                    }
                }
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                    self.FillCalendar(response:responseJSON)
                    DispatchQueue.main.async
                        {
                            self.createCalendar()
                    }
                }
            }
        }
        
        task.resume()
    }
    
    private func FillCalendar(response: [String:Any]){
        AppData.OrderList = [:]
        if let array = response["data"] as? [Any] {
            for JsonOrder in array {
                let dataBody = JsonOrder as? [String: Any]
                let newOrder = Order()
                let intDay = dataBody?["day"] as! Int
                let intMonth = dataBody?["month"] as! Int
                let intYear = dataBody?["year"] as! Int
                
                let date = self.createDateFromJson(year:intYear,month:intMonth,day:intDay)
                newOrder.date = date
                newOrder.customerName = dataBody?["customerName"] as? String
                newOrder.customerNumber = dataBody?["customerPhone"] as? String
                newOrder.long = dataBody?["gpsLong"] as? Double
                newOrder.lat = dataBody?["gpsLat"] as? Double
                newOrder.orderId = dataBody?["orderId"] as? String
                newOrder.status = dataBody?["status"] as? Int

                let fromHour = dataBody?["hourFrom"] as! Int
                let fromMinute = dataBody?["minuteFrom"] as! Int
                let toHour = dataBody?["hourTo"] as! Int
                let toMinute = dataBody?["minuteTo"] as! Int
                newOrder.long = dataBody?["minuteTo"] as? Double
                newOrder.lat = dataBody?["minuteTo"] as? Double
                newOrder.fromTime = String(fromHour)+":"+String(fromMinute)
                newOrder.ToTime = String(toHour)+":"+String(toMinute)
                if(AppData.OrderList[date] == nil){
                    AppData.OrderList[date] = []
                }
                if(newOrder.status == 2){
                    AppData.OrderList[date]?.append(newOrder)
                    self.fillDefaultColors[date] = UIColor.red
                    
                }
            }
            
        }
        self.ShowEvents()
    }
    
     func createDateFromJson(year:Int,month:Int,day:Int)-> String{
   
        var StrDay:String! = String(day)
        var StrMonth:String! = String(month)
        var StrYear:String! = String(year)
        
        if(month<10){
         StrMonth = ("0\(StrMonth!)")
        }
        if(day<10){
            StrDay = ("0\(StrDay!)")
        }
        
        let date:String! = "\(StrYear!)/\(StrMonth!)/\(StrDay!)"
        return date
    }
    
    
    fileprivate var calendar: FSCalendar!
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    private func ShowEvents(){
        for key in AppData.OrderList.keys{
            
            let eventFormatDate = key.replacingOccurrences(of: "/", with: "-")
            if(AppData.OrderList[key]?.count == 1){
                self.datesWithEvent.append(eventFormatDate)
            }
            else if ((AppData.OrderList[key]?.count)! > 1){
                self.datesWithMultipleEvents.append(eventFormatDate)
            }
        }
    }
    
    var fillDefaultColors:[String:UIColor] = ["2015/11/06": UIColor.red,"2015/11/08": UIColor.red]
    var datesWithEvent = ["2015-11-06"]
    var datesWithMultipleEvents = ["2015-11-08"]
    
    
    func createCalendar() {
        //let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 450 : 300
        let calendar = FSCalendar(frame: CGRect(x:0, y:0, width:self.calView.bounds.size.width, height:300))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.backgroundColor = UIColor.white
        calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]
        self.calView.addSubview(calendar)
        self.calendar = calendar
        calendar.select(Date())
        self.LoadingIndicator.isHidden = true
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        
    }
    
    deinit {
        print("\(#function)")
    }
    
    @objc
    func todayItemClicked(sender: AnyObject) {
        self.calendar.setCurrentPage(Date(), animated: false)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter2.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 1
        }
        if self.datesWithMultipleEvents.contains(dateString) {
            return 3
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
        let dateString = self.dateFormatter2.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return UIColor.red
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let key = self.dateFormatter2.string(from: date)
        if self.datesWithMultipleEvents.contains(key) {
            return [UIColor.red, UIColor.red, UIColor.red]
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter1.string(from: date)
        return appearance.selectionColor
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter1.string(from: date)
        if let color = self.fillDefaultColors[key] {
            return color
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        if [8, 17, 21, 25].contains((self.gregorian.component(.day, from: date))) {
            return 1.0
        }
        return 1.0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let key = self.dateFormatter1.string(from: date)
        AppData.selectedDate = key
        NavigationManager.MoveToScene(sceneId: "DateInfoForDriver", View: self)
        
    }
    
}
