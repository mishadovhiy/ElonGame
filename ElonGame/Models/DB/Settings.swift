//
//  Settings.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 01.07.2023.
//

import Foundation

extension DB {
    struct Settings {
        var dict:[String:Any]
        init(dict: [String : Any]) {
            self.dict = dict
        }
        
        var game:Game {
            get {
                return .init(dict: dict["gamee"] as? [String:Any] ?? [:])
            }
            set {
                dict.updateValue(newValue.dict, forKey: "gamee")
            }
        }
        
        struct Game {
            var dict:[String:Any]
            init(dict: [String : Any]) {
                self.dict = dict
            }
            
            var enubleMeteors:Bool {
                get {
                    return dict["enubleMeteors"] as? Bool ?? true
                }
                set {
                    dict.updateValue(newValue, forKey: "enubleMeteors")
                }
            }
            
            var needEnemies:Bool {
                get {
                    return dict["needEnemies"] as? Bool ?? true
                }
                set {
                    dict.updateValue(newValue, forKey: "needEnemies")
                }
            }
            
            var enamieCanShoot:Bool {
                get {
                    return dict["enamieCanShoot"] as? Bool ?? true
                }
                set {
                    dict.updateValue(newValue, forKey: "enamieCanShoot")
                }
            }
            
            var canFast:Bool {
                get {
                    return dict["canFast"] as? Bool ?? true
                }
                set {
                    dict.updateValue(newValue, forKey: "canFast")
                }
            }
        }
    }
}
