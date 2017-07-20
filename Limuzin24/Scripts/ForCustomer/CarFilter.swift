//
//  CarFilter.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 08.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit


class CarFilter: UIViewController {
    
    var pubManager = PublicationData()
    
    @IBOutlet weak var AddressView: UILabel!
    @IBOutlet weak var carType: UIButton!
    @IBOutlet weak var RadiusSlider: UISlider!
    @IBOutlet weak var radius: UILabel!
    
    @IBAction func ChooseCarType(_ sender: Any) {
        AppData.lastScene = "CarFilter"
        NavigationManager.MoveToScene(sceneId: "ChooseCarType", View: self)
    }
    
    @IBAction func SetLocation(_ sender: Any) {
        AppData.waitingForLoc = "CarFilter"
        NavigationManager.MoveToScene(sceneId: "SetCoordinates", View: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(AppData.currentLocation != nil){
            pubManager.getAddress(location: AppData.currentLocation,textView: AddressView)
        }
        if(AppData.carType != nil){
            carType.setTitle(AppData.carType, for: .normal)
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func SetRadius(_ sender: Any) {
        radius.text = String(Int(RadiusSlider.value))+" км"
        
    }
    
    @IBAction func ShowResult(_ sender: Any) {
        AppData.CarList = []
        NavigationManager.MoveToCustomerMain(View: self)
    }
    
    @IBAction func BackToMainView(_ sender: Any) {
        NavigationManager.MoveToCustomerMain(View: self)
    }
    
    
    
}
