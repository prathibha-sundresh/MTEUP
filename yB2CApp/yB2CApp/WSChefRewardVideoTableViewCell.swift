//
//  WSChefRewardVideoTableViewCell.swift
//  yB2CApp
//
//  Created by Lakshminarayana on 05/12/17.
//

import UIKit
import AVKit
import AVFoundation

class WSChefRewardVideoTableViewCell: UITableViewCell {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var PlayPauseText: UILabel!
    @IBOutlet weak var videoText: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoProgressSlider: UISlider!
    var playerLayer: AVPlayerLayer = AVPlayerLayer()
    var player: AVQueuePlayer = AVQueuePlayer()
    var timeObserver: Any?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        checkFileExists()
        videoText.text = WSUtility.getlocalizedString(key: "Our video on how Chef Rewards work", lang: WSUtility.getLanguage(), table: "Localizable")
        PlayPauseText.text = WSUtility.getlocalizedString(key: "Play_Video", lang: WSUtility.getLanguage())
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func addVideoPlayer(videoURL:URL){
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(self.tapOnSlider(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        self.videoProgressSlider.addGestureRecognizer(tapGesture)
        self.videoProgressSlider.addTarget(self, action: #selector(onSliderValueChanged(slider:event:)), for: .valueChanged)
        
        let firstItem = AVPlayerItem(url:videoURL)
        let itemsToPlay = [firstItem]
        self.player = AVQueuePlayer(items: itemsToPlay)
        let interval = CMTime(seconds: 0.05, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        self.timeObserver = self.player.addPeriodicTimeObserver(forInterval: interval, queue: nil, using: { elapsedTime in
            self.updateSlider(elapsedTime: elapsedTime)
        })
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.videoProgressSlider.isHidden = true
        self.timeElapsedLabel.isHidden = true
        self.timeRemainingLabel.isHidden = true
        self.playerLayer.frame = CGRect(x:0, y: 0, width:self.frame.size.width , height: self.videoView.frame.size.height)
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.player.currentItem?.preferredPeakBitRate = 1.0
        self.videoView.layer.addSublayer(self.playerLayer)

    }
    
    func  checkFileExists() {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let videoDataPath = documentsDirectory + "/" + chefRewards_Path_Name
        
        let videoURL = URL(fileURLWithPath: videoDataPath)
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: videoURL.path) {
           addVideoPlayer(videoURL: videoURL)
            activityIndicator.isHidden = true
        } else {
            showActivityIndicator()
            
            let downloadService = WSDownloadFilesManager()
            downloadService.downloadVideo(urlString: ChefRewards_Vedio, PathName: chefRewards_Path_Name,success: {(response) in
                self.hideActivityIndicator()
                self.addVideoPlayer(videoURL: videoURL)
                
            }, failure: {(error) in
                self.hideActivityIndicator()
                self.checkFileExists()
            })
        }
    }
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.activityIndicatorViewStyle = .whiteLarge
            
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    func pauseVideo(){
        player.pause()
      playButton.setImage(#imageLiteral(resourceName: "floatingButton"), for: .normal)
    PlayPauseText.text = WSUtility.getlocalizedString(key: "Play_Video", lang: WSUtility.getLanguage())
    }
    func updateSlider(elapsedTime: CMTime) {
        let playerDuration = playerItemDuration()
        if CMTIME_IS_INVALID(playerDuration) {
            videoProgressSlider.minimumValue = 0.0
            return
        }
        let duration = Float(CMTimeGetSeconds(playerDuration))
        if duration.isFinite && duration > 0 {
            videoProgressSlider.isHidden = false
            self.timeElapsedLabel.isHidden = false
            self.timeRemainingLabel.isHidden = false
            videoProgressSlider.maximumValue = duration
            let time = Float(CMTimeGetSeconds(elapsedTime))
            var minute = Int(time)/60
            self.timeElapsedLabel.text = String(format:"%02d:%02d", minute, Int(time.truncatingRemainder(dividingBy: 60.0)))
            minute = Int(duration)/60
            self.timeRemainingLabel.text = String(format:"%02d:%02d", minute, Int(duration.truncatingRemainder(dividingBy: 60.0)))
            videoProgressSlider.setValue(time, animated: true)
        }
    }
    private func playerItemDuration() -> CMTime {
        let thePlayerItem = player.currentItem
        if thePlayerItem?.status == .readyToPlay {
            return thePlayerItem!.duration
        }
        return kCMTimeInvalid
    }
    
    @objc func tapOnSlider(gesture: UIGestureRecognizer) {
        
        if (self.videoProgressSlider.isHighlighted) {
            return;
        }
        let point = gesture.location(in: self.videoProgressSlider)
        let percentage = point.x/self.videoProgressSlider.bounds.size.width
        let delta = Float(percentage) * (self.videoProgressSlider.maximumValue - self.videoProgressSlider.minimumValue)
        let value = self.videoProgressSlider.minimumValue + delta
        self.videoProgressSlider.setValue(value, animated: false)
        
        let timeInSecond = self.videoProgressSlider.value;
        self.player.seek(to: CMTimeMake(Int64(timeInSecond), 1), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        self.updateSlider(elapsedTime: CMTime(seconds: Double(timeInSecond), preferredTimescale: 1))
    }
    
    @objc func onSliderValueChanged(slider: UISlider, event: UIEvent) {
        let currentValue = slider.value
        self.player.seek(to: CMTimeMake(Int64(currentValue), 1), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        
    }
    
    @IBAction func playPause(_ sender: Any) {
        if player.rate == 0
        {
            player.play()
            playButton.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
            PlayPauseText.text = WSUtility.getlocalizedString(key: "Pause_Video", lang: WSUtility.getLanguage())
            
        } else {
            player.pause()
            playButton.setImage(#imageLiteral(resourceName: "floatingButton"), for: .normal)
            PlayPauseText.text = WSUtility.getlocalizedString(key: "Play_Video", lang: WSUtility.getLanguage())
        }
    }
    
    
}

