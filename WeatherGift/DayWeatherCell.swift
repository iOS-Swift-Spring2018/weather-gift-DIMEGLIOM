//
//  DayWeatherCell.swift
//  WeatherGift
//
//  Created by Mark on 4/2/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import UIKit

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MM dd, y"
    print("%% DateFormatter created in detail VC")
    return dateFormatter
    
}()


class DayWeatherCell: UITableViewCell {
    
    
    @IBOutlet var dayCellIcon: UIImageView!
    @IBOutlet var dayCellWeekday: UILabel!
    @IBOutlet var dayCellSummary: UITextView!
    @IBOutlet var dayCellMinTemp: UILabel!
    @IBOutlet var dayCellMaxTemp: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func update(with dailyForecast: WeatherLocation.DailyForecast, timeZone: String) {
        
        dayCellIcon.image = UIImage(named: dailyForecast.dailyIcon)
        dayCellSummary.text = dailyForecast.dailySummary
        dayCellMaxTemp.text = String(format: "%2.f", dailyForecast.dailyMaxTemp)
        dayCellMinTemp.text = String(format: "%2.f", dailyForecast.dailyMinTemp)
        
     //   let usableDate = Date(timeIntervalSince1970: dailyForecast.dailyDate)
//        var dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEE, MMM, dd, y"
    //    dateFormatter.timeZone = TimeZone(identifier : timeZone)
        let dateString = dailyForecast.dailyDate.format(timeZone: timeZone, dateFormatter: dateFormatter)
        dayCellWeekday.text = dateString
        
    }
    
}
