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
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SetImages") as! SetImages
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func BackToСhooseType(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChooseType") as! ChooseType
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @IBAction func GoToDonePubs(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DonePublicatonsCustomer") as! DonePublicatonsCustomer
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
}