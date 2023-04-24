//
//  Extensions_GameScene.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 24.04.2023.
//

import SpriteKit
import GameplayKit

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
    
    func fillHearts(count: Int) {
        for index in 1...count {
            let heart = SKSpriteNode(imageNamed: "heart")
            let xPosition = heart.size.width * CGFloat(index - 1)
            heart.position = CGPoint(x: xPosition, y: 0)
            heartsArray.append(heart)
            heartContainer.addChild(heart)
        }
    }
    
    func loseHeart() {
        if isHit == true {
                let lastElementIndex = heartsArray.count - 1
                if heartsArray.indices.contains(lastElementIndex - 1) {
                    let lastHeart = heartsArray[lastElementIndex]
                    lastHeart.removeFromParent()
                    heartsArray.remove(at: lastElementIndex)
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                        self.isHit = false
                    }
                }
                else {
                    dying()
                }
                invincible()
            }
    }
    
    func invincible() {
        player?.physicsBody?.categoryBitMask = 0
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.player?.physicsBody?.categoryBitMask = 2
        }
    }
    
    func dying() {
        let dieAction = SKAction.move(to: CGPoint(x: -300, y: 0), duration: 0.1)
        player?.run(dieAction)
        self.removeAllActions()
        fillHearts(count: 3)
        self.showDieScene()
    }
}



extension GameScene:PlayerStateProtocol {
    func endJumping() {
        self.jumpTouched = false
        if !touching {
            print("touching")
            if joystickAction {
                print("resetKnobPosition")
                resetKnobPosition()
            }
        }
    }
}
