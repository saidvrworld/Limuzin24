//
//  Settings.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 10.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit

class Settings: UIViewController {
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func BackToСhooseType(_ sender: Any) {
        AppData.ClearDB()
        NavigationManager.MoveToScene(sceneId: "ChooseType",View: self)
    }
    
    @IBAction func GoToDonePubs(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: "DonePublicatonsCustomer",View: self)
    }
    
    
}
