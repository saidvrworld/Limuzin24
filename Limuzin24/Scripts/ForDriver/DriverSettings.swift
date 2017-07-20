//
//  DriverSettings.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 04.05.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit

class DriverSettings: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func GoToSetImage(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: "SetImages", View: self)

    }
    
    @IBAction func GoToGetIncome(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: "GetDriverIncome", View: self)
        
    }
    
    @IBAction func BackToСhooseType(_ sender: Any) {
        NavigationManager.StopSendLoc()
        AppData.ClearDB()
        NavigationManager.MoveToScene(sceneId: "ChooseType", View: self)

    }
    
    @IBAction func GoToDonePubs(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: "MyFinishedOrdersListForDriver", View: self)

        
    }
    
}
