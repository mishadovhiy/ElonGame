//
//  touchesBegan_GameScene.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 02.04.2023.
//

import UIKit

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let joystic = self.joystick,
              let knob = joystickKnob else { return }
        touches.forEach { touch in
            let location = touch.location(in: joystic)
            joystickAction = knob.frame.contains(location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let joystic = self.joystick,
              let knob = joystickKnob else { return }
        if !joystickAction { return }
        
        touches.forEach { touch in
            let position = touch.location(in: joystic)
            let lenght = sqrt(pow(position.y, 2) + pow(position.x, 2))
            let angle = atan2(position.y, position.x)
            
            if knobRadius > lenght {
                knob.position = position
            } else {
                knob.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius)
            }
        }
    }
    
    func touchEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = self.joystick,
              let knob = joystickKnob else { return }
        if knob.position != .init(x: 0, y: 0) {
            self.resetKnobPosition()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
         super.touchesEnded(touches, with: event)
        self.touchEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.touchEnded(touches, with: event)
    }
}

