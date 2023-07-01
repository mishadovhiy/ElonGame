//
//  SwitchCell.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 01.07.2023.
//

import UIKit

class SwitchCell: ClearCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var switchView: UISwitch!
    
    var data:SettingsVC.SettingsData.Row?
    func set(data:SettingsVC.SettingsData.Row) {
        self.data = data
        self.titleLabel.text = data.name
        switchView.isOn = data.switchData?.isOn ?? false
    }
    
    
    @IBAction func switchChanged(_ sender: Any) {
        if let action = data?.switchData?.switched {
            action((sender as? UISwitch)?.isOn ?? false)
        }
    }
    
}
