//
//  TargetLocationOnMap.swift
//  Limuzin
//
//  Created by Khusan Saidvaliev on 11.06.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation

import Foundation
import MapKit
import CoreLocation

class TargetLocationOnMap: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var curLocation: CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
    }
    
    
    
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    var locationManager = CLLocationManager()
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
            
        }
        do{
            AppData.currentLocation = try Loc2DToLoc(loc: (locationManager.location?.coordinate)!)
        }
        catch{
            AppData.currentLocation = CLLocation.init(latitude:
                41.311144, longitude: 69.279905)
        }
        
        centerMapOnLocation(location: AppData.currentLocation)
        
    }
    
    func getCenterCoordinates() {
        _ = mapView.centerCoordinate
    }
    
    
    func LoadCars(){
        
        var initialLocation = AppData.currentLocation
        if(AppData.DriverLocation != nil){
            
            let car = CarOnTargetMap(locationName: "Ваш водитель", coordinate:  AppData.DriverLocation.coordinate)
            mapView.addAnnotation(car)
        }
       
    }
    
    func LoadTargetLocation(){
        
        if(AppData.targetLocation != nil){
            let target = MyPlacement(locationName: "Yunus", coordinate: AppData.targetLocation.coordinate)
            mapView.addAnnotation(target)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
        LoadTargetLocation()
        LoadCars()

    }
    
    @IBAction func BackToMainView(_ sender: Any) {
          NavigationManager.MoveToScene(sceneId: AppData.lastMapScene, View: self)
    }
    
    
    func Loc2DToLoc(loc:CLLocationCoordinate2D)->CLLocation{
        let getLat: CLLocationDegrees = loc.latitude
        let getLon: CLLocationDegrees = loc.longitude
        let newLoc: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)
        return newLoc
    }
    
    
    
    
}
