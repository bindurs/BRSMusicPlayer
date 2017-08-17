                                                                                                      //
//  MainViewController.swift
//  MusicPlayer
//
//  Created by Bindu on 14/08/17.
//  Copyright © 2017 Xminds. All rights reserved.
//

import UIKit
import MediaPlayer

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var mp3Player:MP3Player?
    var timer:Timer?
    var tracks : [MPMediaItem]?
    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var songlistTabelview: UITableView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackTime: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        pageControl.addTarget(self, action: #selector(changePage), for: UIControlEvents.valueChanged)
        mp3Player = MP3Player()
        setupNotificationCenter()
        setTrackName()
        updateViews()
        
        tracks = mp3Player?.getSongList()
        songlistTabelview.reloadData()
        
        scrollView.scrollRectToVisibleCenteredOn(visibleRect: CGRect(x: self.view.frame.size.width,y:0,width:self.view.frame.size.width,height:scrollView.frame.size.height), animated: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(updateViewsWithTimer(theTimer:)), userInfo: nil, repeats: true)
        timer?.fire()
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
    
    // MARK: - PageControl Action
    
    func changePage() {
        
        let originX = CGFloat(pageControl.currentPage) * self.view.frame.size.width
        
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
