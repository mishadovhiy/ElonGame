//
//  SuperScene.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 01.07.2023.
//

import SpriteKit
import GameplayKit

class SuperScene:SKScene {
    override func sceneDidLoad() {
        super.sceneDidLoad()
        if name?.contains("GameOver") ?? false {
            GameViewController.shared?.gameOverPresented()
        } else {
            GameViewController.shared?.gameOverRemoved()
        }
    }
}
