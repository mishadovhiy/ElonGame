//
//  GameScene.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 02.04.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player : SKNode?
    var joystick : SKNode?
    var joystickKnob : SKNode?
    var cameraNode:SKCameraNode?
    var mount3:SKNode?
    var mount1:SKNode?
    var mount2:SKNode?
    var stars:SKNode?
    var moon:SKNode?
    var heartsArray = [SKSpriteNode]()
    let heartContainer = SKSpriteNode()
    let scoreLabel:SKLabelNode = .init()
    
    var score:Int = 0
    var isHit = false
    
    var joystickAction = false
    var rewardNotTouched = true
    var playerIsFacingRight = true
    var knobRadius : CGFloat = 50.0
    var previousTimeInterval : TimeInterval = 0
    let playerSpeed:Double = 4.0
    var playerState:GKStateMachine!
    var touching = false
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        physicsWorld.contactDelegate = self
         
        player = childNode(withName: "player")
        joystick = childNode(withName: "joystic")
        joystickKnob = joystick?.childNode(withName: "controllIndicator")
        cameraNode = childNode(withName: "cameraNode") as? SKCameraNode
        
        mount1 = childNode(withName: "mount1")
        mount2 = childNode(withName: "mount2")
        mount3 = childNode(withName: "mount3")
        moon = childNode(withName: "moon")
        stars = childNode(withName: "stars")

        playerState = GKStateMachine(states: [
            JumpingState(playerNode: self.player!),
            WalkingState(playerNode: self.player!),
            IdleState(playerNode: self.player!),
            LandingState(playerNode: self.player!),
            StunnedState(playerNode: self.player!)
        ])
        playerState.enter(IdleState.self)
        if let state = playerState.currentState as? PlayerState {
            state.delegate = self
        }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
            self.spawnMeteor()
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
        fillHearts(count: 5)
    }

    var jumpTouched = false
    
    func showDieScene() {
        let scene = GameScene(fileNamed: "GameOver")
        self.view?.presentScene(scene)
        self.removeAllActions()
    }
}


