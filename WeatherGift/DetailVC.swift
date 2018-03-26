//
//  DetailVC.swift
//  WeatherGift
//
//  Created by Mark on 3/25/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var currentImage: UIImageView!
    
    var currentPage = 0
    var locationsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationLabel.text = locationsArray[currentPage]
        
    }

    
    


}
