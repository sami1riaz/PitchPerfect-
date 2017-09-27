//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Sami Riaz on 2017-06-06.
//  Copyright © 2017 Sami Riaz. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var recordingButton: UIButton!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false // at the start, stopRecordingButton can't be pressed
        // Do any additional setup after loading the view, typically from a nib.
    }

    

    @IBAction func recordAudio(_ sender: AnyObject) { //when recordButton is pressed
        recordingLabel.text = "Recording in Progress"
        stopRecordingButton.isEnabled = true    // stopRecordingButton is enabled
        recordingButton.isEnabled = false          // and recordingButton is disabled (can't be pressed again)
    
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        //print(filePath ?? <#default value#>)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    
    
    }

    @IBAction func stopRecording(_ sender: AnyObject) {   // stopRecordingButton is pressed
        
        recordingButton.isEnabled = true               //recordingButton can now be pressed
        stopRecordingButton.isEnabled = false       // stop recordingButton cannot be pressed
        recordingLabel.text = "Tap to Record"
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
        print("Recording was not successful")
    }
    
      
}
    //  before Storyboard executes the segue, it will call our RecordSoundsViewController to prepare for that segue. In preparing, the RecordSoundsViewController will store away the path to the recorded audio.

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" { // check if this is the segue we want
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}
