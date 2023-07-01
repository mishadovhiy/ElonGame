//
//  SettingsVC.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 01.07.2023.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var closeButton: UIButton!
    var tableData:[SettingsData] = []
    var _db:DB.DataBase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
    }
    
    func createData() -> [SettingsData] {
        let data = db?.settings ?? .init(dict: [:])
        return [
            .init(sectionTitle:"Game", data: [
                .init(name: "enuble meteors", switchData: .init(isOn: data.game.enubleMeteors, switched: {
                    self.db?.settings.game.enubleMeteors = $0
                }))
            ]),
            .init(sectionTitle: "Other settings", data: [
                .init(name: "reload", regulare: .init(pressed: reloadPressed))
            ])
        ]
    }
    

    var db:DB.DataBase? {
        get { return _db }
        set {
            _db = newValue
            DB.data = newValue ?? .init(dict: [:])
        }
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}


extension SettingsVC {
    struct SettingsData {
        var sectionTitle:String = ""
        var data:[Row]
        struct Row {
            let name:String
            var regulare:Regular? = nil
            var switchData:Switch? = nil
            struct Switch {
                let isOn:Bool
                let switched:(_ newValue:Bool) -> ()
            }
            struct Regular {
                let pressed:()->()
            }
        }
    }
    
    static func configure()-> SettingsVC {
        let storybord = UIStoryboard(name: "Main", bundle: .main)
        let vc = storybord.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        return vc
    }
    
    static func present(in superVC:UIViewController) {
        let vc = SettingsVC.configure()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        superVC.present(vc, animated: true)
    }
}
