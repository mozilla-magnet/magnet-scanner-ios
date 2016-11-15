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
  var locationResolver: OneShotLocation = OneShotLocation()
  var callback: ((Dictionary<String, AnyObject>) -> Void)!
  
  init(callback: (Dictionary<String, AnyObject>) -> Void) {
    super.init()
    self.callback = callback
  }
  
  func start() {
    self.locationResolver.start { (location) in
      let lat: CLLocationDegrees = location.coordinate.latitude
      let lon: CLLocationDegrees = location.coordinate.longitude
    
      NSLog("Got location update \(lat),\(lon)")
    
      // Here is where we call to the magnet service and then update the callback
      NetworkResolver.resolveLocation(lat, lon: lon, callback: {(result: Array<JSON>) in
          result.forEach({ (json) in
              let url = json["url"].string
              let channel = json["channel_id"].string
              let magnetItem: Dictionary<String, AnyObject> = ["url": url!, "channel_id": channel!]
              NSLog("MagnetScanner :: Found item \(magnetItem)")
              self.callback(magnetItem)
          })
      })
    }
  }
  
  func stop() {
    self.locationResolver.stop()
  }
  
}
