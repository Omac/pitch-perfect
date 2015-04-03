//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Omar Osorio on 3/14/15.
//  Copyright (c) 2015 Kioru. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
	var recordedAudio:RecordedAudio!
    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        statusLabel.text = "Recording..."
        stopButton.hidden = false
        recordButton.enabled = false
        
        var currentTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentTime) + ".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.meteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(sender: UIButton) {
        statusLabel.text = "Tap to Record"
        stopButton.hidden = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
		if(flag){
			recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
			self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
		}else{
			println("Recording was not successful")
			recordButton.enabled = true
			stopButton.hidden = true
		}
    }
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if(segue.identifier == "stopRecording"){
			let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
			playSoundsVC.receivedAudio = sender as RecordedAudio
		}
	}
}

