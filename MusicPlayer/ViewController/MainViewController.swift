//
//  MainViewController.swift
//  MusicPlayer
//
//  Created by Bindu on 14/08/17.
//  Copyright © 2017 Xminds. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var mp3Player:MP3Player?
    var timer:Timer?
    
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackTime: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mp3Player = MP3Player()
        setupNotificationCenter()
        setTrackName()
        updateViews()
    }
    
    @IBAction func playSong(sender: AnyObject) {
        mp3Player?.play()
        startTimer()
    }
    @IBAction func stopSong(sender: AnyObject) {
        mp3Player?.stop()
        timer?.invalidate()
    }
    
    @IBAction func pauseSong(sender: AnyObject) {
        mp3Player?.pause()
        timer?.invalidate()
    }
    
    @IBAction func playNextSong(sender: AnyObject) {
        mp3Player?.nextSong(songFinishedPlaying: false)
        startTimer()
    }
    
    @IBAction func setVolume(sender: UISlider) {
        mp3Player?.setVolume(volume: sender.value)
    }
    
    @IBAction func playPreviousSong(sender: AnyObject) {
        mp3Player?.previousSong()
        startTimer()
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: Selector(("updateViewsWithTimer:")), userInfo: nil, repeats: true)
    }
    
    func updateViewsWithTimer(theTimer: Timer){
        updateViews()
    }
    
    func updateViews(){
        trackTime.text = mp3Player?.getCurrentTimeAsString()
        if let progress = mp3Player?.getProgress() {
            progressBar.progress = progress
        }
    }
    
    func setTrackName(){
        trackName.text = mp3Player?.getCurrentTrackName()
    }
    
    func setupNotificationCenter(){
        NotificationCenter.default.addObserver(self,selector:#selector(MainViewController.setTrackName), name:NSNotification.Name(rawValue: "SetTrackNameText"),
                                                       object:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
