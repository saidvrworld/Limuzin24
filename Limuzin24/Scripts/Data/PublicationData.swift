//
//  PublicationData.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 08.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class PublicationData{
    
    
    func getAddress(location: CLLocation,textView:UILabel){
        var fullAddress:String = " "
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                print(locationName)
                fullAddress = locationName as! String
                textView.text = fullAddress

            }
            
        })

    }
    
    



}
