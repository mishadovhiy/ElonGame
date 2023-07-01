//
//  RegularCell.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 01.07.2023.
//

import UIKit

class RegularCell: Cell {
    @IBOutlet weak var titleLabel: UILabel!

    func set(data:SettingsVC.SettingsData.Row) {
        self.titleLabel.text = data.name
    }
}
