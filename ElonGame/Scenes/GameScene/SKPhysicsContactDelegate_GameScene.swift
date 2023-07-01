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
            if let _ = contact.matched(name: "player") {
                player?.state.enter(LandingState.self)
                print(contact.collisionImpulse, " fdyjgukhj")
                if contact.collisionImpulse >= 190 {
                    self.hitted()
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
               let _ = contact.matched(name: "player"),
               !node.touched
            {
                if let _ = node as? JewelSpeed {
                    let _ = player?.startSuperSpeed()
                        removeJewel(node)
                } else {
                    removeJewel(node)
                }
                
            }
            
        }
        
        if collisions.matches(.player, .killing) {
            if let _ = contact.matched(name: "player") {
                self.hitted()
            } else if let enemy = contact.matched(name: "enemy") as? PlayerNode {
                enemy.meteorHit()
            }
            
        }
        
        if collisions.matches(.bullet, .killing) {
            print("bvghuijk")
        }
        if collisions.matches(.bullet, .ground) {
            print("hgfsd")
        }
        if collisions.matches(.bullet, .bullet) {
            print("hgfsd")
            if let bullet = contact.matched(name: "bullet") as? BulletNode {
                bullet.remove()
            }
            if let bullet = contact.matched(name: "bullet") as? BulletNode {
                bullet.remove()
            }
        }
        
        if collisions.matches(.bullet, .player) {
            if let bullet = contact.matched(name: "bullet") as? BulletNode,
                !bullet.touchedEnemy {
                bullet.touchedEnemy = true
                bullet.remove()
                if let enemy = contact.matched(name: "enemy") as? PlayerNode {
                    
                    enemy.bulletTouched(contact: contact)
                    
                } else if let _ = contact.matched(name: "player") as? PlayerNode {
                    hitted(by: bullet)
                }
                
            }
        }
        if collisions.matches(.bullet, .all) {
            print("bullet in something")
            
        }
        
        if collisions.matches(.player, .all) {
            print("refrwdf")
        }
        
        if collisions.matches(.player, .player) {
            if let player = contact.matched(name: "player") as? PlayerNode,
               let enemy = contact.matched(name: "enemy") as? PlayerNode
            {
                if enemy.position.y.range(30, in: player.position.y) {
                    self.hitted()
                } else {
                    enemy.meteorHit()
                }
                
                
            }
        }

    }

}

