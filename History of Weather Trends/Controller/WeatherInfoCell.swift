//
//  WeatherInfoCell.swift
//  History of Weather Trends
//
//  Created by Oleksii on 28.06.18.
//  Copyright © 2018 Oleksii. All rights reserved.
//

import UIKit

class WeatherInfoCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var monthIcon: UIImageView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!

    // MARK: Methods
    
    func setupWeatherInfoCell(data: WeatherMeasurementsPerWeek) {
        // default image
        monthIcon.image = UIImage(named: "MonthIcon")
        yearLabel.text = String(data.year)
        monthLabel.text = data.getMonthStringRepresentation
    }
}
