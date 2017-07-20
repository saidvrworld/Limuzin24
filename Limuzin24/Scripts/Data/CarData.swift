//
//  CarData.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 08.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit


class CarData{
    
    
    
    func MakeRequest(table: NearList,urlAddress: String,token:String,long: String,lat: String,carTypeId:String){
        table.LoadingView.isHidden = false
        var parameters:String!
        if(carTypeId == "None"){
             parameters = "long="+long+"&lat="+lat+"&token="+token
        }
        else{
             parameters = "long="+long+"&lat="+lat+"&token="+token+"&carType="+carTypeId
        }
       // print(parameters)
       // print(urlAddress)
        let url = URL(string: urlAddress)
        var request = URLRequest(url: (url)!)
        request.httpMethod = "POST"
        
        request.httpBody = parameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                    print(error?.localizedDescription ?? "No data")
                    DispatchQueue.main.async
                        {
                            NavigationManager.ShowError(errorText: "Плохое соединение!", View: table)
                    }
                }
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                    AppData.CarList = self.ManageResponse(response:responseJSON)
                    DispatchQueue.main.async
                        {
                            table.LoadingView.isHidden = true

                            if(AppData.CarList.count != 0){
                                table.tableView.reloadData()
                            }
                            else{
                               table.ShowEmptyError()
                            }
                    }
                }
            }
        }
        
        task.resume()
        
    }
    
    private func ManageResponse(response:[String:Any])->[CarShort]{
        var carList:[CarShort] = []

        if let array = response["data"] as? [Any] {

            for carObj in array {
                let dataBody = carObj as? [String: Any]
               // print(dataBody)
                carList.append(ParseCar(dataBody! as [String : AnyObject]))
                
            }
        }
        return carList
        
    }

    
    
    
    private func ParseCar(_ car:[String:AnyObject])->CarShort{
        let newCar = CarShort()
        newCar.carId = car["carId"] as! Int
        newCar.carImageUrl = car["carImageUrl"] as! String
        newCar.carName = car["carName"] as! String
        //let type = car["type"] as! String
        
        
       // let str = car["distance"] as! String
        //let index = str.index(str.startIndex, offsetBy: 1)
        
        newCar.distance =  car["distance"] as! Int//str.substring(to: index)
        newCar.rate = car["rate"] as! Double
        newCar.longitude = car["long"] as! Double
        newCar.latitude = car["lat"] as! Double

        
        return newCar
    }
    
}
