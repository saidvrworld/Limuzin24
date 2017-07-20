//
//  NearList.swift
//  Track24
//
//  Created by Khusan Saidvaliev on 07.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation


import UIKit
import MapKit
import CoreLocation

class NearList: UIViewController{
    
    var locationManager = CLLocationManager()

    let carMananger = CarData()
    
    @IBOutlet weak var LoadingView: UIView!
    @IBOutlet weak var EmptyListView: UIView!
    
    @IBAction func GoToCarFilter(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: "CarFilter", View: self)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(AppData.CarList.count == 0){
            UpdateCarTable()
        }
        
        var timer = Timer.scheduledTimer(timeInterval: AppData.UpdateInterval, target: self, selector: #selector(self.updateList), userInfo: nil, repeats: true)
        NavigationManager.TimerList.append(timer)

    }
    
    @objc func updateList() {
        LoadingView.isHidden = false
        UpdateCarTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(AppData.CarList.count == 0){
            ShowEmptyError()
        }
        else{
          HideEmptyError()
        
        }
        return AppData.CarList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> CarCell {
        let tableRow:CarCell = self.tableView.dequeueReusableCell(withIdentifier: "CarCell",for: indexPath) as! CarCell
        tableRow.createCell(car: AppData.CarList[indexPath.row])
        return tableRow
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        let currentCell = tableView.cellForRow(at: indexPath!) as! CarCell
        AppData.selectedCarId = currentCell.carId
        GoToDetailsInfo()
    }
    
    private func UpdateCarTable(){
        var my_location:CLLocationCoordinate2D!
        if(AppData.currentLocation == nil){
             my_location = locationManager.location?.coordinate
            if(my_location == nil){
              my_location = CLLocationCoordinate2D.init(latitude: 41.311132, longitude: 69.279612)
            }
            AppData.currentLocation = CLLocation.init(latitude: my_location.latitude, longitude: my_location.longitude)
        }
        else{
             my_location = AppData.currentLocation.coordinate
        }
        if(AppData.carTypeID == nil){
            carMananger.MakeRequest(table: self,urlAddress: AppData.nearListUrl, token: AppData.token, long: String( my_location!.longitude), lat: String(my_location!.latitude),carTypeId: "None")
        }
        else{
        carMananger.MakeRequest(table: self,urlAddress: AppData.nearFilteredListUrl, token: AppData.token, long: String( my_location!.longitude), lat: String(my_location!.latitude),carTypeId: AppData.carTypeID)
        
        }
     
    }
    
    
    @IBAction func GoToCarMap(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: "NearCarMap", View: self)
        
    }
    
    func GoToDetailsInfo() {
        NavigationManager.MoveToScene(sceneId: "CarDetails", View: self)

    }
    
    
    
    func HideEmptyError(){
       self.EmptyListView.isHidden = true
    
    }
    
    func ShowEmptyError(){
        self.EmptyListView.isHidden = false
        
    }
    
}
