//
//  GameScene.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 02.04.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SuperScene {
    
    var player : PlayerNode?
    var joystick : SKNode?
    var joystickKnob : SKNode?
    /*
     var joystick : UIView? {
         return GameViewController.shared?.joysticView
     }
     var joystickKnob : UIView? {
         return GameViewController.shared?.knobView
     }
     */
    var cameraNode:SKCameraNode?
    var mount3:SKNode?
    var mount1:SKNode?
    var mount2:SKNode?
    var stars:SKNode?
    var moon:SKNode?
    var flour:SKNode?
    
    var heartsArray = [SKSpriteNode]()
    let heartContainer = SKSpriteNode()
    let scoreLabel:SKLabelNode = .init()
    
    var score:Int = 0
    
    var joystickAction = false
    var knobRadius : CGFloat = 50.0
    var previousTimeInterval : TimeInterval = 0
    var touching = false
    
    var rewardCount:Int = 0
    var currentScene:Int = 0
    var backgroundPlayer:AudioPlayer?
    var presenting:Bool = false
    var jumpTouched = false
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        presenting = true
        physicsWorld.contactDelegate = self
        setChilds()
        createEnemies()
        setupMeteor()
        additionalUI()

    }
    
    override func removeFromParent() {
        presenting = false
        self.removeAllActions()
        backgroundPlayer?.stop()
        self.removeAllChildren()
        super.removeFromParent()
    }
    
    
    
    func showDieScene() {
        GameViewController.shared?.scene = nil
        let scene = SKScene(fileNamed: "GameOver")
        self.removeFromParent()
        self.view?.presentScene(scene)
        
    }
    
    func checkNextScene(force:Bool = false) {
        print("scssceneewded\nscore:\(score) rewardCount:\(rewardCount)")
        if score >= self.rewardCount || force  {
            if force {
                GameViewController.shared?.currentScene = 1
            } else {
                GameViewController.shared?.currentScene += 1
            }
            run(Sound.levelUp.action)
            
            removeFromParent()
            DispatchQueue.main.async {
                GameViewController.shared?.loadScene(i:GameViewController.shared?.currentScene ?? 0)
            }
        }
    }
    
    func hitted(by:SKSpriteNode? = nil) {
        player?.meteorHit(by: by)
        loseHeart()
    }
    
  //  var pausedOn = false
    func pause(_ pause:Bool = true) {
        isPaused = pause
        enumerateChildNodes(withName: "meteor", using: {node,point in
            node.physicsBody?.affectedByGravity = !pause
        })
        
        enumerateChildNodes(withName: "enemy", using: {node,point in
            if let enemy = node as? EnemyNode {
                enemy.isPaused = pause
                node.physicsBody?.affectedByGravity = !pause
                if !pause {
                    enemy.randomWalking()
                }
            }
        })
    }
    
}

