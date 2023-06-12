//
//  ViewController.swift
//  TimerApp
//
//  Created by Jack Odom on 6/11/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startTime()
        timerOn = false
        musicPlaying = false
        startStopButton.backgroundColor = UIColor.green
        changeBackground()
        guard let audioFileURL = Bundle.main.url(forResource: "cottagecore", withExtension: "mp3") else {
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
        } catch {
            print("Error initializing audio player: \(error.localizedDescription)")
        }
    }
    
    @IBOutlet weak var starryNight: UIImageView!
    @IBOutlet weak var sunnyDay: UIImageView!
    
    var audioPlayer: AVAudioPlayer?
    
    var timer : Timer?
    
    var timer2: Timer?
    
    var timeLeft: Int?
    
    var timerOn: Bool?
    
    var musicPlaying: Bool?
    
    var selectedTime: Date?
    
    @IBAction func selectDate(_ sender: UIDatePicker) {
        let picker = sender as UIDatePicker
        selectedTime = picker.date
    }
    
    func startTime() -> Void {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    
    
    @objc func updateTimer() -> Void {
        if timerOn! {
            if timeLeft! >= 0 {
                let hour = (timeLeft!) / 3600
                let minute = (timeLeft! % 3600) / 60
                let seconds = (timeLeft! % 3600) % 60
                displayTimeRemaining.text = "Time Remaining "
                if hour >= 10 {
                    displayTimeRemaining.text! += String(hour) + ":"
                }
                else {
                    displayTimeRemaining.text! += "0" + String(hour) + ":"
                }
                if minute >= 10 {
                    displayTimeRemaining.text! += String(minute) + ":"
                }
                else {
                    displayTimeRemaining.text! += "0" + String(minute) + ":"
                }
                if seconds >= 10 {
                    displayTimeRemaining.text! += String(seconds)
                }
                else {
                    displayTimeRemaining.text! += "0" + String(seconds)
                }
                timeLeft! -= 1
            }
            else {
                // play sound
                timerOn = false
                musicPlaying = true
                timer2?.invalidate()
                audioPlayer!.play()
                startStopButton.setTitle("Stop Music", for: .normal)
                startStopButton.backgroundColor = UIColor.red
            }
        }
        else {
            displayTimeRemaining.text = "Time Remaining: 00:00:00"
        }
    }
    
    @IBOutlet weak var startStopButton: UIButton!
    
    @IBAction func startTimer(_ sender: Any) {
        if !timerOn!{
            if !musicPlaying!{
                startStopButton.backgroundColor = UIColor.red
                startStopButton.setTitle("Stop Timer", for: .normal)
                let calendar = Calendar.current
                if selectedTime == nil  {
                    selectedTime = Date()
                }
                let hours = calendar.component(.hour, from: selectedTime!)
                let minutes = calendar.component(.minute, from: selectedTime!)
                timeLeft = (hours*3600) + (minutes*60)
                timerOn = true
                timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
                timer2!.fire()
            }
            else {
                startStopButton.backgroundColor = UIColor.green
                startStopButton.setTitle("Start Timer", for: .normal)
                musicPlaying = false
                audioPlayer!.stop()
            }
        }
        else {
            startStopButton.backgroundColor = UIColor.green
            startStopButton.setTitle("Start Timer", for: .normal)
            timer2?.invalidate()
            displayTimeRemaining.text = "Time Remaining 00:00:00"
            timerOn = false
        }
    }
    
    @IBAction func stopTimer(_ sender: Any) {
    }
    
    @objc func updateTime() -> Void {
        let date = Date()
        let format = DateFormatter()
        format.timeStyle = .long
        format.dateStyle = .long
        displayTime.text = format.string(from: date)
        changeBackground()
    }
    
    func changeBackground() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let isAM = hour >= 0 && hour < 12
        
        if isAM {
            starryNight.isHidden = true
            sunnyDay.isHidden = false
        } else {
            starryNight.isHidden = false
            sunnyDay.isHidden = true
        }
    }
    @IBOutlet weak var displayTime: UILabel!
    
    
    @IBOutlet weak var displayTimeRemaining: UILabel!
}

