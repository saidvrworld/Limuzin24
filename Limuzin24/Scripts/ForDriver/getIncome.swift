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
    

    @IBOutlet weak var FromDate: UIDatePicker!
    @IBOutlet weak var ToDate: UIDatePicker!
    
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
             MakeRequest(urlstring: AppData.GetDriverIncomeUrl, token: AppData.token,dateFrom: FromDate,dateTo: ToDate)
        
       
    }
    
    private func MakeRequest(urlstring: String,token: String,dateFrom: UIDatePicker,dateTo:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        let from_date:String = dateFormatter.string(from: dateFrom.date)
        var from_date_array = from_date.characters.split{$0 == "."}.map(String.init)
        
        let to_date:String = dateFormatter.string(from: dateTo.date)
        var to_date_array = to_date.characters.split{$0 == "."}.map(String.init)


        let parameters = "token=\(token)&yearFrom=\(from_date_array[0])&monthFrom=\(from_date_array[1])&dayFrom=\(from_date_array[2])&yearTo=\(to_date_array[0])&monthTo=\(to_date_array[1])&dayTo=\(to_date_array[2])"
        
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
