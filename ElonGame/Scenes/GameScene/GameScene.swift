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
    
    let scoreLabel:SKLabelNode = .init()
    var score:Int = 0
    
    var joystickAction = false
    var rewardNotTouched = true
    var playerIsFacingRight = true

    var knobRadius : CGFloat = 50.0
    var previousTimeInterval : TimeInterval = 0
    let playerSpeed:Double = 4.0
    var playerState:GKStateMachine!
    
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
        addChild(scoreLabel )
    }

    var jumpTouched = false
}

extension GameScene {
    func resetKnobPosition() {
        let initialPoint = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initialPoint, duration: 0.1)
        moveBack.timingMode = .linear
        joystickKnob?.run(moveBack)
        joystickAction = false
    }
    
    func reqardTouched() {
        self.score += 1
        self.scoreLabel.text = "\(score)"
    }
}



extension GameScene:PlayerStateProtocol {
    func endJumping() {
        self.jumpTouched = false
    }
}
