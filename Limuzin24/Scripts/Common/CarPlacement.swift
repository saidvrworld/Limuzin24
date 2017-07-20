//
//  CarPlacement.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 08.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import AddressBook



class CarPlacement: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var carId:Int!
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String,id:Int) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.carId = id
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
}


class MyPlacement: NSObject, MKAnnotation {
    
    let locationName: String
    let coordinate: CLLocationCoordinate2D


    init(locationName: String, coordinate: CLLocationCoordinate2D) {
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    private var subTitle: String {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subTitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = locationName
        
        return mapItem
    }
    
}

class CarOnTargetMap: NSObject, MKAnnotation {
    
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    
    init(locationName: String, coordinate: CLLocationCoordinate2D) {
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    private var subTitle: String {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subTitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = locationName
        
        return mapItem
    }
    
}


class APlacement: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.title = title
        
        super.init()
    }
    
    var subTitle: String {
        return subtitle!
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subTitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
}


class BPlacement: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.title = title
        
        super.init()
    }
    
    var subTitle: String {
        return subtitle!
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subTitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
}

class Placement: NSObject, MKAnnotation {
    
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    
    init(locationName: String, coordinate: CLLocationCoordinate2D) {
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    private var subTitle: String {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subTitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = locationName
        
        return mapItem
    }
    
}


class CarAnnotationView: MKAnnotationView {
    // Required for MKAnnotationView
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
   
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let attractionAnnotation = self.annotation as! CarPlacement
        
        image = UIImage(named: "location_black.png")
    
        
    }
}
