//
//  OrderDetails.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 10.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class OrderDetails: UIViewController {
    
    @IBOutlet weak var LoadingView: UIView!
    
    @IBOutlet weak var targetAddress: UILabel!
    @IBOutlet weak var customerPhone: UILabel!
    @IBOutlet weak var DateOfOrder: UILabel!
    @IBOutlet weak var fromTime: UILabel!

    @IBOutlet weak var toTime: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var OfferButton: UIButton!
    var CurrentOrder:Order!
    @IBOutlet weak var RejectButton: UIButton!
    
    @IBOutlet weak var MyOrderView: UIView!
    var pubManager = PublicationData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MakeRequest(urlstring: AppData.GetDriverOrderInfo, orderId: AppData.selectedOrderId!)
    }
    
    private func MakeRequest(urlstring: String,orderId: String){
        
        let parameters = "token=p009d804c972f432\(orderId)p009d804c972f432"
        
        print(parameters)
        
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
                            NavigationManager.ShowError(errorText: "Плохое соединение!", View: self)
                    }
                }
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                    DispatchQueue.main.async
                        {
                            self.InfoManager(response:responseJSON)
                    }
                

            }
        }
        
        task.resume()
    }

    private func InfoManager(response: [String:Any]){
        print(response)
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                    self.SetText(data: dataBody!)
                
            }
        }
    }
    
    
    private func SetText(data:[String:Any]){
        
        let status = data["status"] as! Int
        
        if(status == 1){
            OfferButton.isHidden = false
            RejectButton.isHidden = false
        }
        customerPhone.text =  data["phoneNumber"] as? String
        if(customerPhone.text == ""){
            MyOrderView.isHidden = false
        }
        
        let fromH = data["hourFrom"] as! String
        let fromM = data["minuteFrom"] as! String
        let toH = data["hourTo"] as! String
        let toM = data["minuteTo"] as! String
        
        let day = data["day"] as! Int
        let month = data["month"] as! Int
        let year = data["year"] as! Int
        
        self.fromTime.text = "\(fromH):\(fromM)"
        self.toTime.text = "\(toH):\(toM)"
        
        self.DateOfOrder.text = String(year)+"/"+String(month)+"/"+String(day)
        self.customerName.text = data["customerName"] as? String
        self.LoadingView.isHidden = true

        do{
            let OrderLat = try data["orderGpsLat"] as? Double
            if let OrderLong = try data["orderGpsLong"] as? Double{
                let targetLocation = CLLocation.init(latitude: OrderLat!, longitude:OrderLong)
                AppData.targetLocation = targetLocation
                pubManager.getAddress(location: targetLocation, textView: targetAddress)

            }
        }
        
    }
    
    @IBAction func MakeCall(_ sender: Any) {
        
        if let number = customerPhone.text{
            callNumber(phoneNumber: number)
        }
    }

    @IBAction func BackToMain(_ sender: Any) {
         GoToMain()
    }
    
    private func GoToMain(){
        if(AppData.lastDetailsScene == "OrderListForDriver"){
            NavigationManager.MoveToDriverMain(View: self)
        }
        else{
            NavigationManager.MoveToScene(sceneId: AppData.lastDetailsScene, View: self)
        }
    }
    
    @IBAction func PressAccept(_ sender: Any) {
         AcceptOrder(urlstring: AppData.APIurl, orderId: (AppData.selectedOrderId)!, status:"2")
    }
    
    @IBAction func PressDeleteOrder(_ sender: Any) {
        AcceptOrder(urlstring: AppData.APIurl, orderId: (AppData.selectedOrderId)!, status:"3")
    }
    
    private func AcceptOrder(urlstring: String,orderId: String,status: String){
        
        let parameters = "orderToken=qjdi5k4nfoe94nt8\(orderId)qjdi5k4nfoe94nt8&status=\(status)&token=\(AppData.token!)"
        print(parameters)
        
        let url = URL(string: urlstring)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = parameters.data(using: .utf8)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                NavigationManager.ShowError(errorText: "Плохое соединение!", View: self)
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            DispatchQueue.main.async
                {
                    self.GoToMain()
            }
            if let responseJSON = responseJSON as? [String: Any] {
                print(response)
                if let array = responseJSON["data"] as? [Any] {
                    if let firstObject = array.first {
                        let dataBody = firstObject as? [String: Any]
                        let success = dataBody?["success"] as! Bool
                        
                    }
                }
            }
        }
        
        task.resume()
        
    }
    
    @IBAction func pressShowOnMap(_ sender: Any) {
        AppData.lastMapScene = "OrderDetails"
        NavigationManager.MoveToScene(sceneId: "TargetLocationOnMap", View: self)
    }
    
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string:"tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL as URL)) {
                application.openURL(phoneCallURL as URL);
            }
        }
    }
    
    
    
}
