//
//  NetworkResolver.swift
//  Magnet
//
//  Created by Francisco Jordano on 20/10/2016.
//

import Foundation
import Alamofire
import SwiftyJSON

//
// In charge of fetching the urls associated to the latitude and longitude
// passed.
//
public class NetworkResolver {
  static let API_END_POINT: String = "https://tengam.org/content/v1/search/beacons/"
  static let RADIUS: Int = 100

  static func getItemsForLocation(lat: Double, lon: Double, callback: (Array<JSON> -> Void)!) {
    let url: String = "\(API_END_POINT)\(lat),\(lon),\(RADIUS)"
    NSLog("Performing geo search request: \(url)")

    Alamofire.request(.GET, url).responseJSON { response in
      let empty: Array<JSON> = Array<JSON>()
      guard response.result.isSuccess else {
        callback(empty)
        return
      }

      if let json: JSON = JSON(response.result.value!) {
        debugPrint("JSON: \(json)")
        callback(filterJSON(json))
      } else {
        callback(empty)
      }
    }
  }

  private static func filterJSON(json: JSON) -> Array<JSON> {
    var result: Array<JSON> = Array()
    for item in json.arrayValue {
      let shortUrl = item["short_url"].string!
      let latPath: [JSONSubscriptType] = ["location", "latitude"]
      let longPath: [JSONSubscriptType] = ["location", "longitude"]
      result.append(JSON([
        "url": shortUrl,
        "channel_id": item["channel_id"].string!,
        "latitude": item[latPath].number!,
        "longitude": item[longPath].number!
      ]))
    }

    return result
  }

}
