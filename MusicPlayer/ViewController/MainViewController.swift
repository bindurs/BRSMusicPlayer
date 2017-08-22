                                                                                                    
//  MainViewController.swift
//  MusicPlayer
//
//  Created by Bindu on 14/08/17.
//  Copyright © 2017 Xminds. All rights reserved.
//

import UIKit
import MediaPlayer

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {
    
    var timer:Timer?
    var tracks : [MPMediaItem]?
    var player : AVAudioPlayer?
    var currentTrackIndex : Int = 0
    var progress : Float?
    
    @IBOutlet var songImageView: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackTime: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet var playNextButton: UIButton!
    @IBOutlet var playPreviousButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    
    @IBOutlet var songlistTabelview: UITableView!

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        pageControl.addTarget(self, action: #selector(changePage), for: UIControlEvents.valueChanged)
        initialSetup()
        setupPlayerView()
        
        // button actions
        playPreviousButton.addTarget(self, action: #selector(previousSong), for: UIControlEvents.touchUpInside)
        pauseButton.addTarget(self, action: #selector(pause), for: UIControlEvents.touchUpInside)
        playButton.addTarget(self, action: #selector(play), for: UIControlEvents.touchUpInside)
        stopButton.addTarget(self, action: #selector(stop), for: UIControlEvents.touchUpInside)
        playNextButton.addTarget(self, action: #selector(nextSong(songFinishedPlaying:)), for: UIControlEvents.touchUpInside)
        
    }
    
    // MARK: - Methods
    
    func initialSetup() {
        
        getSongList()
        songlistTabelview.reloadData()
        changePage()
    }
    
    func setupPlayerView() {
    
        setTrackName()
        queueTrack()
        setupNotificationCenter()
        updateViews()
        
        playButton.isEnabled = true
        pauseButton.isEnabled = false
        stopButton.isEnabled = false
        
        progressBar.isHidden = true
    }
    
    func getSongList() {
        
        tracks = FileReader.readFiles()
    }
    
    func queueTrack() {
        
        if (player != nil) {
            player = nil
        }
        
        let url = tracks?[currentTrackIndex].assetURL
        
        // Removed deprecated use of AVAudioSessionDelegate protocol
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            player?.delegate = self
            player?.prepareToPlay()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "SetTrackNameText"), object: nil)
            
            let image = tracks?[currentTrackIndex].artwork
            
            songImageView.image = image?.image(at:CGSize(width: songImageView.frame.size.width, height: songImageView.frame.size.height))
        } catch {
            print(error)
        }
    }
    
    func play() {
        
        playButton.isEnabled = false
        pauseButton.isEnabled = true
        stopButton.isEnabled = true
        
        progressBar.isHidden = false
        
        if player?.isPlaying == false {
            player?.play()
            startTimer()
        }
    }
    
    func stop(){
        
        progressBar.isHidden = true
        
        playButton.isEnabled = true
        pauseButton.isEnabled = false
        stopButton.isEnabled = false
        
        if player?.isPlaying == true {
            player?.stop()
            player?.currentTime = 0
            
            if timer != nil {
                timer?.invalidate()
            }
        }
        updateViews()
    }
    
    func pause(){
        
        progressBar.isHidden = false
        
        playButton.isEnabled = true
        pauseButton.isEnabled = false
        stopButton.isEnabled = true
        
        if player?.isPlaying == true{
            player?.pause()
            if timer != nil {
                timer?.invalidate()
            }
        }
    }
    
    func nextSong(songFinishedPlaying:Bool){
        
        var playerWasPlaying = false
        if player?.isPlaying == true {
            player?.stop()
            playerWasPlaying = true
        }
        
        currentTrackIndex+=1
        if currentTrackIndex >= (tracks?.count)! {
            currentTrackIndex = 0
        }
        queueTrack()
        if playerWasPlaying || songFinishedPlaying {
            player?.play()
        }
          startTimer()
    }
    
    func previousSong(){
        
        var playerWasPlaying = false
        
        if player?.isPlaying == true {
            player?.stop()
            playerWasPlaying = true
        }
        currentTrackIndex-=1
        if currentTrackIndex < 0 {
            currentTrackIndex = (tracks?.count)! - 1
        }
        
        queueTrack()
        if playerWasPlaying {
            player?.play()
        }
          startTimer()
    }
    
    func getCurrentTrackName() -> String {
        let trackName = tracks?[currentTrackIndex].title
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

    func startTimer(){
     
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(updateViewsWithTimer(theTimer:)), userInfo: nil, repeats: true)
        timer?.fire()
    }

    func updateViewsWithTimer(theTimer: Timer){
        updateViews()
    }
    
    func updateViews(){
        
        trackTime.text = getCurrentTimeAsString()
        progress = getProgress()
        progressBar.progress = progress!
        
    }

    func setTrackName(){
        trackName.text = getCurrentTrackName()
    }
    
    func setupNotificationCenter(){
      
        NotificationCenter.default.addObserver(self,selector:#selector(MainViewController.setTrackName), name:NSNotification.Name(rawValue: "SetTrackNameText"),object:nil)
    }
    
    // MARK: - PageControl Action
    
    func changePage() {
        
        let originX = CGFloat(pageControl.currentPage) * self.view.frame.size.width
        
        scrollView.scrollRectToVisible(CGRect(x:originX,y:0,width: self.view.frame.size.width,height: self.view.frame.size.height - 45), animated: true)
        scrollView.setContentOffset(CGPoint(x:originX, y:0), animated: true)
    }
    
    // MARK: - scrollView Delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / self.view.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        changePage()
    }
    
    // MARK: - UITableview Delegates and DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tracks?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell :SongListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "sCell", for: indexPath) as! SongListTableViewCell
        
        let song = tracks?[indexPath.row]
        
        cell.songTitleLabel.text = song?.albumTitle
        cell.songImageView.image = song?.artwork?.image(at:CGSize(width: cell.songImageView.frame.size.width, height: cell.songImageView.frame.size.height))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        changePage()
        currentTrackIndex = indexPath.row
        queueTrack()
        play()
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
