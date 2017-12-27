//
//  ViewController.swift
//  GoogleMap
//
//  Created by Dinesh Sunder on 12/12/17.
//  Copyright © 2017 Dinesh Sunder. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController {

    @IBOutlet weak var google_mapView: GMSMapView!
  
    
    var locationManager:CLLocationManager!
    var current_place=[String]()
    var chennai=[String]()
    var mumbai=[String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingLocationManager()
        self.title="Map View"
      
        if locationManager.location?.coordinate != nil{
            DispatchQueue.main.async {
               self.loadingMap()
            }
        }
      
    }
    func loadingLocationManager() -> Void {
        
        locationManager=CLLocationManager()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    func loadingMap(){
      let camera=GMSCameraPosition(target: (locationManager.location?.coordinate)!, zoom: 5, bearing: 10, viewingAngle: 10)
      self.google_mapView.camera=camera
      
      let location  = CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)! , longitude: (self.locationManager.location?.coordinate.longitude)!)
      
      self.getAddressFromGeocodeCoordinate(coordinate: location, color: UIColor.green)
      self.getAddressFromGeocodeCoordinate(coordinate: CLLocationCoordinate2D(latitude: 12.9941, longitude: 80.1709), color: UIColor.red)
      self.getAddressFromGeocodeCoordinate(coordinate: CLLocationCoordinate2D(latitude: 19.0896, longitude: 72.8656), color: UIColor.blue)
      loadingStrokeLine(latitude:12.9941,longitude:80.1709,color: UIColor.blue)
      loadingStrokeLine(latitude:19.0896,longitude:72.8656,color:UIColor.black)
        
    }
  func addingMarker(latitude:CLLocationDegrees,longitude:CLLocationDegrees,snippet:[String],color:UIColor){
      let marker:GMSMarker=GMSMarker(position:CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
      marker.snippet=snippet.joined(separator: ",")
    
    marker.isTappable=true
    marker.icon = GMSMarker.markerImage(with: color)
    marker.map=google_mapView
   }
    
  func loadingStrokeLine(latitude:CLLocationDegrees,longitude:CLLocationDegrees,color:UIColor){
       
        let path = GMSMutablePath()
        path.addLatitude((self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
        path.addLatitude(latitude, longitude: longitude)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.strokeColor=color
        polyline.geodesic = true
        polyline.map = google_mapView
        self.google_mapView.animate(toLocation: CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude:(self.locationManager.location?.coordinate.longitude)!))
    }
  // current location name from coordinates
  func getAddressFromGeocodeCoordinate(coordinate: CLLocationCoordinate2D,color:UIColor){
    let geocoder = GMSGeocoder()
    geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
      if let address = response!.firstResult() {
        let lines = address.lines! as [String]
        self.current_place = lines
        self.addingMarker(latitude: coordinate.latitude, longitude: coordinate.longitude, snippet: lines, color: color)
      }
    }
    
  }
  
  
  
   

}

