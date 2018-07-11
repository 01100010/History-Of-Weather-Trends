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

    // MARK: Outlets

    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tMaxTextField: UITextField!
    @IBOutlet weak var tMinTextField: UITextField!
    @IBOutlet weak var daysAirFrostTextField: UITextField!
    @IBOutlet weak var rainfallTextField: UITextField!
    @IBOutlet weak var sunshineTextField: UITextField!

    // MARK: ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad - Detail")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewWillAppear - Detail")
        
        stationNameLabel.text = Settings.currentStation

        if let data = weatherInformation {
            setupSettingView(data)
        }
    }
    
    // MARK: Private Method
    
    private func setupSettingView(_ data: WeatherMeasurementsPerWeek) {
        dateLabel.text = "\(data.year), \(data.getMonthStringRepresentation)"
        
        if let maxT = data.meanMaxTemperature {
            tMaxTextField.text = data.getTemperatureValue(by: Settings.temperatureScale, value: maxT)
        }
        
        if let minT = data.meanMinTemperature {
            tMinTextField.text = data.getTemperatureValue(by: Settings.temperatureScale, value: minT)
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
