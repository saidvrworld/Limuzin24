//
//  OrderListForDriver.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 10.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit

class OrderListForDriver: UIViewController{
    
    
    @IBOutlet weak var EmptyView: UIView!
    var locManager = SendLocation()
    @IBOutlet weak var LoadingView: UIView!
    
    
    private func GetOrders(urlstring: String,token: String){
        
        let parameters = "token=\(token)&imadriver=true"
        
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
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                    AppData.UnacceptedOrderList = self.CreateOrderList(response:responseJSON)
                    DispatchQueue.main.async
                        {
                            self.LoadingView.isHidden = true
                            self.tableView.reloadData()
                    }
                }
            }
        }
        
        task.resume()
    }
    
    private func CreateOrderList(response: [String:Any])-> [Order]{
        self.LoadingView.isHidden = false
        var orderList:[Order] = []
        if let array = response["data"] as? [Any] {
            print(array)
            for JsonOrder in array {
                let dataBody = JsonOrder as? [String: Any]
                let newOrder = Order()
                let day = dataBody?["day"] as! Int
                let month = dataBody?["month"] as! Int
                let year = dataBody?["year"] as! Int
                let date = String(year)+"/"+String(month)+"/"+String(day)
                newOrder.date = date
                newOrder.customerName = dataBody?["customerName"] as? String
                newOrder.customerNumber = dataBody?["customerPhone"] as? String
                newOrder.long = dataBody?["gpsLong"] as? Double
                newOrder.lat = dataBody?["gpsLat"] as? Double
                newOrder.orderId = dataBody?["orderId"] as! String
                newOrder.status = dataBody?["status"] as? Int
                
                let fromHour = dataBody?["hourFrom"] as? Int
                let fromMinute = dataBody?["minuteFrom"] as? Int
                let toHour = dataBody?["hourTo"] as? Int
                let toMinute = dataBody?["minuteTo"] as? Int
                newOrder.long = dataBody?["gpsLong"] as? Double
                newOrder.lat = dataBody?["gpsLat"] as? Double
                newOrder.fromTime = String((fromHour)!)+":"+String((fromMinute)!)
                newOrder.ToTime = String((toHour)!)+":"+String((toMinute)!)
                if(newOrder.status == 1){
                    orderList.append(newOrder)
                }
                
            }
            
        }
        
        return orderList
    }

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetOrders(urlstring: AppData.GetDriverOrdersForDriver, token: AppData.token)

        var timer = Timer.scheduledTimer(timeInterval: AppData.UpdateInterval, target: self, selector: #selector(self.updateList), userInfo: nil, repeats: true)
        NavigationManager.TimerList.append(timer)

    }
    
    @objc func updateList() {
        LoadingView.isHidden = false
        GetOrders(urlstring: AppData.GetDriverOrdersForDriver, token: AppData.token)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(AppData.UnacceptedOrderList.count == 0){
            EmptyView.isHidden = false
        }
        else{
            EmptyView.isHidden = true
            
        }

        return AppData.UnacceptedOrderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> OrderWithDatesForDriverCell {
        let tableRow:OrderWithDatesForDriverCell = self.tableView.dequeueReusableCell(withIdentifier: "OrderWithDatesForDriverCell",for: indexPath) as! OrderWithDatesForDriverCell
        tableRow.createCell(order: AppData.UnacceptedOrderList[indexPath.row])
        return tableRow
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!) as! OrderWithDatesForDriverCell
        AppData.selectedOrderId = AppData.UnacceptedOrderList[(indexPath?.row)!].orderId
        AppData.lastDetailsScene = "OrderListForDriver"
        NavigationManager.MoveToScene(sceneId: "OrderDetails",View: self)
    }
    
    
}
