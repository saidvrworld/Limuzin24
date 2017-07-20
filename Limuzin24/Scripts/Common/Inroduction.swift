//
//  Inroduction.swift
//  Track24
//
//  Created by Khusan Saidvaliev on 19.03.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation

import MapKit
import CoreLocation
import UIKit

class Inroduction: UIViewController {
    
    @IBAction func Skip(_ sender: UIButton) {
        NavigationManager.MoveToScene(sceneId: "ChooseType", View: self)
    }
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        CheckLog()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func CheckLog(){
        
        let defaults = UserDefaults.standard
        if let status = defaults.string(forKey: localKeys.sendStatus) {
             AppData.SendStatus = status
        }
        else{
            AppData.SendStatus = "false"
            defaults.set(AppData.SendStatus, forKey: localKeys.sendStatus)
        }
        
        
        if let userType = defaults.string(forKey: localKeys.userType) {
            print(userType)
            if(userType == "1"){
                AppData.userType = 1
            }
            else if(userType == "2"){
                AppData.userType = 2
            }
            
            if let token = defaults.string(forKey: localKeys.token) {
                AppData.token = token
                if let isSmsSubmited = defaults.string(forKey: localKeys.smsSubmited) {
                
                    if(isSmsSubmited == "yes"){
                        CheckIsRegitered()
                    }
                    else{
                        GoToCodeVerification()
                    }
                }
                else{
                    
                    GoToCodeVerification()
                    }
            }
            else{
                GoToLogIn()
            }
        }
    }
    
    func CheckIsRegitered(){
        let defaults = UserDefaults.standard
        if let isRegistered = defaults.string(forKey: localKeys.isRegistered) {
            if(isRegistered == "1"){
                
                AppData.registered = true
                GoToNearList()
            }
            else{
                AppData.registered = false
                GoToRegistration()
            }
        }
        else{
            GoToCodeVerification()
        }
    }
    
    private func GoToLogIn(){
        NavigationManager.MoveToScene(sceneId: "LogInCustomer", View: self)
    }
    
    func GoToNearList() {
        if(AppData.userType == 1){
            NavigationManager.MoveToScene(sceneId: "ChooseCarTypeIntro", View: self)
        }
        else{
            NavigationManager.MoveToDriverMain(View: self)

        }
    }
    
    func GoToRegistration() {
        if(AppData.userType==1){
            NavigationManager.MoveToScene(sceneId: "SignInCustomer", View: self)
        }
        else{
            NavigationManager.MoveToScene(sceneId: "SignInDriver", View: self)
        }
    }
    
    func GoToCodeVerification() {
        NavigationManager.MoveToScene(sceneId: "SMSVerification", View: self)
    }
    
}



