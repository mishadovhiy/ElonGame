//
//  Extensions_SettingsVC.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 01.07.2023.
//

import UIKit

extension SettingsVC {
    func reloadPressed() {
        GameViewController.shared?.reloadPressed(completion: {
            self.dismiss(animated: true)
        })
    }
    
    func getData() {
        DispatchQueue.init(label: "db", qos: .userInitiated).async {
            self.db = DB.data
            self.tableData = self.createData()
            DispatchQueue.main.async {
                if self.tableView.delegate == nil {
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                }
                self.tableView.reloadData()
            }
        }
    }
}
