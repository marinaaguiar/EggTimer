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
    
    var player: AVAudioPlayer!
    
    @IBOutlet var countDownLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let eggTimes = ["Soft": 5 * 60, "Medium": 7 * 60, "Hard": 12 * 60]
    
    var totalTime = 30
    var secondsPassed = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction
    func hardnessSelected(_ sender: UIButton) {
        
        let hardness = sender.currentTitle!
        totalTime = eggTimes[hardness]!
        
        progressBar.progress = 0.00
        secondsPassed = 0
        
        titleLabel.text = hardness
        
        stopTimer()
        startTimer(with: totalTime)
        
        countDownLabel.text = convertToMinutes(seconds: totalTime)
        
        
    }
    
    
    @IBAction func stopSelected(_ sender: UIButton) {
        stopTimer()
    }
    
    @IBAction func resumeSelected(_ sender: UIButton) {
        resumeTimer()
    }
    
    
    func startTimer(with time: Int) {
        
        totalTime = time
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateCounter),
                                     userInfo: nil,
                                     repeats: true)
        
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func resumeTimer() {
        stopTimer()
        startTimer(with: totalTime)
    }
    
    func convertToMinutes(seconds: Int) -> String {
        
        let secondsFormatter = DateComponentsFormatter()
        secondsFormatter.allowedUnits = [.minute, .second]
        secondsFormatter.unitsStyle = .positional
        secondsFormatter.zeroFormattingBehavior = .pad
        
        return secondsFormatter.string(from: TimeInterval(seconds))!
    }
    
    @objc
    func updateCounter() {
        //example functionality
        if secondsPassed < totalTime {
            
            secondsPassed += 1
            
            let percentageProgress = Float(secondsPassed) / Float(totalTime)
            
            progressBar.progress = percentageProgress
            
            print(percentageProgress)
            
            countDownLabel.text = convertToMinutes(seconds: totalTime - secondsPassed)
            
        } else {
            
            stopTimer()
            countDownLabel.text = ""
            titleLabel.text = "Your egg is ready!"
            
            let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
            
        }
    }
}


