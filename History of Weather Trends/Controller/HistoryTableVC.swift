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

    var searchController = UISearchController(searchResultsController: nil)

    var weatherDataByStation = [WeatherMeasurementsPerWeek]()
    var filteredWeatherData = [WeatherMeasurementsPerWeek]()
    var indexOfData: Int?

    // MARK: ViewController lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        loadWeatherStationData(station: Settings.currentStation)

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

        //indexOfData = indexPath.row

        //tableView.deselectRow(at: indexPath, animated: true)

        //performSegue(withIdentifier: "FromHistoryPage_To_DetailPage", sender: self)

    }

     // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "segueToDetailsVC" {

            guard let cell = sender as? WeatherInfoCell, let indexPath = tableView.indexPath(for: cell), let destination = segue.destination as? DetailAboutWeatherInfoVC else {
                assertionFailure("Error: There is no such cell")
                return
            }

            destination.weatherInformation = filteredWeatherData[indexPath.row]
        }
     }

    // Get Data Back From Setting Page
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {

        if let sender = sender.source as? SettingsPageVC {

            // get station from picker view
            let station = sender.stations[sender.pickerView.selectedRow(inComponent: 0)]
            
            // update weather data
            if station != Settings.currentStation {

                Settings.currentStation = station

                weatherDataByStation.removeAll()
                filteredWeatherData.removeAll()

                loadWeatherStationData(station: Settings.currentStation)
            }

            // set temperature scale
            if let temperatureScale = TemperatureScale(rawValue: sender.segmentedTempScale.selectedSegmentIndex) {
                Settings.temperatureScale = temperatureScale
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
            // is valid data ?
            if let dataFromMetOffice = response.data {
                
                // convert to string
                if let stringRepresentation = String(data: dataFromMetOffice, encoding: String.Encoding.utf8) {
                    
                    // parse data
                    let lines = Parser.splitWeatherStationDataByLines(stringRepresentation)
                    
                    for line in lines {
                        if let weatherInfo = Parser.parseSingleLine(String(line)) {
                            self.weatherDataByStation.append(weatherInfo)
                        }
                    }
                }
            }
            // update view
            self.filteredWeatherData = self.weatherDataByStation
            self.doTableRefresh()
        }
    }

    private func setupSearchController() {
        // Don't hide when scroll
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

        return URL(string: Settings.stubURL + result.lowercased() + "data.txt")
    }

    private func doTableRefresh() {
        // change title
        navigationItem.title = Settings.currentStation + " Station"
        tableView.reloadData()
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
