  //
//  MP3Player.swift
//  MusicPlayer
//
//  Created by Bindu on 14/08/17.
//  Copyright © 2017 Xminds. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class MP3Player: NSObject, AVAudioPlayerDelegate {
    
    var player : AVAudioPlayer?
    var currentTrackIndex = 0
    var tracks :[MPMediaItem] = [MPMediaItem]()

    override init() {
        
        tracks = FileReader.readFiles()
        super.init()
        queueTrack()   
        
    }
    
    func queueTrack() {
        if (player != nil) {
            player = nil
        }
        
        let url = tracks[currentTrackIndex].assetURL
        
        // Removed deprecated use of AVAudioSessionDelegate protocol
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            player?.delegate = self
            player?.prepareToPlay()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "SetTrackNameText"), object: nil)
            
        } catch {
            print(error)
        }
    }
    
    func play() {
        if player?.isPlaying == false {
            player?.play()
        }
    }
    
    func stop(){
        if player?.isPlaying == true {
            player?.stop()
            player?.currentTime = 0
        }
    }
    
    func pause(){
        if player?.isPlaying == true{
            player?.pause()
        }
    }
    
    func nextSong(songFinishedPlaying:Bool){
        
        var playerWasPlaying = false
        if player?.isPlaying == true {
            player?.stop()
            playerWasPlaying = true
        }
        
        currentTrackIndex+=1
        if currentTrackIndex >= tracks.count {
            currentTrackIndex = 0
        }
        queueTrack()
        if playerWasPlaying || songFinishedPlaying {
            player?.play()
        }
    }
    
    func previousSong(){
        var playerWasPlaying = false
        if player?.isPlaying == true {
            player?.stop()
            playerWasPlaying = true
        }
        currentTrackIndex-=1
        if currentTrackIndex < 0 {
            currentTrackIndex = tracks.count - 1
        }
        
        queueTrack()
        if playerWasPlaying {
            player?.play()
        }
    }
    
    func getCurrentTrackName() -> String {
        let trackName = tracks[currentTrackIndex].title
        return (trackName)!
    }
    
    func getCurrentTimeAsString() -> String {
        var seconds = 0
        var minutes = 0
        if let time = player?.currentTime {
            seconds = Int(time) % 60
            minutes = (Int(time) / 60) % 60
        }
        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
    
    func getProgress()->Float{
        var theCurrentTime = 0.0
        var theCurrentDuration = 0.0
        if let currentTime = player?.currentTime, let duration = player?.duration {
            theCurrentTime = currentTime
            theCurrentDuration = duration
        }
        return Float(theCurrentTime / theCurrentDuration)
    }
    
    func setVolume(volume:Float){
        player?.volume = volume
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        if flag == true {
            nextSong(songFinishedPlaying: true)
        }
    }
    
    func getSongList() -> [MPMediaItem] {
        return tracks
    }
}
