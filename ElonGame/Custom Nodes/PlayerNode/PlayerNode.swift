//
//  PlayerNode.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 27.04.2023.
//

import SpriteKit
import GameplayKit
protocol PlayerNodeProtocol {
    func died()
}
class PlayerNode: SKSpriteNode {
    var lifes = 5
    private let regularSpeed: CGFloat = 5
    var isFacingRight = true
    var walkingSpeed:CGFloat {
        let isEnemy = self as? EnemyNode != nil

        return isEnemy ? 1.2 : (isSuperSpeed ? 10 : regularSpeed)
    }
    var isSuperSpeed:Bool = false
    private var timer:Timer?
    var canSpawnBullets = true
    var state:GKStateMachine!
    var shootingFromRight:Bool?
    var delegate:PlayerNodeProtocol?
    
    func startSuperSpeed() -> Bool {
        if timer == nil {
            isSuperSpeed = true
            timer = Timer.scheduledTimer(withTimeInterval: 7.0, repeats: false, block: { t in
                self.timer?.invalidate()
                self.timer = nil
                self.isSuperSpeed = false
            })
            return true
        } else {
            return false
        }
        
    }
    
    
    func spawnBullet(){
        if !canSpawnBullets { return }
        canSpawnBullets = false
        let Bullet = BulletNode(imageNamed: "fireBlue")
        if !isFacingRight {
            Bullet.zRotation = CGFloat(M_PI_2)*2
        }
        Bullet.player = self
        Bullet.name = "bullet"
        Bullet.color = .red
        Bullet.size = .init(width: 20, height: 15)
        Bullet.position = CGPoint(x: self.position.x + (30 * (isFacingRight ? 1 : -1)), y: self.position.y)
        
        let toX = 20 * (isFacingRight ? 1 : -1)
        //let action = SKAction.moveTo(x: toX, duration: 3)
        let action = SKAction.applyImpulse(.init(dx: toX, dy: 0), at: .init(x: 3, y: 0), duration: 1)
        
        // SKAction.applyForce(.init(dx: 5 * (isFacingRight ? 1 : -1), dy: 0), duration: 10)
        let actionDone = SKAction.run {
            Bullet.remove()
        }
        Bullet.run(SKAction.sequence([action, actionDone]))
        
        Bullet.physicsBody = SKPhysicsBody(rectangleOf: Bullet.size)
        Bullet.physicsBody?.allowsRotation = false
        Bullet.physicsBody?.categoryBitMask = PhysicCategory.Mask.bullet.bitmask
        Bullet.physicsBody?.collisionBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.ground.bitmask
        Bullet.physicsBody?.contactTestBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.ground.bitmask
        Bullet.physicsBody?.fieldBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.ground.bitmask
        Bullet.physicsBody?.affectedByGravity = false
        Bullet.physicsBody?.isDynamic = true
        GameViewController.shared?.scene?.addChild(Bullet)
    }
    
    
    func bulletTouched(contact:SKPhysicsContact? = nil) {
        hitted()
        let isRight = (contact?.contactPoint ?? .zero).x - self.position.x > 0
        shootingFromRight = isRight
    }
    
    func die() {
        let dieAction = SKAction.move(to: CGPoint(x: -300, y: 0), duration: 0.1)
        
        self.run(dieAction)
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { _ in
            self.died = true
            self.delegate?.died()
            self.removeFromParent()
        })
        
    }
    var died = false
    var isMeteorHitted = false
    func meteorHit() {
        isMeteorHitted = true

        hitted()
        
    }
    func hitted() {
        state.enter(StunnedState.self)
        lifes -= 1
        if lifes != 0 {
            invincible()
        } else  {
            die()
        }
    }
    
    func invincible() {
        self.physicsBody?.categoryBitMask = 0
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.isMeteorHitted = false
            self.physicsBody?.categoryBitMask = 2
        }
    }
    
    
    func jump(isSecond:Bool = false) {
        self.run(.applyForce(CGVector(dx: 0, dy: !isSecond ? 350 : 400), duration: 0.1))
        self.run(Sound.jump.action)
     //   state.enter(JumpingState.self)
    }
    
    func move(xPosition:CGFloat, deltaTime: TimeInterval, duration:TimeInterval = 0) {
        if floor(xPosition.positive) != 0 {
            state.enter(WalkingState.self)
        } else {
            state.enter(IdleState.self)
        }
        
        let move = SKAction.move(by: .init(dx: deltaTime * xPosition * walkingSpeed, dy: 0), duration: duration)

        let faceAction : SKAction!
        let movingRight = xPosition > 0
        let movingLeft = xPosition < 0
        if movingLeft && isFacingRight {
            isFacingRight = false
            let faceMovement = SKAction.scaleX(to: -1, duration: 0)
            faceAction = SKAction.sequence([move, faceMovement])
        } else if movingRight && !isFacingRight {
            isFacingRight = true
            let faceMovement = SKAction.scaleX(to: 1, duration: 0)
            faceAction = SKAction.sequence([move, faceMovement])
        } else {
            faceAction = move
        }
        self.run(faceAction)
    }


    func sceneMoved() {
        state = GKStateMachine(states: [
            JumpingState(playerNode: self, stateNum: 1),
            WalkingState(playerNode: self, stateNum: 3),
            IdleState(playerNode: self, stateNum: 4),
            LandingState(playerNode: self, stateNum: 5),
            StunnedState(playerNode: self, stateNum: 6)
        ])
        state.enter(IdleState.self)
    }

}
