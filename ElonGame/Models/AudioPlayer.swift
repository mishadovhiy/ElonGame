//
//  AudioPlayer.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 25.04.2023.
//

import UIKit
import AVFoundation

class AudioPlayer:AVAudioPlayer {
    convenience init(sound:Sound, valume:Float = 0.1) {
        
        guard let url = Bundle.main.url(forResource: sound.name, withExtension: sound.type.rawValue) else {
            self.init()
            return
        }
        do {
            //try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            //try AVAudioSession.sharedInstance().setCategory(.playback, options: .duckOthers)
            try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            try self.init(contentsOf: url, fileTypeHint: sound.type.rawValue)
            self.volume = valume//0.05
         //   self.init()
        } catch let error {
            print(error.localizedDescription, " AVAudioPlayer")
            self.init()
           
        }
    }
    
    
    
    func playSound() {
        play()
    }
    
    struct Sound {
        let name:String
        var type:File = .wav

        enum File :String {
            case mp3 = "mp3"
            case mp4 = "mp4"
            case wav = "wav"
        }
    }
}
