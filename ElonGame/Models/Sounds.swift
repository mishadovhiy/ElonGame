//
//  Sounds.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 24.04.2023.
//

import Foundation
import SpriteKit

enum Sound: String {
    case reward, meteorFalling, levelUp, jump, hit
    
    var action:SKAction {
        return SKAction.playSoundFileNamed(self.rawValue + "Sound.wav", waitForCompletion: false)
    }
}

extension SKAction {
    static let playGameMusic:SKAction = .repeatForever(.playSoundFileNamed("music.wav", waitForCompletion: true))
}
