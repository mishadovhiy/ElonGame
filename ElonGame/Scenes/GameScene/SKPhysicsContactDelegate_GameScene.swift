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
                playerState.enter(LandingState.self)
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
            //here
            if let enemy = contact.matched(name: "enemy") as? PlayerNode,
               let bullet = contact.matched(name: "bullet") as? BulletNode,
               !bullet.touchedEnemy
            {
                bullet.touchedEnemy = true
                print("rvfec")
                enemy.bulletTouched()
            }
        }
        if collisions.matches(.bullet, .all) {
            print("bullet in something")
            
        }
        
        if collisions.matches(.player, .all) {
            print("refrwdf")
        }
        
        if collisions.matches(.player, .player) {
            print("hrtegrfwedas")
        }
        
        
    }

}

