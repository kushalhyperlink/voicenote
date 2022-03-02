//
//  MessageInputView.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import UIKit
import SendBirdSDK
import SendBirdUIKit

protocol MessageInputViewDelegate: AnyObject {
    func onClickMic(sender: Any)
}

class MessageInputView: SBUMessageInputView {
    
    //MARK:- Class Variable
    
    weak var delegate: MessageInputViewDelegate? = nil
    
    //MARK:- Override functions
    
    override func setupStyles() {
        super.setupStyles()
        self.addButton?.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        self.addButton?.tintColor = .themePinkishOrange
    }
    
    override func onClickAddButton(_ sender: Any) {
        self.delegate?.onClickMic(sender: sender)
    }
}
