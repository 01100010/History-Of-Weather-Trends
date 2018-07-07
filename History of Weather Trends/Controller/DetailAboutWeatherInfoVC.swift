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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        stationNameLabel.text = station

        if let validWeatherInfo = weatherInformation {

            yearLabel.text = String(validWeatherInfo.year) + ", " + validWeatherInfo.getMonthStringRepresentation

            if let meanMaxTemperature = validWeatherInfo.meanMaxTemperature {
                tMaxTextField.text = validWeatherInfo.getTemperatureValue(by: temperatureScale, value: meanMaxTemperature)
            } else {
                tMaxTextField.text = "---"
            }

            if let meanMinTemperature = validWeatherInfo.meanMinTemperature {
                tMinTextField.text = validWeatherInfo.getTemperatureValue(by: temperatureScale, value: meanMinTemperature)
            } else {
                tMinTextField.text = "---"
            }

            if let validAFValue = validWeatherInfo.daysOfAirFrost {
                daysAirFrostTextField.text = String(validAFValue)
            } else {
                daysAirFrostTextField.text = "---"
            }

            if let validRainfallValue = validWeatherInfo.totalRainfall {
                rainfallTextField.text = String(validRainfallValue)
            } else {
                rainfallTextField.text = "---"
            }

            if let validSunshineValue = validWeatherInfo.totalSunshineDuration {
                sunshineTextField.text = String(validSunshineValue)
            } else {
                sunshineTextField.text = "---"
            }

        }
    }
}
