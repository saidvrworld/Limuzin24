//
//  CarCategoryView.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 25.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit


class CarCategory: UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func GoToLightWeight(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LighCarCategory") as! LighCarCategory
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func GoToMediumWeight(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MiddleWeightCategory") as! MiddleWeightCategory
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @IBAction func GoToHeavyWeight(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HeavyWeightCategory") as! HeavyWeightCategory
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @IBAction func GoToSpecialCars(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LighCarCategory") as! LighCarCategory
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @IBAction func GoBack(_ sender: Any) {
        Back()
        
    }
    
   private func Back(){
        if(AppData.userType == 1){
            if (AppData.lastScene == "AddPublication"){
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddPublication") as! AddPublication
                self.present(nextViewController, animated:true, completion:nil)
            }
            else if (AppData.lastScene == "CarFilter"){
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CarFilter") as! CarFilter
                self.present(nextViewController, animated:true, completion:nil)
            }
        }
        else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignInDriver") as! SignInDriver
            self.present(nextViewController, animated:true, completion:nil)
            
            
        }
    }

    
}

class LighCarCategory: UIViewController {
    
    
    @IBOutlet weak var ChooseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func GoToLabo(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LaboCarCategory") as! LaboCarCategory
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @IBAction func PressChosseButton(_ sender: Any) {
        if(AppData.userType == 1){
            if (AppData.lastScene == "AddPublication"){
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddPublication") as! AddPublication
                self.present(nextViewController, animated:true, completion:nil)
            }
            else if (AppData.lastScene == "CarFilter"){
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CarFilter") as! CarFilter
                self.present(nextViewController, animated:true, completion:nil)
            }
        }
        else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignInDriver") as! SignInDriver
            self.present(nextViewController, animated:true, completion:nil)
            
            
        }

        
    }
    
    @IBAction func ChooseDamas(_ sender: UIButton) {
        AppData.carType = "Damas"
        sender.backgroundColor = UIColor.lightGray
        ChooseButton.isHidden = false
        
    }
    
 
    
    @IBAction func GoBack(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CarCategory") as! CarCategory
        self.present(nextViewController, animated:true, completion:nil)
    }

}


class LaboCarCategory: UIViewController {
    
    @IBOutlet weak var ChooseButton: UIButton!

    
    var LastButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func ChooseWedding(_ sender: UIButton) {
        if(LastButton != nil){
            LastButton.backgroundColor = UIColor.clear
        }
        AppData.carType = "Damas"
        sender.backgroundColor = UIColor.lightGray
        ChooseButton.isHidden = false
        LastButton = sender
        
    }
    
    @IBAction func ChooseTent(_ sender: UIButton) {
        if(LastButton != nil){
            LastButton.backgroundColor = UIColor.clear
        }
        AppData.carType = "Damas"
        sender.backgroundColor = UIColor.lightGray
        ChooseButton.isHidden = false
        LastButton = sender
        
    }
    
    @IBAction func ChooseFreeze(_ sender: UIButton) {
        if(LastButton != nil){
            LastButton.backgroundColor = UIColor.clear
        }
        AppData.carType = "Damas"
        sender.backgroundColor = UIColor.lightGray
        ChooseButton.isHidden = false
        LastButton = sender
        
    }
    
    @IBAction func ChooseBort(_ sender: UIButton) {
        if(LastButton != nil){
            LastButton.backgroundColor = UIColor.clear
        }
        AppData.carType = "Damas"
        sender.backgroundColor = UIColor.lightGray
        ChooseButton.isHidden = false
        LastButton = sender
        
    }
    
    @IBAction func ChooseProm(_ sender: UIButton) {
        if(LastButton != nil){
            LastButton.backgroundColor = UIColor.clear
        }
        AppData.carType = "Damas"
        sender.backgroundColor = UIColor.lightGray
        ChooseButton.isHidden = false
        LastButton = sender
        
    }
    
   
    
    
    @IBAction func GoBack(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LighCarCategory") as! LighCarCategory
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func PressChosseButton(_ sender: Any) {
        if(AppData.userType == 1){
            if (AppData.lastScene == "AddPublication"){
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddPublication") as! AddPublication
                self.present(nextViewController, animated:true, completion:nil)
            }
            else if (AppData.lastScene == "CarFilter"){
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CarFilter") as! CarFilter
                self.present(nextViewController, animated:true, completion:nil)
            }
        }
        else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignInDriver") as! SignInDriver
            self.present(nextViewController, animated:true, completion:nil)
            
            
        }
        
        
    }
    
}



class MiddleWeightCategory: UIViewController {
    
    @IBOutlet weak var ChooseButton: UIButton!
    
   
    
    var LastButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func ChooseWedding(_ sender: UIButton) {
        if(LastButton != nil){
            LastButton.backgroundColor = UIColor.clear
        }
        AppData.carType = "Damas"
        sender.backgroundColor = UIColor.lightGray
        ChooseButton.isHidden = false
        LastButton = sender
        
    }
    
    @IBAction func ChooseTent(_ sender: UIButton) {
        if(LastButton != nil){
            LastButton.backgroundColor = UIColor.clear
        }
        AppData.carType = "Damas"
        sender.backgroundColor = UIColor.lightGray
        ChooseButton.isHidden = false
        LastButton = sender
        
    }
    
    @IBAction func ChooseFreeze(_ sender: UIButton) {
        if(LastButton != nil){
            LastButton.backgroundColor = UIColor.clear
        }
        AppData.carType = "Damas"
        sender.backgroundColor = UIColor.lightGray
        ChooseButton.isHidden = false
        LastButton = sender
        
    }
    
    @IBAction func ChooseBort(_ sender: UIButton) {
        if(LastButton != nil){
            LastButton.backgroundColor = UIColor.clear
        }
        AppData.carType = "Damas"
        sender.backgroundColor = UIColor.lightGray
        ChooseButton.isHidden = false
        LastButton = sender
        
    }
    
    @IBAction func ChooseProm(_ sender: UIButton) {
        if(LastButton != nil){
            LastButton.backgroundColor = UIColor.clear
        }
        AppData.carType = "Damas"
        sender.backgroundColor = UIColor.lightGray
        ChooseButton.isHidden = false
        LastButton = sender
        
    }
    
    
    
    
    @IBAction func GoBack(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LighCarCategory") as! LighCarCategory
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func PressChosseButton(_ sender: Any) {
        if(AppData.userType == 1){
            if (AppData.lastScene == "AddPublication"){
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddPublication") as! AddPublication
                self.present(nextViewController, animated:true, completion:nil)
            }
            else if (AppData.lastScene == "CarFilter"){
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CarFilter") as! CarFilter
                self.present(nextViewController, animated:true, completion:nil)
            }
        }
        else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignInDriver") as! SignInDriver
            self.present(nextViewController, animated:true, completion:nil)
            
            
        }
        
        
    }
    
}



class HeavyWeightCategory: UIViewController {
    
    @IBOutlet weak var ChooseButton: UIButton!
    
    
    
    var LastButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func ChooseWedding(_ sender: UIButton) {
        if(LastButton != nil){
            LastButton.backgroundColor = UIColor.clear
        }
        AppData.carType = "Damas"
        sender.backgroundColor = UIColor.lightGray
        ChooseButton.isHidden = false
        LastButton = sender
        
    }
    
    @IBAction func ChooseTent(_ sender: UIButton) {
        if(LastButton != nil){
            LastButton.backgroundColor = UIColor.clear
        }
        AppData.carType = "Damas"
        sender.backgroundColor = UIColor.lightGray
        ChooseButton.isHidden = false
        LastButton = sender
        
    }
    
    @IBAction func ChooseFreeze(_ sender: UIButton) {
        if(LastButton != nil){
            LastButton.backgroundColor = UIColor.clear
        }
        AppData.carType = "Damas"
        sender.backgroundColor = UIColor.lightGray
        ChooseButton.isHidden = false
        LastButton = sender
        
    }
    
    @IBAction func ChooseBort(_ sender: UIButton) {
        if(LastButton != nil){
            LastButton.backgroundColor = UIColor.clear
        }
        AppData.carType = "Damas"
        sender.backgroundColor = UIColor.lightGray
        ChooseButton.isHidden = false
        LastButton = sender
        
    }
    
    @IBAction func ChooseProm(_ sender: UIButton) {
        if(LastButton != nil){
            LastButton.backgroundColor = UIColor.clear
        }
        AppData.carType = "Damas"
        sender.backgroundColor = UIColor.lightGray
        ChooseButton.isHidden = false
        LastButton = sender
        
    }
    
    
    
    
    @IBAction func GoBack(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LighCarCategory") as! LighCarCategory
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func PressChosseButton(_ sender: Any) {
        if(AppData.userType == 1){
            if (AppData.lastScene == "AddPublication"){
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddPublication") as! AddPublication
                self.present(nextViewController, animated:true, completion:nil)
            }
            else if (AppData.lastScene == "CarFilter"){
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CarFilter") as! CarFilter
                self.present(nextViewController, animated:true, completion:nil)
            }
        }
        else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignInDriver") as! SignInDriver
            self.present(nextViewController, animated:true, completion:nil)
            
            
        }
        
        
    }
    
}
