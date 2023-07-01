//
//  DB.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 01.07.2023.
//

import Foundation

struct DB {
    static var holder:DataBase? {
        get {
            return .init(dict: AppDelegate.shared?.dbHolder ?? [:])
        }
    }
    static var data:DataBase {
        get {
            if let holder = AppDelegate.shared?.dbHolder {
                return .init(dict: holder)
            } else {
                let db:DataBase = .init(dict: UserDefaults.standard.value(forKey: "DataBase") as? [String:Any] ?? [:])
                AppDelegate.shared?.dbHolder = db.dict
                return db
            }
        }
        set {
            AppDelegate.shared?.dbHolder = newValue.dict
            UserDefaults.standard.setValue(newValue.dict, forKey: "DataBase")
        }
    }
    
    
    struct DataBase {
        var dict:[String:Any]
        init(dict: [String : Any]) {
            self.dict = dict
        }
        
        var settings:Settings {
            get {
                return .init(dict: dict["settings"] as? [String:Any] ?? [:])
            }
            set {
                dict.updateValue(newValue.dict, forKey: "settings")
            }
        }
    }
}


