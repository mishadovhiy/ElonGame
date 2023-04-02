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


class PlayerState:GKState {
    unowned var playerNode:SKNode
    init(playerNode: SKNode) {
        self.playerNode = playerNode
        super.init()
    }
}

class JumpingState:PlayerState {
    var hasFinnished:Bool = false
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
 //       if hasFinnished && stateClass is LandingState.Type { return true }
        return true
    }
    let textures: Array<SKTexture> = (0..<2).compactMap({ SKTexture.init(imageNamed: "jump/\($0)")})
    lazy var action = { SKAction.animate(with: self.textures, timePerFrame: 0.1) }()

    
    override func didEnter(from previousState: GKState?) {
        print("jumpingg")
        self.playerNode.removeAction(forKey: PlayerSTateKeys.characterAnimationKey)
        self.playerNode.run(action, withKey: PlayerSTateKeys.characterAnimationKey)
        
        hasFinnished = false
        playerNode.run(.applyForce(CGVector(dx: 0, dy: 350), duration: 0.1))
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: {_ in
            self.hasFinnished = true
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
        self.playerNode.removeAction(forKey: PlayerSTateKeys.characterAnimationKey)
        self.playerNode.run(action, withKey: PlayerSTateKeys.characterAnimationKey)
    }
}

class StunnedState:PlayerState {
    
}
