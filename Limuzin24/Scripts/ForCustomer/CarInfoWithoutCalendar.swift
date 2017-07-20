//
//  CarInfoWithoutCalendar.swift
//  Limuzin
//
//  Created by Khusan Saidvaliev on 12.06.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation

import UIKit
import CoreLocation



class CarInfoWithoutCalendar: UIViewController{
    
    
    @IBOutlet weak var ErrorView: UIView!
    @IBOutlet weak var LoadingIndicator: UIView!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carNumber: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var carWeigth: UILabel!
    @IBOutlet weak var carType: UILabel!
    @IBOutlet weak var driver_rating_Label: UILabel!
    
    
    @IBOutlet weak var car_length: UILabel!
    @IBOutlet weak var driver_price: UILabel!
    @IBOutlet weak var PhoneNumberView: UILabel!
    @IBOutlet weak var DateOfOrder: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    
    @IBOutlet weak var fromTime: UILabel!
    
    @IBOutlet weak var toTime: UILabel!
    @IBOutlet weak var workFrom: UILabel!
    
    @IBOutlet weak var workTo: UILabel!
    var isCarImageLoading = false
    var isUserImageLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            MakeRequest(urlstring: AppData.GetCustomerOrderInfo, orderId: String(AppData.selectedOrderId))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MakeCall(_ sender: Any) {
        
        if let number = PhoneNumberView.text{
            callNumber(phoneNumber: number)
        }
    }
    
    @IBAction func SetRate(_ sender: Any) {
           ShowRateWindow()
    }
    
     func ShowRateWindow(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let PopView = storyBoard.instantiateViewController(withIdentifier: "SetDriverRateWindow") as! SetDriverRateWindow
        self.addChildViewController(PopView)
        PopView.view.frame = self.view.frame
        self.view.addSubview(PopView.view)
        PopView.didMove(toParentViewController: self)
    }
    
    private func MakeRequest(urlstring: String,orderId: String){
        
        let parameters = "token=59394a7arty4t56t\(orderId)59394a7arty4t56t"
        
        //print(parameters)
        
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
                            self.ErrorView.isHidden = false
                            NavigationManager.ShowError(errorText: "Плохое соединение!", View: self)
                    }
                }
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                self.InfoManager(response:responseJSON)

            }
        }
        
        task.resume()
    }
    
    private func InfoManager(response: [String:Any]){
        print(response)
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                //print(dataBody)
                    DispatchQueue.main.async
                        {
                            self.SetText(data: dataBody!)
                            self.LoadingIndicator.isHidden = true
                    }
                
                setCarPicture(dataBody?["carImageUrl"] as! String)
                setUserPicture(dataBody?["userPhoto"] as! String)
            }
        }
    }
    
    
    private func SetText(data:[String:Any]){
        //DateOfOrder.text =
        userName.text = data["userName"] as? String
        carNumber.text = data["carNumber"] as? String
        car_length.text = data["carLength"] as? String
        carType.text = data["carName"] as? String
        details.text = data["details"] as? String
        PhoneNumberView.text = data["phoneNumber"] as? String
        driver_rating_Label.text = String(data["rate"] as! Int)
        driver_price.text = data["driverPrice"] as? String
        let fromH = data["hourFrom"] as! String
        let fromM = data["minuteFrom"] as! String
        let toH = data["hourTo"] as! String
        let toM = data["minuteTo"] as! String
        fromTime.text = "\(fromH):\(fromM)"
        toTime.text = "\(toH):\(toM)"
        do{
        let OrderLat = try data["orderGpsLat"] as? Double
            if let OrderLong = try data["orderGpsLong"] as? Double{
                let targetLocation = CLLocation.init(latitude: OrderLat!, longitude:OrderLong)
                AppData.targetLocation = targetLocation
            
            }
        }
        do{
            let DriverLong = try data["driverGpsLong"] as? Double
            if let DriverLat = try data["driverGpsLat"] as? Double{
                let driverLocation = CLLocation.init(latitude: DriverLat, longitude:DriverLong!)
                AppData.DriverLocation = driverLocation
            }
        }
        let status = data["status"] as! Int
       
        if(status == 1){
            StatusLabel.text = "Ожидается ответ"
        }
        else if(status == 2){
            StatusLabel.text = "Принят"
        }
        
    }
    
    
    @IBAction func BackToMainView(_ sender: Any) {
        NavigationManager.MoveToCustomerMain(View: self)
    }
    
    private func setCarPicture(_ url:String){
        if(self.isCarImageLoading){
            //self.Loading.startAnimating()
        }
        if(!isCarImageLoading){
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                self.carImage.image =  self.DownloadCarImage(url)
                DispatchQueue.main.async
                    {
                        self.isCarImageLoading = false
                }
            }
        }
    }
    
    private func setUserPicture(_ url:String){
        if(self.isUserImageLoading){
            //self.Loading.startAnimating()
        }
        if(!isUserImageLoading){
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                self.userImage.image =  self.DownloadUserImage(url)
                DispatchQueue.main.async
                    {
                        self.isUserImageLoading = false
                }
            }
        }
    }
    
    
    private func DownloadCarImage(_ imgUrl:String)->UIImage{
        self.isCarImageLoading = true
        var Image: UIImage?
        let url = URL(string:imgUrl)
        let data = try? Data(contentsOf: url!)
        
        if data != nil {
            Image = try! UIImage(data:data!)
        } else {
            Image = UIImage(named: "image_placeholder.png")
        }
        if(Image == nil){
            Image = UIImage(named: "image_placeholder.png")
        }
        //self.Loading.stopAnimating()
        return Image!
    }
    
    private func DownloadUserImage(_ imgUrl:String)->UIImage{
        self.isUserImageLoading = true
        var Image: UIImage?
        let url = URL(string:imgUrl)
        let data = try? Data(contentsOf: url!)
        
        if data != nil {
            Image = UIImage(data:data!)
        
        } else {
            Image = UIImage(named: "user_icon.png")
        }
        
        if let newImage = Image{
            return Image!
        }
        else {
          return UIImage(named: "user_icon.png")!
        }
        //self.Loading.stopAnimating()
    }
    
    @IBAction func pressShowOnMap(_ sender: Any) {
        AppData.lastMapScene = "CarInfoWithoutCalendar"
        NavigationManager.MoveToScene(sceneId: "TargetLocationOnMap", View: self)
    }
    
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string:"tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL as URL)) {
                application.openURL(phoneCallURL as URL);
            }
        }
    }
    
    
}
