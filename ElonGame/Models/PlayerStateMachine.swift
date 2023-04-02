//
//  PlayerStateMachine.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 02.04.2023.
//

import Foundation
import GameplayKit

class PlayerSTateKeys {
    fileprivate let characterAnimationKey = "Sprite Animation"

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
        return true
    }
    override func didEnter(from previousState: GKState?) {
        print("jumpingg")
        hasFinnished = false
        playerNode.run(.applyForce(CGVector(dx: 0, dy: 230), duration: 0.1))
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: {_ in
            self.hasFinnished = true
        })
    }
}


