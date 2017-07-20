//
//  PopUpViewController.swift
//  Track24
//
//  Created by Khusan Saidvaliev on 21.03.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func ClosePopUp(_ sender: Any) {
        
        self.view.removeFromSuperview()
    }

}

class DinamicPopUp: UIViewController {
    
    @IBOutlet weak var ErrorText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ErrorText.text = AppData.PopUpErrorText
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ClosePopUp(_ sender: Any) {
        
        self.view.removeFromSuperview()
    }
    
}


class SetDriverRateWindow: UIViewController {
    
    @IBOutlet weak var ratingBoard: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SetRate(_ sender: Any) {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                self.RequestRate(rate: (self.ratingBoard.selectedSegmentIndex+1))
                DispatchQueue.main.async
                    {
                        self.view.removeFromSuperview()
                }
            
           }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func ClosePopUp(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    private func RequestRate(rate:Int){
        let urlstring = AppData.setRateForDriverUrl
        let parameters = "rate=fec5fdf5ac012r43"+String(rate)+"fec5fdf5ac012r43&orderToken=fec5fdf5ac012r43\(AppData.selectedOrderId!)fec5fdf5ac012r43"
        
        print(parameters)
        
        let url = URL(string: urlstring)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        request.httpBody = parameters.data(using: .utf8)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                //self.AnswerManager(response:responseJSON)
            }
        }
        
        task.resume()
        
    }
    
    private func AnswerManager(response: [String:Any]){
        
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                
                let success = dataBody?["success"] as! Bool
                if(success){

                    print("You rate"+String(ratingBoard.selectedSegmentIndex+1))
                }
                
            }
            
        }
        
    }

    
}
