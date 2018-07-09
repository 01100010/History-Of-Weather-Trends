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

    // MARK: Properties

    var selectedStationIndex = 0
    var selectedTemperatureScale = TemperatureScale.celsius

    // MARK: Outlets

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var segmentedTempScale: UISegmentedControl!

    // MARK: ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        // Setup setting view
        pickerView.selectRow(selectedStationIndex, inComponent: 0, animated: true)
        segmentedTempScale.selectedSegmentIndex = selectedTemperatureScale.rawValue
    }
}

extension SettingsPageVC: UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Picker View Delagate

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stations.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stations[row]
    }
}
