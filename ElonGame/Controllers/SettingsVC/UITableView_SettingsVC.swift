//
//  UITableView_SettingsVC.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 01.07.2023.
//

import UIKit

extension SettingsVC:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableData = tableData[indexPath.section].data[indexPath.row]
        if let _ = tableData.regulare {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RegularCell", for: indexPath) as! RegularCell
            cell.set(data: tableData)
            return cell
        } else if let _ = tableData.switchData {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.set(data: tableData)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableData = tableData[indexPath.section].data[indexPath.row]
        if let action = tableData.regulare?.pressed {
            action()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell") as! SectionCell
        cell.set(data: tableData[section])
        let view = cell.contentView
        view.backgroundColor = self.view.backgroundColor
        return view
    }
    
    
    
}
