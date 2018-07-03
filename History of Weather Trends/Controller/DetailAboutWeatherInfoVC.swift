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
    var stationName = ""
    var temperatureScale = TemperatureScale.Celsius
    
    // MARK: Outlets
    
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var tMaxTextField: UITextField!
    @IBOutlet weak var tMinTextField: UITextField!
    @IBOutlet weak var DaysAFTextField: UITextField!
    @IBOutlet weak var RainfallTextField: UITextField!
    @IBOutlet weak var SunshineTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        stationNameLabel.text = stationName
        
        if let validWeatherInfo = weatherInformation {
            
            yearLabel.text = String(validWeatherInfo._year) + ", " + validWeatherInfo.GetMonthStringRepresentation()
            
            if let validMaxTempValue = validWeatherInfo._meanMaxTemperature {
                tMaxTextField.text = SetTemperatureInRightScale(validMaxTempValue)
            } else {
                tMaxTextField.text = "---"
            }
            
            if let validMinTempValue = validWeatherInfo._meanMinTemperature {
                tMinTextField.text = SetTemperatureInRightScale(validMinTempValue)
            } else {
                tMinTextField.text = "---"
            }
            
            if let validAFValue = validWeatherInfo._daysOfAirFrost {
                DaysAFTextField.text = String(validAFValue)
            } else {
                DaysAFTextField.text = "---"
            }
            
            if let validRainfallValue = validWeatherInfo._totalRainfall {
                RainfallTextField.text = String(validRainfallValue)
            } else {
                RainfallTextField.text = "---"
            }
            
            if let validSunshineValue = validWeatherInfo._totalSunshineDuration {
                SunshineTextField.text = String(validSunshineValue)
            } else {
                SunshineTextField.text = "---"
            }
            
        }
    }
    
    // MARK: Private Method
    private func SetTemperatureInRightScale(_ temperature: Double) -> String {
        
        switch temperatureScale {
        case .Celsius: return String(temperature)
        case .Fahrenheit: return String(temperature * 9 / 5 + 32)
        case .Kelvin: return String(temperature + 273.15)
    
        default:
            return String(temperature)
        }
        
    }

}
