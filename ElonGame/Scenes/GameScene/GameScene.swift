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
    private var backgroundPlayer:AudioPlayer?
    var presenting:Bool = false
    var jumpTouched = false
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        presenting = true
        physicsWorld.contactDelegate = self
        
        
        player = childNode(withName: "player") as? PlayerNode
        player?.sceneMoved()
        print(player!.walkingSpeed)
        joystick = childNode(withName: "joystic")
        joystickKnob = joystick?.childNode(withName: "controllIndicator")
        cameraNode = childNode(withName: "cameraNode") as? SKCameraNode
        
        mount1 = childNode(withName: "mount1")
        mount2 = childNode(withName: "mount2")
        mount3 = childNode(withName: "mount3")
        moon = childNode(withName: "moon")
        stars = childNode(withName: "stars")
        self.flour = childNode(withName: "flour")
        self.createEnemies()
        
        enumerateChildNodes(withName: "enemy", using: {node,point in
            if let enemy = node as? EnemyNode {
                enemy.delegate = self
                enemy.sceneMoved()
           //     self.rewardCount += 1
            }
        })
        enumerateChildNodes(withName: "jewel", using: {_,_ in
            self.rewardCount += 1
        })
        print("rewardCount: ", rewardCount)
        
        
        if let state = player?.state.currentState as? PlayerState {
            state.delegate = self
        }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { timer in
            if self.presenting {
                self.spawnMeteor()
            } else {
                timer.invalidate()
            }
        })
        
        
        scoreLabel.position = .init(x: (self.cameraNode?.position.x ?? 0) + 310, y: 140)
        scoreLabel.fontColor = .orange
        scoreLabel.fontSize = 24
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.text = "\(score)"
        addChild(scoreLabel)
        
        
        heartContainer.position = CGPoint(x: -300, y: 140)
        heartContainer.zPosition = 5
        cameraNode?.addChild(heartContainer)
        fillHearts(count: player?.lifes ?? 1)
        
        self.backgroundPlayer = .init(sound: .init(name: "music"), valume: 0.1)
        self.backgroundPlayer?.playSound()
        self.backgroundPlayer?.numberOfLoops = -1
        
        
        let t:PhysicCategory.Mask = .bullet
        print("bullet: ", t.rawValue, " maks ", t.bitmask)
        
    
    
        print(player?.frame.height, " ytrefd")

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
          /*  if let next = GameScene(fileNamed: "Level\(GameViewController.shared?.currentScene ?? 0)")
            {
                self.run(Sound.levelUp.action)
             //   next.scaleMode = .aspectFill
               // self.view?.presentScene(next)
          /*      (
                    GameViewController.shared?.view as? SKView
                )?.presentScene(next)
                GameViewController.shared?.scene = next*/
                GameViewController.shared?.loadScene()
                self.removeFromParent()
                
            } else {
                GameViewController.shared?.currentScene = 0
                self.checkNextScene(force: true)
                print("no more scenes")
            }*/
            run(Sound.levelUp.action)
            GameViewController.shared?.loadScene(i:GameViewController.shared?.currentScene ?? 0)
            removeFromParent()
        }
    }
    func hitted(by:SKSpriteNode? = nil) {
        player?.meteorHit(by: by)
        loseHeart()
    }
    
}



class SuperScene:SKScene {
    override func sceneDidLoad() {
        super.sceneDidLoad()
        if name?.contains("GameOver") ?? false {
            GameViewController.shared?.gameOverPresented()
        } else {
            GameViewController.shared?.gameOverRemoved()
            
        }
    }
}
