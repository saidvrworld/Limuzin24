//
//  SendLocation.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 15.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import CoreLocation

class SendLocation{
    let LocationUrl = "http://dreambox.uz/api/location/"
  
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid

    var locationManager = CLLocationManager()

    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            
        } else {
            locationManager.requestAlwaysAuthorization()
            
        }
    }
    
    func GetCurrentLocation()-> CLLocationCoordinate2D{
        var centre = locationManager.location?.coordinate
        if(centre == nil){
            centre = CLLocationCoordinate2D.init(latitude: 41.311132, longitude: 69.279612)
        }
        return centre!
    }
    
    func StartTimer(){
        var timer = Timer.scheduledTimer(timeInterval: 70.0, target: self, selector: #selector(self.updateLoc), userInfo: nil, repeats: true)
        NavigationManager.TimerList.append(timer) 
    }
    
    @objc func updateLoc() {
        print("location sended",AppData.SendStatus)
         SendLocation(status: AppData.SendStatus,userID: AppData.token)
    }
    
    func fetch(_ completion: () -> Void) {
        completion()
    }

    func UpdateLocationInBackground(){
        let defaults = UserDefaults.standard

        if let userType = defaults.string(forKey: localKeys.userType) {
            if(userType == "2"){
                if let token = defaults.string(forKey: localKeys.token) {

                if let status = defaults.string(forKey: localKeys.sendStatus) {
                    //let date = Date()
                    //let dateFormatter = DateFormatter()
                    //dateFormatter.dateFormat = "HH:mm"
                   // var cur_time:String = dateFormatter.string(from: date)
                   // let beforeTimes = defaults.string(forKey: localKeys.lastUpdate)
                   // var new_time = "\(beforeTimes)\(cur_time)"
                    //defaults.set(new_time, forKey: localKeys.lastUpdate)
                      SendLocation(status: status,userID: token)

                }
                else{
                    SendLocation(status: "false",userID: token)
                    }
                
                }
            }
        }
        
    
    
    }
    
    func SendLocation(status: String,userID:String){
        let curLocation = GetCurrentLocation()
        let curLong = String(curLocation.longitude)
        let curLat = String(curLocation.latitude)
        let user_status = status
        MakeRequest(urlstring: LocationUrl, userId:userID, lat: curLat, long: curLong, status: user_status)
    
    }
    
    
    private func MakeRequest(urlstring: String,userId: String,lat: String,long: String,status: String){
        
        let parameters = "lat="+lat+"&long="+long+"&status="+status+"&token="+userId
        
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
            if (responseJSON as? [String: Any]) != nil {
                print("Location sended")
            }
        }
        
        task.resume()
        
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
    

}
