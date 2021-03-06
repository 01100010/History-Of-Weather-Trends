//
//  SettingsPageVC.swift
//  History of Weather Trends
//
//  Created by Oleksii on 02.07.18.
//  Copyright © 2018 Oleksii. All rights reserved.
//

import UIKit

class SettingsPageVC: UIViewController {

    // MARK: HARDCODE

    var stations = ["Aberporth", "Armagh", "Ballypatrick", "Bradford", "Braemar", "Camborne", "Cambridge", "Cardiff", "Chivenor", "Cwmystwyth", "Dunstaffnage", "Durham", "Eastbourne", "Eskdalemuir", "Heathrow", "Hurn", "Lerwick", "Leuchars", "Lowestoft", "Manston", "Nairn", "Newton Rigg", "Oxford", "Paisley", "Ringway", "Ross-on-Wye", "Shawbury", "Sheffield", "Southampton", "Stornoway", "Sutton Bonington", "Tiree", "Valley", "Waddington", "Whitby", "Wick Airport", "Yeovilton"]

    // MARK: Outlets

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var segmentedTempScale: UISegmentedControl!

    // MARK: ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSettingView()
    }
    
    // MARK: Private Method
    
    func setupSettingView() {
        let stationIndex = stations.index(of: Settings.currentStation) ?? 0
        
        pickerView.selectRow(stationIndex, inComponent: 0, animated: true)
        segmentedTempScale.selectedSegmentIndex = Settings.temperatureScale.rawValue
    }
}

extension SettingsPageVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: Picker View DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // MARK: Picker View Delagate

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stations.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stations[row]
    }
}
