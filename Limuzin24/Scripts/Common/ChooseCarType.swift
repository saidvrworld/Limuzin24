//
//  ChooseCarType.swift
//  Track24
//
//  Created by Khusan Saidvaliev on 05.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit

class ChooseCarType: UIViewController{


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ErrorView: UIView!
    var SelectedCell:TypeCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(AppData.CarTypeList.count == 0){
            MakeRequest(urlstring: AppData.getCarTypesUrl)}
        else{
           tableView.reloadData()
        }
    }
    
    private func MakeRequest(urlstring: String){
        
        let parameters = "token=fec5fdf5ac012r4312fec5fdf5ac012r43"
        
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
                            self.ErrorView.isHidden = false
                            self.ShowError(errorText: "Плохое интернет соединение")
                    }
                }
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(1)
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                    
                    self.InfoManager(response:responseJSON)
                    DispatchQueue.main.async
                        {
                            self.tableView.reloadData()
                    }
                    
                }
            }
        }
        
        task.resume()
        
    }
    
    private func InfoManager(response: [String:Any]){
        
        if let array = response["data"] as? [Any] {
            print(array)
            for car_type in array{
                let car_type = car_type as? [String: Any]
                let newType = CarType()
                newType.type = car_type?["carTypeName"] as? String
                newType.id = car_type?["carTypeId"] as? Int
                newType.imgUrl = car_type?["carPhoto"] as? String
                AppData.CarTypeList.append(newType)
            }
        }
        
    }
    
    @IBAction func PressBack(_ sender: Any) {
        Back()
    }
    
    func Back(){
        
            NavigationManager.MoveToScene(sceneId: AppData.lastScene, View: self)
    }
    
    @IBAction func GoToMain(_ sender: Any) {
        NavigationManager.MoveToCustomerMain(View: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return AppData.CarTypeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> TypeCell {
        let tableRow:TypeCell = self.tableView.dequeueReusableCell(withIdentifier: "TypeCell",for: indexPath) as! TypeCell
        tableRow.createCell(type: AppData.CarTypeList[indexPath.row])
        return tableRow
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        let currentCell = tableView.cellForRow(at: indexPath!) as! TypeCell
        currentCell.Choose()
    }
    
    func ShowError(errorText:String){
        AppData.PopUpErrorText = errorText
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let PopView = storyBoard.instantiateViewController(withIdentifier: "DinamicPopUp") as! DinamicPopUp
        self.addChildViewController(PopView)
        PopView.view.frame = self.view.frame
        self.view.addSubview(PopView.view)
        PopView.didMove(toParentViewController: self)
        
        
    }


}


