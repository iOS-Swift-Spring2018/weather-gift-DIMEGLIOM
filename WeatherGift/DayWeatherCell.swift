//
//  DayWeatherCell.swift
//  WeatherGift
//
//  Created by Mark on 4/2/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import UIKit

class DayWeatherCell: UITableViewCell {
    
    
    @IBOutlet var dayCellIcon: UIImageView!
    @IBOutlet var dayCellWeekday: UILabel!
    @IBOutlet var dayCellSummary: UITextView!
    @IBOutlet var dayCellMinTemp: UILabel!
    @IBOutlet var dayCellMaxTemp: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func update(with dailyForecast: WeatherLocation.DailyForecast) {
        
        dayCellIcon.image = UIImage(named: dailyForecast.dailyIcon)
        dayCellSummary.text = dailyForecast.dailySummary
        dayCellMaxTemp.text = String(format: "%2.f", dailyForecast.dailyMaxTemp)
        dayCellMinTemp.text = String(format: "%2.f", dailyForecast.dailyMinTemp)
        dayCellWeekday.text = ""
        
    }
    
}
