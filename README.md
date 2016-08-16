# magnet-scanner-ios
[![License](https://img.shields.io/badge/license-MPL2-blue.svg)](https://raw.githubusercontent.com/fxbox/foxbox/master/LICENSE)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

This is an iOS library that you can use in your projects to discover physical web objects around you.

Currently discovers urls based on the following protocols:

* Bluetooth Low Energy: Discovering both Eddystone and UriBeacon beacons.
* mDNS: urls advertised via this protocol.

# Usage
```swift
import Foundation
import MagnetScannerIOS

@objc(MagnetScannerClient)
class MagnetScannerClient: NSObject {
  var scanner: MagnetScanner!;
  
  override init() {
    super.init();
    scanner = MagnetScanner(callback: onItemFound);
  }
  
  @objc func start() -> Void {
    scanner.start();
  }
  
  func onItemFound(item: Dictionary<String, AnyObject>) {
    NSLog("ITEM FOUND");
    scanner.stop();
  }
}
```
# Installation
## Carthage
[Carthage][] is a simple, decentralized dependency manager for Cocoa. To
install `magnet-scanner-ios` with Carthage:

 1. Make sure Carthage is [installed][Carthage Installation].

 2. Update your Cartfile to include the following:

    ```
    github "mozilla-magnet/magnet-scanner-ios" ~> 0.1.0
    ```

 3. Run `carthage update` and [add the appropriate framework][Carthage Usage].

[Carthage]: https://github.com/Carthage/Carthage
[Carthage Installation]: https://github.com/Carthage/Carthage#installing-carthage
[Carthage Usage]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application
