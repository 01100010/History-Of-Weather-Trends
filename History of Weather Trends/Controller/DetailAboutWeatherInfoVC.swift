//
//  DetailAboutWeatherInfoVC.swift
//  History of Weather Trends
//
//  Created by Oleksii on 29.06.18.
//  Copyright © 2018 Oleksii. All rights reserved.
//

import UIKit

class DetailAboutWeatherInfoVC: UIViewController {

    // MARK: Properties

    var weatherInformation: WeatherMeasurementsPerWeek?
    var temperatureScale = TemperatureScale.celsius
    var station = ""

    // MARK: Outlets

    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var tMaxTextField: UITextField!
    @IBOutlet weak var tMinTextField: UITextField!
    @IBOutlet weak var daysAirFrostTextField: UITextField!
    @IBOutlet weak var rainfallTextField: UITextField!
    @IBOutlet weak var sunshineTextField: UITextField!

    // MARK: ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        stationNameLabel.text = station

        if let data = weatherInformation {

            yearLabel.text = "\(data.year), \(data.getMonthStringRepresentation)"

            if let maxT = data.meanMaxTemperature {
                tMaxTextField.text = data.getTemperatureValue(by: temperatureScale, value: maxT)
            }

            if let minT = data.meanMinTemperature {
                tMinTextField.text = data.getTemperatureValue(by: temperatureScale, value: minT)
            }

            if let af = data.daysOfAirFrost {
                daysAirFrostTextField.text = String(af)
            }

            if let rain = data.totalRainfall {
                rainfallTextField.text = String(rain)
            }

            if let sun = data.totalSunshineDuration {
                sunshineTextField.text = String(sun)
            }
        }
    }
}
