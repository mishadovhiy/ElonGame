//
//  SKPhysicsContactDelegate_GameScene.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 14.04.2023.
//

import SpriteKit
import GameplayKit

extension GameScene:SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collisions = Collisions(masks: (first: contact.bodyA.categoryBitMask, second: contact.bodyB.categoryBitMask))
        
        if collisions.matches(.player, .killing) {
            let die = SKAction.move(to: .init(x: -300, y: -100), duration: 0)
            player?.run(die)
            run(Sound.hit.action)
        }
        
        if collisions.matches(.player, .ground) {
            playerState.enter(LandingState.self)
            
        }
        
        if collisions.matches(.ground, .killing) {
            if let node = contact.matched(name: "meteor") {
                self.createMolten(at: node.position)
                node.removeFromParent()
                run(Sound.meteorFalling.action)
            }
        }
        
        if collisions.matches(.player, .reward) {
            if let node = contact.matched(name: "jewel") as? JewelNode {
                if !node.touched {
                    node.touched = true
                    node.physicsBody?.categoryBitMask = 0
                    node.removeFromParent()
                    
                    reqardTouched()
                    
                    run(Sound.reward.action)
                }
                
            }

         //   if rewardNotTouched {
           //     rewardNotTouched = false
                
           // }
            
        }
        
        if collisions.matches(.player, .killing) {
            loseHeart()
            isHit = true
            playerState.enter(StunnedState.self)
        }
    }
    
    
    struct Collisions {
        enum Mask:Int {
            case killing, player, reward, ground
            var bitmask:UInt32 { 1 << self.rawValue }
        }
        let masks:(first:UInt32, second:UInt32)
        func matches(_ first:Mask, _ second:Mask) -> Bool {
            return (first.bitmask == self.masks.first && second.bitmask == self.masks.second) || (first.bitmask == self.masks.second && second.bitmask == self.masks.first)
        }
        
    }
    
}


extension  GameScene {
    func spawnMeteor() {
        let node = SKSpriteNode(imageNamed: "meteor")
        node.name = "meteor"
        let camPos = camera?.position
        print(camPos, " huiknbh")
        let x = Int(camPos?.x ?? 0)
        let wi = Int(self.size.width)
        let isMinus = x <= 0
        let xr = isMinus ? x * -1 : x
        let randomXPosition = Int.random(in: xr..<(wi + xr))
        //Int(arc4random_uniform(UInt32(self.size.width)))
        node.position = .init(x: randomXPosition * (isMinus ? -1 : 1), y: 270)
        node.anchorPoint = .init(x: 0.5, y: 1)
        node.zPosition = 5
        
        let phBody = SKPhysicsBody(circleOfRadius: 30)
        phBody.categoryBitMask = Collisions.Mask.killing.bitmask
        phBody.collisionBitMask = Collisions.Mask.player.bitmask | Collisions.Mask.ground.bitmask
        phBody.contactTestBitMask = Collisions.Mask.player.bitmask | Collisions.Mask.ground.bitmask
        phBody.fieldBitMask = Collisions.Mask.player.bitmask | Collisions.Mask.ground.bitmask
        phBody.affectedByGravity = true
        phBody.allowsRotation = false
        phBody.restitution = 0.2
        phBody.friction = 1.0
    
        node.physicsBody = phBody
        
        addChild(node)
    }
    
    func createMolten(at position:CGPoint) {
        let node = SKSpriteNode(imageNamed: "molten")
        node.position = .init(x: position.x, y: position.y - 60)
        node.zPosition = 4
        
        addChild(node)
        
        let action = SKAction.sequence([
            .fadeIn(withDuration: 0.1),
            .wait(forDuration: 3.0),
            .fadeOut(withDuration: 0.2),
            .removeFromParent()
        ])

        node.run(action)
    }
}
