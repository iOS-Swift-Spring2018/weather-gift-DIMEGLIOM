//
//  DetailVC.swift
//  WeatherGift
//
//  Created by Mark on 3/14/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import UIKit
import CoreLocation

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
   dateFormatter.dateFormat = "EEEE, MM dd, y"
    print("%% DateFormatter created in detail VC")
    return dateFormatter

}()

class DetailVC: UIViewController {
    
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var currentImage: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

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
        
        let location = locationsArray[currentPage]
        locationLabel.text = location.name
        let dateString = location.currentTime.format(timeZone: location.timeZone, dateFormatter: dateFormatter)
        temperatureLabel.text = location.currentTemperature
        summaryLabel.text = location.currentSummary
        currentImage.image = UIImage(named: location.currentIcon)
        tableView.reloadData()
        
    }
    
    func formatTimeForTimeZone(unixDate: TimeInterval, timeZone: String) -> String {
        
        let usableDate = Date(timeIntervalSince1970: unixDate)
//        var dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEE, MMM, dd, y"
        dateFormatter.timeZone = TimeZone(identifier : timeZone)
        let dateString = dateFormatter.string(from: usableDate)
        
       return dateString
   
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


extension DetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsArray[currentPage].dailyForecastArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayWeatherCell", for: indexPath) as! DayWeatherCell
       let dailyForecast =  locationsArray[currentPage].dailyForecastArray[indexPath.row]
        let timeZone = locationsArray[currentPage].timeZone
        
        
        cell.update(with: dailyForecast, timeZone: timeZone)
        
    return cell
    
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}



