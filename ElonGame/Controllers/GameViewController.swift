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

    static var shared:GameViewController?
    var currentScene:Int = 0
    var scene:GameScene?
    override func viewDidLoad() {
        super.viewDidLoad()
        GameViewController.shared = self
        loadScene()
    }

    func loadScene() {
        if let scene = GKScene(fileNamed: "Level1") {
            if let sceneNode = scene.rootNode as! GameScene? {
                self.scene = sceneNode
                sceneNode.scaleMode = .aspectFill
                if let view = self.view as! SKView? {
                    self.currentScene = 1
                    view.presentScene(sceneNode)
                    view.ignoresSiblingOrder = false
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
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
    
    @IBAction func reloadPressed(_ sender: Any) {
        AppDelegate.shared?.ai.showAlert(buttons: (.init(title: "cancel", style: .grey, close: true, action: nil), .init(title: "ok", style: .linkBackground, close: true, action: {_ in
            self.scene?.removeAllActions()
            self.loadScene()
        })), title: "restart the game", description: "are you sure you want to restart?")
    }
}
