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

        playerState = GKStateMachine(states: [JumpingState(playerNode: self.player!)])
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

        guard let joystickKnob = joystickKnob else { return }
        let xPosition = Double(joystickKnob.position.x)

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
}


