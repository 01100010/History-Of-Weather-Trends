//
//  WeatherMeasurementsPerWeek.swift
//  History of Weather Trends
//
//  Created by Oleksii on 27.06.18.
//  Copyright © 2018 Oleksii. All rights reserved.
//

import Foundation

enum Month: Int {
    case january = 1, february, march, april, may, june, july, august, september, october, november, december
}

enum TemperatureScale: Int {
    case celsius
    case fahrenheit
    case kelvin
}

struct WeatherMeasurementsPerWeek {

    // MARK: Stored Properties
    
    var year = 0
    var month = Month.january

    var meanMaxTemperature: Double?
    var meanMinTemperature: Double?
    var daysOfAirFrost: Int?
    var totalRainfall: Double?
    var totalSunshineDuration: Double?

    // MARK: Computed Properties
    
    var getFullDate: String {
        return String(year) + " " + getMonthStringRepresentation
    }
    
    var getMonthStringRepresentation: String {
        return String(describing: month).capitalizingFirstLetter()
    }

    // MARK: Initializers

    // default memberwise init
    
    // MARK: Methods
    
    func getTemperatureValue(by scale: TemperatureScale, value temperature: Double) -> String {
        switch scale {
        case .celsius: return String(temperature)
        case .fahrenheit: return String(temperature * 9 / 5 + 32)
        case .kelvin: return String(temperature + 273.15)
        }
    }
}
