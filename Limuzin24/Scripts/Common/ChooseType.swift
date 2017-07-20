//
//  ChooseType.swift
//  Track24
//
//  Created by Khusan Saidvaliev on 19.03.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation


import UIKit

class ChooseType: UIViewController {
    
    @IBOutlet weak var DriverButton: UIButton!
    @IBOutlet weak var CustomerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ChooseUser(_ sender: UIButton) {
        AppData.userType = 1
        
        let defaults = UserDefaults.standard
        defaults.set("1", forKey: localKeys.userType)
        GoToLogIn()
    }
    
    
    @IBAction func ChooseDriver(_ sender: Any) {
        AppData.userType = 2
        let defaults = UserDefaults.standard
        defaults.set("2", forKey: localKeys.userType)
        
        GoToLogIn()
    }
    
    private func GoToLogIn(){
       NavigationManager.MoveToScene(sceneId: "LogInCustomer", View: self)
    }
    
        
}


