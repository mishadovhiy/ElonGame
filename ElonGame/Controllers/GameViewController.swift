//
//  GameViewController.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 02.04.2023.
//

import UIKit
import SpriteKit
import GameplayKit

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
