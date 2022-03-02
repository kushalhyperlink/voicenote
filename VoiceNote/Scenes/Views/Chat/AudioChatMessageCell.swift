//
//  AudioChatMessageCell.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import UIKit
import SendBirdSDK
import SendBirdUIKit
import SnapKit

class AudioChatMessageCell: SBUFileMessageCell {
    
    //MARK:- Class Variables
    
    private lazy var playerSlider: AudioCellSlider = {
        let slider = AudioCellSlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isUserInteractionEnabled = false
        return slider
    }()
    
    private lazy var audioTimeLable: UILabel = {
        let lbl = UILabel()
        lbl.text = "00:00"
        lbl.font = .systemFont(ofSize: 12)
        return lbl
    }()
    
    private weak var timer: Timer?
    
    var audioManager: SCAudioManager?
    
    private var messagePosition: MessagePosition = .left
    
    private var totalDuration: Int = 0 {
        didSet {
            self.audioTimeLable.text = totalDuration.toTimeFormatted()
        }
    }
    
    private var currentPlayTime: Int = 0 {
        didSet {
            self.audioTimeLable.text = currentPlayTime.toTimeFormatted()
        }
    }
    
    //------------------------------------------------------
    
    //MARK:- Init
    
    //------------------------------------------------------
    
    //MARK:- Deinit
    
    deinit {
        stopTimer()
        self.audioManager?.stopPlayingRecordedAudio()
    }
    
    //------------------------------------------------------
    
    //MARK:- Override functions
    
    override func configure(with configuration: SBUBaseMessageCellParams) {
        super.configure(with: configuration)
        messagePosition = configuration.messagePosition
        
        // Audio view setup
        if let fileMessage = self.message as? SBDFileMessage,
           SBUUtils.getFileType(by: fileMessage) == .audio {
            setupSliderConstraint()
            if messagePosition == .right {
                playerSlider.thumbColor = .white
                playerSlider.tintColor = .white
                playerSlider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.4)
                audioTimeLable.textColor = .white
                
            } else {
                audioTimeLable.textColor = .black
                playerSlider.tintColor = .themePinkishOrange
                playerSlider.maximumTrackTintColor = UIColor.themePinkishOrange.withAlphaComponent(0.2)
                playerSlider.thumbColor = .themePinkishOrange
            }
            
            totalDuration = Int(self.message.data) ?? 0
            
            if let commonView = self.baseFileContentView as? SBUCommonContentView {
                commonView.fileNameLabel.isHidden = true
                commonView.stackView.addArrangedSubview(playerSlider)
                commonView.stackView.addArrangedSubview(audioTimeLable)
                
                commonView.fileImageView.tintColor = messagePosition == .left ? .themePinkishOrange : .white
                
                setAudioIcon()
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onPlayPauseAudio))
                commonView.fileImageView.isUserInteractionEnabled = true
                commonView.fileImageView.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    override func setupStyles() {
        super.setupStyles()
        (self.baseFileContentView as? SBUCommonContentView)?.fileImageView.superview?.backgroundColor = .clear
    }
    
    override func onTapContentView(sender: UITapGestureRecognizer) {
        if let fileMessage = self.message as? SBDFileMessage,
           SBUUtils.getFileType(by: fileMessage) == .audio {
            
        } else {
            super.onTapContentView(sender: sender)
        }
    }
    
    //------------------------------------------------------
    
    //MARK:- Other functions
    
    @objc
    private func onPlayPauseAudio() {
        if self.audioManager?.playing() == true {
            stopAudio()
            
        } else {
            if let fileMessage = self.message as? SBDFileMessage,
               let remoteURL = URL(string: fileMessage.url) {
                AudioCache.shared.load(url: remoteURL) { [weak self] url, error in
                    guard let self = self,
                          let playURL = url else {
                              return
                          }
                    DispatchQueue.main.async {
                        self.audioManager?.playbackDelegate = self
                        self.audioManager?.playAudioFile(from: playURL)
                        self.setAudioIcon()
                        self.startTimer()
                    }
                }
            }
        }
    }
    
    func stopAudio() {
        self.playerSlider.value = 0
        self.audioManager?.stopPlayingRecordedAudio()
        setAudioIcon()
        stopTimer()
    }
    
    private func setupSliderConstraint() {
        playerSlider.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            make.width.equalTo(self.bounds.width - 190)
        }
        
        audioTimeLable.snp.makeConstraints { make in
            make.width.equalTo(40)
        }
    }
    
    private func setAudioIcon() {
        if self.audioManager?.playing() == true {
            if let commonView = self.baseFileContentView as? SBUCommonContentView {
                commonView.fileImageView.image = UIImage(named: "stop")
            }
        } else {
            if let commonView = self.baseFileContentView as? SBUCommonContentView {
                commonView.fileImageView.image = UIImage(named: "play-audio")
            }
        }
    }
    
    private func startTimer() {
        stopTimer()
        currentPlayTime = 0
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        self.currentPlayTime = totalDuration
        timer?.invalidate()
        timer = nil
    }
    
    @objc
    private func updateTimer() {
        currentPlayTime += 1
    }
    
    //------------------------------------------------------
}

// MARK: PlaybackDelegate
extension AudioChatMessageCell: PlaybackDelegate {
    func audioManager(_ manager: SCAudioManager!, didUpdatePlayProgress progress: CGFloat) {
        self.playerSlider.value = Float(progress)
    }
    
    func audioManager(_ manager: SCAudioManager!, didFinishPlayingSuccessfully flag: Bool) {
        self.playerSlider.value = 0.0
        setAudioIcon()
        stopTimer()
    }
}
