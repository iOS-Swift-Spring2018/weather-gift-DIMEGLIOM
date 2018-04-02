//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by Mark on 4/1/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class WeatherLocation {
    
    var name = ""
    var coordinates = ""
    var currentTemperature = "--"
    var currentSummary = ""
    
    
    func getWeather(completed: @escaping () -> ()) {
        
        let weatherURL = urlBase + urlAPIKey + coordinates + "/"
        print(weatherURL)
        
        Alamofire.request(weatherURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let temperature = json["currently"]["temperature"].double {
                    
                    print("***** TEMP inside getWeather = \(temperature)")
                    let roundedTemp = String(format: "%3.f", temperature)
                    self.currentTemperature = roundedTemp + "°"
                    
                } else {
                    
                    print("** could not return temperature")
                    
                }
                
                if let summary = json["daily"]["summary"].string {
                    
                    self.currentSummary = summary
                    
                } else {
                    print("*** could not return temp")
                    
                }
                
                
            case.failure(let error):
                print(error)
            }
            
            completed()
        }
        
    }
    
    
}
