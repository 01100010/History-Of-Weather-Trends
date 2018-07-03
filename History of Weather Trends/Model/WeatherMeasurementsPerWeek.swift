//
//  WeatherMeasurementsPerWeek.swift
//  History of Weather Trends
//
//  Created by Oleksii on 27.06.18.
//  Copyright © 2018 Oleksii. All rights reserved.
//

import Foundation

enum Month: String {
    case January
    case February
    case March
    case April
    case May
    case June
    case July
    case August
    case September
    case October
    case November
    case December
}

enum TemperatureScale: Int {
    case Celsius = 0
    case Fahrenheit
    case Kelvin
}

class WeatherMeasurementsPerWeek {
    
    //MARK: Properties
    var _year: Int = -1
    var _month: Int = -1
    
    var _meanMaxTemperature: Double?
    var _meanMinTemperature: Double?
    var _daysOfAirFrost: Int?
    var _totalRainfall: Double?
    var _totalSunshineDuration: Double?
    
    var FullDate: String {
        get {
            return String(_year) + " " + GetMonthStringRepresentation()
        }
    }
    
    //MARK: Initializers
    init(year: Int, month:Int) {
        self._year = year
        self._month = month
    }
    
    init(year: Int, month:Int, meanMaxTemperature: Double?, meanMinTemperature: Double?, daysOfAirFrost: Int?, totalRainfall: Double?, totalSunshineDuration: Double?) {
        // set date
        self._year = year
        self._month = month
        
        // set optional weather info
        self._meanMaxTemperature = meanMaxTemperature
        self._meanMinTemperature = meanMinTemperature
        self._daysOfAirFrost = daysOfAirFrost
        self._totalRainfall = totalRainfall
        self._totalSunshineDuration = totalSunshineDuration
        
    }
    
    func GetMonthStringRepresentation() -> String {
        
        switch self._month {
        case 1:
            return Month.January.rawValue
        case 2:
            return Month.February.rawValue
        case 3:
            return Month.March.rawValue
        case 4:
            return Month.April.rawValue
        case 5:
            return Month.May.rawValue
        case 6:
            return Month.June.rawValue
        case 7:
            return Month.July.rawValue
        case 8:
            return Month.August.rawValue
        case 9:
            return Month.September.rawValue
        case 10:
            return Month.October.rawValue
        case 11:
            return Month.November.rawValue
        case 12:
            return Month.December.rawValue
            
        default:
            return "---"
        }
    }

}
