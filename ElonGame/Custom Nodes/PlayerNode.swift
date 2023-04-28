//
//  PlayerNode.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 27.04.2023.
//

import SpriteKit

class PlayerNode: SKSpriteNode {
    private let regularSpeed: CGFloat = 5
    var walkingSpeed:CGFloat {
        isSuperSpeed ? 15 : regularSpeed
    }
    var isSuperSpeed:Bool = false
    
    private var timer:Timer?
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
}
