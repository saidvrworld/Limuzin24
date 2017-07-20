//
//  SetCoordinates.swift
//  Truck24
//
//  Created by Khusan Saidvaliev on 08.04.17.
//  Copyright © 2017 Khusan Saidvaliev. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class SetCoordinates: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var curLocation: CLLocation!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 0.5
        self.mapView.addGestureRecognizer(longPressGesture)
        
        mapView.delegate = self 

    }
    
    
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    var locationManager = CLLocationManager()
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestAlwaysAuthorization()
            
        }
        getCurrentLocation()
    }
    
    func getCenterCoordinates() {
        let center = mapView.centerCoordinate
    }
    
    func getCurrentLocation(){
        let centre = locationManager.location?.coordinate
        
        if(centre != nil){
            centerMapOnLocation(location: Loc2DToLoc(loc: centre!))
        if(AppData.waitingForLoc == "NearList"){
            AppData.currentLocation = Loc2DToLoc(loc: centre!)
        }
        else if(AppData.waitingForLoc == "TargetLocation" || AppData.waitingForLoc == "TargetLocationForDriver"){
            AppData.targetLocation = Loc2DToLoc(loc: centre!)
        }
        
        let annotation = MyPlacement(locationName: "Yunus", coordinate: centre!)
        self.mapView.addAnnotation(annotation)

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    @IBAction func BackToSignIn(_ sender: Any) {
        
        if(AppData.waitingForLoc == "CarFilter"){
            if(AppData.currentLocation == nil){
                NavigationManager.ShowError(errorText: "Вы не выбрали местоположение!",View: self)
            }else{
                NavigationManager.MoveToScene(sceneId: "CarFilter", View: self)
            }
        }
        else if(AppData.waitingForLoc == "TargetLocation"){
            if(AppData.targetLocation == nil){
                NavigationManager.ShowError(errorText: "Вы не выбрали местоположение!",View: self)
            }else{
                NavigationManager.MoveToScene(sceneId: "AddPublication", View: self)

            }
        }
        else if(AppData.waitingForLoc == "TargetLocationForDriver"){
            if(AppData.targetLocation == nil){
                NavigationManager.ShowError(errorText: "Вы не выбрали местоположение!",View: self)
            }else{
                NavigationManager.MoveToScene(sceneId: "AddOrderForDriver", View: self)
                
            }
        }
       
    }
    
    func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .ended {
            let point = gesture.location(in: self.mapView)
            let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            
            if(AppData.waitingForLoc == "CarFilter"){
                AppData.currentLocation = Loc2DToLoc(loc: coordinate)
            }
            else if(AppData.waitingForLoc == "TargetLocation" || AppData.waitingForLoc == "TargetLocationForDriver"){
                AppData.targetLocation = Loc2DToLoc(loc: coordinate)
            }
            
            let annotation = MyPlacement(locationName: "Yunus", coordinate: coordinate)
            
            self.mapView.annotations.forEach {
                if !($0 is MKUserLocation) {
                    self.mapView.removeAnnotation($0)
                }
            }
            self.mapView.addAnnotation(annotation)
        }
    }
    
    
    func Loc2DToLoc(loc:CLLocationCoordinate2D)->CLLocation{
        let getLat: CLLocationDegrees = loc.latitude
        let getLon: CLLocationDegrees = loc.longitude
        let newLoc: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)
        return newLoc
    }
    
    
    

   
}

