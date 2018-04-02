//
//  DetailVC.swift
//  WeatherGift
//
//  Created by Mark on 3/25/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import UIKit
import CoreLocation

class DetailVC: UIViewController {
    
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var currentImage: UIImageView!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if currentPage != 0 {
            self.locationsArray[currentPage].getWeather {
                self.updateUserInterface()
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if currentPage == 0 {
            
            getLocation()
            
        }
    }
    
    func updateUserInterface() {
        
        locationLabel.text = locationsArray[currentPage].name
        dateLabel.text = locationsArray[currentPage].coordinates
        temperatureLabel.text = locationsArray[currentPage].currentTemperature
        summaryLabel.text = locationsArray[currentPage].currentSummary
        
        
    }

}

extension DetailVC: CLLocationManagerDelegate {
    
    func getLocation() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        
    }
    
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied:
            print("sorry buddy")
        case .restricted:
            print("Access is denied. Sorry")
        
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        handleLocationAuthorizationStatus(status: status)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let geoCoder = CLGeocoder()
        var place = ""
        
        currentLocation = locations.last
        let currentLatitude = currentLocation.coordinate.latitude
        let currentLongitude = currentLocation.coordinate.longitude
        let currentCoordinates = "\(currentLatitude),\(currentLongitude)"
        print(currentCoordinates)
        dateLabel.text = currentCoordinates
        
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) in
            if placemarks != nil {
                
                let placemark = placemarks?.last
                place = (placemark?.name)!
                
            } else {
                
                print("Error getting place. Error: \(error!)")
                place = "Unknown"
            }
            
            print(place)
            
            self.locationsArray[0].name = place
            self.locationsArray[0].coordinates = currentCoordinates
            self.locationsArray[0].getWeather() {
                self.updateUserInterface()
                }
            })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location")
    }
    
    
}
