//
//  SMSVerification.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 07.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation


import UIKit

class SMSVerification: UIViewController {

    
    
    @IBOutlet weak var SMSCode: UITextField!
    
    @IBOutlet weak var LoadingView: UIView!
    @IBOutlet weak var SuccessView: UIView!

    var successCode: Bool = false
    var isRegistrated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(SignInDriver.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func didTapView(){
        self.view.endEditing(true)
    }
    
    func AcceptCode() {
        MakeRequest(urlstring: AppData.APIurl, code: SMSCode.text!, token: AppData.token)
    }
    
    @IBAction func BackToLogIn(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: "LogInCustomer", View: self)
    }
    
    func MakeRequest(urlstring: String,code: String,token:String){
        
        let parameters = "smsResponse=\(code)&token=\(token)"
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
                            self.LoadingView.isHidden = true
                            NavigationManager.ShowError(errorText: "Плохое интернет соединение!", View: self)
                    }
                    
                }
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                    self.CheckCode(response:responseJSON)
                
            }
        }
        
        task.resume()

        
    }
    
    func CheckCode(response: [String:Any]){
        print(response)
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                let success = dataBody?["success"] as! Bool
                let registered = dataBody?["registered"] as! Int
                let userName = dataBody?["userName"] as? String
                
                
                let defaults = UserDefaults.standard
                if(success){
                    print("Success sms Code Verification")
                    successCode = true
                    
                    AppData.token = (dataBody?["token"] as? String)!
                    
                    defaults.set(AppData.token, forKey: localKeys.token)
                    defaults.set("yes", forKey: localKeys.smsSubmited)

                    if(registered == 1){
                        isRegistrated = true
                        defaults.set("1", forKey: localKeys.isRegistered)
                        AppData.userName = userName!
                        defaults.set(AppData.userName, forKey: localKeys.userName)
                        print(AppData.userName)
                    }
                    else{
                        defaults.set("0", forKey: localKeys.isRegistered)
                        isRegistrated = false
                    }
                    
                    self.ShowSuccessView(show: true)
                }
                else{
                    DispatchQueue.main.async
                        {
                            self.LoadingView.isHidden = true
                            NavigationManager.ShowError(errorText: "Код недействителен",View: self)

                    }
                    defaults.set("no", forKey: localKeys.smsSubmited)

                    successCode = false
                }
                
            }
        }
        
    }
    
    func ShowSuccessView(show:Bool){
        DispatchQueue.main.async
            {
                self.SuccessView.isHidden = !show
        }
        
    }
    
    func ShowLoadingView(show:Bool){
        DispatchQueue.main.async
            {
                self.LoadingView.isHidden = !show
        }
        
    }
    
    @IBAction func AddChar(_ sender: UITextField) {
        if((sender.text?.characters.count)! == 5){
            LoadingView.isHidden = false
            self.view.endEditing(true)
            AcceptCode()
        }
    }
    
    
    @IBAction func NextStep(_ sender: Any) {
        if((SMSCode.text?.characters.count)! < 5){
            NavigationManager.ShowError(errorText: "Вы не ввели код полученый по смс", View: self)

        }else{
            if(successCode){
                if(isRegistrated){
                    GoToNearList()
                }else{
                    GoToRegistration()
                }
            }else{
                NavigationManager.ShowError(errorText: "Код недействителен",View: self)
            }
        }
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
    
}


private var __maxLengths = [UITextField: Int]()

extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
    
   
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        let c = self.characters
        if (c.count <= n) { return self }
        return String( Array(c).prefix(upTo: n) )
    }
}
