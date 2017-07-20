//
//  DateInfo.swift
//  Limuzin
//
//  Created by Khusan Saidvaliev on 11.06.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation

class DateInfoForDriver: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(AppData.OrderList[AppData.selectedDate] != nil){
            return AppData.OrderList[AppData.selectedDate]!.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> OrderForDriverCell {
        let tableRow:OrderForDriverCell = self.tableView.dequeueReusableCell(withIdentifier: "OrderForDriverCell",for: indexPath) as! OrderForDriverCell
        tableRow.createCell(order: (AppData.OrderList[AppData.selectedDate]?[indexPath.row])!)
        return tableRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        let currentCell = tableView.cellForRow(at: indexPath!) as! OrderForDriverCell
        AppData.selectedOrderId = AppData.OrderList[AppData.selectedDate]?[(indexPath?.row)!].orderId
        AppData.lastDetailsScene = "DateInfoForDriver"
        NavigationManager.MoveToScene(sceneId: "OrderDetails", View: self)

    }
    
    @IBAction func AddPub(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: "AddOrderForDriver", View: self)

    }
    
    @IBAction func Back(_ sender: Any) {
        NavigationManager.MoveToDriverMain(View: self)
    }
    
   
    
}
