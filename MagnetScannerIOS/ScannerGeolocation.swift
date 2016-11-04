//
//  LocationServices.swift
//  Magnet
//
//  Created by Francisco Jordano on 17/10/2016.
//

import Foundation
import CoreLocation
import SwiftyJSON

class ScannerGeolocation: NSObject, CLLocationManagerDelegate, Scanner {
  let locationManager: CLLocationManager = CLLocationManager()
  var callback: ((Dictionary<String, AnyObject>) -> Void)!
  var initialized: Bool = false
  var lastLocation: CLLocation!
  let MIN_DISTANCE: Double = 10
  
  init(callback: (Dictionary<String, AnyObject>) -> Void) {
    super.init()
    self.callback = callback
  }
  
  func start() {
    lastLocation = nil
    startLocationManager()
  }
  
  func stop() {
    locationManager.stopUpdatingLocation()
  }
  
  func startLocationManager() -> Bool {
    guard CLLocationManager.locationServicesEnabled() else {
      return false;
    }
    
    guard initialized == false else {
      locationManager.startUpdatingLocation()
      return true
    }
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    
    locationManager.startUpdatingLocation()
    initialized  = true;
    
    return true;
  }
    
  private func isValidLocation(location: CLLocation) -> Bool {
    return lastLocation == nil || lastLocation!.distanceFromLocation(location) < MIN_DISTANCE
  }
  
  // Deletegate methods
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    stop()
    guard let location: CLLocation = locations.last else {
      return
    }
    
    guard isValidLocation(location) else {
      return
    }
    
    lastLocation = location
    
    let lat: CLLocationDegrees = location.coordinate.latitude
    let lon: CLLocationDegrees = location.coordinate.longitude
    
    debugPrint("Got location update \(lat),\(lon)")
    
    // Here is where we call to the magnet service and then update the callback
    NetworkResolver.resolveLocation(lat, lon: lon, callback: {(result: Array<JSON>) in
      result.forEach({ (json) in
        let url = json["url"].string
        let channel = json["channel"].string
        let magnetItem: Dictionary<String, AnyObject> = ["url": url!, "channel": channel!]
        self.callback(magnetItem)
      })
    })
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    debugPrint("Got error during location \(error)")
    stop()
  }
}
