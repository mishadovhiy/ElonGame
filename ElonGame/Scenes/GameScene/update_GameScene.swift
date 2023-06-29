//
//  update_GameScene.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 14.04.2023.
//

import SpriteKit
import GameplayKit

extension GameScene {
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        let deltaTime = currentTime - previousTimeInterval
        previousTimeInterval = currentTime

        moveCamera()
        moveBackground()
        movePlayer(deltaTime)
        
        if player?.position.y ?? 0 <= -5000 {
            self.showDieScene()
        }
    }
    
    
    private func movePlayer(_ deltaTime:TimeInterval) {
        guard let joystickKnob = joystickKnob else { return }
        player?.move(xPosition: joystickKnob.position.x, deltaTime: deltaTime)
    }
    
    private func moveCamera() {
        cameraNode?.position.x = player?.position.x ?? 0
        let min:CGFloat = -20
        let y = player?.position.y ?? 0
        cameraNode?.position.y = min >= y ? min : y
        print(cameraNode?.position.y, " hujikolp")
        print(flour?.position.y, " gvhujikl")
        print(flour?.frame.height, " hgrfeds")
        let camPos = cameraNode?.position ?? .init(x: 0, y: 0)
        joystick?.position = .init(x: camPos.x - 300,
                                   y: camPos.y - 100)
        
        
        scoreLabel.position = .init(x: camPos.x + 310, y: camPos.y + 140)
    }
    
    private func moveBackground() {
        self.mountinesAnimations([mount1, mount2, mount3])
        let starsAction = SKAction.moveTo(x: cameraNode?.position.x ?? 0, duration: 0)
        self.stars?.run(starsAction)
        let moonAction = SKAction.moveTo(x: cameraNode?.position.x ?? 0, duration: 0)
        self.moon?.run(moonAction)
    }
    func mountinesAnimations(_ nodes:[SKNode?]) {
        let player = player?.position.x ?? 0
        var val:CGFloat = 10
        nodes.forEach({
            $0?.run(.moveTo(x: player / (val * -1) , duration: 0))
            val += val
        })
    }
}


