//
//  ChatMessageList.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import UIKit
import SendBirdSDK
import SendBirdUIKit
import SnapKit

class ChatMessageList: SBUChannelViewController {
    
    //MARK:- Class Variable
    
    lazy private var audioRecordView: AudioRecordView = {
        return AudioRecordView()
    }()
    
    private lazy var btnBack: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "back"), style: .done, target: self, action: #selector(onBack))
    }()
    
    private let audioManager = SCAudioManager()
    
    //------------------------------------------------------
    
    //MARK:- Init
    
    init(channelUrl: String) {
        super.init(channelUrl: channelUrl)
        
        self.messageInputView = MessageInputView(frame: .zero)
        self.register(fileMessageCell: AudioChatMessageCell(), nib: nil)
        
        setupView()
    }
    
    //------------------------------------------------------
    
    //MARK:- LifeCycle functions
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAudioOfVisibleCells()
    }
    
    //------------------------------------------------------
    
    //MARK:- Override functions
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        (cell as? AudioChatMessageCell)?.audioManager = audioManager
        return cell
    }
    
    //------------------------------------------------------
    
    //MARK:- Other functions
    
    private func hideShowAudioRecordView(isHide: Bool) {
        self.stopAudioOfVisibleCells()
        
        if !isHide {
            self.audioRecordView.startRecording()
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.audioRecordView.alpha = isHide ? 0 : 1
        } completion: { [weak self] isCompleted in
            self?.audioRecordView.isUserInteractionEnabled = !isHide
        }
    }
    
    func setupView() {
        self.view.addSubview(audioRecordView)
        
        audioRecordView.delegate = self
        (messageInputView as? MessageInputView)?.delegate = self
        
        audioRecordView.alpha = 0
        audioRecordView.isUserInteractionEnabled = false
        
        audioRecordView.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            make.leading.trailing.top.bottom.equalTo(self.messageInputView)
        }
        
//        self.leftBarButton = self.btnBack
    }
    
    private func stopAudioOfVisibleCells() {
        self.tableView.visibleCells.forEach { cell in
            (cell as? AudioChatMessageCell)?.stopAudio()
        }
    }
    
    //------------------------------------------------------
    
    //MARK:- Actions
    
    @objc
    private func onBack() {
        self.stopAudioOfVisibleCells()
        self.onClickBack()
    }
    
    //------------------------------------------------------
}

// MARK: MessageInputViewDelegate
extension ChatMessageList: MessageInputViewDelegate {
    func onClickMic(sender: Any) {
        self.hideShowAudioRecordView(isHide: false)
    }
}

// MARK: MessageInputViewDelegate
extension ChatMessageList: AudioRecordViewDelegate {
    func didFinishRecord(at url: URL) {
        
    }
    
    func didDeleteRecord() {
        self.hideShowAudioRecordView(isHide: true)
    }
    
    func didTapSend(with recordURL: URL, totalDuration: String) {
        do {
            let audioData = try Data(contentsOf: recordURL)
            guard let messageParams = SBDFileMessageParams(file: audioData) else {
                return
            }
            if let mimeType = SBUUtils.getMimeType(url: recordURL) {
                messageParams.mimeType = mimeType
            } else {
                messageParams.mimeType = "audio/m4a"
            }
            messageParams.data = totalDuration
            self.sendFileMessage(messageParams: messageParams)
        } catch {
            print("Error in \(#function) : ", error)
        }
    }
}
