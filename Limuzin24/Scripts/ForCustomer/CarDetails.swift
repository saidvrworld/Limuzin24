//
//  CarDetails.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 08.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation

import UIKit



class CarDetails: UIViewController,FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    
    @IBOutlet weak var ErrorView: UIView!
    @IBOutlet weak var LoadingIndicator: UIView!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carNumber: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var carWeigth: UILabel!
    @IBOutlet weak var carType: UILabel!
    @IBOutlet weak var driver_rating_Label: UILabel!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var car_length: UILabel!
    @IBOutlet weak var driver_price: UILabel!
    @IBOutlet weak var PhoneNumberView: UILabel!
    
    @IBOutlet weak var calView: UIView!
    
    
    var isCarImageLoading = false
    var isUserImageLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetOrders(urlstring: AppData.getDriverOrdersForCustomerUrl, carId: String(AppData.selectedCarId))

        if(AppData.CarDetailsList[AppData.selectedCarId] != nil){
                DispatchQueue.main.async
                    {
                        self.FillDataFromAppData()
                        self.LoadingIndicator.isHidden = true
                }
              setCarPicture((AppData.CarDetailsList[AppData.selectedCarId]?.carImage)!)
              setUserPicture((AppData.CarDetailsList[AppData.selectedCarId]?.userImage)!)

         }
        else{
          MakeRequest(urlstring: AppData.CarInfoUrl, carId: String(AppData.selectedCarId))
        }
        
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MakeCall(_ sender: Any) {
        
        if let number = PhoneNumberView.text{
            callNumber(phoneNumber: number)
        }
    }
    
    private func MakeRequest(urlstring: String,carId: String){
        
        let params = "token=fec5fdf5ac012r43"+carId+"fec5fdf5ac012r43"
        //print(parameters)
        
        let url = URL(string: urlstring)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = params.data(using: .utf8)
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
                self.InfoManager(response:responseJSON)
            }
        }
        
        task.resume()
 
    }
    
    private func InfoManager(response: [String:Any]){
        
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                //print(dataBody)
                AppData.CarDetailsList[AppData.selectedCarId] = CarDetail()
                self.FillTextData(car: dataBody!)
                setCarPicture(dataBody?["carImageUrl"] as! String)
                setUserPicture(dataBody?["userPhoto"] as! String)
            }
        }
    }
    
    private func FillTextData(car: [String:Any]){
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
            self.SetText(data: car)
            DispatchQueue.main.async
                {
                    self.FillDataFromAppData()
            }
        }
    }
    
    private func SetText(data:[String:Any]){
        let CurrenrCarDetails = AppData.CarDetailsList[AppData.selectedCarId]
        CurrenrCarDetails?.userName = data["userName"] as! String
        CurrenrCarDetails?.carNumber = data["carNumber"] as! String
        CurrenrCarDetails?.carLength = data["carLength"] as! String
        CurrenrCarDetails?.carType = data["carName"] as! String
        CurrenrCarDetails?.details = data["details"] as! String
        CurrenrCarDetails?.phoneNumber = data["phoneNumber"] as! String
        CurrenrCarDetails?.carImage = data["carImageUrl"] as! String
        CurrenrCarDetails?.userImage = data["userPhoto"] as! String
        CurrenrCarDetails!.rate = data["rate"] as! Int
        CurrenrCarDetails?.driverPrice = "\(data["driverPrice"] as! String) $"
        CurrenrCarDetails?.fromH = data["hourFrom"] as! String
        CurrenrCarDetails?.fromM = data["minuteFrom"] as! String
        CurrenrCarDetails?.toH = data["hourTo"] as! String
        CurrenrCarDetails?.toM = data["minuteTo"] as! String

    }
    
    func FillDataFromAppData(){
        let carInfo = AppData.CarDetailsList[AppData.selectedCarId]
        car_length.text = (carInfo?.carLength)! + " метров"
        carType.text = carInfo?.carType
      //  details.text = carInfo?.details
        PhoneNumberView.text = carInfo?.phoneNumber
        userName.text = carInfo?.userName
        carNumber.text = carInfo?.carNumber
        driver_price.text = carInfo?.driverPrice
        
        driver_rating_Label.text = String(carInfo!.rate)
        DispatchQueue.main.async
            {
                self.LoadingIndicator.isHidden = true
        }


    }
    
    @IBAction func BackToMainView(_ sender: Any) {
        NavigationManager.MoveToCustomerMain(View: self)
    }
    
    private func setCarPicture(_ url:String){
        if(self.isCarImageLoading){
            //self.Loading.startAnimating()
        }
        if(!isCarImageLoading){
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                self.carImage.image =  self.DownloadCarImage(url)
                DispatchQueue.main.async
                    {
                        self.isCarImageLoading = false
                }
            }
        }
    }
    
    private func setUserPicture(_ url:String){
        if(self.isUserImageLoading){
            //self.Loading.startAnimating()
        }
        if(!isUserImageLoading){
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                self.userImage.image =  self.DownloadUserImage(url)
                DispatchQueue.main.async
                    {
                        self.isUserImageLoading = false
                }
            }
        }
    }
    
    
    private func DownloadCarImage(_ imgUrl:String)->UIImage{
        self.isCarImageLoading = true
        var Image: UIImage?
        let url = URL(string:imgUrl)
        let data = try? Data(contentsOf: url!)
        
            if data != nil {
                Image = UIImage(data:data!)
            } else {
                Image = UIImage(named: "image_placeholder.png")
            }
        if(Image == nil){
            Image = UIImage(named: "image_placeholder.png")
        }
        //self.Loading.stopAnimating()
        return Image!
    }
    
    private func DownloadUserImage(_ imgUrl:String)->UIImage{
        self.isUserImageLoading = true
        var Image: UIImage?
        let url = URL(string:imgUrl)
        let data = try? Data(contentsOf: url!)
        
            if data != nil {
                Image = UIImage(data:data!)
            } else {
                Image = UIImage(named: "user_icon.png")
            }
        if(Image == nil){
            Image = UIImage(named: "user_icon.png")
        }
        //self.Loading.stopAnimating()
        return Image!
    }
    
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string:"tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL as URL)) {
                application.openURL(phoneCallURL as URL);
            }
        }
    }
    
    
    //calendarCode
    
    
    private func GetOrders(urlstring: String,carId: String){
        
        let parameters = "token=a5f9abe2d29cffb7\(carId)a5f9abe2d29cffb7"
        
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
           // print(array)
            for JsonOrder in array {
                let dataBody = JsonOrder as? [String: Any]
                let newOrder = Order()
                let intDay = dataBody?["day"] as! Int
                let intMonth = dataBody?["month"] as! Int
                let intYear = dataBody?["year"] as! Int
                let date = self.createDateFromJson(year:intYear,month:intMonth,day:intDay)
                newOrder.date = date
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
                AppData.OrderList[date]?.append(newOrder)
                
                self.fillDefaultColors[date] = UIColor.red
            }
            
        }
        print(AppData.OrderList.count)
        self.ShowEvents()
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
                print(eventFormatDate)
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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let key = self.dateFormatter1.string(from: date)
        AppData.selectedDate = key
        NavigationManager.MoveToScene(sceneId: "DriverDateInfo", View: self)
        
    }

}
