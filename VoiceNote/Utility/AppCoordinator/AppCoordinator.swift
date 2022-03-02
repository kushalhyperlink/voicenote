//
//  AppCoordinator.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import UIKit
import SendBirdUIKit

class AppCoordinator: NSObject {
    
    func basicAppSetup() {
        //Application setup
        UIApplication.shared.windows.first?.isExclusiveTouch = true
        UITextField.appearance().tintColor = .themePinkishOrange
        UITextView.appearance().tintColor = .themePinkishOrange
    }
    
    func setupSendBirdSDK() {
        setCustomColorSet()
        
        SBUMain.setLogLevel(.all)
        
        SBUMain.initialize(applicationId: AppCredential.sendBirdAppId.rawValue) {
        } completionHandler: { error in
        }
        
        SBUGlobals.AccessToken = ""
        SBUGlobals.UsingUserProfile = true
        SBUGlobals.UsingUserProfileInOpenChannel = false
        SBUGlobals.ReplyTypeToUse = .none
    }
    
    func setCustomColorSet() {
        SBUColorSet.primary100 = UIColor("#FD6B62")
        SBUColorSet.primary200 = UIColor("#FD665E")
        SBUColorSet.primary300 = UIColor("#FC534A")
        SBUColorSet.primary400 = UIColor("#FC4036")
        SBUColorSet.primary500 = UIColor("#FC2D22")
        
        let customBaseColor = UIColor.themePinkishOrange
        
        let channelListTheme = SBUChannelListTheme()
        channelListTheme.leftBarButtonTintColor = customBaseColor
        channelListTheme.rightBarButtonTintColor = customBaseColor
        channelListTheme.notificationOnBackgroundColor = customBaseColor
        
        let channelCellTheme = SBUChannelCellTheme()
        channelCellTheme.unreadCountBackgroundColor = UIColor.themePinkishOrange
        
        
        let customTheme = SBUTheme(channelListTheme: channelListTheme,
                                   channelCellTheme: channelCellTheme)
        SBUTheme.set(theme: customTheme)
        SBUTheme.messageCellTheme.fileIconBackgroundColor = .clear
    }
}
