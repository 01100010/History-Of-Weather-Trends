//
//  Parser.swift
//  History of Weather Trends
//
//  Created by Oleksii on 11.07.18.
//  Copyright © 2018 Oleksii. All rights reserved.
//

import Foundation

class Parser {
    
    static func splitWeatherStationDataByLines(_ stringRepresentation: String) -> [Substring] {
        
        // Remove escaped characters '\r'
        let withoutEscapingSymbol = stringRepresentation.replacingOccurrences(of: "\r", with: "")
        
        // Delete Header
        let token = String(describing: withoutEscapingSymbol).components(separatedBy: "hours\n")
        
        // Split by new line
        let lines = token[1].split(separator: "\n")
        
        return lines
        
    }
    
    static func parseSingleLine(_ singleLine: String) -> WeatherMeasurementsPerWeek? {
        
        // split line by empty spaces
        let splittedLine = singleLine.split(separator: " ", omittingEmptySubsequences: true)
        
        guard splittedLine.count > 6 else {
            return nil
        }
        // set date
        let year = Int(splittedLine[0])
        let month = Month(rawValue: Int(splittedLine[1])!)
        // set weather info
        let maxT = Double(splittedLine[2])
        let minT = Double(splittedLine[3])
        let daysAR = Int(splittedLine[4])
        let rainfall = Double(splittedLine[5])
        let sunshine = Double(splittedLine[6])
        
        // Check if year and month valid value
        if let year = year, let month = month {
            return WeatherMeasurementsPerWeek(year: year, month: month, meanMaxTemperature: maxT, meanMinTemperature: minT, daysOfAirFrost: daysAR, totalRainfall: rainfall, totalSunshineDuration: sunshine)
        }
        return nil
    }
}
