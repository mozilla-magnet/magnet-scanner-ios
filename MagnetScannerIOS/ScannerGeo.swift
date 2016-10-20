//
//  LocationServices.swift
//  Magnet
//
//  Created by Francisco Jordano on 17/10/2016.
//

import Foundation
import CoreLocation
import SwiftyJSON

class ScannerGeo: NSObject, CLLocationManagerDelegate, Scanner {
  let lManager: CLLocationManager = CLLocationManager()
  var callback: ((Dictionary<String, AnyObject>) -> Void)!
  var initialized: Bool = false;
  
  init(callback: (Dictionary<String, AnyObject>) -> Void) {
    super.init()
    self.callback = callback
  }
  
  func start() {
    startLocationManager()
  }
  
  func stop() {
    lManager.stopUpdatingLocation()
  }
  
  func startLocationManager() -> Bool {
    guard CLLocationManager.locationServicesEnabled() else {
      return false;
    }
    
    guard initialized == false else {
      lManager.startUpdatingLocation()
      return true
    }
    
    lManager.delegate = self
    lManager.desiredAccuracy = kCLLocationAccuracyBest
    lManager.requestWhenInUseAuthorization()
    
    lManager.startUpdatingLocation()
    initialized  = true;
    
    return true;
  }
  
  // Deletegate methods
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    stop()
    guard let location: CLLocation = locations.first else {
      return
    }
    
    let lat: CLLocationDegrees = location.coordinate.latitude
    let lon: CLLocationDegrees = location.coordinate.longitude
    
    debugPrint("Got location update \(lat),\(lon)")
    
    // Here is where we call to the magnet service and then update the callback
    NetworkResolver.resolveLocation(lat, lon: lon, callback: {(result: Array<JSON>) in
      result.forEach({ (json) in
        let url = json["url"].string
        let magnetItem: Dictionary<String, AnyObject> = ["url": url!]
        self.callback(magnetItem)
      })
    })
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    debugPrint("Got error during location \(error)")
    stop()
  }
}
