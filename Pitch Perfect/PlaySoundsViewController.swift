//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Omar Osorio on 3/28/15.
//  Copyright (c) 2015 Kioru. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var stopButton: UIButton!
    
    var receivedAudio:RecordedAudio!
    
    var audioPlayer:AVAudioPlayer!
    var audioPlayerNode:AVAudioPlayerNode!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.prepareToPlay()
        audioPlayer.enableRate = true
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        audioEngine.attachNode(audioPlayerNode)
        
        stopButton.hidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowSound(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        stopButton.hidden = false
        
        audioPlayer.currentTime = 0
        audioPlayer.rate = 0.5
        audioPlayer.play()
        audioPlayer.delegate = self
    }

    @IBAction func playFastSound(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        stopButton.hidden = false
        
        audioPlayer.currentTime = 0
        audioPlayer.rate = 2.0
        audioPlayer.play()
    }
    
    @IBAction func stopSound(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        stopButton.hidden = true
        
        audioPlayer.currentTime = 0
    }
    
    @IBAction func playChipmunkSound(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitchValue: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioPlayerNode.stop()
        stopButton.hidden = false
        
        let timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitchValue
        
        audioEngine.attachNode(timePitch)
        audioEngine.connect(audioPlayerNode, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        stopButton.hidden = true
    }

}
