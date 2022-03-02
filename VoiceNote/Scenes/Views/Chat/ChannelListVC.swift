//
//  ChannelListVC.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import UIKit
import SendBirdSDK
import SendBirdUIKit

class ChannelListVC: SBUChannelListViewController {
    
    //MARK:- Class Variable
    
    //------------------------------------------------------
    
    //MARK:- Init

    
    //------------------------------------------------------
    
    //MARK:- Override functions
    
    override func setupStyles() {
        super.setupStyles()
        self.leftBarButton = UIBarButtonItem(image: UIImage(named: "logout"), style: .done, target: self, action: #selector(onLogout))
    }
    
    override func showCreateChannel(type: ChannelType = .group) {
        let createChannelVC = CreateChannelVC(type: type)
        self.navigationController?.pushViewController(createChannelVC, animated: true)
    }
    
    //------------------------------------------------------
    
    //MARK:- Override delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = self.channelList[indexPath.row].channelUrl
        let channelVC = ChatMessageList(channelUrl: channel)
        let naviVC = UINavigationController(rootViewController: channelVC)
        naviVC.modalPresentationStyle = .fullScreen
        self.present(naviVC, animated: true)
    }
    
    //------------------------------------------------------
    
    //MARK:- Actions
    
    @objc
    private func onLogout() {
        UIApplication.shared.logoutAppUser()
    }
    
    //------------------------------------------------------
}

