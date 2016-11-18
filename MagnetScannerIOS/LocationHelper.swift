//
//  LocationHelper.swift
//  MagnetScannerIOS
//
//  Created by Francisco Jordano on 09/11/2016.
//  Copyright © 2016 Mozilla. All rights reserved.
//

import Foundation
import CoreLocation

public class LocationHelper: NSObject, CLLocationManagerDelegate {
    let locationManager:CLLocationManager = CLLocationManager()
    var callback: ((CLLocation) -> Void)?
    var lastValidLocation: CLLocation?
    
    public override init() {
        super.init()
    }
    
    @objc public func stop() {
        self.locationManager.stopUpdatingLocation()
        NSObject.cancelPreviousPerformRequestsWithTarget(self)
    }
    
    @objc public func start(callback: (CLLocation) -> Void) {
        self.callback = callback
        self.lastValidLocation = nil
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.distanceFilter = 10
        self.locationManager.headingFilter = 5
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count > 0 else {
            return
        }
        
        guard let location: CLLocation = locations.last else {
            return
        }
        
        guard location.horizontalAccuracy >= 0 else {
            return
        }
        
        guard lastValidLocation == nil || lastValidLocation!.horizontalAccuracy > location.horizontalAccuracy else {
            return
        }
        
        lastValidLocation = location
        
        guard location.horizontalAccuracy <= self.locationManager.desiredAccuracy else {
            NSLog("Discarding location \(location) because accuracy \(location.horizontalAccuracy) is \(self.locationManager.desiredAccuracy)")
            return;
        }
        
        stop()
        
        self.callback!(location)
    }
}

