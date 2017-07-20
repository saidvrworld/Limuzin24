//
//  Agreement.swift
//  Track24
//
//  Created by Khusan Saidvaliev on 06.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation


import UIKit

class Agreement: UIViewController {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BackToSignIn(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if(AppData.userType==1){
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignInCustomer") as! SignInCustomer
            self.present(nextViewController, animated:true, completion:nil)
        }
        else{
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignInDriver") as! SignInDriver
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
}
