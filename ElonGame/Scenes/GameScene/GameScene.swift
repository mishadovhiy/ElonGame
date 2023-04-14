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
    
    var joystickAction = false
    var knobRadius : CGFloat = 50.0
    var previousTimeInterval : TimeInterval = 0
    var playerIsFacingRight = true
    let playerSpeed:Double = 4.0
    var playerState:GKStateMachine!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
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
    }

}

extension GameScene {
    func resetKnobPosition() {
        let initialPoint = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initialPoint, duration: 0.1)
        moveBack.timingMode = .linear
        joystickKnob?.run(moveBack)
        joystickAction = false
    }
}

extension GameScene {
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        let deltaTime = currentTime - previousTimeInterval
        previousTimeInterval = currentTime

        moveCamera()
        moveBackground()
        
        movePlayer(deltaTime)
    }
    
    
    private func movePlayer(_ deltaTime:TimeInterval) {
        guard let joystickKnob = joystickKnob else { return }
        let xPosition = Double(joystickKnob.position.x)
        let positivePos = xPosition < 0 ? -xPosition : xPosition
        if floor(positivePos) != 0 {
            playerState.enter(WalkingState.self)
        } else {
            playerState.enter(IdleState.self)
        }
        
        let displacement = CGVector(dx: deltaTime * xPosition * playerSpeed, dy: 0)
        let move = SKAction.move(by: displacement, duration: 0)
        let faceAction : SKAction!
        let movingRight = xPosition > 0
        let movingLeft = xPosition < 0
        if movingLeft && playerIsFacingRight {
            playerIsFacingRight = false
            let faceMovement = SKAction.scaleX(to: -1, duration: 0.0)
            faceAction = SKAction.sequence([move, faceMovement])
        }
        else if movingRight && !playerIsFacingRight {
            playerIsFacingRight = true
            let faceMovement = SKAction.scaleX(to: 1, duration: 0.0)
            faceAction = SKAction.sequence([move, faceMovement])
        } else {
            faceAction = move
        }
        player?.run(faceAction)
    }
    
    private func moveCamera() {
        cameraNode?.position.x = player?.position.x ?? 0
        let camPos = cameraNode?.position ?? .init(x: 0, y: 0)
        joystick?.position = .init(x: camPos.x - 300,
                                   y: camPos.y - 100)
    }
    
    private func moveBackground() {
        self.mountinesAnimations([mount1, mount2, mount3])
        let starsAction = SKAction.moveTo(x: cameraNode?.position.x ?? 0, duration: 0)
        self.stars?.run(starsAction)
        let moonAction = SKAction.moveTo(x: cameraNode?.position.x ?? 0, duration: 0)
        self.moon?.run(moonAction)
    }
    func mountinesAnimations(_ nodes:[SKNode?]) {
        let player = player?.position.x ?? 0
        var val:CGFloat = 10
        nodes.forEach({
            $0?.run(.moveTo(x: player / (val * -1) , duration: 0))
            val += val
        })
    }
}


