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
        print("scoreeee: ", score)
        self.scoreLabel.text = "\(score)"
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
            self.checkNextScene()
        })
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
        if player?.isMeteorHitted ?? false {
            let lastElementIndex = heartsArray.count - 1
            if heartsArray.indices.contains(lastElementIndex - 1) {
                let lastHeart = heartsArray[lastElementIndex]
                lastHeart.removeFromParent()
                heartsArray.remove(at: lastElementIndex)
            } else {
                dying()
            }
        }
    }
    
    
    
    func dying() {
        GameViewController.shared?.scene = nil
        self.removeAllActions()
        self.showDieScene()
    }
    
    func removeJewel(_ node:JewelNode) {
        node.touched = true
        node.physicsBody?.categoryBitMask = 0
        node.removeFromParent()
        reqardTouched()
        run(Sound.reward.action)
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
