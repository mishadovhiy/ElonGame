//
//  GameViewController.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 02.04.2023.
//

import UIKit
import SpriteKit
import GameplayKit
import GameController
 
class GameViewController: UIViewController {
    
    @IBOutlet weak var fireButton: UIButton!
    
    @IBOutlet weak var joysticView: UIView!
    @IBOutlet weak var knobView: UIImageView!
    
    
    static var shared:GameViewController?
    var currentScene:Int = 0
    var scene:GameScene?
    override func viewDidLoad() {
        super.viewDidLoad()
        GameViewController.shared = self
        
        DispatchQueue.init(label: "db", qos: .userInitiated).async {
            let _ = DB.data
            DispatchQueue.main.async {
                self.loadScene()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDidConnect(_:)), name: .GCControllerDidConnect, object: nil)
        
    }
    
    func applicationWillResignActive() {
        scene?.pause()
    }
    
    func applicationDidBecomeActive() {
        scene?.pause(false)
    }
    
    
    
    
    func loadScene(i:Int = 1) {
        if let scene = GKScene(fileNamed: "Level\(i)"),
           let sceneNode = scene.rootNode as! GameScene?
        {
            self.scene = sceneNode
            sceneNode.scaleMode = .aspectFill
            if let view = self.view as! SKView? {
                self.currentScene = i
                view.presentScene(sceneNode)
                view.ignoresSiblingOrder = false
                view.showsFPS = true
                view.showsNodeCount = true
            }
        } else {
            self.loadScene(i:1)
        }

        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func gameOverPresented() {
        print("gameOverPresented")
    }
    
    func gameOverRemoved() {
        print("gameOverRemoved")

    }
    
    @IBAction func reloadPressed(_ sender: Any) {
        scene?.pause()
        SettingsVC.present(in: self)
        
    }
    
    func reloadPressed(completion:(()->())? = nil, force:Bool = false) {
        if force {
            self.scene?.checkNextScene(force: true)
        } else {
            if let _ = scene {
                 AppDelegate.shared?.ai.showAlert(buttons: (.init(title: "cancel", style: .grey, close: true, action: nil), .init(title: "ok", style: .linkBackground, close: true, action: {_ in
                 //    scene.dying()
                     self.scene?.checkNextScene(force: true)
                     if let compl = completion {
                         compl()
                     }
                 })), title: "restart the game", description: "are you sure you want to restart?")
             }
        }
        
    }
    
    
    @IBAction func firePressed(_ sender: Any) {
        scene?.player?.spawnBullet()
    }
    
}


extension GameViewController {
    
    @objc func controllerDidConnect(_ notification: NSNotification) {
        if let controller = notification.object as? GCController,
           let contr = controller.extendedGamepad {
            if #available(iOS 14.0, *) {
                contr.allButtons.forEach { button in
                    button.valueChangedHandler = {
                        (element: GCControllerElement, value: Float, pressed: Bool) in
                        //move: v * 4.5
                        let key:JoysticName = .init(button.sfSymbolsName ?? "")
                        print("getrfw \(button.sfSymbolsName) pressed \(key)", pressed, " value ", value)

                        self.scene?.controllerPressed(key: key, pressed: pressed, value: value)
                        
                    }
                }
            }
        }
    }
    
    private func horizontalJoystic() {
        
    }
    enum JoysticName:Int {
        case lJoysticLeft
        case lJoysticRight
        case rJoysticTop
        case a
        case b
        case y
        case x
        case rb
        case lb
        case padUp
        case padDown
        case padRight
        case padLeft
        case unrecognized
        
        init(_ string:String) {
            var foundValue:JoysticName?
            if string == "" {
                self = .unrecognized
                return
            }
            for i in 0..<13 {
                let value:JoysticName = .init(rawValue: i) ?? .lJoysticLeft
                let keys = value.keys
                keys.forEach {
                    if $0 == string {
                        foundValue = value
                    }

                }
            }
            if let found = foundValue {
                self = found
            } else {
                self = .unrecognized
            }
        }
        
        var waitRelease:Bool {
            switch self {
            case .rb, .lb, .lJoysticLeft, .lJoysticRight, .padLeft, .padRight:return true
            default: return false
            }
        }
        
        var walking:PlayerNode.WalkingDirection? {
            switch self {
            case .padRight, .rb, .lJoysticRight:return .right
            case .padLeft, .lb, .lJoysticLeft:return .left

            default: return nil
            }
        }
        
        var keys: [String] {

            switch self {
            case .lJoysticLeft:
                return ["l.joystick.tilt.left"]
            case .lJoysticRight:
                return ["l.joystick.tilt.right"]
            case .rJoysticTop:
                return ["r.joystick.tilt.up"]
            case .a:
                return ["a.circle"]
            case .b:
                return ["b.circle"]
            case .y:
                return ["y.circle"]
            case .x:
                return ["x.circle"]
            case .rb:
                return ["rb.rectangle.roundedbottom", "rt.rectangle.roundedtop"]
            case .lb:
                return ["lb.rectangle.roundedbottom", "lt.rectangle.roundedtop"]
            case .padUp:
                return ["dpad.up.fill"]
            case .padDown:
                return ["dpad.down.fill"]
            case .padRight:
                return ["dpad.right.fill"]
            case .padLeft:
                return ["dpad.left.fill"]
            case .unrecognized:
                return []
            }
        }
    }
}
