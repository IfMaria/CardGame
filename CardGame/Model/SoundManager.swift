//
//  SoundManager.swift
//  CardGame
//
//  Created by Maria Kramer on 16.02.2021.
//

import Foundation
import AVFoundation

class SoundManager {

    var audioPlayer:AVAudioPlayer?
 
    enum SoundEffect {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSound(effect: SoundEffect) {
        
        var soundFilename = ""
        
        switch effect {
        
            case .flip:
                soundFilename = "cardflip"
            case .match:
                soundFilename = "dingcorrect"
            case .nomatch:
                soundFilename = "dingwrong"
            case .shuffle:
                soundFilename = "shuffle"
        
        }
        
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: ".wav")
        
        guard bundlePath != nil else {
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        }
        catch {
            print("Couldn't create an audio player")
            return
        }
    }
}
