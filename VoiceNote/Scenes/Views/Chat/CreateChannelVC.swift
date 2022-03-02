//
//  CreateChannelVC.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import UIKit
import SendBirdSDK
import SendBirdUIKit
import SnapKit

class CreateChannelVC: SBUCreateChannelViewController {
    
    //MARK:- Class Variable
    
    private lazy var btnCreate: UIBarButtonItem = {
        let rightItem =  UIBarButtonItem(
            title: SBUStringSet.CreateChannel_Create(0),
            style: .plain,
            target: self,
            action: #selector(onCreate)
        )
        return rightItem
    }()
    
    
    //------------------------------------------------------
    
    //MARK:- Init
    
    override init(users: [SBUUser]? = nil, type: ChannelType = .group) {
        super.init(users: users, type: type)
        self.rightBarButton = btnCreate
    }
    
    //------------------------------------------------------
    
    //MARK:- Override functions
    
  
    //------------------------------------------------------
    
    //MARK:- Other functions
    
    //------------------------------------------------------
    
    //MARK:- Actions
    
    @objc
    private func onCreate() {
        guard !selectedUserList.isEmpty else { return }

        let userIds = Array(self.selectedUserList).sbu_getUserIds()
        self.createChannel(userIds: userIds)

        let params = SBDGroupChannelParams()
        params.name = ""
        params.coverUrl = ""
        params.addUserIds(userIds)
        params.isDistinct = false

        let type = self.channelType
        params.isSuper = (type == .broadcast) || (type == .supergroup)
        params.isBroadcast = (type == .broadcast)

        if let currentUser = SBUGlobals.CurrentUser {
            params.operatorUserIds = [currentUser.userId]
        }

        SBUGlobalCustomParams.groupChannelParamsCreateBuilder?(params)
        
        
        self.shouldShowLoadingIndicator()
        
        self.rightBarButton?.isEnabled = false
        
        SBDGroupChannel.createChannel(with: params) { [weak self] channel, error in
            defer { self?.shouldDismissLoadingIndicator() }
            guard let self = self else { return }
            self.rightBarButton?.isEnabled = true
            
            if let error = error {
                Alert.shared.showAlert(message: error.localizedDescription, completion: nil)
                return
            }
            
            guard let channelUrl = channel?.channelUrl else {
                debugPrint("[Failed] Create channel request: There is no channel url.")
                return
            }
            debugPrint("[Succeed] Create channel: \(channel?.description ?? "")")
            
            self.navigationController?.popViewController(animated: false)
            let channelVC = ChatMessageList(channelUrl: channelUrl)
            let naviVC = UINavigationController(rootViewController: channelVC)
            naviVC.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(naviVC, animated: true)
        }
        
    }
    
    //------------------------------------------------------
}
