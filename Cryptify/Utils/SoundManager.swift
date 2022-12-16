//
//  SoundManager.swift
//  Cryptify
//
//  Created by Jan Babák on 30.11.2022.
//

import Foundation
import AVKit
import SwiftUI

//sound manager implemented as singleton patter
final class SoundManager {
    static let instance = SoundManager()
    static let soundOnUserDefaultsKey = "soundOn"
    
    @AppStorage(SoundManager.soundOnUserDefaultsKey) static private(set) var soundOn = false
    
    private var player: AVAudioPlayer?
    
    enum SoundOption: String {
        case transitionLeft
        case transitionRight
        case tab
    }
    
    func playSound(sound: SoundOption) {
        guard SoundManager.soundOn else { return }
        
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".wav") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("[PLAY SOUND ERROR]", error.localizedDescription)
        }
    }
    
    func playTab() {
        playSound(sound: SoundOption.tab)
    }
    
    func playTransitionRight() {
        playSound(sound: SoundOption.transitionLeft)
    }
    
    func playTransitionLeft() {
        playSound(sound: SoundOption.transitionLeft)
    }
}
