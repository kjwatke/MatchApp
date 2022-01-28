//
//  SoundManager.swift
//  MatchApp
//
//  Created by Kevin  Watke on 1/27/22.
//

import Foundation
import AVFoundation

class SoundManager {
	
	static var audioPlayer: AVAudioPlayer?
	
	enum SoundAffect {
		case flip
		case match
		case nomatch
		case shuffle
	}
	
	
	static func playSound(effect: SoundAffect) {
		
		var soundFilename = ""
		
		switch effect {
			case .flip:
				soundFilename = "cardflip"
				break
			case .match:
				soundFilename = "dingcorrect"
				break
			case .nomatch:
				soundFilename = "dingwrong"
				break
			case .shuffle:
				soundFilename = "shuffle"
				break
		}
		
		// Get path to sound resource
		let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: ".wav")
		
		// Check that it is not nil
		guard let bundlePath = bundlePath else {
			return
		}
		
		// Get the bundle path for the resource
		let url = URL(fileURLWithPath: bundlePath)
		
		do {
			// Create the aduio player
			SoundManager.audioPlayer = try AVAudioPlayer(contentsOf: url)
			
			// Play the sound effect
			audioPlayer?.play()
		}
		catch {
			print("Couldn't create an audio player")
			return
		}
		
	}
}
