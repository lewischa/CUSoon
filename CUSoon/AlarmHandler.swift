//
//  AlarmHandler.swift
//  CUSoon
//
//  Created by Chad Lewis on 4/23/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import Foundation
import AVFoundation

struct AlarmHandler {
    let tone: AVAudioPlayer
    
    init() {
        do {
            tone = try AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: "piano_beat_mix", ofType: "wav")!) as URL)
        } catch {
            tone = AVAudioPlayer()
        }
    }
    
    func play() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        DispatchQueue.main.async {
            self.tone.numberOfLoops = 2
            self.tone.play()
        }
    }
    
    func pause() {
        tone.stop()
    }
    
    func restart() {
        tone.stop()
        tone.currentTime = 0
        tone.play()
    }
    
    func stop() {
        tone.stop()
        tone.currentTime = 0
    }
}
