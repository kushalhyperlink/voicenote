//
//  AudioRecordView.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import UIKit
import DSWaveformImage
import SnapKit

protocol AudioRecordViewDelegate: AnyObject {
    func didFinishRecord(at url: URL)
    func didDeleteRecord()
    func didTapSend(with recordURL: URL, totalDuration: String)
}

enum AudioRecordState {
    case runing, ended, playing, pause, notRunning
    
    var nextStateIcon: String {
        switch self {
        case .runing: return "stop"
        case .ended: return "play-audio"
        case .playing: return "pause-audio"
        case .pause: return "play-audio"
        case .notRunning: return "stop"
        }
    }
}

class AudioRecordView: UIView {
    
    //MARK:- Class Variables
    
    private lazy var mainHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 14
        return stack
    }()
    
    private lazy var btnPlayStopRecord: UIButton = {
        let btn = UIButton(type: .custom)
        btn.contentHuggingPriority(for: .horizontal)
        btn.contentHuggingPriority(for: .vertical)
        btn.setImage(UIImage(named: AudioRecordState.notRunning.nextStateIcon), for: .normal)
        btn.tintColor = .themePinkishOrange
        btn.addTarget(self, action: #selector(self.onPlayPause(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btnDelete: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "trash-red"), for: .normal)
        btn.tintColor = .themePinkishOrange
        btn.addTarget(self, action: #selector(self.onDelete(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btnSend: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "send"), for: .normal)
        btn.tintColor = .themePinkishOrange
        btn.addTarget(self, action: #selector(self.onSend(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var viewWaveForm: WaveformLiveView = {
        let waveForm = WaveformLiveView()
        return waveForm
    }()
    
    private lazy var lblDuration: UILabel = {
        let lbl = UILabel()
        lbl.text = "00:00"
        lbl.font = .systemFont(ofSize: 15)
        return lbl
    }()
    
    weak var delegate: AudioRecordViewDelegate? = nil
    
    private var currentRecordState: AudioRecordState = .notRunning {
        didSet {
            self.btnPlayStopRecord.setImage(UIImage(named: currentRecordState.nextStateIcon), for: .normal)
        }
    }
    
    private let audioManager: SCAudioManager = SCAudioManager()
    private var audioURL: URL?
    
    private var timer: Timer?
    private var totalTime = 0 {
        didSet {
            self.lblDuration.text = self.totalTime.toTimeFormatted()
        }
    }
    
    private var isSendTap: Bool = false
    
    //------------------------------------------------------
    
    //MARK:- Init
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCommon()
    }
    
    
    //------------------------------------------------------
    
    //MARK:- Deinit
    
    deinit {
        stopTimer()
    }
    
    //------------------------------------------------------
    
    //MARK:- Other functions
    
    private func initCommon() {
        self.addSubview(mainHStack)
        self.backgroundColor = .white
        self.mainHStack.addArrangedSubview(btnDelete)
        self.mainHStack.addArrangedSubview(btnPlayStopRecord)
        self.mainHStack.addArrangedSubview(viewWaveForm)
        self.mainHStack.addArrangedSubview(lblDuration)
        self.mainHStack.addArrangedSubview(btnSend)
        
        audioManager.prepareAudioRecording()
        audioManager.recordingDelegate = self
        audioManager.playbackDelegate = self
        
        viewWaveForm.configuration = viewWaveForm.configuration.with(
            style: .striped(.init(color: .themePinkishOrange, width: 3, spacing: 3)),
            dampening: viewWaveForm.configuration.dampening?.with(percentage: 0)
        )
        
        viewWaveForm.backgroundColor = .clear
        setupConstraints()
    }
    
    private func setupConstraints() {
        mainHStack.clipsToBounds = true
        viewWaveForm.clipsToBounds = true
        
        mainHStack.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-15)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(14)
        }
    }
    
    func startRecording() {
        if audioManager.recording() {
            audioManager.stopRecording()
        }
        self.currentRecordState = .runing
        self.audioURL = nil
        viewWaveForm.reset()
        self.startTimer()
        audioManager.startRecording()
    }
    
    private func resetView() {
        stopTimer()
        audioManager.stopRecording()
        self.currentRecordState = .ended
        self.audioURL = nil
        viewWaveForm.reset()
    }
    
    private func startTimer() {
        totalTime = 0
        stopTimer()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc
    private func updateTimer() {
        totalTime += 1
    }
    
    //------------------------------------------------------
    
    //MARK:- Actions
    
    @objc
    private func onPlayPause(_ sender: UIButton) {
        switch currentRecordState {
        case .runing:
            audioManager.stopRecording()
            self.currentRecordState = .pause
        case .playing:
            self.audioManager.stopPlayingRecordedAudio()
            self.currentRecordState = .pause
            
        case .pause:
            self.audioManager.startPlayingRecordedAudio()
            self.currentRecordState = .playing
        default:
            break
        }
    }
    
    @objc
    private func onDelete(_ sender: UIButton) {
        resetView()
        self.delegate?.didDeleteRecord()
    }
    
    @objc
    private func onSend(_ sender: UIButton) {
        isSendTap = true
        audioManager.stopRecording()
        if !audioManager.recording() {
            if let audioURL = audioURL {
                self.currentRecordState = .notRunning
                self.onDelete(btnDelete)
                self.delegate?.didTapSend(with: audioURL, totalDuration: String(self.totalTime))
            }
        }
    }
    
    //------------------------------------------------------
}

extension AudioRecordView: RecordingDelegate {
    func audioManager(_ manager: SCAudioManager!, didAllowRecording success: Bool) {
        if !success {
            //            preconditionFailure("Recording must be allowed in Settings to work.")
        }
    }
    
    func audioManager(_ manager: SCAudioManager!, didFinishRecordingSuccessfully success: Bool) {
        print("did finish recording with success=\(success)")
        audioURL = manager.recordedAudioFileURL()
        self.stopTimer()
        if let url = audioURL {
            self.delegate?.didFinishRecord(at: url)
        }
        
        if isSendTap {
            if let audioURL = audioURL {
                self.currentRecordState = .notRunning
                self.onDelete(btnDelete)
                self.delegate?.didTapSend(with: audioURL, totalDuration: String(self.totalTime))
            }
            isSendTap = false
        }
    }
    
    func audioManager(_ manager: SCAudioManager!, didUpdateRecordProgress progress: CGFloat) {
        print("current power: \(manager.lastAveragePower()) dB")
        let linear = 1 - pow(10, manager.lastAveragePower() / 20)
        viewWaveForm.add(samples: [linear, linear])
    }
}

extension AudioRecordView: PlaybackDelegate {
    func audioManager(_ manager: SCAudioManager!, didUpdatePlayProgress progress: CGFloat) {
        
    }
    
    func audioManager(_ manager: SCAudioManager!, didFinishPlayingSuccessfully flag: Bool) {
        if flag {
            self.currentRecordState = .pause
        }
    }
}
