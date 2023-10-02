//
//  PlayerNode.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 27.04.2023.
//

import SpriteKit
import GameplayKit
protocol PlayerNodeProtocol {
    func enemyDied()
}
class PlayerNode: SKSpriteNode {
    var lifes = 8
    private let regularSpeed: CGFloat = 5
    var isFacingRight = true
    var walkingSpeed:CGFloat {
        let isSuperSpeed = specialAbility[.superSpeed] ?? false
        let isEnemy = self as? EnemyNode != nil
        let enemySpeed = (1.2 + Double((difficulty.n * 3) / 10))
        return (isEnemy ? enemySpeed : regularSpeed) * (isSuperSpeed ? 1.7 : 1)
    }
    private var timer:[String:Timer] = [:]
    var canSpawnBullets = true
    var state:GKStateMachine!
    var delegate:PlayerNodeProtocol?

    var specialAbility:[PlayerAbility:Bool] = [:]
    
    func startSuper(_ value:PlayerAbility) -> Bool {
        if value == .superInvisible {
            self.invincible(time: 15)
            return true
        }
        if value == .superSpeed && !(DB.holder?.settings.game.canFast ?? false) {
            return false
        }
        if timer[value.rawValue] == nil {
            specialAbility.updateValue(true, forKey: value)
            startSuper(key: value.rawValue, time: value == .superShoot ? 25 : 15, ended: {
                self.specialAbility.updateValue(false, forKey: value)
            })
            return true
        } else {
            return false
        }
    }
    override var texture: SKTexture? {
        get {
            return super.texture
        }
        set {
            super.texture = newValue
            if updatingDamage {
                updatingDamage = false
            } else {
                setDamaged()
            }
        }
    }
    
    private func setDamaged() {
        self.damages.forEach({
            self.removeShapeFromTexture(shapeRect: $0, set: false)

        })
    }
    
    override func run(_ action: SKAction, withKey key: String) {
        super.run(action, withKey: key)
        
        if key == PlayerSTateKeys.characterAnimationKey {
            Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: { _ in
                self.setDamaged()
            })
            
        }
    }
    
    private var damages:[CGRect] = []
    var updatingDamage = false
    override func removeShapeFromTexture(shapeRect: CGRect, set:Bool = true) {
        if set {
            self.damages.append(shapeRect)
        }
        super.removeShapeFromTexture(shapeRect: shapeRect, set: set)
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
        let isBig = specialAbility[.superShoot] ?? false
        Bullet.size = .init(width: isBig ? 50 : 20, height: isBig ? 45 : 15)
        Bullet.position = CGPoint(x: self.position.x + (50 * (isFacingRight ? 1 : -1)), y: self.position.y)
        let toX = (isBig ? 100 : 20) * (isFacingRight ? 1 : -1)
        //let action = SKAction.moveTo(x: toX, duration: 3)
        let action = SKAction.applyImpulse(.init(dx: toX, dy: 0), at: .init(x: 3, y: 0), duration: isBig ? 3 : 1)
        
        // SKAction.applyForce(.init(dx: 5 * (isFacingRight ? 1 : -1), dy: 0), duration: 10)
        let actionDone = SKAction.run {
            Bullet.remove()
        }
        Bullet.run(SKAction.sequence([action, actionDone]))
        
        Bullet.physicsBody = SKPhysicsBody(rectangleOf: Bullet.size)
        Bullet.physicsBody?.allowsRotation = false
        Bullet.physicsBody?.categoryBitMask = PhysicCategory.Mask.bullet.bitmask
        Bullet.physicsBody?.collisionBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.all.bitmask
        Bullet.physicsBody?.contactTestBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.all.bitmask
        Bullet.physicsBody?.fieldBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.all.bitmask
        Bullet.physicsBody?.affectedByGravity = false
        Bullet.physicsBody?.isDynamic = true
        GameViewController.shared?.scene?.addChild(Bullet)
    }
    
    func bulletTouched(contact:SKPhysicsContact? = nil) {
        hitted()
        let isRight = (contact?.contactPoint ?? .zero).x - self.position.x > 0
     //   shootingFromRight = isRight
     //   bulletTimerSetted?.invalidate()
        if isRight {
            startSuperTimer(key: .shootReceived,
                            time: 20.0 + Double(5 * difficulty.n))

        }
    }
    
    
    
    func die() {
        self.died = true
        let dieAction = SKAction.move(to: CGPoint(x: -300, y: 0), duration: 0.1)
        
        self.run(dieAction)
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { _ in
            
            self.delegate?.enemyDied()
            self.removeFromParent()
        })
        
    }
    var died = false
    //var isMeteorHitted = false
    
    func meteorHit(by:SKSpriteNode? = nil) {
        hitted(node: by)
        
    }
    func hitPower(node:SKSpriteNode?) -> Int {
        if let node = node {
            if let bullet = node as? BulletNode {
                return (bullet.player?.difficulty.n ?? 0) + (bullet.isBig ? 3 : 1)
            } else {
                return 1
            }
        } else {
            return 1
        }
    }
    
    func hitted(node:SKSpriteNode? = nil) {
      //  isMeteorHitted = true
        specialAbility.updateValue(true, forKey: .meteorReceived)
        state.enter(StunnedState.self)
        lifes -= hitPower(node: node)
        if lifes != 0 {
            invincible()
        } else  {
            die()
        }
        
        if let enemy = self as? EnemyNode {
            enemy.scoreChanged(lifes)
        }
    }
    
    func invincible(time:TimeInterval = 2) {
        self.physicsBody?.categoryBitMask = 0
        self.startSuperTimer(key: .meteorReceived, time: time, ended: {
            self.physicsBody?.categoryBitMask = 2
        })

        
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


    var difficulty:Difficulty = .init()
    func sceneMoved() {
        state = GKStateMachine(states: [
            JumpingState(playerNode: self, stateNum: 1),
            WalkingState(playerNode: self, stateNum: 3),
            IdleState(playerNode: self, stateNum: 4),
            LandingState(playerNode: self, stateNum: 5),
            StunnedState(playerNode: self, stateNum: 6)
        ])
        state.enter(IdleState.self)
        if let _ = self as? EnemyNode {
          //  difficulty = .init()
            self.lifes = 2 * (difficulty.n + 1)
        } else {
            difficulty = .light
        }
    }

    enum PlayerAbility:String {
        case superSpeed = "superSpeed"
        case invisible = "invisible"
        case superInvisible = "superInvisible"

        case superShoot = "superShoot"
        case shootReceived = "shootReceived"
        case meteorReceived = "meteorReceived"
    }

    
    
    private func startSuper(key:String, time:TimeInterval, ended:(()->())? = nil) {
        let timer = Timer.scheduledTimer(withTimeInterval: time, repeats: false, block: { t in
            self.timer[key]?.invalidate()
            self.timer.removeValue(forKey: key)
            t.invalidate()
            if let ended = ended {
                ended()
            }
        })
        self.timer.updateValue(timer, forKey: key)
    }
    
    private func startSuperTimer(key:PlayerAbility, time:TimeInterval, ended:(()->())? = nil) {
        self.startSuper(key: key.rawValue, time: time, ended: ended)
    }
    
    func update(_ currentTime: TimeInterval) {
        if self.position.y ?? 0 <= -5000 && !died {
            print("rgefdwes")
            self.die()
        }
    }
    
}

