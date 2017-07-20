//
//  Singleton.swift
//  Track24
//
//  Created by Khusan Saidvaliev on 05.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import MapKit


class AppData{
    static let sharedInstance = AppData()
    
    static var CarTypeList: [CarType] = []
    static var CarList: [CarShort] = []
    static var PubList: [Publication] = []
    static var DonePubList: [Publication] = []
    static var CarDetailsList:[Int:CarDetail] = [:]
    static var PubDetailsList:[Int:PubDetail] = [:]
    static var OrderList:[String:[Order]] = [:]
    static var UnacceptedOrderList:[Order] = []
    static var CustomerOrders:[OrderForCustomer] = []


    
    static let APIurl: String = "http://dreambox.uz/api/"
    static let nearFilteredListUrl: String = "http://dreambox.uz/api/getNearCars/"
    static let nearListUrl: String = "http://dreambox.uz/api/getNearCars/"
    static let CarInfoUrl: String = "http://dreambox.uz/api/getCarInfo/"
    static let GetDriverOrdersForDriver = "http://dreambox.uz/api/getCarOrders/"
    static let getDriverOrdersForCustomerUrl = "http://dreambox.uz/api/getCarOrders/"
    static let getCarTypesUrl: String = "http://dreambox.uz/api/getCarTypes/"
    static let GetCustomerOrders = "http://dreambox.uz/api/getCustomerOrders/"
    static let GetCustomerOrderInfo = "http://dreambox.uz/api/getCustomerOrderInfo/"
    static let GetDriverOrderInfo = "http://dreambox.uz/api/getDriverOrderInfo/"

   
    static let setRateForDriverUrl = "http://dreambox.uz/api/rateDriver/"
    static let setImageForDriverUrl = "http://dreambox.uz/api/uploadPhoto/"
    static let DriverInfoForDriver = "http://track24.beetechno.uz/api/driver/getDriverInfo/"
    static let GetDriverIncomeUrl = "http://dreambox.uz/api/getDriverEarnings/"
    
    static var userType = 0
    static var userName:String!
    static var selectedDate:String!
    static var selectedOrder:Order!
    static var selectedCustomerOrder:OrderForCustomer!

    
    static var SendStatus:String!
    static var registered:Bool = true
    static var token:String!
    static var phoneNumber:String = "0"
    static var carType:String!
    static var carTypeID:String!
    static var selectedCarId:Int = 0
    static var selectedOrderId:String!
    static var notes:String!
    static var SignIn_car_length:String!
    static var SignIn_details:String!
    static var SignIn_number:String!
    static var SignIn_Driver_price:String!
    static var PopUpErrorText:String!
    static var UpdateInterval = 50.0
    
    static var currentLocation:CLLocation!
    static var targetLocation:CLLocation!
    static var toLocation:CLLocation!
    static var fromLocation:CLLocation!
    static var DriverLocation:CLLocation!
    static var waitingForLoc:String = "None"
    static var lastScene:String = "None"
    static var lastDetailsScene:String!
    static var lastMapScene:String!
    
    static func ClearDB(){
        for timer in NavigationManager.TimerList{
            timer.invalidate()
        }
        AppData.token = nil
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: localKeys.smsSubmited)
        defaults.set(nil, forKey: localKeys.userType)
        defaults.set(nil, forKey: localKeys.token)
        defaults.set(nil, forKey: localKeys.isRegistered)
        
       

    }
    
}


class NavigationManager{
    
    static var TimerList:[Timer]=[]
    static var LocationTimer:Timer?

    static let sharedInstance = NavigationManager()
    
    static func MoveToScene(sceneId:String,View:UIViewController){
        if(NavigationManager.TimerList.count > 0){
            NavigationManager.StopTimers()
        }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: sceneId) as! UINavigationController
        View.present(nextViewController, animated:true, completion:nil)
    }
    
    static func MoveToDriverMain(View:UIViewController){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainDriverView") as! UITabBarController
        View.present(nextViewController, animated:true, completion:nil)
    }
    
    static func MoveToCustomerMain(View:UIViewController){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        View.present(nextViewController, animated:true, completion:nil)
    }
    
    static func ShowError(errorText:String,View:UIViewController){
        AppData.PopUpErrorText = errorText
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let PopView = storyBoard.instantiateViewController(withIdentifier: "DinamicPopUp") as! DinamicPopUp
        View.addChildViewController(PopView)
        PopView.view.frame = View.view.frame
        View.view.addSubview(PopView.view)
        PopView.didMove(toParentViewController: View)
    }
    
    static func StopTimers(){
        for timer in NavigationManager.TimerList{
            timer.invalidate()
        }
    }
    
    static func StopSendLoc(){
            NavigationManager.LocationTimer?.invalidate()
    }
    
    
}


struct localKeys {
    static let userType = "userType"
    static let token = "token"
    static let userName = "userName"
    static let isRegistered = "isRegistered"
    static let smsSubmited = "smsSubmited"
    static let sendStatus = "sendStatus"
    static let lastUpdate = "lastUpdate"

}
