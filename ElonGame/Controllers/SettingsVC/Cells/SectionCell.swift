//
//  SectionCell.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 01.07.2023.
//

import UIKit

class SectionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    func set(data:SettingsVC.SettingsData) {
        titleLabel.text = data.sectionTitle
    }
    

}
