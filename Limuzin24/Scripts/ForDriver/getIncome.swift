//
//  getIncome.swift
//  Limuzin
//
//  Created by Khusan Saidvaliev on 11.07.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit

class GetDriverIncome: UIViewController {
    
    @IBOutlet weak var YearView: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(GetDriverIncome.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)

    }
    
    func didTapView(){
        self.view.endEditing(true)
    }
    
    @IBAction func PressBack(_ sender: Any) {
        NavigationManager.MoveToDriverMain(View: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func GetIncome(_ sender: Any) {
        if(YearView.text?.characters.count == 4){
             MakeRequest(urlstring: AppData.GetDriverIncomeUrl, token: AppData.token, year: YearView.text!)
        }
        else{
         
            NavigationManager.ShowError(errorText: "Введите год!", View: self)
        }
    }
    
    private func MakeRequest(urlstring: String,token: String,year: String){
        
        let parameters = "token=\(token)&year=\(year)"
        
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
                            NavigationManager.ShowError(errorText: "Плохое соединение!", View: self)
                    }
                }
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                if let array = responseJSON["data"] as? [Any] {
                    if let firstObject = array.first {
                        let dataBody = firstObject as? [String: Any]
                        let text = dataBody?["amount"] as! String
                        DispatchQueue.main.async
                            {
                                NavigationManager.ShowError(errorText: "Ваш заработок \(text)", View: self)
                        }
                        
                    }
                }
                
            }
        }
        
        task.resume()
    }

        
}
