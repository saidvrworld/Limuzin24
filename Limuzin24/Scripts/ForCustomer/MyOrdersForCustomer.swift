//
//  MyOrdersForCustomer.swift
//  Limuzin
//
//  Created by Khusan Saidvaliev on 12.06.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit

class MyOrdersForCustomer: UIViewController{
    
    
    @IBOutlet weak var EmptyView: UIView!
    
    @IBOutlet weak var LoadingView: UIView!
    
    private func GetOrders(urlstring: String,token: String){
        LoadingView.isHidden = false

        let parameters = "token="+token
        
        print(parameters)
        print(urlstring)

        
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
                            AppData.CustomerOrders = self.CreateOrderList(response:responseJSON)
                            self.LoadingView.isHidden = true
                            self.tableView.reloadData()
                    }
                
            }
        }
        
        task.resume()
        

    }
    
    
    
    private func CreateOrderList(response: [String:Any])-> [OrderForCustomer]{
        var orderList:[OrderForCustomer] = []
        print(response)
        if let array = response["data"] as? [Any] {
            print(array)
            for JsonOrder in array {
                let dataBody = JsonOrder as? [String: Any]
                let newOrder = OrderForCustomer()
                let day = dataBody?["day"] as! Int
                let month = dataBody?["month"] as! Int
                let year = dataBody?["year"] as! Int
                let date = String(year)+"/"+String(month)+"/"+String(day)
                newOrder.date = date
                newOrder.status = dataBody?["status"] as! Int
                newOrder.orderId = String(dataBody?["orderID"] as! Int)
                newOrder.carName = dataBody?["carName"] as! String
                let fromHour = dataBody?["hourFrom"] as! String
                let fromMinute = dataBody?["minuteFrom"] as! String
                let toHour = dataBody?["hourTo"] as! String
                let toMinute = dataBody?["minuteTo"] as! String
                newOrder.fromTime = String(fromHour)+":"+String(fromMinute)
                newOrder.ToTime = String(toHour)+":"+String(toMinute)
                orderList.append(newOrder)
                
                
            }
            
        }
        
        return orderList
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
      super.viewDidLoad()
        GetOrders(urlstring: AppData.GetCustomerOrders, token: AppData.token)
        var timer = Timer.scheduledTimer(timeInterval: AppData.UpdateInterval, target: self, selector: #selector(self.updateList), userInfo: nil, repeats: true)
        NavigationManager.TimerList.append(timer)

    }
    
    @objc func updateList() {
        LoadingView.isHidden = false
        GetOrders(urlstring: AppData.GetCustomerOrders, token: AppData.token)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(AppData.CustomerOrders.count == 0){
          EmptyView.isHidden = false
        }
        else{
            EmptyView.isHidden = true

        }
        return AppData.CustomerOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> OrderWithDatesForDriverCell {
        let tableRow:OrderWithDatesForDriverCell = self.tableView.dequeueReusableCell(withIdentifier: "OrderWithDatesForCustomerCell",for: indexPath) as! OrderWithDatesForDriverCell
        tableRow.createCell(order: AppData.CustomerOrders[indexPath.row])
        return tableRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!) as! OrderWithDatesForDriverCell
        AppData.selectedOrderId = currentCell.orderId
        NavigationManager.MoveToScene(sceneId: "CarInfoWithoutCalendar",View: self)
    }
    
    
}
