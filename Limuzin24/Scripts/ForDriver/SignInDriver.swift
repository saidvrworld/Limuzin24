//
//  SignInDriver.swift
//  Track24
//
//  Created by Khusan Saidvaliev on 19.03.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//


import Foundation


import UIKit



class SignInDriver: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var LoadingView: UIView!
    @IBOutlet weak var TimeTo: UIDatePicker!         // время начала рабочего дня водителя
    @IBOutlet weak var TimeFrom: UIDatePicker!
    @IBOutlet weak var UserNameField: UITextField!   //Имя фамилия водителя
    @IBOutlet weak var AgreeButton: UIButton!         //кнопка соглашения
    @IBOutlet weak var SuccessRegistredView: UIView!  //Окно которое выходит при удачной регистрации
    @IBOutlet weak var car_number: UITextField!      // номер авто
    @IBOutlet weak var car_details: UITextField!    //детали про автомобиль
    @IBOutlet weak var car_length: UITextField!     // длина автомобиля
    @IBOutlet weak var driver_price: UITextField!   //цена аренды авто на 1 час
    @IBOutlet weak var car_Name: UITextField!   //марка амшины
    @IBOutlet weak var CarTypeButton: UIButton!
    
    
    private var agree:Bool = false
    var CheckBox = UIImage(named:"Checked.jpeg")
    var UnCheckBox = UIImage(named:"UnChecked.jpeg")
    var FromHours:Int!
    var FromMinutes:Int!
    var ToHours:String!
    var ToMinutes:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillFields()
        self.UserNameField.delegate = self;
        self.car_number.delegate = self;
        self.car_details.delegate = self;
        self.car_length.delegate = self;
        self.driver_price.delegate = self;
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(SignInDriver.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    private func fillFields(){
        if(AppData.carType != nil){
            CarTypeButton.setTitle(AppData.carType, for: .normal)
        }
        if(AppData.userName != nil){
            UserNameField.text = AppData.userName
        }
        if(AppData.SignIn_details != nil){
            car_details.text = AppData.SignIn_details
        }
        if(AppData.SignIn_number != nil){
            car_number.text = AppData.SignIn_number
        }
        if(AppData.SignIn_car_length != nil){
            car_length.text = AppData.SignIn_car_length
        }
        if(AppData.SignIn_Driver_price != nil){
            driver_price.text = AppData.SignIn_Driver_price
        }
        
    
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func didTapView(){
        self.view.endEditing(true)
    }
   
    
    private func Registrate(){

        if(AppData.carTypeID == nil){
            NavigationManager.ShowError(errorText: "Вы не выбрали тип машины", View: self)
                return
            }
        if(!(UserNameField.hasText)){
            NavigationManager.ShowError(errorText: "Вы не ввели имя", View: self)
            return
                }
        if(!(car_length.hasText)){
            NavigationManager.ShowError(errorText: "Вы не указали длину машины", View: self)
            return
        }
        
        if(!(driver_price.hasText)){
            NavigationManager.ShowError(errorText: "Вы не указали цену ваших услуг", View: self)
            return
        }
    
        if(!(car_number.hasText)){
            NavigationManager.ShowError(errorText: "Вы не ввели гос. номер машины", View: self)
            return
        }
        
        if(!(car_details.hasText)){
            car_details.text = "Хорошая и удобная машина"
        }
        
        if(!(car_Name.hasText)){
            NavigationManager.ShowError(errorText: "Вы не марку машины", View: self)
            return

        }
        
        if(agree){
            LoadingView.isHidden = false
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            var from_time:String = dateFormatter.string(from: TimeFrom.date)
            var to_time:String = dateFormatter.string(from: TimeTo.date)
            
            var fromTimeList = from_time.characters.split{$0 == ":"}.map(String.init)
            var toTimeList = to_time.characters.split{$0 == ":"}.map(String.init)

            if(Int(fromTimeList[0])!>Int(toTimeList[0])!){
                var cach = fromTimeList
                fromTimeList = toTimeList
                toTimeList = cach
            }
            
            MakeRequest(urlstring: AppData.APIurl,car_name: car_Name.text!, userName: UserNameField.text!, token: AppData.token,carType: AppData.carTypeID, detail: car_details.text!,carNumber: car_number.text!, car_length_in: car_length.text!, driver_price_in: driver_price.text!,hourFrom: fromTimeList[0],minuteFrom: fromTimeList[1],hourTo: toTimeList[0],minuteTo: toTimeList[1],details: car_details.text!)
           }
        else{
            NavigationManager.ShowError(errorText: "Подпишите соглашение", View: self)

        }
    
    }
        
    
    private func MakeRequest(urlstring: String,car_name:String,userName: String,token:String,carType:String,detail:String,carNumber:String,car_length_in:String,driver_price_in:String,hourFrom:String,minuteFrom:String,hourTo:String,minuteTo:String,details:String){
        
        let parameters = "driverName=\(userName)&token=\(token)&carLength=\(car_length_in)&carTypeId=\(carType)&carNumber=\(carNumber)&driverPrice=\(driver_price_in)&workFromH=\(hourFrom)&workFromM=\(minuteFrom)&workToH=\(hourTo)&workToM=\(minuteTo)&details=\(details)&carName=\(car_name)"
        print(parameters)
        let url = URL(string: urlstring)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = parameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
                    self.ManageResponse(response:responseJSON)
                    DispatchQueue.main.async
                        {
                            self.SuccessRegistredView.isHidden = false
                    }
                    
                }

            }
        }
        
        task.resume()
        
    }
    
    private func ManageResponse(response:[String:Any]){
        print(response)
        if let array = response["data"] as? [Any] {
            if let firstObject = array.first {
                let dataBody = firstObject as? [String: Any]
                
                let registered = dataBody?["registered"] as! Int
                
                if(registered == 1){
                    
                    let defaults = UserDefaults.standard
                    defaults.set("1", forKey: localKeys.isRegistered)

                    print("Success registration")
                    print(dataBody?["userName"] as! String)
                    AppData.registered = true
                }
                else{
                    AppData.registered = false
                }
            }
            
        }
        
    }
    
    
    
    @IBAction func SwitchOn(_ sender: UIButton) {
        if(!agree){
            agree = true
            AgreeButton.setImage(CheckBox,for: UIControlState.normal)
            ShowAgreement()
            
        }
        else{
            agree = false
            AgreeButton.setImage(UnCheckBox,for: UIControlState.normal)
        }
        
        
    }
    
    @IBAction func AcceptRegistration(_ sender: Any) {
        Registrate()
    }
    
    @IBAction func BackToSmsVerification(_ sender: Any) {
        NavigationManager.MoveToScene(sceneId: "SMSVerification", View: self)
    }
    
    @IBAction func GoToChooseCarType(_ sender: Any) {
        AppData.lastScene = "SignInDriver"
        NavigationManager.MoveToScene(sceneId: "ChooseCarType", View: self)

    }
    
    @IBAction func GoToAgreement(_ sender: Any) {
        ShowAgreement()

    }
    
    @IBAction func GoToMainDriver(_ sender: Any) {
    NavigationManager.MoveToDriverMain(View: self)
    }
    
    @IBAction func FinishEnterName(_ sender: UITextField) {
        AppData.userName = sender.text!
    }
    
    
    @IBAction func FinishEnterNumber(_ sender: UITextField) {
        AppData.SignIn_number = sender.text!

    }
    
    @IBAction func FinishEnterDetails(_ sender: UITextField) {
        AppData.SignIn_details = sender.text!
    }
    
   private func ShowAgreement(){
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    var  PopView = storyBoard.instantiateViewController(withIdentifier: "AgreementPopUp") as! PopUpViewController
    self.addChildViewController(PopView)
    PopView.view.frame = self.view.frame
    self.view.addSubview(PopView.view)
    PopView.didMove(toParentViewController: self)
    }
    
   

}

