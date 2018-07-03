//
//  HistoryTableVC.swift
//  History of Weather Trends
//
//  Created by Oleksii on 28.06.18.
//  Copyright © 2018 Oleksii. All rights reserved.
//

import UIKit

class HistoryTableVC: UITableViewController {

    // MARK: Properties
    
    private let stubURL = "https://www.metoffice.gov.uk/pub/data/weather/uk/climate/stationdata/"
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var currentWeatherStationName = "Bradford"
    var currentTemperatureScale = TemperatureScale.Celsius
    
    var weatherInfoArray = [WeatherMeasurementsPerWeek]()
    var filteredWeatherInfoArray = [WeatherMeasurementsPerWeek]()
    var indexOfData: Int?
    
    // MARK: Override Methods UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadData(stationName: currentWeatherStationName)
        
        SetupSearchController()
    }
    
    // MARK: - Table view data source & delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return filteredWeatherInfoArray.count
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherInfoCell", for: indexPath) as! WeatherInfoCell

        cell.SetData(data: filteredWeatherInfoArray[indexPath.row])
        
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
            
            let destinationSettingVC = segue.destination as! SettingsPageVC
            
            destinationSettingVC.selectedStationIndex = destinationSettingVC.stationsArray.index(of: "\(currentWeatherStationName)")!
            
            destinationSettingVC.selectedTemperatureScale = currentTemperatureScale.rawValue
            
        } else if segue.identifier == "FromHistoryPage_To_DetailPage" {
            
            let destinationDetailVC = segue.destination as! DetailAboutWeatherInfoVC
            
            if let validIndex = indexOfData {
                
                destinationDetailVC.weatherInformation = filteredWeatherInfoArray[validIndex]
                
                destinationDetailVC.stationName = currentWeatherStationName
                
                destinationDetailVC.temperatureScale = currentTemperatureScale
            }
        }
     }

    // Get Data Back From Setting Page
    @IBAction func unwindFromSettingVC(_ sender: UIStoryboardSegue) {
        
        if sender.source is SettingsPageVC {
            if let SettingVC = sender.source as? SettingsPageVC {
                // Set Weather Station
                
                let stationNameFromSettingPage = SettingVC.stationsArray[SettingVC.pickerView.selectedRow(inComponent: 0)]
                
                if stationNameFromSettingPage != currentWeatherStationName {
                    currentWeatherStationName = stationNameFromSettingPage
                    
                    weatherInfoArray.removeAll()
                    filteredWeatherInfoArray.removeAll()
                    
                    LoadData(stationName: currentWeatherStationName)
                }
                // Set Temperature Scale
                self.currentTemperatureScale = TemperatureScale(rawValue: SettingVC.segmentedTempScale.selectedSegmentIndex)!
            }
        }
    }
    
    // MARK: Private Method
    private func LoadData(stationName: String) {
        
        // Create URL object
        let fileUrl = CreateFullURL(stationName)
        
        // Check URL
        if let validURL = fileUrl {
            
            _ = URLSession.shared.dataTask(with: validURL) { (data, response, error) in
                
                // Is valid data ?
                if let dataFromMetOffice = data {
                    
                    // Convert data to string
                    if var stringRepresentation = String(data: dataFromMetOffice,encoding: String.Encoding.utf8) {

                        self.ParseDataIntoArray(&stringRepresentation)
                        
                    }
                } else if let receivedError = error {
                    print(receivedError.localizedDescription)
                }
                DispatchQueue.main.sync {
                    self.filteredWeatherInfoArray = self.weatherInfoArray;
                    self.TableRefresh()
                }
            }.resume()
            
        } else {
            print("Please enter valid URL address.")
        }
    }
    
    private func ParseDataIntoArray(_ stringRepresentation: inout String) {
    
        // Remove escaped characters '\r'
        stringRepresentation = stringRepresentation.replacingOccurrences(of: "\r", with: "")
        
        // Delete Header
        var token = String(describing: stringRepresentation).components(separatedBy: "hours\n")
        
        // Split by new line
        let lines = token[1].split(separator: "\n")
        
        // Parse Single Line
        for line in lines {
            ParseSingleLine(String(line))
        }
    }
    
    private func ParseSingleLine(_ singleLine: String){
        
        // split line by empty spaces
        let splittedLine = singleLine.split(separator: " ", omittingEmptySubsequences: true)
        
        guard splittedLine.count > 6 else {
            return;
        }
        // set date
        let year = Int(splittedLine[0])
        let month = Int(splittedLine[1])
        // set weather info
        let maxT = Double(splittedLine[2])
        let minT = Double(splittedLine[3])
        let daysAR = Int(splittedLine[4])
        let rainfall = Double(splittedLine[5])
        let sunshine = Double(splittedLine[6])
        
        // Check if year and month valid value
        if let year = year, let month = month {
            
            // Add new instances
            weatherInfoArray.append(WeatherMeasurementsPerWeek(year: year, month: month, meanMaxTemperature: maxT, meanMinTemperature: minT, daysOfAirFrost: daysAR, totalRainfall: rainfall, totalSunshineDuration: sunshine))
            
        }
    }
    
    private func SetupSearchController() {
        // Do not hide when scroll
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Set delegate
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Weather Info by Date"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func CreateFullURL(_ stationName: String) -> URL? {
        
        // Delete redundand characters
        var result = stationName.replacingOccurrences(of: " ", with: "")
        result = result.replacingOccurrences(of: "-", with: "")
    
        return URL(string: stubURL + result.lowercased() + "data.txt")
    }
    
    private func TableRefresh() {
        
        // Change title when change weather station
        self.navigationItem.title = currentWeatherStationName + " Station"
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
            filteredWeatherInfoArray = weatherInfoArray
            TableRefresh()
            return
        }
        filteredWeatherInfoArray = weatherInfoArray.filter({ weatherInfo -> Bool in
            // Search by full date (1995 March)
            weatherInfo.FullDate.contains(searchText)
        })
        TableRefresh()
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






