//
//  HistoryTableVC.swift
//  History of Weather Trends
//
//  Created by Oleksii on 28.06.18.
//  Copyright © 2018 Oleksii. All rights reserved.
//

import UIKit
import Alamofire

class HistoryTableVC: UITableViewController {

    // MARK: Properties

    let stubURL = "https://www.metoffice.gov.uk/pub/data/weather/uk/climate/stationdata/"

    var searchController = UISearchController(searchResultsController: nil)

    var currentWeatherStation = "Bradford"
    var currentTemperatureScale = TemperatureScale.celsius

    var weatherDataByStation = [WeatherMeasurementsPerWeek]()
    var filteredWeatherData = [WeatherMeasurementsPerWeek]()
    var indexOfData: Int?

    // MARK: ViewController lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        loadWeatherStationData(station: currentWeatherStation)

        setupSearchController()
    }

    // MARK: - Table view data source & delegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredWeatherData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherInfoCell", for: indexPath) as? WeatherInfoCell else {
            return UITableViewCell()
        }

        cell.setupWeatherInfoCell(data: filteredWeatherData[indexPath.row])

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        indexOfData = indexPath.row

        tableView.deselectRow(at: indexPath, animated: true)

        performSegue(withIdentifier: "FromHistoryPage_To_DetailPage", sender: self)

    }

     // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "FromHistoryPage_To_SettingsPage" {

            guard let destination = segue.destination as? SettingsPageVC else {
                return
            }

            guard let stationIndex = destination.stations.index(of: currentWeatherStation) else {
                return
            }

            destination.selectedStationIndex = stationIndex
            destination.selectedTemperatureScale = currentTemperatureScale

        } else if segue.identifier == "FromHistoryPage_To_DetailPage" {

            guard let destination = segue.destination as? DetailAboutWeatherInfoVC else {
                return
            }

            guard let index = indexOfData else {
                return
            }

            destination.weatherInformation = filteredWeatherData[index]
            destination.station = currentWeatherStation
            destination.temperatureScale = currentTemperatureScale
        }
     }

    // Get Data Back From Setting Page
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {

        if let sender = sender.source as? SettingsPageVC {

            // get station from picker view
            let station = sender.stations[sender.pickerView.selectedRow(inComponent: 0)]

            // update weather data
            if station != currentWeatherStation {

                currentWeatherStation = station

                weatherDataByStation.removeAll()
                filteredWeatherData.removeAll()

                loadWeatherStationData(station: currentWeatherStation)
            }

            // set temperature scale
            if let temperatureScale = TemperatureScale(rawValue: sender.segmentedTempScale.selectedSegmentIndex) {
                currentTemperatureScale = temperatureScale
            }
        }
    }

    // MARK: Private Method
    private func loadWeatherStationData(station: String) {
        
        // Create URL object
        let urlString = createURLString(station)
        
        // Check URL
        guard let validURL = urlString else {
            print("Error on URL String")
            return
        }
        
        Alamofire.request(validURL).response { response in
            // Check on error
            guard response.error == nil else {
                print("Error on HTTP Request: \(String(describing: response.error?.localizedDescription))")
                return
            }
            // Is valid data ?
            if let dataFromMetOffice = response.data {
                
                // Convert data to string
                if let stringRepresentation = String(data: dataFromMetOffice, encoding: String.Encoding.utf8) {
                    
                    self.splitWeatherStationDataByLines(stringRepresentation)
                    
                }
            }
            self.filteredWeatherData = self.weatherDataByStation
            self.doTableRefresh()
        }
    }
    
    private func splitWeatherStationDataByLines(_ stringRepresentation: String) {

        // Remove escaped characters '\r'
        let withoutEscapingSymbol = stringRepresentation.replacingOccurrences(of: "\r", with: "")

        // Delete Header
        let token = String(describing: withoutEscapingSymbol).components(separatedBy: "hours\n")

        // Split by new line
        let lines = token[1].split(separator: "\n")

        // Parse single Line
        for line in lines {
            parseSingleLine(String(line))
        }
    }

    private func parseSingleLine(_ singleLine: String) {

        // split line by empty spaces
        let splittedLine = singleLine.split(separator: " ", omittingEmptySubsequences: true)

        guard splittedLine.count > 6 else {
            return
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

            // Add new instances
            weatherDataByStation.append(WeatherMeasurementsPerWeek(year: year, month: month, meanMaxTemperature: maxT, meanMinTemperature: minT, daysOfAirFrost: daysAR, totalRainfall: rainfall, totalSunshineDuration: sunshine))

        }
    }

    private func setupSearchController() {
        // Do not hide when scroll
        navigationItem.hidesSearchBarWhenScrolling = false

        // Set delegate
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Weather Info by Date"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func createURLString(_ stationName: String) -> URL? {

        // Delete redundand characters
        var result = stationName.replacingOccurrences(of: " ", with: "")
        result = result.replacingOccurrences(of: "-", with: "")

        return URL(string: stubURL + result.lowercased() + "data.txt")
    }

    private func doTableRefresh() {

        // Change title when change weather station
        self.navigationItem.title = currentWeatherStation + " Station"
        // Do table refresh
        self.tableView.reloadData()
    }
}

extension HistoryTableVC: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        guard !searchText.isEmpty else {
            // If Search Controller Empty Display All Cells
            filteredWeatherData = weatherDataByStation
            doTableRefresh()
            return
        }
        filteredWeatherData = weatherDataByStation.filter({ weatherInfo -> Bool in
            // Search by full date (1995 March)
            weatherInfo.getFullDate.contains(searchText)
        })
        doTableRefresh()
    }

}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
