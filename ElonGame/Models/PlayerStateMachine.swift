//
//  PlayerStateMachine.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 02.04.2023.
//

import Foundation
import GameplayKit

class PlayerSTateKeys {
    static let characterAnimationKey = "Sprite Animation"
    
}

protocol PlayerStateProtocol {
    func endJumping()
}
class PlayerState:GKState {
    unowned var playerNode:SKNode
    var stateNum:Int = 0
    var num:Int = 0
    var delegate:PlayerStateProtocol?
    init(playerNode: SKNode, stateNum:Int) {
        self.playerNode = playerNode
        self.num = stateNum
        super.init()
    }
}

class JumpingState:PlayerState {
    var hasFinnished:Bool = false
    var secondJump = false
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is JumpingState.Type && !secondJump {
            print("JumpingState")
            secondJump = true
            (playerNode as? PlayerNode)?.jump()
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {_ in
                self.secondJump = false
            })
            return false
                                 }
        if stateClass is StunnedState.Type { return true }

        if hasFinnished && stateClass is LandingState.Type { return true }
        return false
    }
    let textures: Array<SKTexture> = (0..<2).compactMap({ SKTexture.init(imageNamed: "jump/\($0)")})
    lazy var action = { SKAction.animate(with: self.textures, timePerFrame: 0.1) }()
    
    override func didEnter(from previousState: GKState?) {
        print("jumpingg")
        
        self.playerNode.removeAction(forKey: PlayerSTateKeys.characterAnimationKey)
        self.playerNode.run(action, withKey: PlayerSTateKeys.characterAnimationKey)
        self.stateNum = 2
        hasFinnished = false
        (playerNode as? PlayerNode)?.jump(isSecond: true)

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: {_ in
            self.hasFinnished = true
            self.stateNum = 1
            self.delegate?.endJumping()
        })
    }
}


class LandingState:PlayerState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is LandingState.Type,is JumpingState.Type:return false
        default: return true
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        self.stateNum = 4
        stateMachine?.enter(IdleState.self)
    }
}

class IdleState:PlayerState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is LandingState.Type, is IdleState.Type:return false
        default: return true
        }
    }
    
    let textrures = SKTexture(imageNamed: "player/0")
    lazy var action = { SKAction.animate(with: [self.textrures], timePerFrame: 0.1) }()
    
    override func didEnter(from previousState: GKState?) {
        self.stateNum = 0
        self.playerNode.removeAction(forKey: PlayerSTateKeys.characterAnimationKey)
        self.playerNode.run(action, withKey: PlayerSTateKeys.characterAnimationKey)
    }
}

class WalkingState:PlayerState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is LandingState.Type, is WalkingState.Type:return false
        default: return true
        }
    }
    
    let textures: Array<SKTexture> = (0..<6).compactMap({ SKTexture.init(imageNamed: "player/\($0)")})
    lazy var action = { SKAction.repeatForever(.animate(with: self.textures, timePerFrame: 0.1)) }()
    
    override func didEnter(from previousState: GKState?) {
        self.stateNum = 0
        self.playerNode.removeAction(forKey: PlayerSTateKeys.characterAnimationKey)
        self.playerNode.run(action, withKey: PlayerSTateKeys.characterAnimationKey)
        
    }
}

class StunnedState:PlayerState {
    var isStunned : Bool = false
    let action = SKAction.repeat(.sequence([
        .fadeAlpha(to: 0.5, duration: 0.01),
        .wait(forDuration: 0.25),
        .fadeAlpha(to: 1.0, duration: 0.01),
        .wait(forDuration: 0.25),
    ]), count: 5)
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        if isStunned { return false }
        switch stateClass {
            
        case is IdleState.Type: return true
        default: return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        isStunned = true
        
        playerNode.run(action)
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
            self.isStunned = false
            self.stateMachine?.enter(IdleState.self)
        }
    }
}


enum Difficulty:Int {
    case soft, light, lightMedium, medium, darkMedium, lightHard, hard, darkHard
    

    init() {
        self = .init(rawValue: .random(in: 0..<8)) ?? .medium

    }
    
    var n:Int {
        switch self {
        case .soft, .light: return 0
        case .medium, .lightMedium, .darkMedium:return 1
        case .hard, .darkHard, .lightHard: return 2

        }
    }
}
