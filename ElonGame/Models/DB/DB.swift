//
//  DB.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 01.07.2023.
//

import Foundation

struct DB {
    static var holder:DataBase?
    static var data:DataBase {
        get {
            if let holder = DB.holder {
                return holder
            } else {
                let db:DataBase = .init(dict: UserDefaults.standard.value(forKey: "DataBase") as? [String:Any] ?? [:])
                DB.holder = db
                return db
            }
        }
        set {
            DB.holder = newValue
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


