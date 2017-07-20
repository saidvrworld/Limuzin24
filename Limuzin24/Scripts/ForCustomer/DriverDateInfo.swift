//
//  DriverDateInfo.swift
//  Limuzin
//
//  Created by Khusan Saidvaliev on 08.06.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation

import UIKit

class DriverDateInfo: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var EmptyView: UIView!
    
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
            EmptyView.isHidden = false
          return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> OrderForCustomerCell {
        let tableRow:OrderForCustomerCell = self.tableView.dequeueReusableCell(withIdentifier: "OrderForCustomerCell",for: indexPath) as! OrderForCustomerCell
        tableRow.createCell(order: (AppData.OrderList[AppData.selectedDate]?[indexPath.row])!)
        return tableRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        let currentCell = tableView.cellForRow(at: indexPath!) as! OrderForCustomerCell
    }
    
    @IBAction func Back(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: "CarDetails", View: self)
    }
    
    @IBAction func GoToAddOrder(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: "AddPublication", View: self)
    }
    
}
