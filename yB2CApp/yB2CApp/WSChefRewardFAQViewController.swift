
//
//  WSChefRewardFAQViewController.swift
//  yB2CApp
//
//  Created by Lakshminarayana on 05/12/17.
//

import UIKit
import AVKit

class WSChefRewardFAQViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
  @IBOutlet weak var tableviewCustomView: UIView!
  @IBOutlet weak var videoPlayerHeightConstarint: NSLayoutConstraint!
  @IBOutlet weak var bottomSliderView: UIView!
  @IBOutlet weak var videoViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var videoTextView: UIView!
  @IBOutlet weak var videoTextViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var PlayVedioText: UILabel!
    @IBOutlet weak var videoText: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var chefRewardFAQSLabel: UILabel!
    @IBOutlet weak var videoProgressSlider: UISlider!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
   var bodyWebViewHeight = 0.0

    var contentHeights : [CGFloat] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    var isCollapsed:Bool = false
    var selectedRow:Int = 0
    let value = FAQModel()
    var rowHeight : [[CGFloat:String]] = []
    
    @IBOutlet weak var faqTableView: UITableView!
    var rewardModel:[WSChefRewardModel] = []
//    var questions = [WSUtility.getlocalizedString(key: "FAQQ1", lang: WSUtility.getLanguage(), table: "Localizable"),WSUtility.getlocalizedString(key: "FAQQ2", lang: WSUtility.getLanguage(), table: "Localizable"),WSUtility.getlocalizedString(key: "FAQQ3", lang: WSUtility.getLanguage(), table: "Localizable"),WSUtility.getlocalizedString(key: "FAQQ4", lang: WSUtility.getLanguage(), table: "Localizable"),WSUtility.getlocalizedString(key: "FAQQ5", lang: WSUtility.getLanguage(), table: "Localizable"),WSUtility.getlocalizedString(key: "FAQQ6", lang: WSUtility.getLanguage(), table: "Localizable"),WSUtility.getlocalizedString(key: "FAQQ7", lang: WSUtility.getLanguage(), table: "Localizable"),WSUtility.getlocalizedString(key: "FAQQ8", lang: WSUtility.getLanguage(), table: "Localizable")]
//    var answers = [WSUtility.getlocalizedString(key: "FAQA1", lang: WSUtility.getLanguage(), table: "Localizable"),WSUtility.getlocalizedString(key: "FAQA2", lang: WSUtility.getLanguage(), table: "Localizable"),WSUtility.getlocalizedString(key: "FAQA3", lang: WSUtility.getLanguage(), table: "Localizable"),WSUtility.getlocalizedString(key: "FAQA4", lang: WSUtility.getLanguage(), table: "Localizable"),WSUtility.getlocalizedString(key: "FAQA5", lang: WSUtility.getLanguage(), table: "Localizable"),WSUtility.getlocalizedString(key: "FAQA6", lang: WSUtility.getLanguage(), table: "Localizable"),WSUtility.getlocalizedString(key: "FAQA7", lang: WSUtility.getLanguage(), table: "Localizable"),WSUtility.getlocalizedString(key: "FAQA8", lang: WSUtility.getLanguage(), table: "Localizable")]
//    
    var playerLayer: AVPlayerLayer = AVPlayerLayer()
    var player: AVQueuePlayer = AVQueuePlayer()
    var timeObserver:Any?
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        
        value.ParseJson()
        self.UISetUP()
        faqTableView.rowHeight = UITableViewAutomaticDimension
        faqTableView.estimatedRowHeight = 300
    
    }


    override func viewWillAppear(_ animated: Bool) {
       // playVideo()
     if  WSUtility.getCountryCode() == "AT"{
//        addVideoPlayer()
        checkFileExists()
        
     }else{
      videoViewHeightConstraint.constant = 0
      videoTextViewHeightConstraint.constant = 0
      videoPlayerHeightConstarint.constant = 0
      bottomSliderView.isHidden = true
      playPauseButton.isHidden = true
      videoText.text = ""
      var frame = tableviewCustomView.frame
      frame.size.height = 413 - 304
      tableviewCustomView.frame = frame
      }
      
    }
  override func viewWillDisappear(_ animated: Bool) {
    pauseVideo()
  }
  
    func UISetUP()  {
        chefRewardFAQSLabel.text = WSUtility.getlocalizedString(key: "Chef Rewards Frequently Asked Questions", lang: WSUtility.getLanguage(), table: "Localizable")
        PlayVedioText.text = WSUtility.getlocalizedString(key: "Play_Video", lang: WSUtility.getLanguage())
        
        videoText.text = WSUtility.getlocalizedString(key: "Our video on how Chef Rewards work", lang: WSUtility.getLanguage(), table: "Localizable")
  
        WSUtility.addNavigationBarBackButton(controller: self)
        for i in 0..<8 {
          var model = WSChefRewardModel()
            model.answerLabel = value.answer[i]
            model.questionLabel = value.question[i]
            model.isCollapsed = false
            rewardModel.append(model)

        }
        faqTableView.reloadData()
    }
  
  
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func registerTableView(){
        faqTableView.delegate = self
        faqTableView.dataSource = self
        faqTableView.register(UINib(nibName: "WSChefRewardOverviewFAQTableViewCell", bundle: nil), forCellReuseIdentifier: "WSChefRewardOverviewFAQTableViewCell")

    }
  
  func pauseVideo(){
    player.pause()
    playPauseButton.setImage(#imageLiteral(resourceName: "floatingButton"), for: .normal)
    PlayVedioText.text = WSUtility.getlocalizedString(key: "Play_Video", lang: WSUtility.getLanguage())
  }
  
    func addVideoPlayer(videoURL:URL) {
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(self.tapOnSlider(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        self.videoProgressSlider.addGestureRecognizer(tapGesture)
        self.videoProgressSlider.addTarget(self, action: #selector(onSliderValueChanged(slider:event:)), for: .valueChanged)
//        let videoURL = URL(string: "http://techstage.nl/ufs_hybris/upload_video/loyalty_program/Unilever_Vid1_v03b_SFX.mp4")
        let firstItem = AVPlayerItem(url:videoURL)
        let itemsToPlay = [firstItem]
        self.player = AVQueuePlayer(items: itemsToPlay)
        let interval = CMTime(seconds: 0.05, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: nil, using: { elapsedTime in
            self.updateSlider(elapsedTime: elapsedTime)
        })
        playerLayer = AVPlayerLayer(player: player)
        self.videoProgressSlider.isHidden = true
        self.timeElapsedLabel.isHidden = true
        self.timeRemainingLabel.isHidden = true
        playerLayer.frame = CGRect(x:0, y: 0, width:self.faqTableView.frame.size.width , height: videoView.frame.size.height)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        player.currentItem?.preferredPeakBitRate = 1.0
        videoView.layer.addSublayer(playerLayer)
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
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            let downloadService = WSDownloadFilesManager()
            downloadService.downloadVideo(urlString: ChefRewards_Vedio, PathName: chefRewards_Path_Name,success: {(response) in
                self.activityIndicator.stopAnimating()
                self.addVideoPlayer(videoURL: videoURL)
                
            }, failure: {(error) in
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                 self.checkFileExists()
            })
        }
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

    @IBAction func playButtonClicked(_ sender: UIButton) {
        if player.rate == 0
        {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
            PlayVedioText.text = WSUtility.getlocalizedString(key: "Pause_Video", lang: WSUtility.getLanguage())
            
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "floatingButton"), for: .normal)
            PlayVedioText.text = WSUtility.getlocalizedString(key: "Play_Video", lang: WSUtility.getLanguage())
        }
    }
    
}

extension WSChefRewardFAQViewController:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return rewardModel.count

        }else{
            
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell = UITableViewCell()
        if indexPath.section == 0{
            let Cell = faqTableView.dequeueReusableCell(withIdentifier: "WSChefRewardOverviewFAQTableViewCell") as! WSChefRewardOverviewFAQTableViewCell
            let AnswerLink = rewardModel[indexPath.row].answerLabel
            Cell.answerWebView.tag = indexPath.row
            Cell.answerWebView.delegate = self
            Cell.answerWebView.loadHTMLString(AnswerLink, baseURL: nil)
            Cell.questionLabel.text = rewardModel[indexPath.row].questionLabel
            let htmlHeight = contentHeights[indexPath.row]
            Cell.myWebViewHeightConstraint.constant = 0
            if rewardModel[indexPath.row].isCollapsed == true {
                Cell.myWebViewHeightConstraint.constant = htmlHeight
            }
            
            Cell.plusMinusButton.setImage(#imageLiteral(resourceName: "plusIcon_black"), for: .normal)
            if rewardModel[indexPath.row].isCollapsed == false {
                Cell.plusMinusButton.setImage(#imageLiteral(resourceName: "plusIcon_black"), for: .normal)

            }
            else {
                Cell.plusMinusButton.setImage(#imageLiteral(resourceName: "minusIcon_black"), for: .normal)

            }
            
            tableViewCell = Cell
        }else{
            let Cell = faqTableView.dequeueReusableCell(withIdentifier: "WSChefRewardTermsAndConditionsTableViewCell") as! WSChefRewardTermsAndConditionsTableViewCell
            Cell.setUI()
            tableViewCell = Cell

        }
      
        return tableViewCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if indexPath.row == selectedRow{
                if rewardModel[indexPath.row].isCollapsed == true {
                    return UITableViewAutomaticDimension
                } else {
                    return 80
                }
            }else{
                return 80
                
            }
        }else{
            return 86
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            var model = rewardModel[indexPath.row]
            if model.isCollapsed == true{
                model.isCollapsed = false
                rewardModel[indexPath.row] = model


            }else{
                model.isCollapsed = true
                rewardModel[indexPath.row] = model


            }
            selectedRow = indexPath.row
            
            var i = 0
            for var model in rewardModel{ // Set all the "-" to "+" except for the selected cell
                if indexPath.row != i{
                    model.isCollapsed = false
                    rewardModel[i] = model
                }
                i = i+1
            }
            faqTableView.reloadData()
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if (contentHeights[webView.tag] != 0.0)
        {
            return // we already know height, no need to reload cell
        }

        contentHeights[webView.tag] = webView.scrollView.contentSize.height
        faqTableView.reloadRows(at: [IndexPath(row: webView.tag, section: 0)], with: UITableViewRowAnimation.automatic)
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(request.url!, options: [:],completionHandler: { (success) in
                        
                    })
                } else {
                     UIApplication.shared.openURL(request.url!)
                }
            return false
        }
        return true
    }
    
    
}


