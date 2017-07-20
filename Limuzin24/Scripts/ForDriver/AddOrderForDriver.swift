//
//  AddOrderForDriver.swift
//  Limuzin
//
//  Created by Khusan Saidvaliev on 16.06.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit




class AddOrderForDriver: UIViewController {
    
    
    var executionDate: String!
    
    @IBOutlet weak var targetAddress: UILabel!
    
    @IBOutlet weak var SuccessView: UIView!
    @IBOutlet weak var LoadingView: UIView!
    @IBOutlet weak var DateView: UIDatePicker!
    var pubManager = PublicationData()
    
    @IBOutlet weak var toTime: UIDatePicker!
    @IBOutlet weak var fromTime: UIDatePicker!
    

    
    @IBAction func SetTargetLocation(_ sender: Any) {
        AppData.waitingForLoc = "TargetLocationForDriver"
        GoToSetCoordinate()
    }
    
    
    @IBAction func SetDate(_ sender: Any) {
        
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
        let carToken = "fec5fdf5ac012r43\(AppData.selectedCarId)fec5fdf5ac012r43"
        
        let date = AppData.selectedDate.characters.split{$0 == "/"}.map(String.init)
        let pub_day = date[2]
        let pub_month = date[1]
        let pub_year = date[0]
        
        GetDetails(urlstring: AppData.APIurl, token: AppData.token, day: pub_day, month: pub_month, year: pub_year, fromH: fromTimeList[0], fromM: fromTimeList[1], toH: toTimeList[0], toM: toTimeList[1], lat: String(AppData.targetLocation.coordinate.latitude), long: String(AppData.targetLocation.coordinate.longitude),driverId: AppData.token)
        
    }
    
    private func GetDetails(urlstring: String,token: String,day:String,month:String,year:String,fromH:String,fromM:String,toH:String,toM:String,lat:String,long:String,driverId:String){
        self.LoadingView.isHidden = false
        
       
        let parameters = "token=\(token)&day=\(day)&month=\(month)&year=\(year)&hourFrom=\(fromH)&minuteFrom=\(fromM)&hourTo=\(toH)&minuteTo=\(toM)&driverID=\(driverId)&long=\(long)&lat=\(lat)&status=2"
        
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
                    self.ManageResponse(response:responseJSON)
                    
                
            }
        }
        
        task.resume()
        
    }
    
    func ManageResponse(response:[String:Any]){
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                self.SuccessView.isHidden = false

            }
            
        }
        
    }
    
    
    
    @IBAction func BackToDriverDateInfo(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: "DateInfoForDriver", View: self)
    }
    
    @IBAction func GoToMain(_ sender: Any) {
        NavigationManager.MoveToDriverMain(View: self)
    }
    
    
}


