//
//  AddPublication.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 08.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation

import UIKit


class AddPublication: UIViewController{

    
    var executionDate: String!
    
    @IBOutlet weak var targetAddress: UILabel!

   // @IBOutlet weak var FromHour: UIPickerView!
  //  @IBOutlet weak var FromMinute: UIPickerView!
   

    @IBOutlet weak var workTo: UILabel!
    @IBOutlet weak var workFrom: UILabel!
    @IBOutlet weak var SuccessView: UIView!
    @IBOutlet weak var LoadingView: UIView!
    @IBOutlet weak var DateView: UIDatePicker!
    var pubManager = PublicationData()

    @IBOutlet weak var toTime: UIDatePicker!
    @IBOutlet weak var fromTime: UIDatePicker!
    
    @IBAction func SetTargetLocation(_ sender: Any) {
        AppData.waitingForLoc = "TargetLocation"
        GoToSetCoordinate()
    }
    
    
    
    func GoToSetCoordinate() {
        NavigationManager.MoveToScene(sceneId: "SetCoordinates", View: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFilledFields()
           }
    
   
    
    private func setFilledFields(){
        if(AppData.targetLocation != nil){
            pubManager.getAddress(location: AppData.targetLocation,textView: targetAddress)
        }
        if let carInfo = AppData.CarDetailsList[AppData.selectedCarId]{
            workFrom.text = carInfo.fromH+":"+carInfo.fromM
            workTo.text = carInfo.toH+":"+carInfo.toM
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func CreatePublication(_ sender: Any) {
        if(AppData.targetLocation == nil){
            NavigationManager.ShowError(errorText: "Вы не выбрали местоположение!",View: self)
        }
        else{
           AddPub()
        }
    }
    
    func AddPub(){
    
        LoadingView.isHidden = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        var from_time:String = dateFormatter.string(from: fromTime.date)
        var to_time:String = dateFormatter.string(from: toTime.date)
        
        var fromTimeList = from_time.characters.split{$0 == ":"}.map(String.init)
        var toTimeList = to_time.characters.split{$0 == ":"}.map(String.init)
        
        if(Int(fromTimeList[0])!>Int(toTimeList[0])!){
            var cach = fromTimeList
            fromTimeList = toTimeList
            toTimeList = cach
        }
        
        let carInfo = AppData.CarDetailsList[AppData.selectedCarId]
        
        let fullNameArr = AppData.selectedDate.characters.split{$0 == "/"}.map(String.init)
        let pub_day = fullNameArr[2]
        let pub_month = fullNameArr[1]
        let pub_year = fullNameArr[0]
        
        GetDetails(urlstring: AppData.APIurl, token: AppData.token, day: pub_day, month: pub_month, year: pub_year, fromH: fromTimeList[0], fromM: fromTimeList[1], toH: toTimeList[0], toM: toTimeList[1], lat: String(AppData.targetLocation.coordinate.latitude), long: String(AppData.targetLocation.coordinate.longitude),driverId: String(AppData.selectedCarId))
        
    }
    
    private func GetDetails(urlstring: String,token: String,day:String,month:String,year:String,fromH:String,fromM:String,toH:String,toM:String,lat:String,long:String,driverId:String){
        self.LoadingView.isHidden = false

        let driverID = "9670d6002257b9ce\(driverId)9670d6002257b9ce"
        let parameters = "token=\(token)&day=\(day)&month=\(month)&year=\(year)&hourFrom=\(fromH)&minuteFrom=\(fromM)&hourTo=\(toH)&minuteTo=\(toM)&driverID=\(driverID)&long=\(long)&lat=\(lat)&status=1"
        
        print(parameters)
        
        let url = URL(string: urlstring)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = parameters.data(using: .utf8)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                    self.ManageResponse(response:responseJSON)
                    DispatchQueue.main.async
                        {
                            self.SuccessView.isHidden = false
                    }
                }
            }
        }
        
        task.resume()
        
    }
    
    func ManageResponse(response:[String:Any]){
        print(response)
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                
            }
            
        }
        
    }
    
    
    @IBAction func BackToDriverDateInfo(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: "DriverDateInfo", View: self)
    }
    
    @IBAction func GoToMain(_ sender: Any) {
        NavigationManager.MoveToCustomerMain(View: self)
    }
    
    
}
