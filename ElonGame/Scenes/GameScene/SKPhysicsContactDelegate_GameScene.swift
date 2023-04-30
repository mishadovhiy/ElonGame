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
        let collisions = PhysicCategory(masks: (first: contact.bodyA.categoryBitMask, second: contact.bodyB.categoryBitMask))

        
        
        if collisions.matches(.player, .ground) {
            playerState.enter(LandingState.self)
            if let node = contact.matched(name: "flour") {
                if node.intName != currentFloour {
                    currentFloour = node.intName
                }
            }
        }
        
        if collisions.matches(.ground, .killing) {
            if let node = contact.matched(name: "meteor") {
                self.createMolten(at: node.position)
                node.removeFromParent()
                run(Sound.meteorFalling.action)
            }
        }
        
        if collisions.matches(.player, .reward) {
            if let node = contact.matched(name: "jewel") as? JewelNode,
               !node.touched
            {
                if let _ = node as? JewelSpeed {
                    if player?.startSuperSpeed() ?? false {
                        removeJewel(node)
                    }
                } else {
                    removeJewel(node)
                }
                
            }
            
        }
        
        if collisions.matches(.player, .killing) {
            self.hitted()
        }
        
        if collisions.matches(.bullet, .killing) {
            print("bvghuijk")
        }
        if collisions.matches(.bullet, .ground) {
            print("hgfsd")
        }
        if collisions.matches(.bullet, .player) {
            print("grefwd")
        }
    }
    
    
    
    
    
}


extension  GameScene {
    func spawnMeteor() {
        let node = SKSpriteNode(imageNamed: "meteor")
        node.name = "meteor"
        let camPos = camera?.position
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
        phBody.categoryBitMask = PhysicCategory.Mask.killing.bitmask
        phBody.collisionBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.ground.bitmask
        phBody.contactTestBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.ground.bitmask
        phBody.fieldBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.ground.bitmask
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
