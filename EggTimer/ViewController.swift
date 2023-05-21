//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
	
	let timers = ["Soft": 300, "Medium": 420, "Hard": 720]
	
	var player: AVAudioPlayer?
	
	func playSound(soundName: String) {
		guard let path = Bundle.main.path(forResource: soundName, ofType:"mp3") else {
			print("Sound file \(soundName) not found")
			return
		}
		let url = URL(fileURLWithPath: path)
		
		do {
			player = try AVAudioPlayer(contentsOf: url)
			player?.play()
			
		} catch let error {
			print("Error playing sound: \(error.localizedDescription)")
		}
	}
	
	@IBOutlet weak var progressBar: UIProgressView!
	@IBOutlet weak var titleDone: UILabel!
	
	var timer: Timer?
	var remainingTime: Int = 0
	var originalTime: Int = 0
	
	@IBAction func hardnessSelected(_ sender: UIButton) {
		if let hardness = sender.currentTitle, let time = timers[hardness] {
			startTimer(with: time, hardness: hardness)
		}
	}
	
	func startTimer(with time: Int, hardness: String) {
		remainingTime = time
		originalTime = time
		progressBar.progress = 0.0
		timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
		print("Timer started for \(hardness) (\(time) seconds)")
	}
	
	@objc func updateTimer() {
		if remainingTime > 0 {
			remainingTime -= 1
			let progress = Float(originalTime - remainingTime) / Float(originalTime)
			progressBar.progress = progress
			print("\(remainingTime) seconds remaining")
		} else {
			stopTimer()
			playSound(soundName: "alarm_sound")
			titleDone.text = "DONE!"
			print("Timer ended")
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
				self.titleDone.text = "How do you like your eggs?"
			}
		}
	}

	
	func stopTimer() {
		timer?.invalidate()
		timer = nil
	}
}


